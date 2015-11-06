//
//  BlockerRulesDataManager.h
//  ContentBlocker
//
//  Created by baina on 9/16/15.
//  Copyright © 2015 Baina/JieLi. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface BlockerRulesDataManager : NSObject
{

}
+(BlockerRulesDataManager *) shareInstance;

-(BOOL)checkServerData:(NSDictionary*)data;
-(void)parseServerListData:(NSDictionary*)dataInfo;
-(void)parsePushRuleData:(NSDictionary*)dataInfo;
- (void)downloadFile:(id)sender;
-(void)downloadAllRules:(id)sender;
-(void)loadDefaultRulesIfNeeded;
-(void)saveUpdateRulesToFile:(NSMutableArray*)rules;
-(NSMutableArray*)loadUpdateRulesFromFile;
-(void)testPushData;
-(void)saveNewRule:(NSDictionary*)rule;
-(NSDictionary*)getNewRule;
-(void)setRuleUpdated:(NSDictionary*)rule;
-(BOOL)newRuleUpdated;
-(NSString*)loadContentFromFile:(NSURL*)path;
-(void)addNewRules:(NSString*)newRules;
-(void)relpaseOldRules:(NSURL*)newPath;
-(NSString*)buildRequestRemoteRulesUrl;
-(NSUInteger)maxRuleVersion;
-(void)enableBlockRuleWithName: (NSString *)ruleFileName;
-(void)disableBlockRuleWithName: (NSString *)ruleFileName;
@end
