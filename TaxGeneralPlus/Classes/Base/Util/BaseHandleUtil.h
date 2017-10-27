/************************************************************
 Class    : BaseHandleUtil.h
 Describe : 基本的通用工具类
 Company  : Prient
 Author   : Yanzheng 严正
 Date     : 2017-10-25
 Version  : 1.0
 Declare  : Copyright © 2017 Yanzheng. All rights reserved.
 ************************************************************/

#import <Foundation/Foundation.h>

@interface BaseHandleUtil : NSObject

// 单例模式方法
SingletonH(BaseHandleUtil)

// 获取当前展示的视图控制器ViewController
- (UIViewController *)topViewController;

// 将JSONData解析为对象，返回NSArray或NSDictionary
- (id)objectWithJSONData:(id)data;

// 将对象解析为NSString
- (NSString *)JSONStringWithObject:(id)object;

// 读取JSON文件内容（返回NSArray或NSDictionary）
- (id)readWithJSONFile:(NSString *)file;

/**
 *  计算文本所需的宽高
 *
 *  @param  str      需要计算的文本
 *  @param  font     文本显示的字体
 *  @param  maxSize  文本显示的范围
 *
 *  @return 文本实际所需的高度
 */
- (CGSize)sizeWithString:(NSString *)str font:(UIFont *)font maxSize:(CGSize)maxSize;

@end
