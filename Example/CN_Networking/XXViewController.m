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

@end

@implementation XXViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [CN_HTTP CN_Request:^(CN_HTTP *http) {
        http.path = @"/xm/login";
        http.method = CN_REQ_METHOD_POST;
        http.params = @{
                        @"k" : @"v"
                        };
        http.header = @{
                        @"Cookie" : @"k1=v1; k2=v2"
                        };
        http.timeout = 30.f;
    } success:^(id result) {
        
    } failure:^(NSString *errMsg) {
        
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
