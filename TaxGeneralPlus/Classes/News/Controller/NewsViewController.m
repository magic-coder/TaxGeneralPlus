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
#import "GooeySlideMenu.h"
#import "NewsTableViewCell.h"
#import "NewsModel.h"
#import "NewsUtil.h"
#import "MJRefresh.h"
#import "YALSunnyRefreshControl.h"

#define NAVBAR_CHANGE_POINT 50

@interface NewsViewController () <UITableViewDelegate, UITableViewDataSource, YZCycleScrollViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) YALSunnyRefreshControl *sunnyRefreshControl;   // 顶部刷新动画视图

@property (nonatomic, strong) GooeySlideMenu *slideMenu;                    // 滑动快捷菜单
@property (nonatomic, strong) UIButton *tiggerBtn;                          // 快捷菜单按钮

@property (nonatomic, assign) int pageNo;                                   // 页码值
@property (nonatomic, assign) int totalPage;                                // 最大页

@property (nonatomic, strong) NSMutableArray *data;                         // 数据列表
@property (nonatomic, strong) YZCycleScrollView *cycleScrollView;           // 顶部轮播焦点图

@end

@implementation NewsViewController

static NSString * const reuseIdentifier = @"newsTableViewCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"首页";
    
    [self.navigationController.navigationBar yz_setBackgroundColor:[UIColor clearColor]];
    self.view.backgroundColor = DEFAULT_BACKGROUND_COLOR;
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.tiggerBtn];
    
    [self.view sendSubviewToBack:self.tableView];// 设置视图层级为最下层
    [self.view bringSubviewToFront:self.tiggerBtn];// 设置视图层级为最上层
    
    [self autoLayout];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 自动布局
- (void)autoLayout{

    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.tiggerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-5);
        make.right.equalTo(self.view).offset(-5);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(60);
    }];
}
#pragma mark - 视图即将显示
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self scrollViewDidScroll:self.tableView];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
    // 判断是否登录
    if(IS_LOGIN){
        if(nil == _data || _data.count <= 0){
            // [self.tableView.mj_header beginRefreshing];// 马上进入刷新状态
            [self.sunnyRefreshControl beginRefreshing];
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
    
    // 请求数据
    [[NewsUtil sharedNewsUtil] initDataWithPageSize:10 success:^(NSDictionary *dataDict) {
        // 创建数据对象（初始化）
        _data = [[NSMutableArray alloc] init];
        
        // 顶部轮播焦点图数据
        //NSDictionary *loopDict = [dataDict objectForKey:@"loopResult"];
        //NSArray *titles = [loopDict objectForKey:@"titles"];
        //NSArray *images = [loopDict objectForKey:@"images"];
        //NSArray *urls = [loopDict objectForKey:@"urls"];
        
        NSArray *titles = @[@"[学习十九大报告·一日一课]建设美丽中国", @"在新的历史方位上认识和推动国家治理体系和治理能力现代化", @"中央首次派宣讲团赴港宣讲十九大 这位正部领衔", @"多架轰6K等战机飞赴南海战斗巡航的背后"];
        NSArray *images = @[@"cycle_1", @"cycle_2", @"cycle_3", @"cycle_4"];
        NSArray *urls = @[@"https://www.qq.com", @"https://www.alibaba.com", @"https://www.baidu.com", @"https://www.jd.com"];
        
        _cycleScrollView = [[YZCycleScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frameWidth, floorf((CGFloat)self.view.frameWidth/1.8)) titles:titles images:images urls:urls autoPlay:YES delay:2.7f];
        _cycleScrollView.delegate = self;
        self.tableView.tableHeaderView = _cycleScrollView;
        
        // 首页税闻列表数据
        NSArray *newsArray = [dataDict objectForKey:@"newsResult"];
        for(NSDictionary *newsDict in newsArray){
            NewsModel *model = [NewsModel createWithDictionary:newsDict];
            [_data addObject:model];
        }
        
        _totalPage = [[dataDict objectForKey:@"totalPage"] intValue];
        if(_totalPage > 1)
            self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];    // 设置上拉加载
        
        [self.sunnyRefreshControl endRefreshing];   // 结束头部刷新动画
        
        [self.tableView reloadData];    // 重新加载数据
        
        // 读取系统设置（播放音效）
        NSDictionary *settingDict = [[BaseSettingUtil sharedBaseSettingUtil] loadSettingData];
        BOOL sysVoiceOn = [[settingDict objectForKey:@"sysVoice"] boolValue];
        if(sysVoiceOn){
            [[BaseHandleUtil sharedBaseHandleUtil] playSoundEffect:@"refreshsound" type:@"caf"];// 刷新时音效
        }
        
    } failure:^(NSString *error) {
        [self.sunnyRefreshControl endRefreshing];   // 结束头部刷新动画
        [MBProgressHUD showHUDView:self.view text:error progressHUDMode:YZProgressHUDModeShow]; // 错误提示
    } invalid:^(NSString *msg) {
        [self.sunnyRefreshControl endRefreshing];   // 结束头部刷新动画
        
        SHOW_RELOGIN_VIEW
    }];

}

#pragma mark - 加载更多数据
- (void)loadMoreData {
    
    _pageNo++;
    
    [[NewsUtil sharedNewsUtil] moreDataWithPageNo:_pageNo pageSize:10 success:^(NSArray *dataArray) {
        
        for(NSDictionary *dataDict in dataArray){
            NewsModel *model = [NewsModel createWithDictionary:dataDict];
            [_data addObject:model];
        }
        [self.tableView reloadData];
        [self.tableView.mj_footer endRefreshing];// 结束底部刷新
        
    } failure:^(NSString *error) {
        _pageNo--;
        [self.tableView.mj_footer endRefreshing];   // 结束底部刷新
        
        [MBProgressHUD showHUDView:self.view text:error progressHUDMode:YZProgressHUDModeShow];// 错误提示
    } invalid:^(NSString *msg) {
        _pageNo--;
        [self.tableView.mj_footer endRefreshing];   // 结束底部刷新

        SHOW_RELOGIN_VIEW
    }];
    
}

