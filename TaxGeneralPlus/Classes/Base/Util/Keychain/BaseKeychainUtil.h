/************************************************************
 Class    : BaseKeychainUtil.h
 Describe : 安全存储类，采用Keychain存储数据
 Company  : Prient
 Author   : Yanzheng 严正
 Date     : 2017-12-26
 Version  : 1.0
 Declare  : Copyright © 2017 Yanzheng. All rights reserved.
 ************************************************************/

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, GestureType) {
    One,    // 第一次输入的手势密码
    Final   // 最终的手势密码
};

@interface BaseKeychainUtil : NSObject

// 单例模式方法
SingletonH(BaseKeychainUtil)

// 保存用户基本信息
- (void)saveUserDict:(NSDictionary *)dict;

// 获取用户基本信息
- (NSDictionary *)getUserDict;

// 删除用户信息
- (BOOL)removeUserDict;

//  保存手势密码
- (void)saveGesture:(NSString *)gesture type:(GestureType)type;

//  获取手势密码
- (NSString *)getGestureType:(GestureType)type;

//  删除手势密码
- (BOOL)removeGestureType:(GestureType)type;

@end
