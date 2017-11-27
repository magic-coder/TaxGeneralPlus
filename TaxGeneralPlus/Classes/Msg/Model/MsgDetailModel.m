/************************************************************
 Class    : MsgDetailModel.m
 Describe : 消息明细列表数据模型
 Company  : Prient
 Author   : Yanzheng 严正
 Date     : 2017-11-24
 Version  : 1.0
 Declare  : Copyright © 2017 Yanzheng. All rights reserved.
 ************************************************************/

#import "MsgDetailModel.h"

@implementation MsgDetailModel

+ (MsgDetailModel *)createWithJSON:(id)json {
    MsgDetailModel *model = [MsgDetailModel yy_modelWithJSON:json];
    return model;
}

+ (MsgDetailModel *)createWithDictionary:(NSDictionary *)dictionary {
    MsgDetailModel *model = [MsgDetailModel yy_modelWithDictionary:dictionary];
    return model;
}

@end
