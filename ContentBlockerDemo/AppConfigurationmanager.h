//
//  AppConfigurationmanager.h
//  ContentBlocker
//
//  Created by baina on 9/10/15.
//  Copyright © 2015 Baina/JieLi. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface AppConfigurationmanager : NSObject
+(AppConfigurationmanager *) shareInstance;

-(void)setIsNewUser;
-(BOOL)isNewUser;
-(void)incraseAppLaunchCount;
-(NSUInteger)launchCount;
-(BOOL)firstLaunch;
-(BOOL)hadShowUserGuild;
-(void)setShowUserGuild;
-(BOOL)isAdBlockerOK;
-(void)setAdBlockerOK;
-(void)setShow1Button:(BOOL)show1;
-(BOOL)show1Button;
-(BOOL)canChangePage;
-(void)setChangePage:(BOOL)change;
-(void)sethasLoadDefaultRules:(BOOL)need;
-(BOOL)hasLoadDefaultRules;
-(void)setNeedShowUpdateBadge:(BOOL)need;
-(BOOL)needShowUpdateBadge;
-(void)setneedGoToUpdate:(BOOL)need;
-(BOOL)needGoToUpdate;
-(NSUInteger)maxRuleVersion;
-(void)updateMaxRuleVersion:(NSUInteger)version;
-(NSNumber *)getFisrtLaunchTime;
-(void)setFirstLaunchTime: (NSNumber *)time;
-(BOOL)shouldRateAppDialogShow;
-(BOOL)hasRatedApp;
-(void)setHasRatedApp;
-(BOOL)hasReminderRateApp;
-(void)setHasReminderRateApp;
-(void)setSwitchState:(NSDictionary *)switchStatDic;
-(NSMutableDictionary *)getSwitchState;
@end
