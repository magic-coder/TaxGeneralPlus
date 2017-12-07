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

@interface AppDelegate ()

@property (nonatomic, strong) MainTabBarController *rootVC; // 根视图

@property (nonatomic, strong) UIVisualEffectView *blurView; // 多任务后台毛玻璃遮挡效果视图

@end

@implementation AppDelegate

#pragma mark - 程序加载完毕
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [[BaseHandleUtil sharedBaseHandleUtil] currentDeviceInfo]; // 获取设备基本信息
    [[BaseSettingUtil sharedBaseSettingUtil] initSettingData]; // 初始化基本设置信息
    
    // 隐藏顶部状态栏设为NO
    [UIApplication sharedApplication].statusBarHidden = NO;
    // 设置顶部状态栏字体为白色
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    // 设置主window视图
    _window = [[UIWindow alloc] initWithFrame:FRAME_SCREEN];
    _window.backgroundColor = [UIColor whiteColor];
    
    // 设置root视图控制器
    _rootVC = [[MainTabBarController alloc] init];
    _window.rootViewController = _rootVC;
    [_window makeKeyAndVisible];
    
    [self verifyUnlock];// 判断是否设置安全密码
    
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
