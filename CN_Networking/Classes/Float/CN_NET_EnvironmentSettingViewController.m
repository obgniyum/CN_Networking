
#import "CN_NET_EnvironmentSettingViewController.h"
#import "CN_NET_Service.h"

@interface CN_NET_EnvironmentSettingViewController ()

@property (strong, nonatomic) UIBarButtonItem *item_right;
@property (strong, nonatomic) UISegmentedControl *seg;
@property (strong, nonatomic) UIView *backView;
@property (strong, nonatomic) NSMutableArray <UITextField *>*tfs;

@end

@implementation CN_NET_EnvironmentSettingViewController

// MARK:- Life

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViews];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

// MARK:- UI
- (void)setupViews {
    self.view.backgroundColor = UIColor.whiteColor;
    
    self.title = @"Environment Setting";
    UIBarButtonItem *item_left = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:self action:@selector(action_back)];
    self.navigationItem.leftBarButtonItem = item_left;
    
    self.item_right = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(action_done)];
    self.navigationItem.rightBarButtonItem = self.item_right;
    
    [self.view addSubview:self.seg];
    self.seg.frame = CGRectMake(20, 64 + 50, [UIScreen mainScreen].bounds.size.width - 20 * 2, 30);
    
    self.backView.frame = CGRectMake(20, 64 + 50 + 30 + 20, [UIScreen mainScreen].bounds.size.width - 20 * 2, 130);
    [self.view addSubview:self.backView];
    
    NSArray *labelTitles = @[@"scheme", @"host", @"port"];
    NSArray *placeholders = @[@"http", @"192.168.0.1", @"8080"];
    for (int i = 0; i < labelTitles.count; i++) {
        UILabel *l = [[UILabel alloc] init];
        l.text = labelTitles[i];
        l.backgroundColor = UIColor.yellowColor;
        l.textAlignment = NSTextAlignmentCenter;
        l.layer.cornerRadius = 3;
        l.layer.masksToBounds = YES;
        l.frame = CGRectMake(10, 10 + i * 40, 70, 30);
        [self.backView addSubview:l];
        
        UITextField *tf = [[UITextField alloc] init];
        tf.placeholder = placeholders[i];
        tf.borderStyle = UITextBorderStyleRoundedRect;
        tf.frame = CGRectMake(10 + 70 + 5, 10 + i * 40, self.backView.bounds.size.width - l.bounds.size.width - 10 - 5 - 10, 30);
        [self.backView addSubview:tf];
        [self.tfs addObject:tf];
    }
    [self ui_refresh_segChanged:self.seg.selectedSegmentIndex];
}

- (void)ui_refresh_segChanged:(NSInteger)index {
    
    [CN_NET_Service CN_Instance].type = index;
    
    [self.view endEditing:YES];
    BOOL isCustom = self.seg.selectedSegmentIndex == 3;
    self.item_right.enabled = isCustom;
    self.backView.hidden = !isCustom;
    
    if (isCustom) {
        NSDictionary *env_custom = [CN_NET_Service CN_Instance].env_custom;
        self.tfs[0].text = env_custom[@"scheme"];
        self.tfs[1].text = env_custom[@"host"];
        self.tfs[2].text = env_custom[@"port"];
    }
    
}

// MARK:- Action
- (void)action_back {
    [self.navigationController dismissViewControllerAnimated:true completion:nil];
}

- (void)action_done {
    if (!self.tfs[0].text.length) {
        NSLog(@"scheme is empty");
        return;
    }
    
    if (!self.tfs[1].text.length) {
        NSLog(@"host is empty");
        return;
    }
    
    if (!self.tfs[2].text.length) {
        NSLog(@"port is empty");
        return;
    }
    
    NSDictionary *env_custom = @{
                          @"scheme" : self.tfs[0].text,
                          @"host" : self.tfs[1].text,
                          @"port" : self.tfs[2].text,
                          };
    [CN_NET_Service CN_Instance].env_custom = env_custom;
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)action_seg:(UISegmentedControl *)seg {
    [self ui_refresh_segChanged:seg.selectedSegmentIndex];
}

// MARK:- Lazy
- (UISegmentedControl *)seg {
    if (!_seg) {
        NSArray *titles = @[@"debug", @"test", @"release", @"custom"];
        _seg = [[UISegmentedControl alloc] initWithItems: titles];
        NSInteger type = [CN_NET_Service CN_Instance].type;
        _seg.selectedSegmentIndex = type;
        [_seg addTarget:self action:@selector(action_seg:) forControlEvents:UIControlEventValueChanged];
    }
    return _seg;
}

- (UIView *)backView {
    if (!_backView) {
        _backView = [[UIView alloc] init];
        _backView.backgroundColor = UIColor.greenColor;
        _backView.layer.cornerRadius = 3;
    }
    return _backView;
}

- (NSMutableArray<UITextField *> *)tfs {
    if (!_tfs) {
        _tfs = [NSMutableArray array];
    }
    return _tfs;
}



@end
