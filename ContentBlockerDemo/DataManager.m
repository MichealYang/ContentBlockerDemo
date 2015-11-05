//
//  DataManager.m
//  ContentBlockerDemo
//
//  Created by lyang on 10/21/15.
//  Copyright © 2015 lyang. All rights reserved.
//

#import "DataManager.h"
#import "AppConfigurationmanager.h"
#import "Constants.h"

@implementation DataManager

+(DataManager*)shareInstance
{
    static DataManager *_instance = nil;

    static dispatch_once_t oncePredicate;

    dispatch_once(&oncePredicate, ^{
        _instance = [[DataManager alloc] init];
    });

    return _instance;
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

@end
