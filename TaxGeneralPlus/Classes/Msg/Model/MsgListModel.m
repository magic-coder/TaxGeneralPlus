//
//  MsgListModel.m
//  TaxGeneralPlus
//
//  Created by Apple on 2017/11/24.
//  Copyright © 2017年 prient. All rights reserved.
//

#import "MsgListModel.h"

@implementation MsgListModel

+ (MsgListModel *)createWithJSON:(id)json {
    MsgListModel *model = [super yy_modelWithJSON:json];
    return model;
}

+ (MsgListModel *)createDictionary:(NSDictionary *)dictionary {
    MsgListModel *model = [super yy_modelWithDictionary:dictionary];
    return model;
}

@end
