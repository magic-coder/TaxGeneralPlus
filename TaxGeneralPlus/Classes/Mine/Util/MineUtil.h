/************************************************************
 Class    : MineUtil.h
 Describe : 我的模块处理工具类
 Company  : Prient
 Author   : Yanzheng 严正
 Date     : 2017-11-07
 Version  : 1.0
 Declare  : Copyright © 2017 Yanzheng. All rights reserved.
 ************************************************************/

#import <Foundation/Foundation.h>

@interface MineUtil : NSObject

SingletonH(MineUtil)

- (NSMutableArray *)loadMineData;

- (NSMutableArray *)accountData;

- (void)accountLogout:(void (^)(void))success failed:(void (^)(NSString *error))failed;

@end
