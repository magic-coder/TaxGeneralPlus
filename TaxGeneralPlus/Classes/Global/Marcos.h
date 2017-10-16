//
//  Marcos.h
//  TaxGeneralPlus
//
//  Created by Apple on 2017/10/13.
//  Copyright © 2017年 prient. All rights reserved.
//

#ifndef Marcos_h
#define Marcos_h


#define APPDELEGETE         ((AppDelegate*)[[UIApplication sharedApplication] delegate])
#define WBColor(r, g, b, a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:a]

#pragma mark - Frame
#define FRAME_SCREEN    [[UIScreen mainScreen] bounds]                                      // 主屏幕Frame
#define WIDTH_SCREEN    [[UIScreen mainScreen] bounds].size.width                           // 主屏幕Width
#define HEIGHT_SCREEN   [[UIScreen mainScreen] bounds].size.height                          // 主屏幕Height
//#define HEIGHT_STATUS   [[UIApplication sharedApplication] statusBarFrame].size.height    // 状态栏高度(20)
#define HEIGHT_STATUS   20                                                                  // 状态栏高度(20)
#define HEIGHT_NAVBAR   44                                                                  // NavBar高度(44)
#define HEIGHT_TABBAR   49                                                                  // TabBar高度(49)


#endif /* Marcos_h */
