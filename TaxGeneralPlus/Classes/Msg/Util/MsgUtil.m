/************************************************************
 Class    : MsgUtil.m
 Describe : 消息列表工具类
 Company  : Prient
 Author   : Yanzheng 严正
 Date     : 2017-11-27
 Version  : 1.0
 Declare  : Copyright © 2017 Yanzheng. All rights reserved.
 ************************************************************/

#import "MsgUtil.h"

@implementation MsgUtil

SingletonM(MsgUtil)

- (void)msgUnReadCountSuccess:(void (^)(int))success{
    [YZNetworkingManager POST:@"message/getUnreadCount" parameters:nil success:^(id responseObject) {
        NSDictionary *businessData = [responseObject objectForKey:@"businessData"];
        int unReadCount = [[businessData objectForKey:@"unReadCount"] intValue];
        success(unReadCount);
    } failure:^(NSString *error) {
        success(0);
    } invalid:^(NSString *msg) {
        success(0);
    }];
    
}

- (NSDictionary *)loadMsgFile {
    return [[BaseSandBoxUtil sharedBaseSandBoxUtil] loadDataWithFileName:MSG_FILE];
}

- (void)loadMsgListPageNo:(int)pageNo pageSize:(int)pageSize
                  success:(void (^)(NSDictionary *))success
                  failure:(void (^)(NSString *))failure
                  invalid:(void (^)(NSString *))invalid{
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:[NSNumber numberWithInt:pageNo] forKey:@"pageNo"];
    [dict setObject:[NSNumber numberWithInt:pageSize] forKey:@"pageSize"];
    
    [YZNetworkingManager POST:@"message/getMsgList" parameters:dict success:^(id responseObject) {
        NSDictionary *businessData = [responseObject objectForKey:@"businessData"];
        NSArray *results = [businessData objectForKey:@"results"];
        if(results.count <= 0){
            [[BaseSandBoxUtil sharedBaseSandBoxUtil] removeFileName:MSG_FILE];// 删除本地 msg 数据信息
        }
        NSDictionary *resDict = @{@"results" : results};
        [[BaseSandBoxUtil sharedBaseSandBoxUtil] writeData:resDict fileName:MSG_FILE];// 写入本地缓存 SandBox
        
        success(resDict);
    } failure:^(NSString *error) {
        failure(error);
    } invalid:^(NSString *msg) {
        invalid(msg);
    }];
}

- (void)deleteMsgListSourceCode:(NSString *)sourceCode pushOrgCode:(NSString *)pushOrgCode
                        success:(void (^)(void))success
                        failure:(void (^)(NSString *))failure
                        invalid:(void (^)(NSString *))invalid {
}

@end
