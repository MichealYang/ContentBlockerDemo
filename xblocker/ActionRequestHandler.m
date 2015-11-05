//
//  ActionRequestHandler.m
//  xblocker
//
//  Created by lyang on 15/9/2.
//  Copyright © 2015年 lyang. All rights reserved.
//

#import "ActionRequestHandler.h"

@interface ActionRequestHandler ()

@end

@implementation ActionRequestHandler

- (void)beginRequestWithExtensionContext:(NSExtensionContext *)context {

    NSURL *groupURL = [[NSFileManager defaultManager]
                       containerURLForSecurityApplicationGroupIdentifier:
                       @"group.com.yang.blocker"];
    NSString *Json_path=[groupURL.absoluteString stringByAppendingPathComponent:@"originAdRule.json"];

    NSURL* url = [NSURL URLWithString:Json_path];
    if(nil == groupURL
       || nil == Json_path
       || nil == url) {
        [self loadBuildInRules:context];
        return;
    }
    NSItemProvider *attach = [[NSItemProvider alloc] initWithContentsOfURL:url];
    NSExtensionItem *item = [[NSExtensionItem alloc] init];
    item.attachments = @[attach];
    [context completeRequestReturningItems:@[item] completionHandler:nil];

}

-(void)loadBuildInRules:(NSExtensionContext *)context
{
    NSItemProvider *attachment = [[NSItemProvider alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"blockerList" withExtension:@"json"]];

    NSExtensionItem *item = [[NSExtensionItem alloc] init];
    item.attachments = @[attachment];

    [context completeRequestReturningItems:@[item] completionHandler:nil];
}
@end
