bool UserHasPermissions = false;

void Main() {
    if (!CheckPermissions()) return;
    AddAudiences();
    await({startnew(LoadClubs), startnew(LoadCurrClubTag)});
}

bool notifiedPermissionsMissing = false;
bool CheckPermissions() {
    if (!OpenplanetHasFullPermissions()) {
        if (!notifiedPermissionsMissing)
            NotifyError("Missing permissions: This plugin will do nothing. You need club access.");
        notifiedPermissionsMissing = true;
        return false;
    }
    UserHasPermissions = true;
    return true;
}

string g_CurrClubTag = "Loading...";

void LoadCurrClubTag() {
    g_CurrClubTag = ColoredString(UserMgr_GetClubTag());
    print("curr tag: " + g_CurrClubTag);
    auto @tags = GetClubTags({LocalAccountId});
    if (tags.Length == 0) {
        g_CurrClubTag = "";
    } else {
        g_CurrClubTag = ColoredString(tags[0]);
    }
    print("curr tag: " + g_CurrClubTag);
}

void SetCurrClubTagFromJson(Json::Value@ data) {
    // resp from POST set tag: {"accountId":"0a2d1bc0-4aaa-4374-b2db-3d561bdab1c9","tagClubId":36476,"tag":"$FF03$CC01$9904","pinnedClub":0}
    if (data !is null && data.GetType() == Json::Type::Object) {
        g_CurrClubTag = ColoredString(data['tag']);
        print("curr tag from json: " + g_CurrClubTag);
    }
}

enum LoadStatus {
    Uninitialized,
    LoadingClubs,
    LoadedClubs
}

LoadStatus g_State = LoadStatus::Uninitialized;

class ClubData {
    int id;
    string name;
    string plainName;
    string tag;
    ClubData(int id, const string &in name, const string &in tag) {
        this.id = id;
        this.name = ColoredString(name);
        plainName = StripFormatCodes(name);
        this.tag = ColoredString(tag);
    }
    int opCmp(const ClubData@ other) const {
        if (plainName < other.plainName) return -1;
        if (plainName == other.plainName) return (id < other.id ? -1 : 1);
        return 0;
    }
}

ClubData@[] myClubs;
int maxPage;
int clubCount;

void AddClubsJson(Json::Value@ clubs) {
    for (uint i = 0; i < clubs.Length; i++) {
        auto item = clubs[i];
        myClubs.InsertLast(ClubData(item['id'], item['name'], item['tag']));
    }
    myClubs.SortAsc();
}

void LoadClubs() {
    myClubs.RemoveRange(0, myClubs.Length);
    g_State = LoadStatus::LoadingClubs;
    try {
        auto resp = GetMyClubs();
        AddClubsJson(resp['clubList']);
        maxPage = resp['maxPage'];
        clubCount = resp['clubCount'];
        if (maxPage > 1) GetAdditionalClubs();
    } catch {
        NotifyWarning('Failed to update clubs list: ' + getExceptionInfo() + "\n\nRefresh club list to try again.");
    }
    g_State = LoadStatus::LoadedClubs;
}

void GetAdditionalClubs() {
    for (uint page = 2; page <= maxPage; page++) {
        AddClubsJson(GetMyClubs(100, (page - 1) * 100)['clubList']);
    }
}

void Notify(const string &in msg) {
    UI::ShowNotification(Meta::ExecutingPlugin().Name, msg);
    trace("Notified: " + msg);
}

void NotifyError(const string &in msg) {
    warn(msg);
    UI::ShowNotification(Meta::ExecutingPlugin().Name + ": Error", msg, vec4(.9, .3, .1, .3), 15000);
}

void NotifyWarning(const string &in msg) {
    warn(msg);
    UI::ShowNotification(Meta::ExecutingPlugin().Name + ": Warning", msg, vec4(.9, .6, .2, .3), 15000);
}

void AddSimpleTooltip(const string &in msg) {
    if (UI::IsItemHovered()) {
        UI::BeginTooltip();
        UI::Text(msg);
        UI::EndTooltip();
    }
}

void CopyToClipboardAndNotify(const string &in toCopy) {
    IO::SetClipboard(toCopy);
    Notify("Copied: " + toCopy);
}

string[]@ Slice(string[] &in list, uint from, uint to) {
    if (to >= list.Length) to = list.Length;
    string[] r;
    for (uint i = from; i < to; i++) {
        r.InsertLast(list[i]);
    }
    return r;
}
