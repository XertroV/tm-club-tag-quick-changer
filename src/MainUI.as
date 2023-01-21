const string PluginIcon = Icons::Tags;
const string MenuTitle = "\\$2dd" + PluginIcon + "\\$z " + Meta::ExecutingPlugin().Name;

/** Render function called every frame intended only for menu items in `UI`.
*/
void RenderMenu() {
    if (!UserHasPermissions) return;
    if (UI::BeginMenu(MenuTitle)) {
        UI::Text("Current Tag: " + g_CurrClubTag);
        switch (g_State) {
            case LoadStatus::Uninitialized: {
                UI::Text("\\$888 --- Starting Up ---");
                break;
            }
            case LoadStatus::LoadingClubs: {
                UI::Text("\\$888 --- Loading Clubs ---");
                DrawClubTagMenuList();
                break;
            }
            case LoadStatus::LoadedClubs: {
                UI::Text("\\$888 --- Click to Set Tag ---");
                DrawClubTagMenuList();
                break;
            }
        }
        UI::EndMenu();
    }
}


void DrawClubTagMenuList() {
    UI::BeginDisabled(g_State != LoadStatus::LoadedClubs);
    if (UI::MenuItem("Refresh Clubs", "")) {
        startnew(LoadClubs);
        startnew(LoadCurrClubTag);
    }
    // if (UI::MenuItem("Tell Menu to Remove Club Tag", "")) {
    //     MLHook::Queue_Menu_SendCustomEvent("TMNext_ClubStore_Action_RemoveClubTag", {});
    // }
    UI::EndDisabled();
    UI::Separator();
    for (uint i = 0; i < myClubs.Length; i++) {
        DrawSetClubMenuItem(myClubs[i]);
    }
}

void DrawSetClubMenuItem(ClubData@ club) {
    // prepend tag with fff so that it shows up white if the tag doesn't add other color formatting.
    if (UI::MenuItem(club.name, "\\$fff" + club.tag, g_CurrClubTag == club.tag)) {
        startnew(OnClickSetClubTag, club);
    }
}

void OnClickSetClubTag(ref@ r_club) {
    // todo: LayerCustomEvent(CGameUILayer@ Layer, wstring Type, MwFastBuffer<wstring>& Data)
    if (!Permissions::JoinClub()) {
        NotifyError("Cannot set club tag, you lack the right permissions");
        return;
    }
    auto club = cast<ClubData>(r_club);
    if (club is null) {
        NotifyWarning("on click set club tag got null club.");
        return;
    }
    Notify("Setting club tag to: " + club.tag);
    auto resp = SetClubTag(club.id);
    trace("Got json resp: " + Json::Write(resp));
    // if we unset the tag, call again to set it.
    if (!resp.HasKey('tag') || string(resp['tag']) == "") {
        @resp = SetClubTag(club.id);
    }
    SetCurrClubTagFromJson(resp);
    // note: input here seems not to matter -- overridden by `SetClubTag` even tho this is called after.
    // in any case, we still need to call it tho, this is what updates the tag in the UI without resorting to ML stuff.
    UserMgr_SetClubTag(string(resp['tag']));
    Notify("Set club tag to: " + g_CurrClubTag);
}
