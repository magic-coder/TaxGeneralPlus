//
//  AppViewController.m
//  TaxGeneralPlus
//
//  Created by Apple on 2017/10/19.
//  Copyright © 2017年 prient. All rights reserved.
//

#import "AppViewController.h"
#import "TestViewController.h"

@interface AppViewController ()

@end

@implementation AppViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = DEFAULT_BACKGROUND_COLOR;
    
    /*
     UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, WIDTH_SCREEN, HEIGHT_SCREEN/4)];
     [imageView sd_setImageWithURL:[NSURL URLWithString:@"http://i1.douguo.net//upload/banner/d/8/2/d89f438789ee1b381966c1361928cb32.jpg"] placeholderImage:[UIImage imageWithColor:HexColor(@"#865331", 1.0f)]];
     [self.view addSubview:imageView];
     */
    
    // 添加轮播图
    NSArray *titles = @[@"腾讯", @"京东", @"阿里巴巴", @"小米"];
    NSArray *images = @[@"http://i1.douguo.net//upload/banner/0/6/a/06e051d7378040e13af03db6d93ffbfa.jpg", @"http://i1.douguo.net//upload/banner/9/3/4/93f959b4e84ecc362c52276e96104b74.jpg", @"http://i1.douguo.net//upload/banner/5/e/3/5e228cacf18dada577269273971a86c3.jpg", @"http://i1.douguo.net//upload/banner/d/8/2/d89f438789ee1b381966c1361928cb32.jpg"];
    NSArray *urls = @[@"http://www.qq.com", @"http://www.jd.com", @"http://www.taobao.com", @"http://www.xiaomi.com"];
    
    YZCycleScrollView *cycleScrollView = [[YZCycleScrollView alloc] initWithFrame:CGRectMake(0, 0, WIDTH_SCREEN, HEIGHT_SCREEN/4) titles:titles images:images urls:urls autoPlay:YES delay:2.0f];
    [self.view addSubview:cycleScrollView];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = CGRectMake(100, 400, 100, 30);
    [btn setTitle:@"test push" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(onClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:btn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onClick:(UIButton *)btn{
    DLog(@"点击了按钮");
    [self.navigationController pushViewController:[NSClassFromString(@"TestViewController") new] animated:YES];
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
