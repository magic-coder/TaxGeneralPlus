//
//  UIColor+YZ.h
//  TaxGeneralPlus
//
//  Created by Apple on 2017/10/24.
//  Copyright © 2017年 prient. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (YZ)

// 根据16进制颜色代码生成颜色
+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;

@end
