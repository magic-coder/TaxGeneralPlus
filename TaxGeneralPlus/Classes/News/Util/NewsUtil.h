/************************************************************
 Class    : NewsUtil.m
 Describe : 首页新闻工具类
 Company  : Prient
 Author   : Yanzheng 严正
 Date     : 2017-10-26
 Version  : 1.0
 Declare  : Copyright © 2017 Yanzheng. All rights reserved.
 ************************************************************/

#import <Foundation/Foundation.h>

@interface NewsUtil : NSObject

SingletonH(NewsUtil)

- (void)initDataWithPageSize:(int)pageSize dataBlock:(void (^)(NSDictionary *dataDict))dataBlock failed:(void(^)(NSString *error))failed;

- (void)moreDataWithPageNo:(int)pageNo pageSize:(int)pageSize dataBlock:(void (^)(NSArray *dataArray))dataBlock failed:(void(^)(NSString *error))failed;

@end
