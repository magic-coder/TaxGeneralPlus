//
//  MineUtil.m
//  TaxGeneralPlus
//
//  Created by Apple on 2017/11/7.
//  Copyright © 2017年 prient. All rights reserved.
//

#import "MineUtil.h"
#import "BaseTableModel.h"

@implementation MineUtil

SingletonM(MineUtil)

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

@end
