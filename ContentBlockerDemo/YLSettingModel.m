//
//  YLSettingModel.m
//  ContentBlockerDemo
//
//  Created by lyang on 11/5/15.
//  Copyright © 2015 lyang. All rights reserved.
//

#import "YLSettingModel.h"

@implementation YLSettingModel




-(instancetype)initWithDic:(NSDictionary *)dic
{
    if (self = [super init]) {
        self.text = [dic objectForKey:@"text"];
        self.desc = [dic objectForKey:@"desc"];
    }
    return self;

}


+ (instancetype)settingWithDic:(NSDictionary *)dic
{
    return [[self alloc]initWithDic:dic];
}

@end
