/************************************************************
 Class    : GestureViewController.h
 Describe : 手势密码视图
 Company  : Prient
 Author   : Yanzheng 严正
 Date     : 2017-11-20
 Version  : 1.0
 Declare  : Copyright © 2017 Yanzheng. All rights reserved.
 ************************************************************/

#import <UIKit/UIKit.h>

typedef enum{
    GestureViewControllerTypeSetting = 1,
    GestureViewControllerTypeLogin
}GestureViewControllerType;

typedef enum{
    buttonTagReset = 1,
    buttonTagManager,
    buttonTagForget
    
}buttonTag;

@interface GestureViewController : UIViewController

/**
 *  控制器来源类型
 */
@property (nonatomic, assign) GestureViewControllerType type;

@end
