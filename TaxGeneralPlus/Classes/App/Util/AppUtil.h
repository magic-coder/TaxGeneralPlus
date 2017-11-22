/************************************************************
 Class    : AppUtil.h
 Describe : 应用模块工具类
 Company  : Prient
 Author   : Yanzheng 严正
 Date     : 2017-10-31
 Version  : 1.0
 Declare  : Copyright © 2017 Yanzheng. All rights reserved.
 ************************************************************/

#import <Foundation/Foundation.h>

// 应用列表数据类型
typedef NS_ENUM(NSInteger, AppItemsType){
    AppItemsTypeNone,   // 一般应用列表类型
    AppItemsTypeEdit    // 编辑类型
};

@interface AppUtil : NSObject

SingletonH(AppUtil)

- (NSMutableDictionary *)loadDataWithType:(AppItemsType)type;

- (void)initDataWithType:(AppItemsType)type dataBlock:(void (^)(NSMutableDictionary *dataDict))dataBlock failed:(void(^)(NSString *error))failed;

- (NSMutableArray *)loadSubDataWithPno:(NSString *)pno level:(NSString *)level;

- (NSMutableArray *)loadSearchData;

@end
