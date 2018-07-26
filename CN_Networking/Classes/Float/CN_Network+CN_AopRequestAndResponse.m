//
//  CN_Network+CN_AopRequestAndResponse.m
//  CN_Networking
//
//  Created by Obgniyum on 2018/7/26.
//

#import "CN_Network+CN_AopRequestAndResponse.h"
#import <objc/runtime.h>
#import "CN_NET_Float.h"

@implementation CN_Network (CN_AopRequestAndResponse)

+ (void)load {
    // request
    Method method_request_original = class_getInstanceMethod([self class], @selector(_request));
    Method method_request_swizzled = class_getInstanceMethod([self class], @selector(aop_request));
    if (method_request_original && method_request_swizzled) {
        method_exchangeImplementations(method_request_original, method_request_swizzled);
    }
    
    // success
    Method method_success_original = class_getInstanceMethod([self class], @selector(_handleSuccess:));
    Method method_success_swizzled = class_getInstanceMethod([self class], @selector(aop_success:));
    if (method_success_original && method_success_swizzled) {
        method_exchangeImplementations(method_success_original, method_success_swizzled);
    }
    
    // failure
    Method method_failure_original = class_getInstanceMethod([self class], @selector(_handleFailure:));
    Method method_failure_swizzled = class_getInstanceMethod([self class], @selector(aop_failure:));
    if (method_failure_original && method_failure_swizzled) {
        method_exchangeImplementations(method_failure_original, method_failure_swizzled);
    }
}

- (void)aop_request {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSMutableDictionary *request = [NSMutableDictionary dictionary];
        request[@"request"] = self.description;
        request[@"url"] = self.url;
        request[@"method"] = @(self.method);
        request[@"params"] = self.params;
        request[@"header"] = self.header;
        request[@"cookie"] = self.cookie;
        [[CN_NET_Float CN_Instance].dataSource addObject:request];
    });
    return [self aop_request];
}

- (void)aop_success:(id _Nullable)responseObject {
    [[CN_NET_Float CN_Instance].dataSource enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(NSMutableDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj[@"request"] isEqualToString:self.description]) {
            obj[@"success"] = responseObject;
            *stop = YES;
        }
    }];
    [self aop_success:responseObject];
}

- (void)aop_failure:(NSError * _Nonnull)error {
    [[CN_NET_Float CN_Instance].dataSource enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(NSMutableDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj[@"request"] isEqualToString:self.description]) {
            obj[@"failure"] = error;
            *stop = YES;
        }
    }];
    [self aop_failure:error];
}


@end
