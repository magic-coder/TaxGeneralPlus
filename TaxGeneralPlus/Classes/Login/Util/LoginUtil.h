/************************************************************
 Class    : LoginUtil.h
 Describe : 用户登录工具类
 Company  : Prient
 Author   : Yanzheng 严正
 Date     : 2017-11-13
 Version  : 1.0
 Declare  : Copyright © 2017 Yanzheng. All rights reserved.
 ************************************************************/

#import <Foundation/Foundation.h>

@interface LoginUtil : NSObject

SingletonH(LoginUtil)

// 通过app进行登录
- (void)loginWithAppDict:(NSMutableDictionary *)dict success:(void (^)(void))success failed:(void (^)(NSString *error))failed;

@end
