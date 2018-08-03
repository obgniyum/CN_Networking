//
//  CN_Network+CN_AopRequestAndResponse.m
//  CN_Networking
//
//  Created by Obgniyum on 2018/7/26.
//

#import "CN_Network+AOP_CallBack.h"
#import <objc/runtime.h>
#import "CN_NET_Float.h"

@implementation CN_Network (AOP_CallBack)

+ (void)load {
    // success
    Method method_success_original = class_getInstanceMethod([self class], @selector(callback_success:));
    Method method_success_swizzled = class_getInstanceMethod([self class], @selector(aop_success:));
    if (method_success_original && method_success_swizzled) {
        method_exchangeImplementations(method_success_original, method_success_swizzled);
    }
    
    // failure
    Method method_failure_original = class_getInstanceMethod([self class], @selector(callback_failure:));
    Method method_failure_swizzled = class_getInstanceMethod([self class], @selector(aop_failure:));
    if (method_failure_original && method_failure_swizzled) {
        method_exchangeImplementations(method_failure_original, method_failure_swizzled);
    }
}

- (void)aop_success:(id _Nullable)result {
    [self aop_success:result];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSMutableDictionary *request = [NSMutableDictionary dictionary];
        NSDate *date = [NSDate date];
        NSTimeZone *zone = [NSTimeZone systemTimeZone];
        NSInteger interval = [zone secondsFromGMTForDate:date];
        NSDate *localeDate = [date dateByAddingTimeInterval:interval];
        request[@"time"] = localeDate;
        request[@"url"] = self.url;
        request[@"method"] = @(self.method);
        request[@"params"] = self.params;
        if (self.header.allKeys.count) {
            request[@"header"] = self.header;
        }
        if (self.cookie.allKeys.count) {
            request[@"cookie"] = self.cookie;
        }
        request[@"success"] = result;
        [[CN_NET_Float CN_Instance].dataSource addObject:request];
    });
}

- (void)aop_failure:(NSError * _Nonnull)error {
    [self aop_failure:error];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSMutableDictionary *request = [NSMutableDictionary dictionary];
        NSDate *date = [NSDate date];
        NSTimeZone *zone = [NSTimeZone systemTimeZone];
        NSInteger interval = [zone secondsFromGMTForDate:date];
        NSDate *localeDate = [date dateByAddingTimeInterval:interval];
        request[@"time"] = localeDate;
        request[@"url"] = self.url;
        request[@"method"] = @(self.method);
        request[@"params"] = self.params;
        request[@"header"] = self.header;
        request[@"cookie"] = self.cookie;
        request[@"failure"] = error;
        [[CN_NET_Float CN_Instance].dataSource addObject:request];
    });
}

@end
