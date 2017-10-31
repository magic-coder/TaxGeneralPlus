/************************************************************
 Class    : AppUtil.m
 Describe : 应用模块工具类
 Company  : Prient
 Author   : Yanzheng 严正
 Date     : 2017-10-31
 Version  : 1.0
 Declare  : Copyright © 2017 Yanzheng. All rights reserved.
 ************************************************************/

#import "AppUtil.h"

@implementation AppUtil

SingletonM(AppUtil)

- (NSDictionary *)loadData {
    NSDictionary *dic = [[BaseHandleUtil sharedBaseHandleUtil] readWithJSONFile:@"App.json"];
    return dic;
}

@end
