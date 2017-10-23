//
//  TestViewController.m
//  TaxGeneralPlus
//
//  Created by Apple on 2017/10/19.
//  Copyright © 2017年 prient. All rights reserved.
//

#import "TestViewController.h"

@interface TestViewController ()

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    DLog(@"%f", HEIGHT_STATUS);
    
    self.title = @"Test";
    self.view.backgroundColor = DEFAULT_BACKGROUND_COLOR;
    
    UIImageView *testImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 50, 50)];
    [testImageView sd_setImageWithURL:[NSURL URLWithString:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1508498082662&di=47a95adc26742482328425a3dd6b47b3&imgtype=0&src=http%3A%2F%2Fimg.zcool.cn%2Fcommunity%2F019f9c5542b8fc0000019ae980d080.jpg%401280w_1l_2o_100sh.jpg"] placeholderImage:[UIImage imageNamed:@"navigation_bg"]];
    [self.view addSubview:testImageView];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = CGRectMake(10, 80, 200, 30);
    [btn setTitle:@"MBProgressHUD" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(onClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:btn];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onClick:(UIButton *)btn{
    
    /*
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    UIImage *image = [[UIImage imageNamed:@"Checkmark"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    hud.customView = [[UIImageView alloc] initWithImage:image];
    //hud.square = YES;// 设置成正方形
    hud.label.text = @"正在加载...";
    hud.contentColor = [UIColor whiteColor];
    hud.bezelView.backgroundColor = [UIColor blackColor];
    [hud hideAnimated:YES afterDelay:3.f];
    */
    
    [MBProgressHUD showHUDView:self.view text:@"加载中..." progressHUDMode:(YZProgressHUDModeLock)];
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        sleep(2.0);
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hiddenHUDView:self.view];
        });
    });
    
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
