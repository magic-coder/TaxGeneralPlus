/************************************************************
 Class    : BaseHandleUtil.m
 Describe : 基本的通用工具类
 Company  : Prient
 Author   : Yanzheng 严正
 Date     : 2017-10-25
 Version  : 1.0
 Declare  : Copyright © 2017 Yanzheng. All rights reserved.
 ************************************************************/

#import "BaseHandleUtil.h"

@implementation BaseHandleUtil

#pragma mark - 单例模式方法
SingletonM(BaseHandleUtil)

#pragma mark - 获取当前展示的视图控制器
#pragma mark 获取当前显示的视图（主方法）
- (UIViewController *)topViewController {
    UIViewController *resultVC;
    resultVC = [self _topViewController:[[UIApplication sharedApplication].keyWindow rootViewController]];
    while (resultVC.presentedViewController) {
        resultVC = [self _topViewController:resultVC.presentedViewController];
    }
    return resultVC;
}

#pragma mark 获取当前展示的视图控制器（递归调用方法）
- (UIViewController *)_topViewController:(UIViewController *)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self _topViewController:[(UINavigationController *)vc topViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self _topViewController:[(UITabBarController *)vc selectedViewController]];
    } else {
        return vc;
    }
    return nil;
}

#pragma mark - 将JSONData解析为对象，返回NSArray或NSDictionary
- (id)objectWithJSONData:(id)data {
    //将JSON数据转为NSArray或NSDictionary
    id object = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    return object;
}

#pragma mark - 将对象解析为NSString
- (NSString *)JSONStringWithObject:(id)object {
    NSString *jsonString = nil;
    NSError *error;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object options:NSJSONWritingPrettyPrinted error:&error];
    if(jsonData){
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }else{
        DLog(@"JSON 转换失败 error : %@",error);
    }
    
    return jsonString;
}

#pragma mark - 读取指定路径下文件的内容
- (NSString *)readWithFile:(NSString *)path {
    NSString *fileName = [path stringByDeletingPathExtension];
    NSString *typeName = [path pathExtension];
    // 文件的路径
    NSString *filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:typeName];
    // 读取对应文件中的数据
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    NSString *content = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return content;
}

#pragma mark - 计算文本所需的宽高
- (CGSize)sizeWithString:(NSString *)str font:(UIFont *)font maxSize:(CGSize)maxSize {
    NSDictionary *dict = @{NSFontAttributeName : font};
    // 如果将来计算的文字的范围超出了指定的范围,返回的就是指定的范围
    // 如果将来计算的文字的范围小于指定的范围, 返回的就是真实的范围
    CGSize size = [str boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    return size;
}

@end
