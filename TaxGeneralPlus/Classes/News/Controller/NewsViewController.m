//
//  NewsViewController.m
//  TaxGeneralPlus
//
//  Created by Apple on 2017/10/26.
//  Copyright © 2017年 prient. All rights reserved.
//

#import "NewsViewController.h"
#import "NewsTableViewCell.h"
#import "NewsModel.h"

@interface NewsViewController ()

@property (nonatomic, strong) NSMutableArray *data;     // 数据列表

@end

@implementation NewsViewController

static NSString * const reuseIdentifier = @"newsTableViewCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.rowHeight = 80;// 设置基本行高
    
    self.view.backgroundColor = DEFAULT_BACKGROUND_COLOR;
    self.tableView.backgroundColor = [UIColor whiteColor];
    //self.tableView.showsVerticalScrollIndicator = NO;// 隐藏纵向滚动条
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;// 自定义cell样式
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];// 去除底部多余分割线
    [self.tableView registerClass:[NewsTableViewCell class] forCellReuseIdentifier:reuseIdentifier];
    
    
    _data = [[NSMutableArray alloc] init];
    //JSON文件的路径
    NSString *path = [[NSBundle mainBundle] pathForResource:@"News" ofType:@"json"];
    //加载JSON文件
    NSData *data = [NSData dataWithContentsOfFile:path];
    //将JSON数据转为NSArray或NSDictionary
    NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    NSArray *dataArray = [dataDict objectForKey:@"newsArray"];
    for(NSDictionary *dic in dataArray){
        NewsModel *model = [NewsModel yy_modelWithDictionary:dic];
        [_data addObject:model];
    }
    
    
     
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // 1.缓存中取
    NewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    // 2.创建
    if (!cell) {
        cell = [[NewsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    // 3.设置数据
    cell.model = [_data objectAtIndex:indexPath.row];
    // 4.返回cell
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    // 点击后将颜色变回来
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    DLog(@"Yan -> 点击了第%ld个", indexPath.row);
    NewsTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    DLog(@"Yan -> 标题为：%@", cell.model.title);

}

// 设置cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NewsModel *model = [_data objectAtIndex:indexPath.row];
    if(model.cellHeight > 0){
        return model.cellHeight;
    }
    return 0;
}

@end
