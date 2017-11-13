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

/**
 *  获取当前设备的基本信息
 */
- (void)currentDeviceInfo;

/**
 *  获取当前最顶端展示的视图控制器
 *
 *  @return 正在显示的视图控制器ViewController
 */
- (UIViewController *)topViewController;

/**
 *  读取程序中的JSON文件数据转换为OC对象
 *
 *  @param  file    程序中JSON文件名称
 *
 *  @return OC对象（NSArray、NSDictionary）
 */
- (id)readWithJSONFile:(NSString *)file;

/**
 *  将JSON转换为OC对象
 *
 *  @param  data    需要转换的JSONData数据
 *
 *  @return OC对象（NSArray、NSDictionary）
 */
- (id)objectWithJSONData:(NSData *)data;

/**
 *  将OC对象转换为JSON
 *
 *  @param  object  需要转换的对象（NSArray、NSDictionary）
 *
 *  @return NSString类型的JSON字符串
 */
- (NSString *)JSONStringWithObject:(id)object;

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
