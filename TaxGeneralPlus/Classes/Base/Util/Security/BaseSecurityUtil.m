//
//  BaseSecurityUtil.m
//  TaxGeneralPlus
//
//  Created by Apple on 2017/12/26.
//  Copyright © 2017年 prient. All rights reserved.
//

#import "BaseSecurityUtil.h"
#import "AES.h"

#define Secret_Key  @"https://github.com/micyo202"

@implementation BaseSecurityUtil

SingletonM(BaseSecurityUtil)

- (NSString *)encryptStr:(NSString *)str {
    return [AES encrypt:str password:Secret_Key];
}

- (NSString *)decryptStr:(NSString *)str {
    return [AES decrypt:str password:Secret_Key];
}

@end
