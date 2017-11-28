/************************************************************
 Class    : MsgListViewController.m
 Describe : 消息分组列表界面
 Company  : Prient
 Author   : Yanzheng 严正
 Date     : 2017-11-27
 Version  : 1.0
 Declare  : Copyright © 2017 Yanzheng. All rights reserved.
 ************************************************************/

#import "MsgListViewController.h"
#import "MsgListViewCell.h"
#import "MsgListModel.h"
#import "MsgUtil.h"

@interface MsgListViewController ()

@property (nonatomic, strong) NSMutableArray *data;             // 消息列表数据
@property (nonatomic, assign) int pageNo;                       // 页码值

@property (nonatomic, assign) double lastTimestamp;             // 最后一次进入时间戳
@property (nonatomic, assign) double currentTimestamp;          // 当前时间戳

@end

@implementation MsgListViewController

static NSString * const reuseIdentifier = @"msgListCell";
static int const pageSize = 100;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _data = [[NSMutableArray alloc] init];
    
    [self.view setBackgroundColor:DEFAULT_BACKGROUND_COLOR];
    [self.tableView setBackgroundColor:[UIColor whiteColor]];
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
    
    [self.tableView registerClass:[MsgListViewCell class] forCellReuseIdentifier:reuseIdentifier];
    [self.tableView setSeparatorStyle: UITableViewCellSeparatorStyleNone];
    
    self.title = @"消息";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // 判断是否登录，若没登录则返回登录页面
    if(IS_LOGIN){
        // 计算上次刷新与当前时间戳
        NSTimeInterval timestamp = [[NSDate date] timeIntervalSince1970];
        _currentTimestamp = floor(timestamp);
        if(_currentTimestamp - _lastTimestamp < 180){
            NSDictionary *dataDict = [[MsgUtil sharedMsgUtil] loadMsgFile];
            if(dataDict != nil){
                [self handleDataDict:dataDict];// 数据处理
            }else{
                [self loadData];
            }
        }else{
            _lastTimestamp = _currentTimestamp;
            [self loadData];
        }
    }else{
        SHOW_LOGIN_VIEW
    }
}

#pragma mark - 加载数据
- (void)loadData{
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(WIDTH_SCREEN/2-80, HEIGHT_NAVBAR/2-20, 160, 40)];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 5, 80, 30)];
    titleLabel.text = @"收取中...";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
    UIActivityIndicatorView *loading = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    loading.center = CGPointMake(-8, 15);
    [loading startAnimating];
    
    [titleView addSubview:titleLabel];
    [titleLabel addSubview:loading];
    
    self.navigationItem.titleView = titleView;
    _pageNo = 1;
    [[MsgUtil sharedMsgUtil] loadMsgListPageNo:_pageNo pageSize:pageSize success:^(NSDictionary *dataDict) {
        [self handleDataDict:dataDict];// 处理获取到的数据
        
        self.navigationItem.titleView = nil;
        self.navigationItem.title = @"消息";
        [self.tableView reloadData];
    } failure:^(NSString *error) {
        self.navigationItem.titleView = nil;
        self.navigationItem.title = @"未连接";
        [MBProgressHUD showHUDView:self.view text:error progressHUDMode:YZProgressHUDModeShow];
    } invalid:^(NSString *msg) {
        self.navigationItem.titleView = nil;
        self.navigationItem.title = @"未连接";
        
        SHOW_RELOGIN_VIEW
    }];
}

#pragma mark - 处理得到的数据
- (void)handleDataDict:(NSDictionary *)dataDict {
    _data = [[NSMutableArray alloc] init];
    
    NSArray *results = [dataDict objectForKey:@"results"];
    NSMutableArray *sysData = [[NSMutableArray alloc] init];
    NSMutableArray *userData = [[NSMutableArray alloc] init];
    int badge = 0;
    for(NSDictionary *dict in results){
        MsgListModel *model = [MsgListModel createWithDictionary:dict];
        if(![model.sourceCode isEqualToString:@"01"]){
            [sysData addObject:model];
        }else{
            [userData addObject:model];
        }
        
        badge += [model.unReadCount intValue];
    }
    [Variable sharedVariable].unReadCount = badge;
    [[BaseHandleUtil sharedBaseHandleUtil] msgBadge:badge];// 设置提醒角标
    
    [_data addObject:sysData];
    [_data addObject:userData];
}

#pragma mark - Table view data source数据源方法
#pragma mark 返回组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _data.count;
}

#pragma mark 返回每组条数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *array = [_data objectAtIndex:section];
    return array.count;
}

#pragma mark 返回cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MsgListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    NSArray *array = [_data objectAtIndex:indexPath.section];
    [cell setModel:[array objectAtIndex:indexPath.row]];
    indexPath.row == 0 ? [cell setTopLineStyle:CellLineStyleFill] : [cell setTopLineStyle:CellLineStyleNone];
    indexPath.row == array.count - 1 ? [cell setBottomLineStyle:CellLineStyleFill] : [cell setBottomLineStyle:CellLineStyleDefault];
    
    return cell;
}

#pragma mark - <UITableViewDelegate>代理方法
#pragma mark 每行是否可以进行编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

#pragma mark 编辑显示的标题
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}

#pragma mark 点击删除按钮执行的操作
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        MsgListViewCell *cell = (MsgListViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        NSString *sourceCode = cell.model.sourceCode;
        NSString *pushOrgCode = cell.model.pushOrgCode;
        if(pushOrgCode == nil){
            pushOrgCode = @"";
        }
        [MBProgressHUD showHUDView:self.view text:@"删除中" progressHUDMode:YZProgressHUDModeShow];
        // 开始删除方法
    }
}

#pragma mark 返回行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 63;
}

#pragma mark 返回头视图高度
/*
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01f;
}

*/
#pragma mark 点击行触发点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    // 获取当前点击的cell
    MsgListViewCell *cell = (MsgListViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    
    //MessageDetailViewController *messageDetailVC = [[MessageDetailViewController alloc] init];
    //messageDetailVC.title = cell.messageListModel.name; // 设置详细视图标题
    
    //messageDetailVC.sourceCode = cell.messageListModel.sourceCode;
    //messageDetailVC.pushOrgCode = cell.messageListModel.pushOrgCode;
    //[self.navigationController pushViewController:messageDetailVC animated:YES];
}

@end
