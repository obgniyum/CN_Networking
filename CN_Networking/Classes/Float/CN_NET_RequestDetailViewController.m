//
//  CN_NET_RequestDetailViewController.m
//  CN_Networking
//
//  Created by Obgniyum on 2018/7/26.
//

#import "CN_NET_RequestDetailViewController.h"

@interface CN_NET_RequestDetailViewController ()

@property (strong, nonatomic) UITextView *tv;

@end

@implementation CN_NET_RequestDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Request Detail";
    
//    UIColor *selectedColor = [UIColor colorWithRed:32 / 255.0 green:136 / 255.0 blue:22 / 255.0 alpha:1];
    [self.view addSubview:self.tv];
    self.tv.frame = CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64);
    if (self.successData) {
        self.tv.textColor = UIColor.blackColor;
        self.tv.text = self.successData.description;
    } else {
        self.tv.textColor = UIColor.redColor;
        self.tv.text = self.failureData.description;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITextView *)tv {
    if (!_tv) {
        _tv = [[UITextView alloc] init];
        _tv.editable = NO;
    }
    return _tv;
}

@end
