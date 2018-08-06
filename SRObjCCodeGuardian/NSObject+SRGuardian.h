//
//  NSObject+SRGuardian.h
//  SRObjCCodeGuardianDemo
//
//  Created by https://github.com/guowilling on 2017/7/27.
//  Copyright © 2017年 SR. All rights reserved.
//
//  守护 ObjC 代码, 防止操作数组字典, unrecognized selector 等引起的程序 Crash.

#import <Foundation/Foundation.h>

/// Set 1 when occurs exception, console will print log to locate the bug;
/// Set 0 when occurs exception, application will crash and print sys log.
#define SRObjCCodeGuardianDebugMode 1

#define SRObjCCodeGuardianAssert(exceptionInfo) NSAssert(SRObjCCodeGuardianDebugMode != 0, exceptionInfo);

#define SRObjCCodeGuardianLogFormatter(exceptionInfo)            \
SRObjCCodeGuardianAssert(exceptionInfo);                         \
printf("----------------SRObjCCodeGuardian-----------------\n"); \
SRLog(@"%@", exceptionInfo);                                     \
printf("---------------------------------------------------\n"); \

#ifdef SRObjCCodeGuardianDebugMode
#define SRLog(FORMAT, ...) {\
NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];\
[dateFormatter setDateStyle:NSDateFormatterMediumStyle];\
[dateFormatter setTimeStyle:NSDateFormatterShortStyle];\
[dateFormatter setDateFormat:@"HH:mm:ss:SSSS"];\
NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];\
fprintf(stderr,"[%s:%d %s] %s\n", [[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, [dateString UTF8String], [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);\
}
#else
#define SRLog(FORMAT, ...) nil
#endif

@interface NSObject (SRGuardian)

+ (void)methodSwizzlingWithOriginalSelector:(SEL)originalSelector swizzledSelector:(SEL)swizzledSelector;

@end
