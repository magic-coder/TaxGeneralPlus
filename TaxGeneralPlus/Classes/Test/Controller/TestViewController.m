/************************************************************
 Class    : TestViewController.m
 Describe : 测试类控制器
 Company  : Prient
 Author   : Yanzheng 严正
 Date     : 2017-10-09
 Version  : 1.0
 Declare  : Copyright © 2017 Yanzheng. All rights reserved.
 ************************************************************/

#import "TestViewController.h"
#import "NewsUtil.h"
#import "AuthHelper.h"

@interface TestViewController () <YBPopupMenuDelegate, YZCycleScrollViewDelegate, SangforSDKDelegate>

@property (nonatomic, assign) int i;

@property (nonatomic, strong) AuthHelper *helper;    // VPN 处理类

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    DLog(@"%d", HEIGHT_STATUS);
    
    self.title = @"Test";
    self.view.backgroundColor = DEFAULT_BACKGROUND_COLOR;
    
    // 延展视图包含部包含不透明的NavigationBar
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = NO;
    
    // 添加导航栏右侧按钮
    UIBarButtonItem *saveButtonItem  = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:(UIBarButtonSystemItemAdd) target:self action:@selector(saveBtnClick:)];
    self.navigationItem.rightBarButtonItem = saveButtonItem;
    
    /*
    UIImageView *testImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 50, 50)];
    [testImageView sd_setImageWithURL:[NSURL URLWithString:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1508498082662&di=47a95adc26742482328425a3dd6b47b3&imgtype=0&src=http%3A%2F%2Fimg.zcool.cn%2Fcommunity%2F019f9c5542b8fc0000019ae980d080.jpg%401280w_1l_2o_100sh.jpg"] placeholderImage:[UIImage imageNamed:@"navigation_bg"]];
    [self.view addSubview:testImageView];
    */
    
    UIImageView *testImageView = [[UIImageView alloc] init];
    [testImageView sd_setImageWithURL:[NSURL URLWithString:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1508498082662&di=47a95adc26742482328425a3dd6b47b3&imgtype=0&src=http%3A%2F%2Fimg.zcool.cn%2Fcommunity%2F019f9c5542b8fc0000019ae980d080.jpg%401280w_1l_2o_100sh.jpg"] placeholderImage:[UIImage imageNamed:@"navigation_bg"]];
    [self.view addSubview:testImageView];
    [testImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(10);
        make.right.equalTo(self.view).with.offset(-10);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = CGRectMake(10, 10, 200, 30);
    [btn setTitle:@"MBProgressHUD" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(onClick:) forControlEvents:(UIControlEventTouchUpInside)];
    btn.tag = 0;
    [self.view addSubview:btn];
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeSystem];
    btn1.frame = CGRectMake(10, btn.frameBottom, 300, 30);
    [btn1 setTitle:@"UIAlertControllerBlocks-Alert" forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(onClick:) forControlEvents:(UIControlEventTouchUpInside)];
    btn1.tag = 1;
    [self.view addSubview:btn1];
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeSystem];
    btn2.frame = CGRectMake(10, btn1.frameBottom, 300, 30);
    [btn2 setTitle:@"UIAlertControllerBlocks-ActionSheet" forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(onClick:) forControlEvents:(UIControlEventTouchUpInside)];
    btn2.tag = 2;
    [self.view addSubview:btn2];
    
    UIButton *btn3 = [UIButton buttonWithType:UIButtonTypeSystem];
    btn3.frame = CGRectMake(10, btn2.frameBottom, 300, 30);
    [btn3 setTitle:@"YZBottomSelectView" forState:UIControlStateNormal];
    [btn3 addTarget:self action:@selector(onClick:) forControlEvents:(UIControlEventTouchUpInside)];
    btn3.tag = 3;
    [self.view addSubview:btn3];
    
    UIButton *btn4 = [UIButton buttonWithType:UIButtonTypeSystem];
    btn4.frame = CGRectMake(10, btn3.frameBottom, 300, 30);
    [btn4 setTitle:@"AFNetworking请求数据" forState:UIControlStateNormal];
    [btn4 addTarget:self action:@selector(onClick:) forControlEvents:(UIControlEventTouchUpInside)];
    btn4.tag = 4;
    [self.view addSubview:btn4];
    
    UIButton *btn5 = [UIButton buttonWithType:UIButtonTypeSystem];
    btn5.frame = CGRectMake(10, btn4.frameBottom, 300, 30);
    [btn5 setTitle:@"跳转登录界面" forState:UIControlStateNormal];
    [btn5 addTarget:self action:@selector(onClick:) forControlEvents:(UIControlEventTouchUpInside)];
    btn5.tag = 5;
    [self.view addSubview:btn5];
    
    UIButton *btn6 = [UIButton buttonWithType:UIButtonTypeSystem];
    btn6.frame = CGRectMake(10, btn5.frameBottom, 300, 30);
    [btn6 setTitle:@"WebView" forState:UIControlStateNormal];
    [btn6 addTarget:self action:@selector(onClick:) forControlEvents:(UIControlEventTouchUpInside)];
    btn6.tag = 6;
    [self.view addSubview:btn6];
    
    UIButton *btn7 = [UIButton buttonWithType:UIButtonTypeSystem];
    btn7.frame = CGRectMake(10, btn6.frameBottom, 300, 30);
    [btn7 setTitle:@"VPN连接" forState:UIControlStateNormal];
    [btn7 addTarget:self action:@selector(onClick:) forControlEvents:(UIControlEventTouchUpInside)];
    btn7.tag = 7;
    [self.view addSubview:btn7];
    
    // 添加轮播图
    NSArray *titles = @[@"腾讯", @"京东", @"阿里巴巴", @"小米"];
    NSArray *images = @[@"http://i1.douguo.net//upload/banner/0/6/a/06e051d7378040e13af03db6d93ffbfa.jpg", @"http://i1.douguo.net//upload/banner/9/3/4/93f959b4e84ecc362c52276e96104b74.jpg", @"http://i1.douguo.net//upload/banner/5/e/3/5e228cacf18dada577269273971a86c3.jpg", @"http://i1.douguo.net//upload/banner/d/8/2/d89f438789ee1b381966c1361928cb32.jpg"];
    NSArray *urls = @[@"http://www.qq.com", @"http://www.jd.com", @"http://www.taobao.com", @"http://www.xiaomi.com"];
    
    YZCycleScrollView *cycleScrollView = [[YZCycleScrollView alloc] initWithFrame:CGRectMake(0, btn7.frameBottom , WIDTH_SCREEN, HEIGHT_SCREEN/4) titles:titles images:images urls:urls autoPlay:YES delay:2.0f];
    cycleScrollView.delegate = self;
    [self.view addSubview:cycleScrollView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)saveBtnClick:sender {
    [YBPopupMenu showPopupMenuWithTitles:@[@"驾乘路线", @"公交路线", @"步行路线"] icons:@[@"map_route_car", @"map_route_bus", @"map_route_walk"] delegate:self];
}

// 菜单点击代理
- (void)ybPopupMenuDidSelectedAtIndex:(NSInteger)index ybPopupMenu:(YBPopupMenu *)ybPopupMenu {
    DLog(@"点击了菜单的序列为：index = %ld", index);
}

// 轮播图点击代理
- (void)cycleScrollViewDidSelectedImage:(YZCycleScrollView *)cycleScrollView index:(int)index {
    DLog(@"点击的轮播图序号为：%d", index);
}

- (void)onClick:(UIButton *)btn{
    if(0 == btn.tag){
        [MBProgressHUD showHUDView:self.view text:@"请求超时，请联系管理员！" progressHUDMode:YZProgressHUDModeShow];
        
        /*
        [MBProgressHUD showHUDView:self.view text:@"加载中..." progressHUDMode:(YZProgressHUDModeLock)];
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
            sleep(2.0);
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hiddenHUDView:self.view];
            });
        });
         */
    }
    
    if(1 == btn.tag){
        [UIAlertController showAlertInViewController:self withTitle:@"顶部标题" message:@"详细提示信息" cancelButtonTitle:@"取消按钮" destructiveButtonTitle:@"红色按钮" otherButtonTitles:@[@"自定义按钮1", @"自定义按钮2"] tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
            DLog(@"buttonIndex = %ld", buttonIndex);
            if (buttonIndex == controller.cancelButtonIndex) {
                DLog(@"点击了取消按钮");
            } else if (buttonIndex == controller.destructiveButtonIndex) {
                DLog(@"点击了红色按钮");
            } else if (buttonIndex >= controller.firstOtherButtonIndex) {
                DLog(@"点击了自定义按钮的序列为 %ld", (long)buttonIndex - controller.firstOtherButtonIndex);
            }
        }];
    }
    
    if(2 == btn.tag){
        [UIAlertController showActionSheetInViewController:self withTitle:@"顶部标题" message:@"详细提示信息" cancelButtonTitle:@"取消按钮" destructiveButtonTitle:@"红色按钮" otherButtonTitles:@[@"自定义按钮1", @"自定义按钮2"] popoverPresentationControllerBlock:^(UIPopoverPresentationController * _Nonnull popover) {
            popover.sourceView = self.view;
            popover.sourceRect = btn.frame;
        } tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
            if (buttonIndex == controller.cancelButtonIndex) {
                DLog(@"点击了取消按钮");
            } else if (buttonIndex == controller.destructiveButtonIndex) {
                DLog(@"点击了红色按钮");
            } else if (buttonIndex >= controller.firstOtherButtonIndex) {
                DLog(@"点击了自定义按钮的序列为 %ld", (long)buttonIndex - controller.firstOtherButtonIndex);
            }
        }];
    }
    
    if(3 == btn.tag){
        [YZBottomSelectView showBottomSelectViewWithTitle:@"顶部标题" cancelButtonTitle:@"取消按钮" destructiveButtonTitle:@"红色按钮" otherButtonTitles:@[@"自定义按钮1", @"自定义按钮2"] handler:^(YZBottomSelectView *bootomSelectView, NSInteger index) {
            DLog(@"点击按钮的序列号：%ld", index);
        }];
    }
    
    if(4 == btn.tag){
        _i = 1;
        [YZNetworkingManager POST:@"public/taxmap/init" parameters:nil success:^(id responseObject) {
            DLog(@"请求次数统计：%d", _i++);
            DLog(@"responseObject = %@", responseObject);
        } failure:^(NSString *error) {
            DLog(@"error = %@", error);
        } invalid:^(NSString *msg) {
            DLog(@"msg = %@", msg);
        }];
    }
    
    if(5 == btn.tag){
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        [self presentViewController:loginVC animated:YES completion:nil];
    }
    
    if(6 == btn.tag){
        BaseWebViewController *webVC = [[BaseWebViewController alloc] initWithURL:@"https://www.qq.com"];
        [self.navigationController pushViewController:webVC animated:YES];
    }
    
    if(7 == btn.tag){
        [self initializeVPN];       // 初始化VPN
    }
    
}

