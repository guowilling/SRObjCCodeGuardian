//
//  NSDictionary+SRGuardian.m
//  SRObjCCodeGuardianDemo
//
//  Created by https://github.com/guowilling on 2017/7/27.
//  Copyright © 2017年 SR. All rights reserved.
//

#import "NSDictionary+SRGuardian.h"
#import "NSObject+SRGuardian.h"
#import <objc/runtime.h>

@implementation NSDictionary (SRGuardian)

+ (void)load {
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        [objc_getClass("__NSDictionaryI") methodSwizzlingWithOriginalSelector:@selector(objectForKey:)
//                                                             swizzledSelector:@selector(hook_objectForKey:)];
//    });
}

- (id)hook_objectForKey:(id)aKey {
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

@end
