//
//  BaseSecurityUtil.h
//  TaxGeneralPlus
//
//  Created by Apple on 2017/12/26.
//  Copyright © 2017年 prient. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseSecurityUtil : NSObject

SingletonH(BaseSecurityUtil)

- (NSString *)encryptStr:(NSString *)str;

- (NSString *)decryptStr:(NSString *)str;

@end
