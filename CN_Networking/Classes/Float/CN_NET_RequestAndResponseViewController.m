//
//  CN_NET_RequestDetailViewController.m
//  CN_Networking
//
//  Created by Obgniyum on 2018/7/26.
//

#import "CN_NET_RequestAndResponseViewController.h"

@interface CN_NET_RequestAndResponseViewController ()

@property (strong, nonatomic) UITextView *tv;

@end

@implementation CN_NET_RequestAndResponseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

// MARK:- UI
- (void)setupViews {
    self.navigationItem.title = @"Response";
    
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

// MARK:- Lazy

- (UITextView *)tv {
    if (!_tv) {
        _tv = [[UITextView alloc] init];
        _tv.editable = NO;
    }
    return _tv;
}

@end
