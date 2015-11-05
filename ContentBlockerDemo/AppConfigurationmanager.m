//
//  AppConfigurationmanager.m
//  ContentBlocker
//
//  Created by baina on 9/10/15.
//  Copyright © 2015 Baina/JieLi. All rights reserved.
//

#import "AppConfigurationmanager.h"
#import "Constants.h"

@implementation AppConfigurationmanager
+(AppConfigurationmanager*)shareInstance
{
    static AppConfigurationmanager *_instance = nil;

    static dispatch_once_t oncePredicate;

    dispatch_once(&oncePredicate, ^{
        _instance = [[AppConfigurationmanager alloc] init];
    });
    return _instance;
}

-(void)incraseAppLaunchCount
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSUInteger count = [userDefaults integerForKey:KEY_AD_BLOCKER_RUN_COUNT];
    [userDefaults setInteger:++count forKey:KEY_AD_BLOCKER_RUN_COUNT];
    [userDefaults synchronize];
}

-(NSUInteger)launchCount
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSUInteger count = [userDefaults integerForKey:KEY_AD_BLOCKER_RUN_COUNT];
    return count;
}

-(BOOL)firstLaunch {
    return [self launchCount] <=1;
}

-(BOOL)hadShowUserGuild
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults boolForKey:KEY_HAD_SHOW_USER_GUILD];
}

-(void)setShowUserGuild
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:YES forKey:KEY_HAD_SHOW_USER_GUILD];
    [userDefaults synchronize];
}

-(BOOL)isAdBlockerOK
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults boolForKey:KEY_AD_BLOCKER_SET_OK];
}

-(void)setAdBlockerOK
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:YES forKey:KEY_AD_BLOCKER_SET_OK];
    [userDefaults synchronize];
}

-(void)setShow1Button:(BOOL)show1
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:show1 forKey:KEY_DHOW_1_BUTTON];
    [userDefaults synchronize];
}

-(BOOL)show1Button
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults boolForKey:KEY_DHOW_1_BUTTON];
}

-(void)setChangePage:(BOOL)change
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:change forKey:KEY_CAN_CHANGE_PAGE];
    [userDefaults synchronize];
}

-(BOOL)canChangePage
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults boolForKey:KEY_CAN_CHANGE_PAGE];
}

-(void)sethasLoadDefaultRules:(BOOL)need
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:need forKey:KEY_NEED_LOAD_DEFAULT_RULES];
    [userDefaults synchronize];
}

-(BOOL)hasLoadDefaultRules
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults boolForKey:KEY_NEED_LOAD_DEFAULT_RULES];
}

-(void)setNeedShowUpdateBadge:(BOOL)need
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:need forKey:KEY_NEED_SHOW_UPDATE_BADGE];
    [userDefaults synchronize];
}

-(BOOL)needShowUpdateBadge
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults boolForKey:KEY_NEED_SHOW_UPDATE_BADGE];
}

-(void)setneedGoToUpdate:(BOOL)need
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:need forKey:KEY_NEED_GO_TO_UPDATE];
    [userDefaults synchronize];
}

-(BOOL)needGoToUpdate
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults boolForKey:KEY_NEED_GO_TO_UPDATE];
}

-(void)updateMaxRuleVersion:(NSUInteger)version
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setInteger:version forKey:KEY_MAX_RULE_VERSION];
    [userDefaults synchronize];
}

-(NSUInteger)maxRuleVersion
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults integerForKey:KEY_MAX_RULE_VERSION];
}

-(NSString *)getLastLanguage
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults valueForKey:KEY_LAST_LANGUAGE];
}

-(void)setLastLanguage:(NSString *)language

{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setValue:language forKey:KEY_LAST_LANGUAGE];
    [userDefaults synchronize];
}

@end
