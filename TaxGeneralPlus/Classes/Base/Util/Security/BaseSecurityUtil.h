/************************************************************
 Class    : BaseSecurityUtil.h
 Describe : 安全存储类，采用Keychain存储数据
 Company  : Prient
 Author   : Yanzheng 严正
 Date     : 2017-12-25
 Version  : 1.0
 Declare  : Copyright © 2017 Yanzheng. All rights reserved.
 ************************************************************/

#import <Foundation/Foundation.h>

@interface BaseSecurityUtil : NSObject

// 单例模式方法
SingletonH(BaseSecurityUtil)

// 保存用户基本信息
- (void)saveUserDict:(NSDictionary *)dict;

// 获取用户基本信息
- (NSDictionary *)getUserDict;

// 删除用户信息
- (BOOL)removeUserDict;

@end
