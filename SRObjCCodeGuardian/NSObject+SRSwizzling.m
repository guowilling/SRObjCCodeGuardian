//
//  NSObject+SRSwizzling.m
//  SRObjCCodeGuardianDemo
//
//  Created by 郭伟林 on 2017/7/27.
//  Copyright © 2017年 SR. All rights reserved.
//

#import "NSObject+SRSwizzling.h"
#import <objc/runtime.h>

@implementation NSObject (SRSwizzling)

+ (void)methodSwizzlingWithOriginalSelector:(SEL)originalSelector swizzledSelector:(SEL)swizzledSelector {
    
    //Method originalMethod = class_getInstanceMethod(self, originalSelector);
    //Method swizzledMethod = class_getInstanceMethod(self, swizzledSelector);
    //method_exchangeImplementations(originalMethod, swizzledMethod);
    
    Method originalMethod = class_getInstanceMethod(self, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(self, swizzledSelector);
    BOOL didAddMethod = class_addMethod(self, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    if (didAddMethod) {
        class_replaceMethod(self, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

@end
