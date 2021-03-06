

#import "CN_NET_RequestListViewController.h"
#import "CN_NET_Float.h"
#import "CN_NET_RequestAndResponseViewController.h"
#import "CN_NET_Util.h"

@interface CN_NET_RequestListViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *mainTableView;

@end

@implementation CN_NET_RequestListViewController

// MARK:- Life
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViews];
}

// MARK:- UI
- (void)setupViews {
    self.view.backgroundColor = UIColor.whiteColor;
    
    self.title = @"Request";
    UIBarButtonItem *item_left = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:self action:@selector(action_back)];
    self.navigationItem.leftBarButtonItem = item_left;
    
    UIBarButtonItem *item_right = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(action_reload)];
    self.navigationItem.rightBarButtonItem = item_right;
    
    [self.view addSubview:self.mainTableView];
}

// MARK:- Action
- (void)action_back {
    [self.navigationController dismissViewControllerAnimated:true completion:nil];
}

- (void)action_reload {
    [self.mainTableView reloadData];
}

// MARK:- Delegate
// MARK: └ UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [CN_NET_Float CN_Instance].dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *data = [CN_NET_Float CN_Instance].dataSource[indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"UITableViewCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (data[@"success"]) {
        cell.textLabel.textColor = UIColor.blackColor;
        cell.detailTextLabel.textColor = UIColor.blackColor;
    } else {
        cell.textLabel.textColor = UIColor.redColor;
        cell.detailTextLabel.textColor = UIColor.redColor;
    }
    cell.textLabel.numberOfLines = 0;
    NSString *number = [NSString stringWithFormat:@"%ld", indexPath.row + 1];
    NSString *method = [CN_NET_Util CN_StringFromMethod:(CN_REQ_METHOD)([data[@"method"] integerValue])];
    NSString *time = [data[@"time"] description];
    NSString *url = data[@"url"];
    cell.textLabel.text = [NSString stringWithFormat:@"%@.\t%@\t%@\n%@", number, method, time, url];
    return cell;
}

// MARK: └ UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CN_NET_RequestAndResponseViewController *detail = [[CN_NET_RequestAndResponseViewController alloc] init];
    NSDictionary *data = [CN_NET_Float CN_Instance].dataSource[indexPath.row];
    if (data[@"success"]) {
        detail.successData = data;
    } else {
        detail.failureData = data;
    }
    [self.navigationController pushViewController:detail animated:YES];
}

// MARK:- Lazy

- (UITableView *)mainTableView {
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64) style:UITableViewStylePlain];
        _mainTableView.dataSource = self;
        _mainTableView.delegate = self;
        _mainTableView.tableFooterView = [UIView new];
        _mainTableView.estimatedRowHeight = UITableViewAutomaticDimension;
    }
    return _mainTableView;
}

@end
