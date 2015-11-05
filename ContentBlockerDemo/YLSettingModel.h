//
//  YLSettingModel.h
//  ContentBlockerDemo
//
//  Created by lyang on 11/5/15.
//  Copyright © 2015 lyang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YLSettingModel : NSObject

@property (nonatomic,copy)NSString *text;

@property (nonatomic,copy)NSString *desc;

-(instancetype)initWithDic: (NSDictionary *)dic;
+(instancetype)settingWithDic: (NSDictionary *)dic;

@end
