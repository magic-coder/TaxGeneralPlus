/************************************************************
 Class    : MainNavigationController.m
 Describe : 主界面Navigation顶部导航栏
 Company  : Prient
 Author   : Yanzheng 严正
 Date     : 2017-10-13
 Version  : 1.0
 Declare  : Copyright © 2017 Yanzheng. All rights reserved.
 ************************************************************/

#import "MainNavigationController.h"

@interface MainNavigationController () <UINavigationControllerDelegate>

@end

@implementation MainNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.delegate = self;
    
    //self.navigationBar.translucent = NO;// 设置导航栏不透明
    //self.navigationBar.barStyle = UIBaselineAdjustmentNone;// 去除 navigationBar 下面的黑线
    self.navigationBar.barTintColor = DEFAULT_BLUE_COLOR;// 设置导航栏背景颜色
    //[self.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigation_bg" scaleToSize:CGSizeMake(WIDTH_SCREEN, HEIGHT_STATUS + HEIGHT_NAVBAR)] forBarMetrics:UIBarMetricsDefault];// 设置导航栏背景图
    self.navigationBar.tintColor = [UIColor whiteColor];// 设置导航栏itemBar字体颜色
    self.navigationBar.titleTextAttributes = @{ NSForegroundColorAttributeName : [UIColor whiteColor] };// 设置导航栏title标题字体颜色
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 重写pushViewController:方法
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if(self.viewControllers.count > 0) {
        [viewController setHidesBottomBarWhenPushed:YES];// 隐藏底部tabBar
    }
    [super pushViewController:viewController animated:animated];
}

#pragma mark - <UINavigationControllerDelegate>代理方法（控制隐藏、显示顶部导航栏）
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    // 判断要显示的控制器是否是否进行隐藏
    //BOOL isHidden = [viewController isKindOfClass:[NSClassFromString(@"NewsViewController") class]];
    BOOL isNavigationBarHidden = NO;
    NSArray *hidenControllers = @[@"NewsViewController_BAK", @"AppViewController"];
    for(NSString *hidenControllerName in hidenControllers){
        isNavigationBarHidden = isNavigationBarHidden || [viewController isKindOfClass:[NSClassFromString(hidenControllerName) class]];
    }
    // 控制隐藏、显示顶部导航栏
    [viewController.navigationController setNavigationBarHidden:isNavigationBarHidden animated:animated];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
