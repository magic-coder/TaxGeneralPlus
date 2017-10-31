/************************************************************
 Class    : AppGroupView.h
 Describe : 自定义应用列表分组栏视图
 Company  : Prient
 Author   : Yanzheng 严正
 Date     : 2017-10-31
 Version  : 1.0
 Declare  : Copyright © 2017 Yanzheng. All rights reserved.
 ************************************************************/

#import <UIKit/UIKit.h>

@interface AppGroupView : UIView

@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) BOOL top;// 是否第一个组，如果是顶部部生成线

@end