#pragma mark - 初始化VPN方法
- (void)initializeVPN {
    // 判断VPN是否已经初始化登录
    if (VPN_STATUS_OK == [self.helper vpnQueryStatus]){
        DLog(@"vpn当前是已经登录状态，注销后才能再登录");
        return;
    }
    self.helper = [AuthHelper getInstance];
    [self.helper init:EasyApp host:VPN_HOST port:VPN_PORT delegate:self];
}
#pragma mark - 初始化用户名、密码认证参数
- (void)initializeAuthParam {
    [self.helper setAuthParam:@PORPERTY_NamePasswordAuth_NAME param:VPN_USERNAME];
    [self.helper setAuthParam:@PORPERTY_NamePasswordAuth_PASSWORD param:VPN_PASSWORD];
}
#pragma mark - SangforSDKDelegate 深信服VPN代理方法
- (void)onCallBack:(const VPN_RESULT_NO)vpnErrno authType:(const int)authType {
    switch (vpnErrno) {
        case RESULT_VPN_INIT_FAIL: {
            DLog(@"VPN 初始化失败！");
            break;
        }
        case RESULT_VPN_AUTH_FAIL: {
            [self.helper clearAuthParam:@SET_RND_CODE_STR];
            [self.helper vpnQueryStatus];
            DLog(@"VPN 认证失败！");
            break;
        }
        case RESULT_VPN_INIT_SUCCESS: {
            DLog(@"VPN 初始化成功！");
            //显示当前sdk版本号
            NSString *version = [self.helper getSdkVersion];
            DLog(@"VPN SDK Version: %@", version);
            [self.helper setAuthParam:@AUTH_DEVICE_LANGUAGE param:@"en_US"];//zh_CN or en_US
            
            [self initializeAuthParam];
            
            [self.helper loginVpn:SSL_AUTH_TYPE_PASSWORD];
            break;
        }
        case RESULT_VPN_AUTH_SUCCESS: {
            DLog(@"VPN认证成功！");
            [self startAuth:authType];
            break;
        }
        case RESULT_VPN_AUTH_LOGOUT: {
            DLog(@"VPN注销！");
            break;
        }
        case RESULT_VPN_OTHER: {
            DLog(@"VPN返回其他状态！");
            break;
        }
        case RESULT_VPN_NONE: {
            DLog(@"VPN值无效！");
            break;
        }
        case RESULT_VPN_L3VPN_FAIL: {
            [self.helper clearAuthParam:@SET_RND_CODE_STR];
            DLog(@"L3VPN启动失败！");
            break;
        }
        default: {
            DLog(@"VPN未知错误！");
            break;
        }
    }
}
#pragma mark - 开始认证方法
- (void) startAuth:(const int)authType {
    switch (authType) {
        case SSL_AUTH_TYPE_CERTIFICATE: {
            DLog(@"开始证书认证！");
            break;
        }
        case SSL_AUTH_TYPE_PASSWORD: {
            DLog(@"开始用户名密码认证！");
            [self initializeAuthParam];
            break;
        }
        case SSL_AUTH_TYPE_NONE: {
            DLog(@"VPN认证成功!");
            return;
        }
        case SSL_AUTH_TYPE_SMS: {
            DLog(@"VPN开始短信认证！");
            break;
        }
        case SSL_AUTH_TYPE_RADIUS: {
            DLog(@"VPN开始短信认证！");
            break;
        }
        case SSL_AUTH_TYPE_TOKEN:
        default:
            DLog(@"VPN未知错误！");
            return;
    }
    [self.helper loginVpn:authType];
}

@end
