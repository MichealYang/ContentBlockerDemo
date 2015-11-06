//
//  Debug.h
//  ContentBlocker
//
//  Created by baina on 9/11/15.
//  Copyright © 2015 Baina/JieLi. All rights reserved.
//


#ifdef DEBUG

#ifdef LOG_VERBOSE
#define DebugLog( s, ... ) NSLog((@"%s [Line %d] " s), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define DebugLog( s, ... ) NSLog(s, ##__VA_ARGS__)
#endif

#else

#define DebugLog( s, ... )

#endif

#define DEBUGM 1

#ifdef DEBUGM
#import <objc/runtime.h>
#define DEBUG_LOG_MEMORY DebugLog(@"%s is dealloc....", class_getName([self class]));
#else
#define DEBUG_LOG_MEMORY
#endif