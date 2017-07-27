//
//  NSMutableArray+SRGuardian.m
//  SRObjCCodeGuardianDemo
//
//  Created by 郭伟林 on 2017/7/27.
//  Copyright © 2017年 SR. All rights reserved.
//

#import "NSMutableArray+SRGuardian.h"
#import "NSObject+SRSwizzling.h"
#import <objc/runtime.h>

@implementation NSMutableArray (SRGuardian)

+ (void)load {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [objc_getClass("__NSArrayM") methodSwizzlingWithOriginalSelector:@selector(objectAtIndex:)
                                                        swizzledSelector:@selector(hook_objectAtIndex:)];
        
        [objc_getClass("__NSArrayM") methodSwizzlingWithOriginalSelector:@selector(setObject:atIndexedSubscript:)
                                                        swizzledSelector:@selector(hook_setObject:atIndexedSubscript:)];
        
        [objc_getClass("__NSArrayM") methodSwizzlingWithOriginalSelector:@selector(addObject:)
                                                        swizzledSelector:@selector(hook_addObject:)];
        
        [objc_getClass("__NSArrayM") methodSwizzlingWithOriginalSelector:@selector(removeObject:)
                                                        swizzledSelector:@selector(hook_removeObject:)];
        
        [objc_getClass("__NSArrayM") methodSwizzlingWithOriginalSelector:@selector(insertObject:atIndex:)
                                                        swizzledSelector:@selector(hook_insertObject:atIndex:)];
        
        [objc_getClass("__NSArrayM") methodSwizzlingWithOriginalSelector:@selector(removeObjectAtIndex:)
                                                        swizzledSelector:@selector(hook_removeObjectAtIndex:)];
    });
}

- (id)hook_objectAtIndex:(NSUInteger)index {
    
    NSString *exceptionInfo = nil;
    if (self.count == 0) {
        exceptionInfo = [NSString stringWithFormat:@"%s the array is empty.", __FUNCTION__];
        SRObjCCodeGuardianLogFormatter(exceptionInfo);
        return nil;
    }
    if (index >= self.count) {
        exceptionInfo = [NSString stringWithFormat:@"%s %zd index is out of bounds for get.", __FUNCTION__, index];
        SRObjCCodeGuardianLogFormatter(exceptionInfo);
        return nil;
    }
    return [self hook_objectAtIndex:index];
}

- (void)hook_setObject:(id)anObject atIndexedSubscript:(NSUInteger)index {
    
    NSString *exceptionInfo = nil;
    if (!anObject) {
        exceptionInfo = [NSString stringWithFormat:@"%s can't setObject nil object at index %zd.", __FUNCTION__, index];
        SRObjCCodeGuardianLogFormatter(exceptionInfo);
    } else if (index > self.count) {
        exceptionInfo = [NSString stringWithFormat:@"%s %zd index is out of bounds for set", __FUNCTION__, index];
        SRObjCCodeGuardianLogFormatter(exceptionInfo);
    } else {
        [self hook_setObject:anObject atIndexedSubscript:index];
    }
}

- (void)hook_addObject:(id)anObject {
    
    NSString *exceptionInfo = nil;
    if (!anObject) {
        exceptionInfo = [NSString stringWithFormat:@"%s can't add nil object into array.", __FUNCTION__];
        SRObjCCodeGuardianLogFormatter(exceptionInfo);
    } else {
        [self hook_addObject:anObject];
    }
}

- (void)hook_removeObject:(id)anObject {
    
    NSString *exceptionInfo = nil;
    if (!anObject) {
        exceptionInfo = [NSString stringWithFormat:@"%s call -removeObject:, but the argument anObject is nil.", __FUNCTION__];
        SRObjCCodeGuardianLogFormatter(exceptionInfo);
    } else {
        [self hook_removeObject:anObject];
    }
}

- (void)hook_insertObject:(id)anObject atIndex:(NSUInteger)index {
    
    NSString *exceptionInfo = nil;
    if (!anObject) {
        exceptionInfo = [NSString stringWithFormat:@"%s can't insert nil into array", __FUNCTION__];
        SRObjCCodeGuardianLogFormatter(exceptionInfo);
    } else if (index > self.count) { // Note here is no '='
        exceptionInfo = [NSString stringWithFormat:@"%s %zd index is out of bounds for insert", __FUNCTION__, index];
        SRObjCCodeGuardianLogFormatter(exceptionInfo);
    } else {
        [self hook_insertObject:anObject atIndex:index];
    }
}

- (void)hook_removeObjectAtIndex:(NSUInteger)index {
    
    NSString *exceptionInfo = nil;
    if (self.count == 0) {
        exceptionInfo = [NSString stringWithFormat:@"%s the array is empty.", __FUNCTION__];
        SRObjCCodeGuardianLogFormatter(exceptionInfo);
        return;
    }
    if (index >= self.count) {
        exceptionInfo = [NSString stringWithFormat:@"%s %zd index out of bounds for remove.", __FUNCTION__, index];
        SRObjCCodeGuardianLogFormatter(exceptionInfo);
        return;
    }
    [self hook_removeObjectAtIndex:index];
}

@end
