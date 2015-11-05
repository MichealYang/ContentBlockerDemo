//
//  BlockerRulesDataManager.m
//  ContentBlocker
//
//  Created by baina on 9/16/15.
//  Copyright © 2015 Baina/JieLi. All rights reserved.
//

#import "BlockerRulesDataManager.h"
#import <SafariServices/SafariServices.h>

@implementation BlockerRulesDataManager
+(BlockerRulesDataManager*)shareInstance
{
    static BlockerRulesDataManager *_instance = nil;

    static dispatch_once_t oncePredicate;

    dispatch_once(&oncePredicate, ^{
        _instance = [[BlockerRulesDataManager alloc] init];
    });

    return _instance;
}

-(void)testPushData
{
    NSDictionary* data = [[NSDictionary alloc] initWithObjectsAndKeys:
    @"1",@"version",
    @"block ro baidu",@"title",
    @"baidu description,baidu music ads",@"des",
    @"http://www.baidu.com/ads_blocker",@"url",
    @"0",@"type",
    nil];
    [self parsePushRuleData:data];
}

-(BOOL)checkServerData:(NSDictionary *)data
{
    NSNumber* status = [data objectForKey:JSON_KEY_RULE_STATUS];
    if(0 != status.integerValue){
        return false;
    }
    return true;
}

-(void)parseServerListData:(NSDictionary *)dataInfo
{
    if(!dataInfo){
        return;
    }

    NSArray* rules = [dataInfo objectForKey:JSON_KEY_RULE_RULES];
    if(!rules || [rules count] <= 0){
        return;
    }
    NSMutableArray* oldRules = [self loadUpdateRulesFromFile];
    if(!oldRules){
        oldRules = [[NSMutableArray alloc] init];
    }

    NSMutableDictionary* oldRulesVersionList = [[NSMutableDictionary alloc] init];
    for(NSDictionary* rule in oldRules){
        NSNumber *version = [rule objectForKey:JSON_KEY_RULE_VERSION];
        [oldRulesVersionList setObject:rule forKey:version];
    }

    for(NSDictionary* rule in rules){
        NSNumber *version = [rule objectForKey:JSON_KEY_RULE_VERSION];
        NSNumber *type = [rule objectForKey:JSON_KEY_RULE_TYPE];
        NSString* title = [rule objectForKey:JSON_KEY_RULE_TITLE];
        NSString* description = [rule objectForKey:JSON_KEY_RULE_DESCRIPTION];
        NSString* url = [rule objectForKey:JSON_KEY_RULE_URL];
        if(!url || !title || !version || !description) {
            continue;
        }

        if(![oldRulesVersionList objectForKey:version]){
            [oldRules addObject:rule];
        }
        if(version.integerValue <= [[AppConfigurationmanager shareInstance] maxRuleVersion]){
            continue;
        }
        [self saveNewRule:rule];
    }
    [self saveUpdateRulesToFile:oldRules];
}

-(void)parsePushRuleData:(NSDictionary*)dataInfo
{
    if(nil == dataInfo
       || NULL == dataInfo
       || [dataInfo isKindOfClass:[NSNull class]]) {
        return;
    }

    NSNumber *version = [dataInfo objectForKey:JSON_KEY_RULE_VERSION];
    NSNumber *type = [dataInfo objectForKey:JSON_KEY_RULE_TYPE];
    NSString* title = [dataInfo objectForKey:JSON_KEY_RULE_TITLE];
    NSString* description = [dataInfo objectForKey:JSON_KEY_RULE_DESCRIPTION];
    NSString* url = [dataInfo objectForKey:JSON_KEY_RULE_URL];
    if(!url || !title || !version || !description) {
        return;
    }
//    BlockerRules* rules = [[BlockerRules alloc] init];
//    rules.rulesVersion = version.integerValue;
//    rules.rulesType = type.integerValue;
//    rules.rulesTitle = title;
//    rules.rulesDescription = description;
//    rules.rulesDownloadUrl = url;
    NSMutableArray* updateRules = [self loadUpdateRulesFromFile];
    if(!updateRules){
        updateRules = [[NSMutableArray alloc] init];
    }
//    NSDictionary* oldRule = [updateRules objectForKey:version];
//    if(oldRule){
//        return;
//    }
//    [updateRules setObject:dataInfo forKey:version];
    if(version.integerValue <= [[AppConfigurationmanager shareInstance] maxRuleVersion]){
        return;
    }
    [updateRules addObject:dataInfo];

    [self saveNewRule:dataInfo];
    [self saveUpdateRulesToFile:updateRules];
}

