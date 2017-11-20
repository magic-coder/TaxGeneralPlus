//
//  BaseSettingUtil.m
//  TaxGeneralPlus
//
//  Created by Apple on 2017/11/8.
//  Copyright © 2017年 prient. All rights reserved.
//

#import "BaseSettingUtil.h"

@implementation BaseSettingUtil

SingletonM(BaseSettingUtil)

- (void)initSettingData{
    NSMutableDictionary *settingDict = [[BaseSandBoxUtil sharedBaseSandBoxUtil] loadDataWithFileName:SETTING_FILE];
    
    // 初始化配置信息，包括手势密码、指纹、通知(声音、震动)、系统音效、检测更新、夜间模式
    if(settingDict == nil){
        NSNumber *open = [NSNumber numberWithBool:YES];
        NSNumber *close = [NSNumber numberWithBool:NO];
        // 初始化默认值的设置数据
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:close, @"gesturePwd", close, @"touchID", open, @"voice", open, @"shake", open, @"sysVoice", close, @"nightShift", nil];
        [[BaseSandBoxUtil sharedBaseSandBoxUtil] writeData:dict fileName:SETTING_FILE];
    }
}

- (NSMutableDictionary *)loadSettingData{
    return [[BaseSandBoxUtil sharedBaseSandBoxUtil] loadDataWithFileName:SETTING_FILE];
}

-(BOOL)writeSettingData:(NSMutableDictionary *)data{
    return [[BaseSandBoxUtil sharedBaseSandBoxUtil] writeData:data fileName:SETTING_FILE];
}

-(void)removeSettingData{
    [[BaseSandBoxUtil sharedBaseSandBoxUtil] removeFileName:SETTING_FILE];
}

@end
