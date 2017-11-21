/************************************************************
 Class    : YZNetworkingManager.m
 Describe : 自己封装的AFN，包含单向自签名https请求
 Company  : Prient
 Author   : Yanzheng
 Date     : 2017-10-31
 Version  : 1.0
 Declare  : Copyright © 2017 Yanzheng. All rights reserved.
 ************************************************************/

#import "YZNetworkingManager.h"

@implementation YZNetworkingManager

+ (AFHTTPSessionManager *)sessionManager {
    static dispatch_once_t onceToken;
    static AFHTTPSessionManager *_manager = nil;
    dispatch_once(&onceToken, ^{
        _manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:SERVER_URL]];
        
        /// 注意将你的证书加入项目，并把下面名称改为自己证书的名称
        NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"root-cert" ofType:@"der"];
        NSData *caCertData = [NSData dataWithContentsOfFile:cerPath];
        
        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate withPinnedCertificates:[NSSet setWithObject:caCertData]];
        
        /// 是否允许使用自签名证书
        securityPolicy.allowInvalidCertificates = YES;
        /// 是否需要验证域名
        securityPolicy.validatesDomainName = NO;
        
        _manager.securityPolicy = securityPolicy;
        
        // 声明返回的结果类型
        // 不加上这句话，会报“Request failed: unacceptable content-type: text/plain”错误，因为我们要获取text/plain类型数据
        //_manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        // 如果报接受类型不一致请替换一致text/html  或者 text/plain
        //_manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil];
        //[_manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        
        // 请求超时，时间设置
        _manager.requestSerializer.timeoutInterval = 20.0;
        
        /// 关闭缓存避免干扰测试
        _manager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
        
        /// 客户端请求验证 重写 setSessionDidReceiveAuthenticationChallengeBlock 方法
        [_manager setSessionDidReceiveAuthenticationChallengeBlock:^NSURLSessionAuthChallengeDisposition(NSURLSession * _Nonnull session, NSURLAuthenticationChallenge * _Nonnull challenge, NSURLCredential *__autoreleasing *_credential) {
            
            /// 获取服务器的trust object
            SecTrustRef serverTrust = [[challenge protectionSpace] serverTrust];
            SecCertificateRef caRef = SecCertificateCreateWithData(NULL, (__bridge CFDataRef)caCertData);
            NSCAssert(caRef != nil, @"caRef is nil");
            
            NSArray *caArray = @[(__bridge id)(caRef)];
            NSCAssert(caArray != nil, @"caArray is nil");
            
            /// 将读取到的证书设置为serverTrust的根证书
            OSStatus status = SecTrustSetAnchorCertificates(serverTrust, (__bridge CFArrayRef)caArray);
            SecTrustSetAnchorCertificatesOnly(serverTrust,NO);
            NSCAssert(errSecSuccess == status, @"SecTrustSetAnchorCertificates failed");
            
            /// 选择质询认证的处理方式
            NSURLSessionAuthChallengeDisposition disposition = NSURLSessionAuthChallengePerformDefaultHandling;
            __autoreleasing NSURLCredential *credential = nil;
            
            /// NSURLAuthenticationMethodServerTrust质询认证方式
            if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
                
                /// 基于客户端的安全策略来决定是否信任该服务器，不信任则不响应质询。
                if ([_manager.securityPolicy evaluateServerTrust:challenge.protectionSpace.serverTrust forDomain:challenge.protectionSpace.host]) {
                    
                    /// 创建质询证书
                    credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
                    /// 确认质询方式
                    if (credential) {
                        disposition = NSURLSessionAuthChallengeUseCredential;
                    } else {
                        disposition = NSURLSessionAuthChallengePerformDefaultHandling;
                    }
                } else {
                    /// 取消挑战
                    disposition = NSURLSessionAuthChallengeCancelAuthenticationChallenge;
                }
                
            } else {
                disposition = NSURLSessionAuthChallengePerformDefaultHandling;
            }
            
            return disposition;
        }];
        
    });
    return _manager;
}

+ (void)POST:(NSString *)URLString
  parameters:(id)parameters
     success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
     failure:(void (^)(NSURLSessionDataTask *task, NSString *error))failure {
    
    // 格式化url、请求参数
    NSString *url = [NSString stringWithFormat:@"%@%@", SERVER_URL, URLString];
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:[[BaseHandleUtil sharedBaseHandleUtil] JSONStringWithObject:parameters], @"msg", nil];
    
    [[[self class] sessionManager] POST:url parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(task, responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(task, [self stringWithError:error]);
        }
    }];
}

+ (void)GET:(NSString *)URLString
 parameters:(id)parameters
    success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
    failure:(void (^)(NSURLSessionDataTask *task, NSString *error))failure {
    
    // 格式化url、请求参数
    NSString *url = [NSString stringWithFormat:@"%@%@", SERVER_URL, URLString];
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:[[BaseHandleUtil sharedBaseHandleUtil] JSONStringWithObject:parameters], @"msg", nil];
    
    [[[self class] sessionManager] GET:url parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(task, responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(task, [self stringWithError:error]);
        }
    }];
}

/**
 * @brief 把错误信息转换成文字描述
 * @param error 错误信息
 * @return 返回字符串
 */
+ (NSString *)stringWithError:(NSError *)error{
    
    DLog("错误提示信息：%@", error.description);
    
    switch (error.code) {
        case NSURLErrorTimedOut:
            return @"访问服务器超时，请检查网络！";
            break;
        case NSURLErrorUnsupportedURL:
            return @"无效的访问地址，请联系管理员！";
            break;
        case NSURLErrorNotConnectedToInternet:
            return @"网络连接失败，请检查网络！";
            break;
        case NSURLErrorBadServerResponse:
            return @"404错误，请稍后再试！";
            break;
        default:
            return @"未知错误异常，请稍后再试！";
            break;
    }
}

@end
