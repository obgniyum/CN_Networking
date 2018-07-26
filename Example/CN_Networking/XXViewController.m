//
//  XXViewController.m
//  CN_Networking
//
//  Created by obgniyum on 07/25/2018.
//  Copyright (c) 2018 obgniyum. All rights reserved.
//

#import "XXViewController.h"
#import "CN_Networking.h"


@interface XXViewController ()

@property (nonatomic, strong) UIWindow *w;

@end

@implementation XXViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.backgroundColor = [UIColor redColor];
    btn.frame = CGRectMake(200, 300, 100, 30);
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(xxx) forControlEvents:UIControlEventTouchUpInside];

}

- (void)xxx {
    [[CN_NET_Float CN_Instance] cn_show:NO];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [CN_Network CN_Request:^(CN_Network *http) {
        http.path = @"/xm/login";
        http.method = CN_REQ_METHOD_POST;
        http.params = @{
                        @"k" : @"v"
                        };
        http.cookie = @{
                        @"k" : @"v",
                        @"k2" : @"v2"
                        };
        http.timeout = 30.f;
    } success:^(id result) {

    } failure:^(NSString *errMsg) {

    }];

//    [[CN_NET_Float CN_Instance] cn_show:YES];

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
