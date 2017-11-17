//
//  TestViewController.m
//  TaxGeneralPlus
//
//  Created by Apple on 2017/10/19.
//  Copyright © 2017年 prient. All rights reserved.
//

#import "TestViewController.h"
#import "TestModel.h"
#import "NewsModel.h"

@interface TestViewController () <YBPopupMenuDelegate, YZCycleScrollViewDelegate>

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
    
    UIImageView *testImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 50, 50)];
    [testImageView sd_setImageWithURL:[NSURL URLWithString:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1508498082662&di=47a95adc26742482328425a3dd6b47b3&imgtype=0&src=http%3A%2F%2Fimg.zcool.cn%2Fcommunity%2F019f9c5542b8fc0000019ae980d080.jpg%401280w_1l_2o_100sh.jpg"] placeholderImage:[UIImage imageNamed:@"navigation_bg"]];
    [self.view addSubview:testImageView];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = CGRectMake(10, 80, 200, 30);
    [btn setTitle:@"MBProgressHUD" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(onClick:) forControlEvents:(UIControlEventTouchUpInside)];
    btn.tag = 0;
    [self.view addSubview:btn];

    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeSystem];
    btn1.frame = CGRectMake(10, 120, 300, 30);
    [btn1 setTitle:@"UIAlertControllerBlocks-Alert" forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(onClick:) forControlEvents:(UIControlEventTouchUpInside)];
    btn1.tag = 1;
    [self.view addSubview:btn1];
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeSystem];
    btn2.frame = CGRectMake(10, 150, 300, 30);
    [btn2 setTitle:@"UIAlertControllerBlocks-ActionSheet" forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(onClick:) forControlEvents:(UIControlEventTouchUpInside)];
    btn2.tag = 2;
    [self.view addSubview:btn2];
    
    UIButton *btn3 = [UIButton buttonWithType:UIButtonTypeSystem];
    btn3.frame = CGRectMake(10, 180, 300, 30);
    [btn3 setTitle:@"YZBottomSelectView" forState:UIControlStateNormal];
    [btn3 addTarget:self action:@selector(onClick:) forControlEvents:(UIControlEventTouchUpInside)];
    btn3.tag = 3;
    [self.view addSubview:btn3];
    
    UIButton *btn4 = [UIButton buttonWithType:UIButtonTypeSystem];
    btn4.frame = CGRectMake(10, 260, 300, 30);
    [btn4 setTitle:@"AFNetworking单项认证登录" forState:UIControlStateNormal];
    [btn4 addTarget:self action:@selector(onClick:) forControlEvents:(UIControlEventTouchUpInside)];
    btn4.tag = 4;
    [self.view addSubview:btn4];
    
    UIButton *btn5 = [UIButton buttonWithType:UIButtonTypeSystem];
    btn5.frame = CGRectMake(10, 300, 300, 30);
    [btn5 setTitle:@"AFNetworking请求首页税闻" forState:UIControlStateNormal];
    [btn5 addTarget:self action:@selector(onClick:) forControlEvents:(UIControlEventTouchUpInside)];
    btn5.tag = 5;
    [self.view addSubview:btn5];
    
    UIButton *btn6 = [UIButton buttonWithType:UIButtonTypeSystem];
    btn6.frame = CGRectMake(10, 340, 300, 30);
    [btn6 setTitle:@"登录界面" forState:UIControlStateNormal];
    [btn6 addTarget:self action:@selector(onClick:) forControlEvents:(UIControlEventTouchUpInside)];
    btn6.tag = 6;
    [self.view addSubview:btn6];
    
    UIButton *btn7 = [UIButton buttonWithType:UIButtonTypeSystem];
    btn7.frame = CGRectMake(10, 380, 300, 30);
    [btn7 setTitle:@"WebView" forState:UIControlStateNormal];
    [btn7 addTarget:self action:@selector(onClick:) forControlEvents:(UIControlEventTouchUpInside)];
    btn7.tag = 7;
    [self.view addSubview:btn7];
    
    // 添加轮播图
    NSArray *titles = @[@"腾讯", @"京东", @"阿里巴巴", @"小米"];
    NSArray *images = @[@"http://i1.douguo.net//upload/banner/0/6/a/06e051d7378040e13af03db6d93ffbfa.jpg", @"http://i1.douguo.net//upload/banner/9/3/4/93f959b4e84ecc362c52276e96104b74.jpg", @"http://i1.douguo.net//upload/banner/5/e/3/5e228cacf18dada577269273971a86c3.jpg", @"http://i1.douguo.net//upload/banner/d/8/2/d89f438789ee1b381966c1361928cb32.jpg"];
    NSArray *urls = @[@"http://www.qq.com", @"http://www.jd.com", @"http://www.taobao.com", @"http://www.xiaomi.com"];
    
    YZCycleScrollView *cycleScrollView = [[YZCycleScrollView alloc] initWithFrame:CGRectMake(0, HEIGHT_SCREEN/2, WIDTH_SCREEN, HEIGHT_SCREEN/4) titles:titles images:images urls:urls autoPlay:YES delay:2.0f];
    cycleScrollView.delegate = self;
    [self.view addSubview:cycleScrollView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)saveBtnClick:sender {
    [YBPopupMenu showPopupMenuWithTitles:@[@"内容搜索", @"扫一扫", @"设置"] icons:@[@"popupMenu_search", @"popupMenu_scan", @"popupMenu_setting"] delegate:self];
    
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
        [MBProgressHUD showHUDView:self.view text:nil progressHUDMode:(YZProgressHUDModeLock)];
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
            sleep(2.0);
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hiddenHUDView:self.view];
            });
        });
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
        
        // 拼接报文参数
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setObject:@"26100010001" forKey:@"userCode"];
        [dict setObject:@"Aa111111" forKey:@"password"];
        [dict setObject:@"876635" forKey:@"verificationCode"];
        [dict setObject:@"app" forKey:@"loginType"];
        [dict setObject:@"iPhoneX" forKey:@"phonemodel"];
        [dict setObject:[UIDevice currentDevice].systemVersion forKey:@"osversion"];
        [dict setObject:@"4" forKey:@"phonetype"];
        [dict setObject:[[[UIDevice currentDevice] identifierForVendor] UUIDString] forKey:@"deviceid"];
        
        NSString *jsonString = [[BaseHandleUtil sharedBaseHandleUtil] JSONStringWithObject:dict];
        
        /*
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setObject:[NSNumber numberWithInt:10] forKey:@"pageSize"];
        [dict setObject:@"26101000000" forKey:@"orgCode"];
        
        NSString *jsonString = [[BaseHandleUtil sharedBaseHandleUtil] JSONStringWithObject:dict];
        */
        NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:jsonString, @"msg", nil];
        
        [YZNetworkingManager POST:[NSString stringWithFormat:@"%@account/login", SERVER_URL] parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        DLog(@"responseObject = %@", responseObject);
        } failure:^(NSURLSessionDataTask *task, NSString *error) {
        DLog(@"error = %@", error);
        }];
    }
    
    if(5 == btn.tag){
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setObject:@"10" forKey:@"pageSize"];
        [dict setObject:@"26101007900" forKey:@"orgCode"];
        
        NSString *jsonString = [[BaseHandleUtil sharedBaseHandleUtil] JSONStringWithObject:dict];
        NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:jsonString, @"msg", nil];
        
        [YZNetworkingManager POST:[NSString stringWithFormat:@"%@public/photonews/index", SERVER_URL] parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
            DLog(@"responseObject = %@", responseObject);
        } failure:^(NSURLSessionDataTask *task, NSString *error) {
            DLog(@"error = %@", error);
        }];
    }
    
    if(6 == btn.tag){
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        [self presentViewController:loginVC animated:YES completion:nil];
    }
    
    if(7 == btn.tag){
        
        BaseWebViewController *webVC = [[BaseWebViewController alloc] initWithURL:@"http://www.qq.com"];
         
        [self.navigationController pushViewController:webVC animated:YES];
        
        
    }
    
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
