//
//  UIViewController+AOP_LifeCycle.m
//  AFNetworking
//
//  Created by Obgniyum on 2018/7/28.
//

#import "UIViewController+CN_NET_AOP.h"
#import <objc/runtime.h>
#import "CN_NET_Float.h"

@implementation UIViewController (CN_NET_AOP)

+ (void)load {
    // viewWillAppear
    Method ori_viewWillAppear = class_getInstanceMethod([self class], @selector(viewWillAppear:));
    Method new_viewWillAppear = class_getInstanceMethod([self class], @selector(aop_viewWillAppear_cn_net_float:));
    if (ori_viewWillAppear && new_viewWillAppear) {
        method_exchangeImplementations(ori_viewWillAppear, new_viewWillAppear);
    }
    
    // dealloc
    Method ori_dealloc = class_getInstanceMethod([self class], NSSelectorFromString(@"dealloc"));
    Method new_dealloc = class_getInstanceMethod([self class], @selector(aop_dealloc_cn_net_float));
    if (ori_dealloc && new_dealloc) {
        method_exchangeImplementations(ori_dealloc, new_dealloc);
    }
}

- (void)aop_viewWillAppear_cn_net_float:(BOOL)animated {
    [self aop_viewWillAppear_cn_net_float:animated];
    NSString *selfName = NSStringFromClass([self class]);
    NSArray *targetControllerNames = @[@"CN_NET_RequestListViewController", @"CN_NET_EnvironmentSettingViewController"];
    for (NSString *name in targetControllerNames) {
        if ([name isEqualToString:selfName]) {
            [[CN_NET_Float CN_Instance] cn_show:NO];
        }
    }
}

- (void)aop_dealloc_cn_net_float {
    NSString *selfName = NSStringFromClass([self class]);
    [self aop_dealloc_cn_net_float];
    NSArray *targetControllerNames = @[@"CN_NET_RequestListViewController", @"CN_NET_EnvironmentSettingViewController"];
    for (NSString *name in targetControllerNames) {
        if ([name isEqualToString:selfName]) {
            [[CN_NET_Float CN_Instance] cn_show:YES];
        }
    }
}


@end
