//
//  BaseSettingUtil.h
//  TaxGeneralPlus
//
//  Created by Apple on 2017/11/8.
//  Copyright © 2017年 prient. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseSettingUtil : NSObject

SingletonH(BaseSettingUtil)

- (void)initSettingData;// 初始化setting设置信息

- (NSMutableDictionary *)loadSettingData;// 读取已有的设置数据

- (BOOL)writeSettingData:(NSMutableDictionary *)data;// 写入设置数据

- (void)removeSettingData;// 清空设置

@end
