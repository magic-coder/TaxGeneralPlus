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

#define SNOW_IMAGE_X                arc4random()%(int)WIDTH_SCREEN
#define SNOW_IMAGE_ALPHA            ((float)(arc4random()%10))/10 + 0.5f
#define SNOW_IMAGE_WIDTH            arc4random()%20 + 20

@interface MineViewController () <MineHeaderViewDelegate>

@property (nonatomic, strong) MineHeaderView *headerView;

@property (nonatomic, assign) float headerViewH;        // 头部视图高度
@property (nonatomic, assign) float headerBottomViewH;  // 头部视图下方功能按钮栏高度

// 下雪效果
@property (nonatomic, strong) NSMutableArray *snowImagesArray;
@property (nonatomic, strong) NSTimer *snowTimer;

@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 为适配所有设备，按比例计算头部视图高度
    _headerViewH = ceilf(HEIGHT_SCREEN*0.35f);
    _headerBottomViewH = floorf(_headerViewH*0.25f);
    
    // 不进行自动调整（否则顶部会自动留出安全距离[空白]）
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
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

#pragma mark - UIScrollViewDelegate正在拖拽事件（下滑顶部视图放大效果）
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
#pragma mark - 拖拽结束事件（监控下雪事件）
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    CGPoint offset = scrollView.contentOffset;
    if(offset.y < -160){
        [self snowAnimation];
    }
}

#pragma mark - 头部视图按钮点击方法
- (void)mineHeaderViewBtnDidSelected:(UIButton *)sender {
    // 防止按钮重复点击
    CLICK_LOCK
    
    if(IS_LOGIN){
        if(0 == sender.tag){
            [self.navigationController pushViewController:[[NSClassFromString(@"AccountViewController") class] new] animated:YES];
        }
        if(1 == sender.tag){
            DLog(@"详细升级规则");
        }
        if(2 == sender.tag){
            DLog(@"钻石");
        }
        if(3 == sender.tag){
            DLog(@"每日签到");
            FCAlertView *alert = [[FCAlertView alloc] init];
            [alert showAlertWithTitle:@"签到成功"
                         withSubtitle:@"恭喜您，获得10积分奖励，明天继续来签到哦😉"
                      withCustomImage:nil
                  withDoneButtonTitle:@"完成"
                           andButtons:nil];
            [alert makeAlertTypeSuccess];
        }
    }else{
        SHOW_LOGIN_VIEW
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

#pragma mark - 下雪动画效果
#pragma mark 初始化雪花效果
- (void)snowAnimation {
    _snowImagesArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < 20; ++ i) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mine_snow"]];
        float x = SNOW_IMAGE_WIDTH;
        imageView.frame = CGRectMake(SNOW_IMAGE_X, -36, x, x);
        imageView.alpha = SNOW_IMAGE_ALPHA;
        [self.view addSubview:imageView];
        [_snowImagesArray addObject:imageView];
    }
    self.snowTimer = [NSTimer scheduledTimerWithTimeInterval:0.3f target:self selector:@selector(makeSnow) userInfo:nil repeats:YES];
}
#pragma mark 制作雪花
static int i = 0;
- (void)makeSnow {
    i = i + 1;
    if ([_snowImagesArray count] > 0) {
        UIImageView *imageView = [_snowImagesArray objectAtIndex:0];
        imageView.tag = i;
        [_snowImagesArray removeObjectAtIndex:0];
        [self snowFall:imageView];
    }else{
        // 释放定时器，销毁 timer
        if([self.snowTimer isValid]){
            [self.snowTimer invalidate];
            self.snowTimer = nil;
        }
    }
}
#pragma mark 雪花下落效果
- (void)snowFall:(UIImageView *)aImageView {
    [UIView beginAnimations:[NSString stringWithFormat:@"%li",(long)aImageView.tag] context:nil];
    [UIView setAnimationDuration:6];
    [UIView setAnimationDelegate:self];
    aImageView.frame = CGRectMake(aImageView.frame.origin.x, HEIGHT_SCREEN, aImageView.frameWidth, aImageView.frameHeight);
    [UIView commitAnimations];
}

@end
