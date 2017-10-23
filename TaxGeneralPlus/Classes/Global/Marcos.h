/************************************************************
 Class    : Marcos.h
 Describe : 全局通用的宏定义
 Company  : Prient
 Author   : Yanzheng 严正
 Date     : 2017-10-10
 Version  : 1.0
 Declare  : Copyright © 2017 Yanzheng. All rights reserved.
 ************************************************************/

#ifndef Marcos_h
#define Marcos_h


#define APPDELEGETE         ((AppDelegate*)[[UIApplication sharedApplication] delegate])
#define WINDOW              [[UIApplication sharedApplication] keyWindow]
#define WBColor(r, g, b, a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:a]

#pragma mark - 设置调试日志输出Log
#ifdef DEBUG
// 在控制台输出Log日志
#define DLog(FORMAT, ...) NSLog((@"Yan输出[Debug Log] -> %s [Line %d] " FORMAT), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define DLog(...)
#endif

#pragma mark - 框架Frame所需基本宏
#define FRAME_SCREEN    [[UIScreen mainScreen] bounds]                                      // 主屏幕Frame
#define WIDTH_SCREEN    [[UIScreen mainScreen] bounds].size.width                           // 主屏幕Width
#define HEIGHT_SCREEN   [[UIScreen mainScreen] bounds].size.height                          // 主屏幕Height
#define HEIGHT_STATUS   [[UIApplication sharedApplication] statusBarFrame].size.height      // 状态栏高度(20/44)
#define HEIGHT_NAVBAR   44                                                                  // NavBar高度(44)
#define HEIGHT_TABBAR   49                                                                  // TabBar高度(49)[34]

#pragma mark - 自定义系统颜色Color
//#define     DEFAULT_NAVBAR_COLOR            WBColor(36.0, 105.0, 211.0, 0.9f)
#define     DEFAULT_BACKGROUND_COLOR        WBColor(239.0, 239.0, 244.0, 1.0f)
#define     DEFAULT_RED_COLOR               WBColor(230.0, 66.0, 66.0, 1.0f)
#define     DEFAULT_BLUE_COLOR              WBColor(69.0, 126.0, 212.0, 1.0f)
#define     DEFAULT_LIGHT_BLUE_COLOR        WBColor(152.0, 189.0, 233.0, 1.0f)
#define     DEFAULT_LINE_GRAY_COLOR         WBColor(188.0, 188.0, 188.0, 0.6f)
#define     DEFAULT_TABBAR_TINTCOLOR        WBColor(0.0, 190.0, 12.0, 1.0f)
#define     DEFAULT_SELECTED_GRAY_COLOR     WBColor(217.0, 217.0, 217.0, 1.0f)

#pragma mark - 设置服务器地址Service Url
#define SERVER_URL      @"https://10.100.16.133:8443/mobiletax/"     // 生产https VPN服务器地址


#endif /* Marcos_h */
