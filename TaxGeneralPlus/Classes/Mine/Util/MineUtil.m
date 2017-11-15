/************************************************************
 Class    : MineUtil.m
 Describe : 我的模块处理工具类
 Company  : Prient
 Author   : Yanzheng 严正
 Date     : 2017-11-07
 Version  : 1.0
 Declare  : Copyright © 2017 Yanzheng. All rights reserved.
 ************************************************************/

#import "MineUtil.h"
#import "BaseTableModel.h"

@implementation MineUtil

SingletonM(MineUtil)

#pragma mark - 获取我的模块信息列表
- (NSMutableArray *)loadMineData {
    
    NSMutableArray *items = [NSMutableArray array];
    
    BaseTableModelItem *safe = [BaseTableModelItem createWithImageName:@"mine_safe" title:@"安全中心"];
    BaseTableModelItem *schedule = [BaseTableModelItem createWithImageName:@"mine_schedule" title:@"我的日程"];
    BaseTableModelItem *service = [BaseTableModelItem createWithImageName:@"mine_service" title:@"我的客服"];
    
    BaseTableModelGroup *group1 = [[BaseTableModelGroup alloc] initWithHeaderTitle:nil footerTitle:nil settingItems:safe, schedule, service, nil];
    [items addObject:group1];
    
    BaseTableModelItem *setting = [BaseTableModelItem createWithImageName:@"mine_setting" title:@"设置"];
    
    BaseTableModelGroup *group2 = [[BaseTableModelGroup alloc] initWithHeaderTitle:nil footerTitle:nil settingItems:setting, nil];
    [items addObject:group2];
    
    BaseTableModelItem *about = [BaseTableModelItem createWithImageName:@"mine_about" title:@"关于"];
    BaseTableModelGroup *group3 = [[BaseTableModelGroup alloc] initWithHeaderTitle:nil footerTitle:nil settingItems:about, nil];
    [items addObject:group3];
    
    return items;
    
}

#pragma mark - 获取我的用户基本信息
- (NSMutableArray *)accountData {
    
    NSDictionary *loginDict = [[NSUserDefaults standardUserDefaults] objectForKey:LOGIN_SUCCESS];
    
    NSMutableArray *items = [[NSMutableArray alloc] init];
    BaseTableModelItem *userID = [BaseTableModelItem createWithTitle:@"姓名" subTitle:[loginDict objectForKey:@"userName"]];
    userID.accessoryType = UITableViewCellAccessoryNone;
    BaseTableModelGroup *group1 = [[BaseTableModelGroup alloc] initWithHeaderTitle:nil footerTitle:nil settingItems:userID, nil];
    [items addObject:group1];
    
    BaseTableModelItem *name = [BaseTableModelItem createWithTitle:@"账号" subTitle:[loginDict objectForKey:@"userCode"]];
    name.accessoryType = UITableViewCellAccessoryNone;
    BaseTableModelItem *phoneNum = [BaseTableModelItem createWithTitle:@"手机号" subTitle:[loginDict objectForKey:@"userMobile"]];
    phoneNum.accessoryType = UITableViewCellAccessoryNone;
    //BaseTableModelItem *barCode = [BaseTableModelItem createWithImageName:nil title:@"我的二维码" subTitle:nil rightImageName:@"mine_barcode"];
    //barCode.accessoryType = UITableViewCellAccessoryNone;
    BaseTableModelItem *organ = [BaseTableModelItem createWithTitle:@"所属部门" subTitle:[loginDict objectForKey:@"orgName"]];
    organ.accessoryType = UITableViewCellAccessoryNone;
    BaseTableModelGroup *group2 = [[BaseTableModelGroup alloc] initWithHeaderTitle:nil footerTitle:nil settingItems:name, phoneNum, organ, nil];
    [items addObject:group2];
    
    
    BaseTableModelItem *lastTime = [BaseTableModelItem createWithTitle:@"上次登录时间" subTitle:[loginDict objectForKey:@"loginDate"]];
    lastTime.accessoryType = UITableViewCellAccessoryNone;
    BaseTableModelGroup *group3 = [[BaseTableModelGroup alloc] initWithHeaderTitle:nil footerTitle:nil settingItems:lastTime, nil];
    [items addObject:group3];
    
    BaseTableModelItem *exit = [BaseTableModelItem createWithTitle:@"退出登录"];
    exit.alignment = BaseTableModelItemAlignmentMiddle;
    exit.titleColor = DEFAULT_RED_COLOR;
    
    BaseTableModelGroup *group4 = [[BaseTableModelGroup alloc] initWithHeaderTitle:nil footerTitle:nil settingItems:exit, nil];
    [items addObject:group4];
    
    return items;
    
}

#pragma mark - 用户注销方法
- (void)accountLogout:(void (^)(void))success failed:(void (^)(NSString *))failed {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:@"app" forKey:@"loginType"];
    
    NSDictionary *userDict = [[NSUserDefaults standardUserDefaults] objectForKey:LOGIN_SUCCESS];
    [dict setObject:[userDict objectForKey:@"userCode"] forKey:@"userCode"];
    
    [YZNetworkingManager POST:@"account/loginout" parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        // 获取请求状态值
        if(IS_SUCCESS){
            // 删除用户登录信息
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:LOGIN_SUCCESS];
            // 清理缓存
            [[SDImageCache sharedImageCache] clearDiskOnCompletion:nil];
            [[SDImageCache sharedImageCache] clearMemory];
            // 清空Cookie
            NSHTTPCookieStorage * loginCookie = [NSHTTPCookieStorage sharedHTTPCookieStorage];
            for (NSHTTPCookie * cookie in [loginCookie cookies]){
                [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
            }
            // 删除沙盒自动生成的Cookies.binarycookies文件
            NSString * path = NSHomeDirectory();
            NSString * filePath = [path stringByAppendingPathComponent:@"/Library/Cookies/Cookies.binarycookies"];
            NSFileManager * manager = [NSFileManager defaultManager];
            [manager removeItemAtPath:filePath error:nil];
            
            success();
        }else{
            failed([responseObject objectForKey:@"msg"]);
        }
    } failure:^(NSURLSessionDataTask *task, NSString *error) {
        failed(error);
    }];

}

@end

