//
//  UIViewController+AOP_Life.m
//  CN_Networking_Example
//
//  Created by Obgniyum on 2018/7/28.
//  Copyright © 2018年 obgniyum. All rights reserved.
//

#import "UIViewController+AOP_Life.h"
#import <objc/runtime.h>

@implementation UIViewController (AOP_Life)

+ (void)load {
    // success
    Method method_success_original = class_getInstanceMethod([self class], @selector(viewWillAppear:));
    Method method_success_swizzled = class_getInstanceMethod([self class], @selector(aop_viewWillAppear:));
    if (method_success_original && method_success_swizzled) {
        method_exchangeImplementations(method_success_original, method_success_swizzled);
    }
}

- (void)aop_viewWillAppear:(BOOL)anm {
    NSLog(@"%@-viewWillAppear", NSStringFromClass([self class]));
    [self aop_viewWillAppear:anm];
}

@end
