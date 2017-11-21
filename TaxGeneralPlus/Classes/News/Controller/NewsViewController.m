/************************************************************
 Class    : NewsViewController.h
 Describe : 首页新闻展示视图控制器
 Company  : Prient
 Author   : Yanzheng 严正
 Date     : 2017-10-27
 Version  : 1.0
 Declare  : Copyright © 2017 Yanzheng. All rights reserved.
 ************************************************************/

#import "NewsViewController.h"
#import "NewsTableViewCell.h"
#import "NewsModel.h"
#import "NewsUtil.h"
#import "MJRefresh.h"

#define NAVBAR_CHANGE_POINT 50

@interface NewsViewController () <YZCycleScrollViewDelegate>

@property (nonatomic, assign) int pageNo;                           // 页码值
@property (nonatomic, assign) int totalPage;                        // 最大页

@property (nonatomic, strong) NSMutableArray *data;                 // 数据列表
@property (nonatomic, strong) YZCycleScrollView *cycleScrollView;   // 顶部轮播焦点图

@end

@implementation NewsViewController

static NSString * const reuseIdentifier = @"newsTableViewCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //self.tableView.rowHeight = 80;// 设置基本行高
    
    self.view.backgroundColor = DEFAULT_BACKGROUND_COLOR;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;//
    //self.tableView.showsVerticalScrollIndicator = NO;// 隐藏纵向滚动条
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;// 自定义cell样式
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];// 去除底部多余分割线
    [self.navigationController.navigationBar yz_setBackgroundColor:[UIColor clearColor]];
    
    // 设置下拉刷新
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(initializeData)];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 视图即将显示
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self scrollViewDidScroll:self.tableView];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
    // 判断是否登录
    if(IS_LOGIN){
        if(nil == _data || _data.count <= 0){
            [self.tableView.mj_header beginRefreshing];// 马上进入刷新状态
        }
    }else{
        SHOW_LOGIN_VIEW
    }
    
}

#pragma mark - 视图即将销毁方法
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController.navigationBar yz_reset];
}

#pragma mark - 滚动屏幕渐进渐出顶部导航栏
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    UIColor * color = DEFAULT_BLUE_COLOR;
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY > NAVBAR_CHANGE_POINT) {
        CGFloat alpha = MIN(1, 1 - ((NAVBAR_CHANGE_POINT + HEIGHT_STATUS + HEIGHT_NAVBAR - offsetY) / (HEIGHT_STATUS + HEIGHT_NAVBAR)));
        if(alpha > 0.95)
            alpha = 0.95;
        [self.navigationController.navigationBar yz_setBackgroundColor:[color colorWithAlphaComponent:alpha]];
        if(alpha > 0.6)
            self.navigationItem.title = @"首页";
    } else {
        [self.navigationController.navigationBar yz_setBackgroundColor:[color colorWithAlphaComponent:0]];
        CGFloat alpha = MIN(1, 1 - ((NAVBAR_CHANGE_POINT + HEIGHT_STATUS + HEIGHT_NAVBAR - offsetY) / (HEIGHT_STATUS + HEIGHT_NAVBAR)));
        if(alpha < 0.6)
            self.navigationItem.title = nil;
    }
}

#pragma mark - 初始化数（下拉刷新方法）
- (void)initializeData {
    _pageNo = 1;
    
    // 创建数据对象（初始化）
    _data = [[NSMutableArray alloc] init];
    
    // 请求数据
    [[NewsUtil sharedNewsUtil] initDataWithPageSize:10 dataBlock:^(NSDictionary *dataDict) {
        
        _totalPage = [[dataDict objectForKey:@"totalPage"] intValue];
        
        // 顶部轮播焦点图数据
        NSDictionary *loopDict = [dataDict objectForKey:@"loopResult"];
        NSArray *titles = [loopDict objectForKey:@"titles"];
        NSArray *images = [loopDict objectForKey:@"images"];
        NSArray *urls = [loopDict objectForKey:@"urls"];
        _cycleScrollView = [[YZCycleScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frameWidth, floorf((CGFloat)self.view.frameWidth/1.8)) titles:titles images:images urls:urls autoPlay:YES delay:2.0f];
        _cycleScrollView.delegate = self;
        self.tableView.tableHeaderView = _cycleScrollView;
        // 首页税闻列表数据
        NSArray *newsArray = [dataDict objectForKey:@"newsResult"];
        for(NSDictionary *newsDict in newsArray){
            NewsModel *model = [NewsModel createWithDictionary:newsDict];
            [_data addObject:model];
        }
        [self.tableView reloadData];// 重新加载数据
        
        [self.tableView.mj_header endRefreshing];// 结束头部刷新
        
        if(_totalPage > 1){
            self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];// 设置上拉加载
            [self.tableView.mj_footer resetNoMoreData]; // 重置没有更多的数据（消除没有更多数据的状态）
        }
        
    } failed:^(NSString *error) {
        [self.tableView.mj_header endRefreshing];// 结束头部刷新
        [MBProgressHUD showHUDView:self.view text:error progressHUDMode:YZProgressHUDModeShow];// 错误提示
    }];
}

#pragma mark - 加载更多数据
- (void)loadMoreData {
    _pageNo++;
    
    [[NewsUtil sharedNewsUtil] moreDataWithPageNo:_pageNo pageSize:10 dataBlock:^(NSArray *dataArray) {
        for(NSDictionary *dataDict in dataArray){
            NewsModel *model = [NewsModel createWithDictionary:dataDict];
            [_data addObject:model];
        }
        
        [self.tableView reloadData];
        
        if(_pageNo < _totalPage){
            [self.tableView.mj_footer endRefreshing];// 结束底部刷新
        }else{
            // 拿到当前的上拉刷新控件，变为没有更多数据的状态
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        
    } failed:^(NSString *error) {
        _pageNo--;
        [self.tableView.mj_footer endRefreshing];   // 结束底部刷新
        [self.tableView.mj_footer resetNoMoreData]; // 重置没有更多的数据（消除没有更多数据的状态）
        [MBProgressHUD showHUDView:self.view text:error progressHUDMode:YZProgressHUDModeShow];// 错误提示
    }];
}

#pragma mark - <YZCycleScrollViewDelegate>顶部轮播图点击代理方法
- (void)cycleScrollViewDidSelectedImage:(YZCycleScrollView *)cycleScrollView index:(int)index {
    DLog(@"点击了顶部轮播图的第%d个，标题为：%@", index, cycleScrollView.titles[index]);
}

#pragma mark - Table view data source
#pragma mark 数据源方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // 1.缓存中取
    NewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    // 2.创建
    if (!cell) {
        cell = [[NewsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    // 3.设置数据
    cell.model = [_data objectAtIndex:indexPath.row];
    // 4.返回cell
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    // 点击后将颜色变回来
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NewsTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    BaseWebViewController *baseWebVC = [[BaseWebViewController alloc] initWithURL:cell.model.url];
    [self.navigationController pushViewController:baseWebVC animated:YES];
    
    //[self.navigationController pushViewController:[NSClassFromString(@"TestViewController") new] animated:YES];

}

// 设置cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NewsModel *model = [_data objectAtIndex:indexPath.row];
    if(model.cellHeight > 0){
        return model.cellHeight;
    }
    return 0;
}

@end
