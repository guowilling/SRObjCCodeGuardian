//
//  NSObject+SRSwizzling.h
//  SRObjCCodeGuardianDemo
//
//  Created by 郭伟林 on 2017/7/27.
//  Copyright © 2017年 SR. All rights reserved.
//

#import <Foundation/Foundation.h>


#define SRObjCCodeGuardianDebugMode 1 // If value is 0, when occurs nil exception, application will crash.

#define SRObjCCodeGuardianAssert(exceptionInfo) NSAssert(SRObjCCodeGuardianDebugMode != 0, exceptionInfo);

#define SRObjCCodeGuardianLogFormatter(exceptionInfo) \
printf("----------------SRObjCCodeGuardian-----------------\n"); \
NSLog(@"%@", exceptionInfo);                                     \
SRObjCCodeGuardianAssert(exceptionInfo);                         \
printf("---------------------------------------------------\n"); \


@interface NSObject (SRSwizzling)

+ (void)methodSwizzlingWithOriginalSelector:(SEL)originalSelector swizzledSelector:(SEL)swizzledSelector;

@end
