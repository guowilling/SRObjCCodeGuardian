//
//  NSArray+SRGuardian.m
//  SRObjCCodeGuardianDemo
//
//  Created by 郭伟林 on 2017/7/27.
//  Copyright © 2017年 SR. All rights reserved.
//

#import "NSArray+SRGuardian.h"
#import "NSObject+SRGuardian.h"
#import <objc/runtime.h>

@implementation NSArray (SRGuardian)

+ (void)load {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [objc_getClass("__NSArrayI") methodSwizzlingWithOriginalSelector:@selector(objectAtIndex:)
                                                        swizzledSelector:@selector(hook_objectAtIndex:)];
    });
}

- (id)hook_objectAtIndex:(NSUInteger)index {
    
    NSString *exceptionInfo = nil;
    if (self.count == 0) {
        exceptionInfo = [NSString stringWithFormat:@"%s the array is empty.", __FUNCTION__];
        SRObjCCodeGuardianLogFormatter(exceptionInfo)
        return nil;
    }
    if (index >= self.count) {
        exceptionInfo = [NSString stringWithFormat:@"%s %zd index is out of bounds.", __FUNCTION__, index];
        SRObjCCodeGuardianLogFormatter(exceptionInfo)
        return nil;
    }
    return [self hook_objectAtIndex:index];
}

@end
