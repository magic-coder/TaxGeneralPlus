/************************************************************
 Class    : MineViewController.m
 Describe : 我的模块视图控制
 Company  : Prient
 Author   : Yanzheng 严正
 Date     : 2017-11-08
 Version  : 1.0
 Declare  : Copyright © 2017 Yanzheng. All rights reserved.
 ************************************************************/

#import "MineViewController.h"
#import "MineHeaderView.h"
#import "MineUtil.h"

@interface MineViewController () <MineHeaderViewDelegate>

@property (nonatomic, strong) MineHeaderView *headerView;

@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 不进行自动调整（否则顶部会自动留出安全距离[空白]）
    self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    
    // 设置头部视图
    _headerView = [[MineHeaderView alloc] initWithFrame:CGRectMake(0, 0, WIDTH_SCREEN, HEIGHT_STATUS+HEIGHT_NAVBAR+170)];
    _headerView.delegate = self;
    _headerView.nameText = @"未登录";
    
    self.tableView.tableHeaderView = _headerView;
    
    // 初始化数据
    self.data = [MineUtil sharedMineUtil].loadMineData;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIScrollViewDelegate（ 下滑顶部视图放大效果）
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGPoint offset = scrollView.contentOffset;
    if (offset.y < 0) {
        CGRect rect = _headerView.imageView.frame;
        rect.origin.y = offset.y;
        rect.size.height = HEIGHT_STATUS+HEIGHT_NAVBAR+100 - offset.y;
        _headerView.imageView.frame = rect;
        
        _headerView.nightBtn.frame = CGRectMake(WIDTH_SCREEN-35, offset.y + HEIGHT_STATUS+10, 20, 20);
    }
}

#pragma mark - 头部视图点击方法
- (void)mineHeaderViewDidSelected {
    DLog(@"进入账户信息");
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
}

@end
