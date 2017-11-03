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

#pragma mark - 获取当前最顶端展示的视图控制器
#pragma mark 获取当前显示的视图（主方法）
- (UIViewController *)topViewController {
    UIViewController *resultVC;
    resultVC = [self _topViewController:[WINDOW rootViewController]];
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

#pragma mark - 读取程序中的JSON文件数据转换为OC对象
- (id)readWithJSONFile:(NSString *)file {
    
    NSString *fileName = [file stringByDeletingPathExtension];
    NSString *fileType = [file pathExtension];
    
    // JSON文件的路径
    NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:fileType];
    // 读取JSON文件
    NSData *data = [NSData dataWithContentsOfFile:path];
    // 将JSON数据转为NSArray或NSDictionary（调用本类中已经写好的方法）
    id object = [self objectWithJSONData:data];
    return object;
}

#pragma mark - 将JSON转换为OC对象
- (id)objectWithJSONData:(id)data {
    // 将JSON数据转为NSArray或NSDictionary
    id object = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    return object;
}

#pragma mark - 将OC对象转换为JSON字符串
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

#pragma mark - 计算文本所需的宽高
- (CGSize)sizeWithString:(NSString *)str font:(UIFont *)font maxSize:(CGSize)maxSize {
    NSDictionary *dict = @{NSFontAttributeName : font};
    // 如果将来计算的文字的范围超出了指定的范围,返回的就是指定的范围
    // 如果将来计算的文字的范围小于指定的范围, 返回的就是真实的范围
    CGSize size = [str boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    return size;
}

@end