-(void)saveUpdateRulesToFile:(NSMutableArray*)rules
{
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,
                                                              NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:@"update_rules.plist"];
    BOOL success = [rules writeToFile:plistPath atomically:YES];
    DebugLog(@"[BlockerRulesDatamanager] saveUpdateRulesToFile:\n %@,\n result:%@", rules, success?@"success":@"failed");
}

-(NSMutableArray*)loadUpdateRulesFromFile
{

    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,
                                                              NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:@"update_rules.plist"];

    NSMutableArray * updateRules = [[NSMutableArray alloc] initWithContentsOfFile:plistPath];
    DebugLog(@"[BlockerRulesDatamanager] loadUpdateRulesFromFile:\n %@", updateRules);
    return updateRules;
}

-(NSString*)loadContentFromFile:(NSURL*)path
{
    NSMutableString* resContent =  [NSMutableString stringWithContentsOfURL:path encoding:NSUTF8StringEncoding error:nil];
    return resContent;
}

-(void)addNewRules:(NSString*)newRules
{
    NSURL* groupURL = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:APP_GROUP_NAME];
    NSString* Json_path = [groupURL.absoluteString stringByAppendingPathComponent:JSON_BLOCKLIST_ORIGIN];
    NSError* error;
    NSMutableString* resContent =  [NSMutableString stringWithContentsOfURL:[NSURL URLWithString:Json_path] encoding:NSUTF8StringEncoding error:&error];
    DebugLog(@"load old content error: %@", error);
    [resContent insertString:newRules atIndex:1];


    NSString* result = [resContent writeToURL:[NSURL URLWithString:Json_path] atomically:YES encoding:NSUTF8StringEncoding error:nil] ? @"Succeed":@"Failed";
    DebugLog(@"write file %@",result);

    [SFContentBlockerManager reloadContentBlockerWithIdentifier:APP_EXTENSION_NAME completionHandler:^(NSError * _Nullable error) {
        DebugLog(@"ReloadState:%@",error);
    }];
}

-(void)relpaseOldRules:(NSURL*)newPath
{
    NSData *data=[NSData dataWithContentsOfURL:newPath];
    NSURL* groupURL = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:APP_GROUP_NAME];
    NSString* Json_path = [groupURL.absoluteString stringByAppendingPathComponent:JSON_BLOCKLIST_ORIGIN];
    NSString* result = [data writeToURL:[NSURL URLWithString:Json_path] atomically:YES] ? @"Succeed":@"Failed";
    DebugLog(@"use new rules: %@",result);
    [SFContentBlockerManager reloadContentBlockerWithIdentifier:APP_EXTENSION_NAME completionHandler:^(NSError * _Nullable error) {
        DebugLog(@"ReloadState:%@",error);
    }];
}

/* 获取Documents文件夹的路径 */
- (NSString *)getDocumentsPath {
    NSArray *documents = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = documents[0];
    return documentsPath;
}

