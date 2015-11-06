//
//  DeviceUtils.m
//  Dolphin
//
//  Created by Jim Huang on 6/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DeviceUtils.h"
/* For iPad also import SIM related library, because until now we cannot import library when runtime*/
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <UIKit/UIKit.h>
#import <sys/sysctl.h>
#define GUID_KEY                       @"GUID"
#define BUNDLE_VERSION_CODE_KEY        @"Bundle version code"
#define MARKET_NAME_KEY                @"Market Name"

#define Y_PIEXL_COUNT_IN_4_INCHES_SCREEN 1136
#define X_PIEXL_COUNT_IN_4_INCHES_SCREEN 640

@implementation DeviceUtils


+(BOOL)isPad
{
#ifdef UI_USER_INTERFACE_IDIOM
    return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
#else
    return [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad;
#endif
}


+(NSString*)machineType
{
    static NSString *platform = nil;
    if (nil == platform)
    {
        size_t size;
        sysctlbyname("hw.machine", NULL, &size, NULL, 0);
        char *machine = malloc(size);
        memset(machine, 0, size);
        sysctlbyname("hw.machine", machine, &size, NULL, 0);
        platform = [[NSString stringWithCString:machine encoding:NSUTF8StringEncoding] copy];
        free(machine);
    }

    // For iphone it's a litter strange, @"iPhone3,x" is for iPhone4, @"iPhone4,1" is for iPhone4S.
    if ([platform isEqualToString:@"iPhone1,1"])    return @"iPhone1G";
    if ([platform isEqualToString:@"iPhone1,2"])    return @"iPhone3G";
    if ([platform isEqualToString:@"iPhone2,1"])    return @"iPhone3GS";
    if ([platform hasPrefix:@"iPhone3"]) return @"iPhone4";     // @"iPhone3,1" for @"iPhone 4", @"iPhone3,3" for @"Verizon iPhone 4".
    if ([platform isEqualToString:@"iPhone4,1"])    return @"iPhone4S";
    if ([platform hasPrefix:@"iPhone5"] || [platform hasPrefix:@"iPod5"]) return @"iPhone5"; //iPhone 5 GSM - iPhone5,1 iPhone 5 CDMA - iPhone5,2 iPod 5 - iPod5,1
    if ([platform hasPrefix:@"iPhone6"] ) return @"iPhone5S";
    if ([platform hasPrefix:@"iPhone7,1"]) return @"iPhone6p";
    if ([platform hasPrefix:@"iPhone7,2"]) return @"iPhone6";

    if ([platform hasPrefix:@"iPad1,1"]) return @"iPad1";
    if ([platform hasPrefix:@"iPad2,1"]) return @"iPad2";
    if ([platform hasPrefix:@"iPad3,1"]) return @"iPad Generation";
    if ([platform hasPrefix:@"iPad4,1"]) return @"iPad Air Wifi";
    if ([platform hasPrefix:@"iPad4,2"]) return @"iPad Air Cellular";
    if ([platform hasPrefix:@"iPad4,4"]) return @"iPad Mini2 Wifi";
    if ([platform hasPrefix:@"iPad4,5"]) return @"iPad Mini2 Cellular";
    if ([platform hasPrefix:@"iPad4,6"]) return @"iPad Mini3";
    if ([platform hasPrefix:@"iPad4,7"]) return @"iPad Mini3";
    return platform;
}

+(NSString *)deviceOSVersion
{
    static NSString *systemVersion;

    if (systemVersion == nil)
    {
        UIDevice *device = [UIDevice currentDevice];
        //get systemVersion need 143ms, so cache it
        systemVersion = [device systemVersion];
    }

    return systemVersion;
}

+ (NSString *)appVersionCodeString
{
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
}

+(NSInteger)appVersionCodeInteger
{
    return [[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"] integerValue];
}

+ (NSString *)appVersionString
{
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
}

+ (NSString *)packageNameString
{
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleIdentifierKey];
}

+ (NSString*)preferredUserLanguage {

    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary * globalDomain = [defaults persistentDomainForName:@"NSGlobalDomain"];
    NSArray * languages = [globalDomain objectForKey:@"AppleLanguages"];

    NSString* preferredLang = [languages objectAtIndex:0];

    return preferredLang;
}

+ (NSString*)preferreduserLocale{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary * globalDomain = [defaults persistentDomainForName:@"NSGlobalDomain"];
    NSString * language = [globalDomain objectForKey:@"AppleLocale"];
    return language;
}
@end
