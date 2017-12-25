/************************************************************
 Class    : BaseSecurityUtil.m
 Describe : 安全存储类，采用Keychain存储数据
 Company  : Prient
 Author   : Yanzheng 严正
 Date     : 2017-12-25
 Version  : 1.0
 Declare  : Copyright © 2017 Yanzheng. All rights reserved.
 ************************************************************/

#import "BaseSecurityUtil.h"

@implementation BaseSecurityUtil

#pragma mark - 单例模式方法
SingletonM(BaseSecurityUtil)

- (void)saveUserDict:(NSDictionary *)dict {
    
}

- (NSDictionary *)getUserDict {
    return nil;
}

- (BOOL)removeUserDict {
    return nil;
}

@end