-(void)loadDefaultRulesIfNeeded
{
//    NSString *currentLanguage = [self getCurrentLanguage];
//    if([[AppConfigurationmanager shareInstance] hasLoadDefaultRules]){
//        NSString *lastLanguage = [[AppConfigurationmanager shareInstance] getLastLanguage];
//        //如果已经加载过，并且系统语言没有发生变化，那么不加载新的json规则
//        if ([lastLanguage isEqualToString:currentLanguage]) {
//            return;
//        }
//    }
    NSURL* groupURL = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:APP_GROUP_NAME];
    NSString* Json_path = [groupURL.absoluteString stringByAppendingPathComponent:JSON_BLOCKLIST_ORIGIN];
    NSString* defaultReules = [NSString stringWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"blockerList" withExtension:@"json"] encoding:NSUTF8StringEncoding error:nil];
    NSString* result = [defaultReules writeToURL:[NSURL URLWithString:Json_path] atomically:YES encoding:NSUTF8StringEncoding error:nil] ? @"Succeed":@"Failed";
    DebugLog(@"use new rules: %@",result);
    [SFContentBlockerManager reloadContentBlockerWithIdentifier:APP_EXTENSION_NAME completionHandler:^(NSError * _Nullable error) {
        DebugLog(@"ReloadState:%@",error);
        if(nil == error){
//            //如果加载成功，那么将当前系统语言记录下来，用作下次比较
//            [[AppConfigurationmanager shareInstance] setLastLanguage:currentLanguage];
//            [[AppConfigurationmanager shareInstance] sethasLoadDefaultRules:YES];
        }
    }];
}


- (NSString *)getCurrentLanguage
{
    NSArray *languages = [NSLocale preferredLanguages];
    NSString *currentLanguage = [languages objectAtIndex:0];
    DebugLog(@"%@" , currentLanguage);
    return  currentLanguage;

}

-(void)saveNewRule:(NSDictionary *)rule
{
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,
                                                              NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:@"new_rule.plist"];
    NSDictionary* oldRule = [self getNewRule];
    NSNumber* oldRuleVersion = [oldRule objectForKey:JSON_KEY_RULE_VERSION];
    NSNumber* newRuleVersion = [rule objectForKey:JSON_KEY_RULE_VERSION];
    if(newRuleVersion.intValue <= oldRuleVersion.intValue){
        return;
    }
    [[AppConfigurationmanager shareInstance] updateMaxRuleVersion:newRuleVersion.intValue];
    [rule writeToFile:plistPath atomically:YES];
}

-(NSDictionary*)getNewRule
{
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,
                                                              NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:@"new_rule.plist"];
    return [[NSDictionary alloc] initWithContentsOfFile:plistPath];
}

-(NSUInteger)maxRuleVersion
{
    NSDictionary* rule = [self getNewRule];
    NSNumber* version = [rule objectForKey:JSON_KEY_RULE_VERSION];
    return version.integerValue;
}

-(void)setRuleUpdated:(NSDictionary *)rule
{
    if(!rule){
        rule = [self getNewRule];
    }
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,
                                                              NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:@"new_rule.plist"];
    NSMutableDictionary* newRule = [[NSMutableDictionary alloc] initWithDictionary:rule];
    [newRule setObject:[NSNumber numberWithBool:YES] forKey:JSON_KEY_RULE_UPDATED];
    NSDictionary* oldRule = [self getNewRule];
    NSNumber* oldRuleVersion = [oldRule objectForKey:JSON_KEY_RULE_VERSION];
    NSNumber* newRuleVersion = [rule objectForKey:JSON_KEY_RULE_VERSION];
    if(newRuleVersion.intValue == oldRuleVersion.intValue){
        [newRule writeToFile:plistPath atomically:YES];
    }

    NSMutableArray* historyRules = [self loadUpdateRulesFromFile];
    if(!historyRules){
        historyRules = [[NSMutableArray alloc] init];
        [historyRules addObject:newRule];
    }
    NSNumber *version = [rule objectForKey:JSON_KEY_RULE_VERSION];
    for(NSMutableDictionary* r in historyRules){
        NSNumber *v = [r objectForKey:JSON_KEY_RULE_VERSION];
        if(v.integerValue != version.integerValue){
            continue;
        }
        [r setObject:[NSNumber numberWithBool:YES] forKey:JSON_KEY_RULE_UPDATED];
    }
    [self saveUpdateRulesToFile:historyRules];
}

-(BOOL)newRuleUpdated
{
    NSDictionary* newRule = [self getNewRule];
    NSNumber *updatedNumber = [newRule objectForKey:JSON_KEY_RULE_UPDATED];
    NSString* title = [newRule objectForKey:JSON_KEY_RULE_TITLE];
    if(!title){
        return true;
    }
    return updatedNumber.boolValue;
}

