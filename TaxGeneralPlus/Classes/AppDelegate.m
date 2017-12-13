/************************************************************
 Class    : AppDelegate.m
 Describe : 应用主委托代理类
 Company  : Prient
 Author   : Yanzheng 严正
 Date     : 2017-10-09
 Version  : 1.0
 Declare  : Copyright © 2017 Yanzheng. All rights reserved.
 ************************************************************/

#import "AppDelegate.h"
#import "MainTabBarController.h"
#import "GestureViewController.h"
#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件

@interface AppDelegate ()

@property (nonatomic, strong) MainTabBarController *rootVC; // 根视图

@property (nonatomic, strong) BMKMapManager *mapManager;    // 百度 Map 初始化

@property (nonatomic, strong) UIVisualEffectView *blurView; // 多任务后台毛玻璃遮挡效果视图

@end

@implementation AppDelegate

#pragma mark - 程序加载完毕
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    // 隐藏顶部状态栏设为NO
    [UIApplication sharedApplication].statusBarHidden = NO;
    // 设置顶部状态栏字体为白色
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    // 设置主window视图
    _window = [[UIWindow alloc] initWithFrame:FRAME_SCREEN];
    _window.backgroundColor = DEFAULT_BLUE_COLOR;
    
    // 设置root视图控制器
    _rootVC = [[MainTabBarController alloc] init];
    _window.rootViewController = _rootVC;
    [_window makeKeyAndVisible];
    
    [self welcomeAnimation];    // 加载启动动画
    
    // 判断系统版本是否支持
#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_10_0
    
    [UIAlertController showAlertInViewController:_window.rootViewController withTitle:@"对不起，当前系统版本过低" message:@"请在iPhone的\"设置-通用-软件更新\"中升级您的操作系统至ios10.0以上再使用。" cancelButtonTitle:@"退出应用" destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
        exit(0);
    }];
    
#else
    
    [[BaseHandleUtil sharedBaseHandleUtil] currentDeviceInfo]; // 获取设备基本信息
    [[BaseSettingUtil sharedBaseSettingUtil] initSettingData]; // 初始化基本设置信息
    [self initializeBaiduMap];  // 百度地图 BMKMapManager 初始化
    
    [self verifyUnlock];// 判断是否设置安全密码
    
#endif
    
    return YES;
}

#pragma mark - 程序失去焦点
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}

#pragma mark - 程序进入后台
- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    [self showBlurView:YES];// 开启遮挡视图
}

#pragma mark - 程序从后台回到前台
- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    
    [self verifyUnlock];// 判断是否设置安全密码
}

#pragma mark - 程序获取焦点
- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    [self showBlurView:NO];// 开启遮挡视图
}

#pragma mark - 程序即将退出
- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - 程序内存警告，可能要终止程序
- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    DLog(@"程序内存警告，可能要终止程序");
}

#pragma mark - 启动欢迎动画
- (void)welcomeAnimation {
    //logo mask
    CALayer *maskLayer = [CALayer layer];
    maskLayer.contents = (id)[UIImage imageNamed:@"common_launch"].CGImage;
    maskLayer.position = _rootVC.view.center;
    maskLayer.bounds = CGRectMake(0, 0, 60, 60);
    _rootVC.view.layer.mask = maskLayer;
    
    //logo mask background view
    UIView *maskBackgroundView = [[UIView alloc]initWithFrame:_rootVC.view.bounds];
    maskBackgroundView.backgroundColor = [UIColor whiteColor];
    [_rootVC.view addSubview:maskBackgroundView];
    [_rootVC.view bringSubviewToFront:maskBackgroundView];
    
    //logo mask animation
    CAKeyframeAnimation *logoMaskAnimaiton = [CAKeyframeAnimation animationWithKeyPath:@"bounds"];
    logoMaskAnimaiton.duration = 1.0f;
    logoMaskAnimaiton.beginTime = CACurrentMediaTime() + 1.5f;//延迟一秒
    
    CGRect initalBounds = maskLayer.bounds;
    CGRect secondBounds = CGRectMake(0, 0, 50, 50);
    CGRect finalBounds  = CGRectMake(0, 0, 2000, 2000);
    logoMaskAnimaiton.values = @[[NSValue valueWithCGRect:initalBounds],[NSValue valueWithCGRect:secondBounds],[NSValue valueWithCGRect:finalBounds]];
    logoMaskAnimaiton.keyTimes = @[@(0),@(0.5),@(1)];
    logoMaskAnimaiton.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut],[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    logoMaskAnimaiton.removedOnCompletion = NO;
    logoMaskAnimaiton.fillMode = kCAFillModeForwards;
    [_rootVC.view.layer.mask addAnimation:logoMaskAnimaiton forKey:@"logoMaskAnimaiton"];
    
    //maskBackgroundView fade animation
    [UIView animateWithDuration:0.1 delay:1.85 options:UIViewAnimationOptionCurveEaseIn animations:^{
        maskBackgroundView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [maskBackgroundView removeFromSuperview];
    }];
}

#pragma mark - 百度地图 BMKMapManager 初始化
- (void)initializeBaiduMap {
    _mapManager = [[BMKMapManager alloc] init];
    // 如果要关注网络及授权验证事件，请设定 generalDelegate 参数
    BOOL ret = [_mapManager start:BaiduMap_Key generalDelegate:nil];
    if (!ret) {
        DLog(@"百度地图管理器启动失败!");
    }
}

#pragma mark - 判断是否开启了手势密码、指纹解锁功能
- (void)verifyUnlock {
    
    MainTabBarController *mainTabBarController = [MainTabBarController sharedMainTabBarController];
    
    if(IS_LOGIN){
        // 校验用户是否开启了手势密码、指纹解锁，并进行相应跳转
        NSDictionary *settingDict = [[BaseSettingUtil sharedBaseSettingUtil] loadSettingData];
        
        if([[settingDict objectForKey:@"touchID"] boolValue]){  // 指纹解锁
            [mainTabBarController presentViewController:[[NSClassFromString(@"TouchIDViewController") class] new] animated:NO completion:nil];
        }else{
            if([[settingDict objectForKey:@"gesturePwd"] boolValue]){
                NSString *gesturePwd = [[NSUserDefaults standardUserDefaults] objectForKey:GESTURES_PASSWORD];
                if(gesturePwd.length > 0){  // 手势验证解锁
                    GestureViewController *gestureVC = [[GestureViewController alloc] init];
                    [gestureVC setType:GestureViewControllerTypeLogin];
                    
                    [mainTabBarController presentViewController:gestureVC animated:NO completion:nil];
                }
            }
        }
    }
}

#pragma mark - 切换后台缩略图毛玻璃遮挡
- (void) showBlurView:(BOOL)isMask{
    if(isMask){
        [[[UIApplication sharedApplication] keyWindow] addSubview:self.blurView];
    }
    [UIView animateWithDuration:0 animations:^{
        self.blurView.alpha = isMask ? 0.97f : 0;
    } completion:^(BOOL finished) {
        if (!isMask){
            [self.blurView removeFromSuperview];
        }
    }];
}
#pragma mark 毛玻璃遮挡视图效果
- (UIVisualEffectView *)blurView{
    if (!_blurView) {
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        //  毛玻璃view 视图
        _blurView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        _blurView.frame = [[UIApplication sharedApplication] keyWindow].bounds;
        _blurView.alpha = 0;
    }
    return _blurView;
}

@end
