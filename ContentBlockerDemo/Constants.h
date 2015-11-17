//
//  Constants.h
//  ContentBlocker
//
//  Created by baina on 9/16/15.
//  Copyright © 2015 Baina/JieLi. All rights reserved.
//

#ifndef Constants_h
#define Constants_h

#define API_SERVER_URI_FOR_RELEASE @"http://opsen.dolphin-browser.com"
#define API_SERVER_URI_FOR_DEBUE @"http://172.16.7.14"
#define API_SERVER_RULE_LIST @"dop/ios/adblocker.json"
#define API_SERVER_REPORT_URL @"dop/ios/save/adblocker-feedback.json"

#define APP_GROUP_NAME @"group.com.dolphin.adblock.iphone"
#define APP_EXTENSION_NAME @"com.dolphin.adblocker.iphone.pro.ContentBlockerExtension"

#define RULES_TYPE_INCREASE 0
#define RULES_TYPE_TOTAL 1

#define JSON_KEY_RULE_STATUS @"status"
#define JSON_KEY_RULE_DATA @"data"
#define JSON_KEY_RULE_RULES @"rules"
#define JSON_KEY_RULE_VERSION @"version"
#define JSON_KEY_RULE_TYPE @"type"
#define JSON_KEY_RULE_TITLE @"title"
#define JSON_KEY_RULE_DESCRIPTION @"des"
#define JSON_KEY_RULE_URL @"url"
#define JSON_KEY_RULE_OTHER @"other"
#define JSON_KEY_RULE_UPDATED @"updated"
#define RATE_URL_PRO @"itms-apps://itunes.apple.com/cn/app/ad-blocker-pro-for-iphone/id1041679545?l=en&mt=8"
#define RATE_URL_FREE @"itms-apps://itunes.apple.com/app/ad-blocker-for-safari-browser/id1039210135?l=en&mt=8"

#define KEY_IS_NEW_USER @"KEY_IS_NEW_USER"
#define KEY_AD_BLOCKER_RUN_COUNT @"KEY_AD_BLOCKER_RUN_COUNT"
#define KEY_HAD_SHOW_USER_GUILD @"KEY_HAD_SHOW_USER_GUILD"
#define KEY_AD_BLOCKER_SET_OK @"KEY_AD_BLOCKER_SET_OK"
#define KEY_DHOW_1_BUTTON @"KEY_DHOW_1_BUTTON"
#define KEY_CAN_CHANGE_PAGE @"KEY_CAN_CHANGE_PAGE"
#define KEY_FIRST_LAUNCH_TIME @"KEY_FIRST_LAUNCH_TIME"
#define KEY_HAS_RATE_APP @"KEY_HAS_RATE_APP"
#define KEY_HAS_REMINDER_RATE_APP @"KEY_HAS_REMINDER_RATE_APP"


#define KEY_NEED_LOAD_DEFAULT_RULES @"KEY_NEED_LOAD_DEFAULT_RULES"
#define KEY_NEED_SHOW_UPDATE_BADGE @"KEY_NEED_SHOW_UPDATE_BADGE"
#define KEY_NEED_GO_TO_UPDATE @"KEY_NEED_GO_TO_UPDATE"
#define KEY_MAX_RULE_VERSION @"KEY_MAX_RULE_VERSION"
#define KEY_LAST_LANGUAGE @"KEY_LAST_LANGUAGE"

#define KEY_SWITCH_STATE @"KEY_SWITCH_STATE"

#define JSON_BLOCKLIST_AD_DATA @"blockerListTrackers.json"
#define JSON_BLOCKLIST_SOCIALBUTTON @"blockerListSocialButton.json"
#define JSON_BLOCKLIST_COMMENT @"blockerListComment.json"
#define JSON_BLOCKLIST_SCRIPT @"blockerListJavascript.json"
#define JSON_BLOCKLIST_FONT @"blockerListFont.json"
#define JSON_BLOCKLIST_IMAGE @"blockerListImage.json"
#define JSON_BLOCKLIST_ORIGIN @"originAdRule.json"




#define FONT_SIZE(s) [UIFont fontWithName:FONT_NAME size:s]
#define FONT_NAME @"Helvetica"
#define FONT_SIZE_11        FONT_SIZE(11)
#define FONT_SIZE_12        FONT_SIZE(12)
#define FONT_SIZE_13        FONT_SIZE(13)
#define FONT_SIZE_14        FONT_SIZE(14)
#define FONT_SIZE_15        FONT_SIZE(15)
#define FONT_SIZE_16        FONT_SIZE(16)
#define FONT_SIZE_17        FONT_SIZE(17)
#define FONT_SIZE_18        FONT_SIZE(18)
#define FONT_SIZE_19        FONT_SIZE(19)
#define FONT_SIZE_20        FONT_SIZE(20)
#endif /* Constants_h */
