//
//  DeviceUtils.h
//  Dolphin
//
//  Created by Jim Huang on 6/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

/* For iPad also import SIM related library, because until now we cannot import library when runtime*/
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>

#define DATA_VERSION_KEY                         @"DateVersion"
#define DATA_VERSION_CODE_LENGTH                 6

#define IsAtLeastiOSVersion(X) ([[[UIDevice currentDevice] systemVersion] compare:X options:NSNumericSearch] != NSOrderedAscending)

#define STATUS_BAR_HEIGHT 20

#if defined(__IPHONE_7_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_7_0

#define CONTENT_TOP_MARGIN (IsAtLeastiOSVersion(@"7.0")? STATUS_BAR_HEIGHT: 0)

#else

#define CONTENT_TOP_MARGIN 0

#endif

@interface DeviceUtils : NSObject {
    
}

+(BOOL)isPad;
+(NSString*)machineType;
+(NSString *)deviceOSVersion;
+(NSString *)appVersionString;
+(NSString *)appVersionCodeString;
+(NSInteger)appVersionCodeInteger;
+(NSString *)packageNameString;
+(NSString*)preferredUserLanguage;
+(NSString*)preferreduserLocale;
@end
