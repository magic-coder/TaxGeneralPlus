//
//  MsgDetailModel.m
//  TaxGeneralPlus
//
//  Created by Apple on 2017/11/24.
//  Copyright © 2017年 prient. All rights reserved.
//

#import "MsgDetailModel.h"

@implementation MsgDetailModel

+ (MsgDetailModel *)createWithJSON:(id)json {
    MsgDetailModel *model = [MsgDetailModel yy_modelWithJSON:json];
    return model;
}

+ (MsgDetailModel *)createDictionary:(NSDictionary *)dictionary {
    MsgDetailModel *model = [MsgDetailModel yy_modelWithDictionary:dictionary];
    return model;
}

@end
