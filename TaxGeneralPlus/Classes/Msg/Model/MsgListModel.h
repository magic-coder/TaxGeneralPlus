//
//  MsgListModel.h
//  TaxGeneralPlus
//
//  Created by Apple on 2017/11/24.
//  Copyright © 2017年 prient. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MsgListModel : NSObject

/************************ 属性 ************************/
@property (nonatomic, strong) NSString *sourceCode;     // 来源代码
@property (nonatomic, strong) NSString *pushOrgCode;    // 推送机构代码
@property (nonatomic, strong) NSString *avatar;         // 头像
@property (nonatomic, strong) NSString *name;           // 名称
@property (nonatomic, strong) NSString *message;        // 消息
@property (nonatomic, strong) NSString *date;           // 时间
@property (nonatomic, strong) NSString *unReadCount;    // 未读条数

/************************ 类方法 ************************/
+ (MsgListModel *)createWithJSON:(id)json;
+ (MsgListModel *)createDictionary:(NSDictionary *)dictionary;

@end
