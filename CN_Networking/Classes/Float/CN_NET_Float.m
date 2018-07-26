
#import "CN_NET_Float.h"
#import <UIKit/UIKit.h>
#import "CN_NET_RequestListViewController.h"

@interface CN_NET_Float()

@property (nonatomic, strong) UIWindow *w;

@end

@implementation CN_NET_Float

+ (instancetype)CN_Instance {
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[super allocWithZone:NULL] init];
    });
    return instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [[self class] CN_Instance];
}

- (instancetype)copyWithZone:(struct _NSZone *)zone{
    return [[self class] CN_Instance];
}

- (void)cn_show:(BOOL)show {
    if (show) {
        if (self.w == nil) {
            [self performSelectorOnMainThread:@selector(_show) withObject:nil waitUntilDone:NO];
        }
    } else {
        [self.w setHidden:YES];
        [self.w resignKeyWindow];
        self.w = nil;
    }
}

- (void)_show {
    
    CGSize size = [UIScreen mainScreen].bounds.size;
    UIColor *c = [UIColor colorWithRed:71 / 255.0 green:156 / 255.0 blue:228 / 255.0 alpha:1];
    
    self.w = [[UIWindow alloc] init];
    self.w.windowLevel = 2001;
    
    self.w.frame = CGRectMake(size.width - 40, size.height - 80, 40, 40);
    self.w.backgroundColor = UIColor.clearColor;
    [self.w makeKeyAndVisible];
    self.w.layer.cornerRadius = 20;
    self.w.layer.masksToBounds = YES;
    self.w.layer.borderWidth = 2;
    self.w.layer.borderColor = c.CGColor;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor clearColor];
    btn.frame = self.w.bounds;
    [self.w addSubview:btn];
    [btn addTarget:self action:@selector(_action_click) forControlEvents:UIControlEventTouchUpInside];
    btn.adjustsImageWhenHighlighted = NO;
    [btn setTitle:@"NET" forState:UIControlStateNormal];
    [btn setTitleColor:c forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:13];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(_action_pan:)];
    [self.w addGestureRecognizer:pan];
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(_action_longPress:)];
    [self.w addGestureRecognizer:longPress];
    
}

- (void)_action_click {
    NSLog(@"click");
    
    CN_NET_RequestListViewController *vc = [[CN_NET_RequestListViewController alloc] init];
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:vc];
    [[UIApplication sharedApplication].windows.firstObject.rootViewController presentViewController:navi animated:YES completion:nil];
}

- (void)_action_pan:(UIPanGestureRecognizer *)ges {
    if (ges.state == UITouchPhaseEnded) {
        
    } else {
        UIWindow *kw = [UIApplication sharedApplication].keyWindow;
        CGPoint point = [ges translationInView:kw];
        // x
        CGFloat x_new = ges.view.center.x + point.x;
        CGFloat x_max = [UIScreen mainScreen].bounds.size.width - 20;
        CGFloat x_min = 20;
        if (x_new > x_max) {
            x_new = x_max;
        }
        if (x_new < x_min) {
            x_new = x_min;
        }
        // y
        CGFloat y_new = ges.view.center.y + point.y;
        CGFloat y_max = [UIScreen mainScreen].bounds.size.height - 20;
        CGFloat y_min = 20;
        if (y_new > y_max) {
            y_new = y_max;
        }
        if (y_new < y_min) {
            y_new = y_min;
        }
        ges.view.center = CGPointMake(x_new, y_new);
        [ges setTranslation:CGPointMake(0, 0) inView:kw];
    }
}

- (void)_action_longPress:(UILongPressGestureRecognizer *)ges {
    if (ges.state != UIGestureRecognizerStateBegan) {
        return;
    }
    NSLog(@"present");
}

- (NSMutableArray<NSMutableDictionary *> *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

@end
