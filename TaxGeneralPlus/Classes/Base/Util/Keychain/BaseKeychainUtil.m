/************************************************************
 Class    : BaseKeychainUtil.m
 Describe : 安全存储类，采用Keychain存储数据
 Company  : Prient
 Author   : Yanzheng 严正
 Date     : 2017-12-26
 Version  : 1.0
 Declare  : Copyright © 2017 Yanzheng. All rights reserved.
 ************************************************************/

#import "BaseKeychainUtil.h"
#import "SAMKeychain.h"

#define LOGIN_SUCCESS           @"loginSuccess"
#define GESTURES_ONE_PASSWORD   @"gesturesPassword"
#define GESTURE_FINAL_PASSWORD  @"gesturesPassword"

/**
 *  第一个手势密码存储key
 */
#define gestureOneSaveKey @"gesturesOnePassword"

#define SERVICE             [[NSBundle mainBundle] bundleIdentifier]

@implementation BaseKeychainUtil

#pragma mark - 单例模式方法
SingletonM(BaseKeychainUtil)

#pragma mark - 将用户基本信息写入
- (void)saveUserDict:(NSDictionary *)dict {
    [SAMKeychain setPasswordData:[[BaseHandleUtil sharedBaseHandleUtil] dataWithObject:dict] forService:SERVICE account:LOGIN_SUCCESS];
}

#pragma mark - 获取用户基本信息
- (NSDictionary *)getUserDict {
    NSData *data = [SAMKeychain passwordDataForService:SERVICE account:LOGIN_SUCCESS];
    NSDictionary *dict = [[BaseHandleUtil sharedBaseHandleUtil] objectWithJSONData:data];
    return dict;
}

#pragma mark - 删除用户基本信息
- (BOOL)removeUserDict {
    BOOL res = [SAMKeychain deletePasswordForService:SERVICE account:LOGIN_SUCCESS];
    return res;
}

#pragma mark - 保存手势密码
- (void)saveGesture:(NSString *)gesture type:(GestureType)type {
    if(One == type){
        [SAMKeychain setPassword:gesture forService:SERVICE account:GESTURES_ONE_PASSWORD];
    }
    if(Final == type){
        [SAMKeychain setPassword:gesture forService:SERVICE account:GESTURE_FINAL_PASSWORD];
    }
}

#pragma mark - 获取手势密码
- (NSString *)getGestureType:(GestureType)type {
    NSString *gesture = nil;
    if(One == type){
        gesture= [SAMKeychain passwordForService:SERVICE account:GESTURES_ONE_PASSWORD];
    }
    if(Final == type){
        gesture= [SAMKeychain passwordForService:SERVICE account:GESTURE_FINAL_PASSWORD];
    }
    return gesture;
}

#pragma mark - 删除手势密码
- (BOOL)removeGestureType:(GestureType)type {
    BOOL res = NO;
    if(One == type){
        res = [SAMKeychain deletePasswordForService:SERVICE account:GESTURES_ONE_PASSWORD];
    }
    if(Final == type){
        res = [SAMKeychain deletePasswordForService:SERVICE account:GESTURE_FINAL_PASSWORD];
    }
    return res;
}

@end
