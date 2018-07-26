//
//  CN_NET_FloatBaseViewController.m
//  CN_Networking
//
//  Created by Obgniyum on 2018/7/26.
//

#import "CN_NET_FloatBaseViewController.h"
#import "CN_NET_Float.h"

@interface CN_NET_FloatBaseViewController ()

@end

@implementation CN_NET_FloatBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[CN_NET_Float CN_Instance] cn_show:NO];
}

- (void)dealloc {
    [[CN_NET_Float CN_Instance] cn_show:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
