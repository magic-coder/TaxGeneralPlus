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

@property (nonatomic, assign) float headerViewH;        // 头部视图高度
@property (nonatomic, assign) float headerBottomViewH;  // 头部视图下方功能按钮栏高度

@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 为适配所有设备，按比例计算头部视图高度
    _headerViewH = ceilf(HEIGHT_SCREEN*0.35f);
    _headerBottomViewH = floorf(_headerViewH*0.25f);
    
    // 不进行自动调整（否则顶部会自动留出安全距离[空白]）
    self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    // 设置头部视图
    _headerView = [[MineHeaderView alloc] initWithFrame:CGRectMake(0, 0, WIDTH_SCREEN, _headerViewH)];
    _headerView.delegate = self;
    
    self.tableView.tableHeaderView = _headerView;
    
    // 初始化数据
    self.data = [[MineUtil sharedMineUtil] mineData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 视图即将显示
- (void)viewWillAppear:(BOOL)animated {
    // 设置头视图数据
    if(IS_LOGIN){
        _headerView.nameText = [[[NSUserDefaults standardUserDefaults] objectForKey:LOGIN_SUCCESS] objectForKey:@"userName"];
    }else{
        _headerView.nameText = @"未登录";
    }
}

#pragma mark - UIScrollViewDelegate（ 下滑顶部视图放大效果）
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGPoint offset = scrollView.contentOffset;
    if (offset.y < 0) {
        [_headerView.imageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_headerView).with.mas_equalTo(offset.y);
            make.bottom.equalTo(_headerView).with.mas_equalTo(-_headerBottomViewH);
        }];
        
        [_headerView.nightShiftBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_headerView).with.offset(offset.y+HEIGHT_STATUS+10);
        }];
    }
}

#pragma mark - 头部视图按钮点击方法
- (void)mineHeaderViewBtnDidSelected:(UIButton *)sender {
    if(0 == sender.tag){
        if(IS_LOGIN){
            [self.navigationController pushViewController:[[NSClassFromString(@"AccountViewController") class] new] animated:YES];
        }else{
            SHOW_LOGIN_VIEW
        }
    }
    if(1 == sender.tag){
        if(IS_LOGIN){
            DLog(@"详细升级规则");
        }else{
            SHOW_LOGIN_VIEW
        }
    }
    if(2 == sender.tag){
        if(IS_LOGIN){
            DLog(@"钻石");
        }else{
            SHOW_LOGIN_VIEW
        }
    }
    if(3 == sender.tag){
        if(IS_LOGIN){
            DLog(@"每日签到");
        }else{
            SHOW_LOGIN_VIEW
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    BaseTableModelGroup *group = [self.data objectAtIndex:indexPath.section];
    BaseTableModelItem *item = [group itemAtIndex:indexPath.row];
    
    if([item.title isEqualToString:@"安全中心"]){
        if(IS_LOGIN){
            [self.navigationController pushViewController:[[NSClassFromString(@"SafeViewController") class] new] animated:YES];
        }else{
            SHOW_LOGIN_VIEW
        }
    }
    if([item.title isEqualToString:@"我的日程"]){
        //[self.navigationController pushViewController:[[NSClassFromString(@"ScheduleViewController") class] new] animated:YES];
        [UIAlertController showAlertInViewController:self withTitle:nil message:[NSString stringWithFormat:@"\"%@\"想要打开\"日历\"", [[Variable sharedVariable] appName]] cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"打开"] tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
            if(0 == (buttonIndex - controller.firstOtherButtonIndex)){
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"calshow:"] options:@{} completionHandler:nil];
            }
        }];
    }
    if([item.title isEqualToString:@"我的客服"]){
        [self.navigationController pushViewController:[[NSClassFromString(@"ServiceViewController") class] new] animated:YES];
    }
    if([item.title isEqualToString:@"设置"]){
        [self.navigationController pushViewController:[[NSClassFromString(@"SettingViewController") class] new] animated:YES];
    }
    if([item.title isEqualToString:@"关于"]){
        [self.navigationController pushViewController:[[NSClassFromString(@"AboutViewController") class] new] animated:YES];
    }
    if([item.title isEqualToString:@"测试"]){
        [self.navigationController pushViewController:[[NSClassFromString(@"TestViewController") class] new] animated:YES];
    }
}

@end
