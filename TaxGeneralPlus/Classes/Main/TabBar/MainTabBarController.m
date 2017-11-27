/************************************************************
 Class    : MainTabBarController.m
 Describe : 主界面TabBar底部选项卡
 Company  : Prient
 Author   : Yanzheng 严正
 Date     : 2017-10-13
 Version  : 1.0
 Declare  : Copyright © 2017 Yanzheng. All rights reserved.
 ************************************************************/

#import "MainTabBarController.h"
#import "MainNavigationController.h"

#define CLASS_NAME      @"className"
#define TITLE           @"title"
#define IMAGE           @"image"
#define SELECTED_IMAGE  @"selectedImage"

@interface MainTabBarController ()

@end

@implementation MainTabBarController

SingletonM(MainTabBarController)

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tabBar.translucent= NO;// 设置tabBar不透明
    self.tabBar.barTintColor = [UIColor whiteColor];// 设置tabBar背景颜色
    
    NSArray *items = @[
                       @{
                           CLASS_NAME       :   @"NewsViewController",
                           TITLE            :   @"首页",
                           IMAGE            :   @"tabbar_news",
                           SELECTED_IMAGE   :   @"tabbar_newsHL"
                           },
                       @{
                           CLASS_NAME       :   @"AppViewController",
                           TITLE            :   @"应用",
                           IMAGE            :   @"tabbar_app",
                           SELECTED_IMAGE   :   @"tabbar_appHL"
                           },
                       @{
                           CLASS_NAME       :   @"MsgListViewController",
                           TITLE            :   @"消息",
                           IMAGE            :   @"tabbar_msg",
                           SELECTED_IMAGE   :   @"tabbar_msgHL"
                           },
                       @{
                           CLASS_NAME       :   @"MineViewController",
                           TITLE            :   @"我",
                           IMAGE            :   @"tabbar_mine",
                           SELECTED_IMAGE   :   @"tabbar_mineHL"
                           }
                       ];
    
    NSMutableArray  *viewControllers = [[NSMutableArray alloc] init];
    // 使用block方法遍历集合
    [items enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        UIViewController *viewController = [[NSClassFromString(obj[CLASS_NAME]) alloc] init];// 根据类名称动态创建类
        viewController.title = obj[TITLE];
        viewController.tabBarItem.image = [UIImage imageNamed:obj[IMAGE]];
        viewController.tabBarItem.selectedImage = [[UIImage imageNamed:obj[SELECTED_IMAGE]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        MainNavigationController *mainNav = [[MainNavigationController alloc] initWithRootViewController:viewController];
        [viewControllers addObject:mainNav];
        
    }];
    
    self.viewControllers = viewControllers;// 设置tabBar视图集合
    UITabBarItem *item = [UITabBarItem appearance];// 获取tabBarItem的外观
    [item setTitleTextAttributes:@{NSForegroundColorAttributeName : DEFAULT_BLUE_COLOR} forState:UIControlStateSelected];// 设置tabBar选中颜色
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
