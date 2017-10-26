/************************************************************
 Class    : UINavigationBar+YZ.h
 Describe : 自定义UINavigationBar的扩展类
 Company  : Prient
 Author   : Yanzheng 严正
 Date     : 2017-10-26
 Version  : 1.0
 Declare  : Copyright © 2017 Yanzheng. All rights reserved.
 ************************************************************/

#import <UIKit/UIKit.h>

@interface UINavigationBar (YZ)

- (void)lt_setBackgroundColor:(UIColor *)backgroundColor;
- (void)lt_setElementsAlpha:(CGFloat)alpha;
- (void)lt_setTranslationY:(CGFloat)translationY;
- (void)lt_reset;

@end
