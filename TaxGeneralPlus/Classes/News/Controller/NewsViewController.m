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

#define NAVBAR_CHANGE_POINT 50

@interface NewsViewController () <YZCycleScrollViewDelegate>

@property (nonatomic, strong) NSMutableArray *data;// 数据列表
@property (nonatomic, strong) YZCycleScrollView *cycleScrollView;// 顶部轮播焦点图

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
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];

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
        // 初始化数据
        [self initializeData];
    }else{
        LOGIN_VIEW
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

#pragma mark - 下拉刷新数据
- (void)refreshData {
    
    DLog(@"触发下拉刷新事件");
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView.mj_header endRefreshing];
    });
}

#pragma mark - 初始化数据
- (void)initializeData {
    // 创建数据对象（初始化）
    _data = [[NSMutableArray alloc] init];
    
    NSDictionary *dataDic = [[NewsUtil sharedNewsUtil] loadData];
    // 顶部轮播焦点图数据
    NSDictionary *loopDic = [dataDic objectForKey:@"cycleDict"];
    NSArray *titles = [loopDic objectForKey:@"titles"];
    NSArray *images = [loopDic objectForKey:@"images"];
    NSArray *urls = [loopDic objectForKey:@"urls"];
    _cycleScrollView = [[YZCycleScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frameWidth, floorf((CGFloat)self.view.frameWidth/1.8)) titles:titles images:images urls:urls autoPlay:YES delay:2.0f];
    _cycleScrollView.delegate = self;
    self.tableView.tableHeaderView = _cycleScrollView;
    // 新闻列表数据
    NSArray *dataArray = [dataDic objectForKey:@"dataArray"];
    for(NSDictionary *dic in dataArray){
        NewsModel *model = [NewsModel createWithDictionary:dic];
        [_data addObject:model];
    }
    
    [self.tableView reloadData];
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
    DLog(@"点击了第%ld个，标题为：%@", indexPath.row, cell.model.title);
    
    [self.navigationController pushViewController:[NSClassFromString(@"TestViewController") new] animated:YES];

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
