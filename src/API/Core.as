string[]@ GetClubTags(string[]@ wsids) {
    MwFastBuffer<wstring> _wsidList = MwFastBuffer<wstring>();
    for (uint i = 0; i < wsids.Length; i++) {
        _wsidList.Add(wstring(wsids[i]));
    }
    auto app = cast<CGameManiaPlanet>(GetApp());
    auto userId = app.MenuManager.MenuCustom_CurrentManiaApp.UserMgr.Users[0].Id;
    auto resp = app.MenuManager.MenuCustom_CurrentManiaApp.UserMgr.Tag_GetClubTagList(userId, _wsidList);
    WaitAndClearTaskLater(resp, app.MenuManager.MenuCustom_CurrentManiaApp.UserMgr);
    if (resp.HasFailed || !resp.HasSucceeded) {
        throw('getting club tags failed: ' + resp.ErrorCode + ", " + resp.ErrorType + ", " + resp.ErrorDescription);
    }
    string[] tags;
    for (uint i = 0; i < wsids.Length; i++) {
        tags.InsertLast(resp.GetClubTag(wsids[i]));
    }
    return tags;
}

const string LocalAccountId {
    get {
        return cast<CGameManiaPlanet>(GetApp()).MenuManager.MenuCustom_CurrentManiaApp.LocalUser.WebServicesUserId;
    }
}



const string UserMgr_GetClubTag() {
    auto userMgr = cast<CGameManiaPlanet>(GetApp()).MenuManager.MenuCustom_CurrentManiaApp.UserMgr;
    auto resp = userMgr.Tag_GetClubTag(userMgr.Users[0].Id);
    WaitAndClearTaskLater(resp, userMgr);
    if (resp.HasSucceeded)
        return resp.Value;
    warn("GetClubTag failed: " + resp.ErrorCode + ", " + resp.ErrorType + ", " + resp.ErrorDescription);
    return "";
}

void UserMgr_SetClubTag(const string &in clubTag) {
    if (!Permissions::JoinClub()) {
        NotifyWarning("refusing to set club tag since you lack permissions to join a club.");
        return;
    }
    auto userMgr = cast<CGameManiaPlanet>(GetApp()).MenuManager.MenuCustom_CurrentManiaApp.UserMgr;
    auto resp = userMgr.Tag_SetClubTag(userMgr.Users[0].Id, clubTag);
    WaitAndClearTaskLater(resp, userMgr);

}
