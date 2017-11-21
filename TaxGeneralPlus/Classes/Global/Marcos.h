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

#pragma mark - 框架Frame所需基本宏
#define FRAME_SCREEN    [[UIScreen mainScreen] bounds]              // 主屏幕Frame
#define WIDTH_SCREEN    [[UIScreen mainScreen] bounds].size.width   // 主屏幕Width
#define HEIGHT_SCREEN   [[UIScreen mainScreen] bounds].size.height  // 主屏幕Height
#define HEIGHT_STATUS   (DEVICE_SCREEN_INCH_5_8 ? 44 : 20)          // 状态栏高度(20/44)
#define HEIGHT_NAVBAR   44                                          // NavBar高度(44)
#define HEIGHT_TABBAR   49                                          // TabBar高度(49)[iPhoneX底部安全高度34]

#pragma mark - 判断设备屏幕尺寸，返回 YES/NO
#define DEVICE_SCREEN_INCH_3_5  WIDTH_SCREEN == 320 && HEIGHT_SCREEN == 480 // 3.5英寸    320*480 (4、4s)
#define DEVICE_SCREEN_INCH_4_0  WIDTH_SCREEN == 320 && HEIGHT_SCREEN == 568 // 4.0英寸    320*568 (5、5s、5se)
#define DEVICE_SCREEN_INCH_4_7  WIDTH_SCREEN == 375 && HEIGHT_SCREEN == 667 // 4.7英寸    375*667 (6、6s、7、8)
#define DEVICE_SCREEN_INCH_5_5  WIDTH_SCREEN == 414 && HEIGHT_SCREEN == 736 // 5.5英寸    414*736 (6 plus、6s plus、7 plus、8 plus)
#define DEVICE_SCREEN_INCH_5_8  WIDTH_SCREEN == 375 && HEIGHT_SCREEN == 812 // 5.8英寸    375*812 (X)
#define DEVICE_SCREEN_INCH_IPAD WIDTH_SCREEN > 414 && HEIGHT_SCREEN > 812   // iPad 尺寸  7.9英寸/9.7英寸（768*1024）、10.5英寸（834*1112）、12.9英寸（1024*1366）

#pragma mark - 常用方法宏定义
#define RgbColor(r, g, b, a)    [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:a]
#define HexColor(hex, a)        [UIColor colorWithHexString:hex alpha:a]
#define APPDELEGETE             [[UIApplication sharedApplication] delegate]
#define WINDOW                  [[UIApplication sharedApplication] keyWindow]
#define PLACEHOLDER_IMAGE       [UIImage imageNamed:@"common_placeholder"]
#define REQUEST_SUCCESS         [@"00" isEqualToString:[responseObject objectForKey:@"statusCode"]]
#define LOGIN_INVALID           [@"510" isEqualToString:[responseObject objectForKey:@"statusCode"]]
#define RESPONSE_MSG            [responseObject objectForKey:@"msg"]
#define IS_LOGIN                (nil != [[NSUserDefaults standardUserDefaults] objectForKey:LOGIN_SUCCESS])
#define SHOW_LOGIN_VIEW         [self presentViewController:[[NSClassFromString(@"LoginViewController") class] new] animated:YES completion:nil];

#pragma mark - 自定义系统颜色Color
#define DEFAULT_NAVBAR_COLOR            RgbColor(36.0, 105.0, 211.0, 0.9f)
#define DEFAULT_BACKGROUND_COLOR        RgbColor(239.0, 239.0, 244.0, 1.0f)
#define DEFAULT_RED_COLOR               RgbColor(230.0, 66.0, 66.0, 1.0f)
#define DEFAULT_BLUE_COLOR              RgbColor(69.0, 126.0, 212.0, 1.0f)
#define DEFAULT_LIGHT_BLUE_COLOR        RgbColor(152.0, 189.0, 233.0, 1.0f)
#define DEFAULT_LINE_GRAY_COLOR         RgbColor(188.0, 188.0, 188.0, 0.6f)
#define DEFAULT_TABBAR_TINTCOLOR        RgbColor(0.0, 190.0, 12.0, 1.0f)
#define DEFAULT_SELECTED_GRAY_COLOR     RgbColor(217.0, 217.0, 217.0, 1.0f)

#pragma mark - 设置服务器地址Service Url
#define SERVER_URL  @"https://192.168.14.235:8444/mobiletax/"   // 测试 https服务器地址
//#define SERVER_URL  @"https://10.100.16.133:8443/mobiletax/"    // 生产 https VPN 服务器地址

#pragma mark - 定义全局常用key值
#define DEVICE_INFO         @"deviceInfo"
#define LOGIN_SUCCESS       @"loginSuccess"
#define LAST_LOGINCODE      @"lastLoginCode"
#define GESTURES_PASSWORD   @"gesturesPassword"

#pragma mark - 定义设置文件名称
#define SETTING_FILE    @"settingData.plist"


#endif /* Marcos_h */