-(void)enableBlockRuleWithName: (NSString *)ruleFileName
{
    // 1.从对应的blockList中读取文件
    NSString *contentString = [self getLocalJsonStringWithFileName:ruleFileName];

    //获取共享区文件的路径
    NSURL *groupUrl = [self getGroupShareJsonURL];
    //根据路径获取内容
    NSMutableString *originContentString = [NSMutableString stringWithContentsOfURL:groupUrl encoding:NSUTF8StringEncoding error:nil];
    DebugLog(@"origin path is %@",groupUrl);
//    DebugLog(@"origin contentString is %@",originContentString);
    // 将contentString的内容写入到originContentString中去
    [originContentString insertString:contentString atIndex:1];
    //将最新的json写入到共享数据区
    [originContentString writeToURL:groupUrl atomically:YES encoding:NSUTF8StringEncoding error:nil];
    //exstension重新加载group中的数据
//    DebugLog(@"the current contentString is %@",originContentString);
    [SFContentBlockerManager reloadContentBlockerWithIdentifier:APP_EXTENSION_NAME completionHandler:^(NSError * _Nullable error) {
        DebugLog(@"ReloadState:%@",error);
        if(nil == error){
            DebugLog(@"extension data reload success");
        }
    }];
}

-(void)disableBlockRuleWithName: (NSString *)ruleFileName
{
    //获取共享区文件的路径
    NSURL *groupUrl = [self getGroupShareJsonURL];
    //根据路径获取内容
    NSMutableString *originContentString = [NSMutableString stringWithContentsOfURL:groupUrl encoding:NSUTF8StringEncoding error:nil];

    NSString *contentString = [self getLocalJsonStringWithFileName:ruleFileName];
    //查找字符串并删除,查找ImageRule并移除
    NSRange range = [originContentString rangeOfString:contentString];
    if (range.location == NSNotFound) {
        DebugLog(@"can't found rules in origin rule");
        return;
    }
    [originContentString deleteCharactersInRange:range];
    DebugLog(@"originContent is %@",originContentString);

    //将数据保存到共享区并刷新
    [originContentString writeToURL:groupUrl atomically:YES encoding:NSUTF8StringEncoding error:nil];
    [SFContentBlockerManager reloadContentBlockerWithIdentifier:APP_EXTENSION_NAME completionHandler:^(NSError * _Nullable error) {
        if (error == nil) {
            DebugLog(@"extension data reload success");
        }
    }];
}

-(NSString *)getLocalJsonStringWithFileName: (NSString *)ruleFileName
{
    // 1.从对应的blockList中读取文件
    NSString *path =[[NSBundle mainBundle] pathForResource:ruleFileName ofType:nil];
    NSString *contentString = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSCharacterSet *whiteSpace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    contentString = [contentString stringByTrimmingCharactersInSet:whiteSpace];
    contentString = [contentString stringByAppendingString:@","];
    DebugLog(@"path is %@",path);
    DebugLog(@"contentString is %@",contentString);
    return contentString;

}
-(NSURL *)getGroupShareJsonURL
{
    return [[[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:APP_GROUP_NAME ]URLByAppendingPathComponent:JSON_BLOCKLIST_ORIGIN];
}


-(NSString*)buildRequestRemoteRulesUrl
{
    NSString* api_server;
    NSString* api_path;
    api_server = API_SERVER_URI_FOR_RELEASE;

    api_path = API_SERVER_RULE_LIST;
    NSString* pn = [DeviceUtils packageNameString];
    NSString* lc = [DeviceUtils preferreduserLocale];
    if(!lc){
        lc = @"en_us";
    }
    return [NSString stringWithFormat:@"%@/%@?pn=%@&lc=%@&os=ios&appvc=%ld&id=%lu", api_server, api_path, pn, lc, (long)[DeviceUtils appVersionCodeInteger], (unsigned long)[self maxRuleVersion]];
}
@end