#pragma mark - <YZCycleScrollViewDelegate>顶部轮播图点击代理方法
- (void)cycleScrollViewDidSelectedImage:(YZCycleScrollView *)cycleScrollView index:(int)index {
    BaseWebViewController *webVC = [[BaseWebViewController alloc] initWithURL:cycleScrollView.urls[index]];
    webVC.title = @"详情";
    [self.navigationController pushViewController:webVC animated:YES];
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
    baseWebVC.title = @"详情";
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

#pragma mark - 懒加载方法
- (UITableView *)tableView {
    if(!_tableView){
        _tableView = [[UITableView alloc] init];
        /*
        if(DEVICE_SCREEN_INCH_5_8){
            _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH_SCREEN, HEIGHT_SCREEN-HEIGHT_TABBAR-34) style:UITableViewStylePlain];
        }else{
            _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH_SCREEN, HEIGHT_SCREEN-HEIGHT_TABBAR) style:UITableViewStylePlain];
        }
         */
        _tableView.backgroundColor = [UIColor whiteColor];
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        //_tableView.showsVerticalScrollIndicator = NO;// 隐藏纵向滚动条
        //_tableView.rowHeight = 80;// 设置基本行高
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;// 自定义cell样式
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];// 去除底部多余分割线
        _tableView.delegate = self;
        _tableView.dataSource = self;
        // 设置下拉刷新
        //_tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(initializeData)];
        // 设置下拉刷新动画视图
        [self sunnyRefreshControl];
    }
    return _tableView;
}
- (YALSunnyRefreshControl *)sunnyRefreshControl {
    if(!_sunnyRefreshControl){
        _sunnyRefreshControl = [[YALSunnyRefreshControl alloc] init];
        [_sunnyRefreshControl addTarget:self action:@selector(sunnyControlDidStartAnimation) forControlEvents:UIControlEventValueChanged];
        [_sunnyRefreshControl attachToScrollView:self.tableView];
    }
    return _sunnyRefreshControl;
}
- (UIButton *)tiggerBtn {
    if(!_tiggerBtn){
        _tiggerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        /*
        if(DEVICE_SCREEN_INCH_5_8){
            _tiggerBtn.frame = CGRectMake(WIDTH_SCREEN-60, HEIGHT_SCREEN-HEIGHT_TABBAR-34-60, 60, 60);
        }else{
            _tiggerBtn.frame = CGRectMake(WIDTH_SCREEN-60, HEIGHT_SCREEN-HEIGHT_TABBAR-60, 60, 60);
        }
        */
        [_tiggerBtn setImage:[UIImage imageNamed:@"common_trigger"] forState:UIControlStateNormal];
        [_tiggerBtn setImage:[UIImage imageNamed:@"common_triggerHL"] forState:UIControlStateHighlighted];
        [_tiggerBtn addTarget:self action:@selector(tiggerBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _tiggerBtn;
}
- (GooeySlideMenu *)slideMenu {
    if(!_slideMenu){
        _slideMenu = [[GooeySlideMenu alloc] initWithTitles:@[@"个人信息", @"每日签到", @"设置", @"功能介绍", @"常见问题", @"联系客服"]];
        _slideMenu.menuClickBlock = ^(NSInteger index, NSString *title, NSInteger titleCounts) {
            if(0 == index){
                UIBarButtonItem *backItem=[[UIBarButtonItem alloc] init];
                backItem.title=@"首页";
                super.navigationItem.backBarButtonItem = backItem;
                [super.navigationController pushViewController:[[NSClassFromString(@"AccountViewController") class] new] animated:YES];
            }
            if(1 == index){
                [MBProgressHUD showHUDView:super.view text:@"签到成功" progressHUDMode:YZProgressHUDModeShow];
            }
            if(2 == index){
                UIBarButtonItem *backItem=[[UIBarButtonItem alloc] init];
                backItem.title=@"首页";
                super.navigationItem.backBarButtonItem = backItem;
                [super.navigationController pushViewController:[[NSClassFromString(@"SettingViewController") class] new] animated:YES];
            }
            if(3 == index){
                BaseWebViewController *introduceVC = [[BaseWebViewController alloc] initWithURL:[NSString stringWithFormat:@"%@taxnews/public/introductionIOS.htm", SERVER_URL]];
                introduceVC.title =  title;
                [super.navigationController pushViewController:introduceVC animated:YES];
            }
            if(4 == index){
                BaseWebViewController *questionVC = [[BaseWebViewController alloc] initWithURL:[NSString stringWithFormat:@"%@taxnews/public/comProblemIOS.htm", SERVER_URL]];
                questionVC.title =  title;
                [super.navigationController pushViewController:questionVC animated:YES];
            }
            if(5 == index){
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://029-87663504"] options:@{} completionHandler:nil];
            }
        };
    }
    return _slideMenu;
}

#pragma mark - 菜单按钮点击左侧弹出菜单事件
- (void)tiggerBtnAction:(UIButton *)sender {
    [self.slideMenu trigger];
}
#pragma mark - 下拉刷新动画方，开始执行方法
-(void)sunnyControlDidStartAnimation{
    /*
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.sunnyRefreshControl endRefreshing];
    });
     */
    [self initializeData];
}

@end
