//
//  XXViewController.m
//  CN_Networking
//
//  Created by obgniyum on 07/25/2018.
//  Copyright (c) 2018 obgniyum. All rights reserved.
//

#import "XXViewController.h"
#import "XX_Network.h"


@interface XXViewController ()

@property (nonatomic, strong) UIWindow *w;

@end

@implementation XXViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.backgroundColor = [UIColor redColor];
    [btn setTitle:@"request" forState:UIControlStateNormal];
    btn.frame = CGRectMake(200, 300, 100, 30);
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(request_test) forControlEvents:UIControlEventTouchUpInside];

}

- (void)request_test {
    
    [CN_Network CN_Request:^(CN_Network *http) {
        
    } success:^(id result) {
        
    } failure:^(NSError *error) {
        
    }];
    
    [XX_Network CN_Request:^(CN_Network *http) {
//        http.url = @"http://192.168.0.136:8080/xm/user";
        http.path = @"/xm/user";
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
        
    } failure:^(NSError *error) {
        NSLog(@"%@", error.localizedDescription);
    }];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
