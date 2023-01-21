


// string[] ClubObjKeys = {'id', 'name', 'tag', 'description', 'iconUrl', 'logoUrl', 'decalUrl', 'verticalUrl', 'popularityLevel'};

// Json::Value@ PrepClubSetTagEvent(Json::Value@ club) {
//     auto ret = Json::Object();
//     // property names were we only need to capitalize the first letter
//     for (uint i = 0; i < ClubObjKeys.Length; i++) {
//         ret[ClubObjKeys[i].SubStr(0, 1).ToUpper() + ClubObjKeys[i].SubStr(1)] = club[ClubObjKeys[i]];
//     }
//     // different property names
//     ret['BgUrl'] = club['backgroundUrl'];
//     ret['PrivacyState'] = club['state'];
//     ret['DecoImageUrl_DecalSponsor4x1'] = club['decalSponsor4x1Url'];
//     ret['DecoImageUrl_Screen16x9'] = club['screen16x1Url'];
//     ret['DecoImageUrl_Screen8x1'] = club['screen8x1Url'];
//     ret['DecoImageUrl_Screen16x1'] = club['screen16x9Url'];
//     // some other things
//     ret['VIPListOnMap'] = Json::Array();
//     ret['FeaturedActivity'] = Json::Object();
//     ret['FeaturedActivity']['Id'] = 0;
//     ret['FeaturedActivity']['ClubId'] = 0;
//     ret['FeaturedActivity']['Name'] = '';
//     ret['FeaturedActivity']['Type'] = '';
//     ret['FeaturedActivity']['ExternalId'] = 0;
//     ret['FeaturedActivity']['Position'] = 0;
//     ret['FeaturedActivity']['Public'] = false;
//     ret['FeaturedActivity']['Active'] = false;
//     ret['FeaturedActivity']['MediaUrl'] = '';
//     ret['FeaturedActivity']['Password'] = false;
//     ret['FeaturedActivity']['Featured'] = false;
//     // matches event payload, now
//     return ret;
// }

// const string GetMLRefreshClubs(Json::Value@ clubJsonMLPayload) {
//     string ml = """
// <script><!--

// main() {
//     SendCustomEvent("TMNext_ClubStore_Action_ApplyClubTag", ["__INNER_JSON__"]);
// }

// --></script>
//     """;
//     return ml.Replace("__INNER_JSON__", Json::Write(clubJsonMLPayload).Replace('"', '\\"'));
// }

// void UpdateMLState(ClubData@ club) {
//     auto clubJson = GetClubById(club.id);
//     /* // ~~if we have a tag set, this will tell the ML that we unset it.~~
//     MLHook::Queue_Menu_SendCustomEvent("TMNext_ClubStore_Action_RemoveClubTag", {});
//     sleep(100);
//     */
//     // next, we need to pass the payload for the new club tag.
//     auto eventJson = PrepClubSetTagEvent(clubJson);
//     // MLHook::Queue_Menu_SendCustomEvent("TMNext_ClubStore_Action_ApplyClubTag", {Json::Write(eventJson)});
//     // print(GetMLRefreshClubs(eventJson));
//     // auto layer = cast<CGameManiaPlanet>(GetApp()).MenuManager.MenuCustom_CurrentManiaApp.UILayerCreate();
//     // layer.AttachId = "tmp send club event " + Time::Now;
//     // layer.ManialinkPageUtf8 = GetMLRefreshClubs(eventJson);
// }
