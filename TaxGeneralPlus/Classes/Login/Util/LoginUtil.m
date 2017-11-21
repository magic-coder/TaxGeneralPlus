/************************************************************
 Class    : LoginUtil.m
 Describe : 用户登录工具类
 Company  : Prient
 Author   : Yanzheng 严正
 Date     : 2017-11-13
 Version  : 1.0
 Declare  : Copyright © 2017 Yanzheng. All rights reserved.
 ************************************************************/

#import "LoginUtil.h"

@implementation LoginUtil

SingletonM(LoginUtil)

#pragma mark - 通过app进行登录
- (void)loginWithAppDict:(NSMutableDictionary *)dict success:(void (^)(void))success failed:(void (^)(NSString *))failed {

    // 获取设备信息
    NSDictionary *deviceDict = [[NSUserDefaults standardUserDefaults] objectForKey:DEVICE_INFO];
    // 设置登录请求基本信息参数
    [dict setObject:@"app" forKey:@"loginType"];
    [dict setObject:@"4" forKey:@"phonetype"];
    [dict setObject:[deviceDict objectForKey:@"deviceIdentifier"] forKey:@"deviceid"];
    [dict setObject:[deviceDict objectForKey:@"deviceModel"] forKey:@"phonemodel"];
    [dict setObject:[deviceDict objectForKey:@"systemVersion"] forKey:@"osversion"];
    
    [YZNetworkingManager POST:@"account/login" parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        // 获取请求状态值
        if(REQUEST_SUCCESS){
            // 获取登录成功信息
            NSDictionary *businessData = [responseObject objectForKey:@"businessData"];
            [dict setObject:[businessData objectForKey:@"userName"] forKey:@"userName"];
            [dict setObject:[businessData objectForKey:@"orgCode"] forKey:@"orgCode"];
            [dict setObject:[businessData objectForKey:@"orgName"] forKey:@"orgName"];
            [dict setObject:[businessData objectForKey:@"userMobile"] forKey:@"userMobile"];
            [dict setObject:[businessData objectForKey:@"userPhone"] forKey:@"userPhone"];
            [dict setObject:[businessData objectForKey:@"token"] forKey:@"token"];
            // 获取系统当前时间(登录时间)
            NSDate *sendDate = [NSDate date];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSString *loginDate = [dateFormatter stringFromDate:sendDate];
            [dict setObject:loginDate forKey:@"loginDate"];
            
            // 将登录成功信息保存到用户单例模式中
            [[NSUserDefaults standardUserDefaults] setObject:[dict objectForKey:@"userCode"] forKey:LAST_LOGINCODE];// 记录最近一次登录用户名以便注销后展示
            [[NSUserDefaults standardUserDefaults] setObject:dict forKey:LOGIN_SUCCESS];
            [[NSUserDefaults standardUserDefaults] synchronize]; // 强制写入
            
            success();
        }else{
            failed(RESPONSE_MSG);
        }
    } failure:^(NSURLSessionDataTask *task, NSString *error) {
        // 登录失败
        failed(error);
    }];
    
}

#pragma mark - 通过token进行登录
- (void)loginWithTokenSuccess:(void (^)(void))success failed:(void (^)(NSString *))failed {
    
    NSDictionary *deviceDict = [[NSUserDefaults standardUserDefaults] objectForKey:DEVICE_INFO];
    NSDictionary *userDict = [[NSUserDefaults standardUserDefaults] objectForKey:LOGIN_SUCCESS];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:@"appToken" forKey:@"loginType"];
    [dict setObject:@"4" forKey:@"phonetype"];
    [dict setObject:[userDict objectForKey:@"userCode"] forKey:@"userCode"];
    [dict setObject:[userDict objectForKey:@"token"] forKey:@"token"];
    [dict setObject:[deviceDict objectForKey:@"deviceIdentifier"] forKey:@"deviceid"];
    [dict setObject:[deviceDict objectForKey:@"deviceModel"] forKey:@"phonemodel"];
    [dict setObject:[deviceDict objectForKey:@"systemVersion"] forKey:@"osversion"];
    
    [YZNetworkingManager POST:@"account/login" parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        if(REQUEST_SUCCESS){
            
            NSDictionary *businessData = [responseObject objectForKey:@"businessData"];
            [dict setObject:[businessData objectForKey:@"userName"] forKey:@"userName"];
            [dict setObject:[businessData objectForKey:@"orgCode"] forKey:@"orgCode"];
            [dict setObject:[businessData objectForKey:@"orgName"] forKey:@"orgName"];
            [dict setObject:[businessData objectForKey:@"userMobile"] forKey:@"userMobile"];
            [dict setObject:[businessData objectForKey:@"userPhone"] forKey:@"userPhone"];
            // 获取系统当前时间(登录时间)
            NSDate *sendDate = [NSDate date];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSString *loginDate = [dateFormatter stringFromDate:sendDate];
            [dict setObject:loginDate forKey:@"loginDate"];
            
            // 登录成功将信息保存到用户单例模式中
            [[NSUserDefaults standardUserDefaults] setObject:dict forKey:LOGIN_SUCCESS];
            [[NSUserDefaults standardUserDefaults] synchronize]; // 强制写入
            
            success();
        }else{
            failed(RESPONSE_MSG);
        }
    } failure:^(NSURLSessionDataTask *task, NSString *error) {
        failed(error);
    }];
}

@end
