/************************************************************
 Class    : NewsUtil.m
 Describe : 首页新闻工具类
 Company  : Prient
 Author   : Yanzheng 严正
 Date     : 2017-10-26
 Version  : 1.0
 Declare  : Copyright © 2017 Yanzheng. All rights reserved.
 ************************************************************/

#import "NewsUtil.h"

@implementation NewsUtil

SingletonM(NewsUtil)

- (NSDictionary *)loadData {
    // JSON文件的路径
    NSString *path = [[NSBundle mainBundle] pathForResource:@"News" ofType:@"json"];
    // 读取JSON文件
    NSData *data = [NSData dataWithContentsOfFile:path];
    // 将JSON数据转为NSArray或NSDictionary
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    return dic;
}

@end
