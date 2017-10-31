/************************************************************
 Class    : AppUtil.h
 Describe : 应用模块工具类
 Company  : Prient
 Author   : Yanzheng 严正
 Date     : 2017-10-31
 Version  : 1.0
 Declare  : Copyright © 2017 Yanzheng. All rights reserved.
 ************************************************************/

#import <Foundation/Foundation.h>

@interface AppUtil : NSObject


SingletonH(AppUtil)

- (NSDictionary *)loadData;

@end
