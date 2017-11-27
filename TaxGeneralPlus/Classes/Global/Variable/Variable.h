//
//  Variable.h
//  TaxGeneralPlus
//
//  Created by Apple on 2017/11/15.
//  Copyright © 2017年 prient. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Variable : NSObject

SingletonH(Variable)

@property (nonatomic, strong) NSString *appName;            // 应用名称
@property (nonatomic, strong) NSString *appVersion;         // 应用版本号
@property (nonatomic, strong) NSString *buildVersion;       // 编译版本号

@property (nonatomic, assign) int unReadCount;              // 未读消息条数
@property (nonatomic, assign) BOOL vpnSuccess;              // VPN是否陈成功

@end
