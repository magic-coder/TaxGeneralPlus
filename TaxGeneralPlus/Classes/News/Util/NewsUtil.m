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
    NSDictionary *dic = [[BaseHandleUtil sharedBaseHandleUtil] readWithJSONFile:@"News.json"];
    return dic;
}

@end
