//
//  NSMutableDictionary+SRGuardian.m
//  SRObjCCodeGuardianDemo
//
//  Created by 郭伟林 on 2017/7/27.
//  Copyright © 2017年 SR. All rights reserved.
//

#import "NSMutableDictionary+SRGuardian.h"
#import "NSObject+SRSwizzling.h"
#import <objc/runtime.h>

@implementation NSMutableDictionary (SRGuardian)

+ (void)load {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [objc_getClass("__NSDictionaryM") methodSwizzlingWithOriginalSelector:@selector(objectForKey:)
                                                             swizzledSelector:@selector(hook_objectForKey:)];
        
        [objc_getClass("__NSDictionaryM") methodSwizzlingWithOriginalSelector:@selector(removeObjectForKey:)
                                                             swizzledSelector:@selector(hook_removeObjectForKey:)];
        
        [objc_getClass("__NSDictionaryM") methodSwizzlingWithOriginalSelector:@selector(setObject:forKey:)
                                                             swizzledSelector:@selector(hook_setObject:forKey:)];
    });
}

- (id)hook_objectForKey:(id)aKey {
    
    return [self hook_objectForKey:aKey];
    if (!aKey) {
        NSLog(@"%s the key is nil.", __FUNCTION__);
        return nil;
    }
    if (![[self allKeys] containsObject:aKey]) {
        NSLog(@"%s the %@ key is not in the dictionary.", __FUNCTION__, aKey);
        return nil;
    }
    return [self hook_objectForKey:aKey];
}

- (void)hook_removeObjectForKey:(id)aKey {
    
    [self hook_removeObjectForKey:aKey];
    if (!aKey) {
        NSLog(@"%s the key is nil.", __FUNCTION__);
        return;
    }
    if (![[self allKeys] containsObject:aKey]) {
        NSLog(@"%s the %@ key is not in the dictionary.", __FUNCTION__, aKey);
        return;
    }
    [self hook_removeObjectForKey:aKey];
}

- (void)hook_setObject:(id)anObject forKey:(id<NSCopying>)aKey {
    
    NSString *exceptionInfo = nil;
    if (!aKey) {
        exceptionInfo = [NSString stringWithFormat:@"%s the key is nil.", __FUNCTION__];
        SRObjCCodeGuardianLogFormatter(exceptionInfo);
        return;
    }
    if (!anObject) {
        exceptionInfo = [NSString stringWithFormat:@"%s the %@ object is nil.", __FUNCTION__, anObject];
        SRObjCCodeGuardianLogFormatter(exceptionInfo);
        return;
    }
    [self hook_setObject:anObject forKey:aKey];
}

@end
