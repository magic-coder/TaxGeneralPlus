/************************************************************
 Class    : NewsModel.m
 Describe : 首页新闻展示数据模型
 Company  : Prient
 Author   : Yanzheng 严正
 Date     : 2017-10-26
 Version  : 1.0
 Declare  : Copyright © 2017 Yanzheng. All rights reserved.
 ************************************************************/

#import "NewsModel.h"

@implementation NewsModel

+ (instancetype)yy_modelWithJSON:(id)json {
    NewsModel *model = [super yy_modelWithJSON:json];
    
    switch (model.images.count) {
        case 0:
            model.style = NewsModelStyleText;
            break;
        case 1:
            model.style = NewsModelStyleFewImage;
            break;
        case 2:
            model.style = NewsModelStyleFewImage;
            break;
        default:
            model.style = NewsModelStyleMoreImage;
            break;
    }
    
    return model;
}

+ (instancetype)yy_modelWithDictionary:(NSDictionary *)dictionary {
    NewsModel *model = [super yy_modelWithDictionary:dictionary];
    
    switch (model.images.count) {
        case 0:
            model.style = NewsModelStyleText;
            break;
        case 1:
            model.style = NewsModelStyleOneImage;
            break;
        case 2:
            model.style = NewsModelStyleFewImage;
            break;
        default:
            model.style = NewsModelStyleMoreImage;
            break;
    }
    
    return model;
}

@end
