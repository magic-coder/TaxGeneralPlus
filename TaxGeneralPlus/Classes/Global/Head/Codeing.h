/************************************************************
 Class    : Codeing.h
 Describe : 常用代码片段宏定义，便于程序使用
 Company  : Prient
 Author   : Yanzheng 严正
 Date     : 2017-11-28
 Version  : 1.0
 Declare  : Copyright © 2017 Yanzheng. All rights reserved.
 ************************************************************/

#ifndef Codeing_h
#define Codeing_h

#ifdef  DEBUG
// 在控制台输出Log日志
#define DLog(FORMAT, ...) NSLog((@"Yan输出[Debug Log]%s [Line %d] " FORMAT), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define DLog(...)
#endif

#define APPDELEGETE             [[UIApplication sharedApplication] delegate]
#define WINDOW                  [[UIApplication sharedApplication] keyWindow]
#define PLACEHOLDER_IMAGE       [UIImage imageNamed:@"common_placeholder"]
#define IS_LOGIN                (nil != [[NSUserDefaults standardUserDefaults] objectForKey:LOGIN_SUCCESS])
#define SHOW_LOGIN_VIEW         [self presentViewController:[[NSClassFromString(@"LoginViewController") class] new] animated:YES completion:nil];
#define SHOW_RELOGIN_VIEW \
\
[UIAlertController showAlertInViewController:self withTitle:@"提示" message:msg cancelButtonTitle:@"重新登录" destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) { \
[MBProgressHUD showHUDView:self.view text:@"注销中..." progressHUDMode:YZProgressHUDModeLock]; \
[[LoginUtil sharedLoginUtil] logout:^{ \
[MBProgressHUD hiddenHUDView:self.view]; \
SHOW_LOGIN_VIEW \
} failure:^(NSString *error) { \
[MBProgressHUD hiddenHUDView:self.view]; \
[MBProgressHUD showHUDView:self.view text:error progressHUDMode:YZProgressHUDModeShow]; \
}]; \
}]; \

#pragma mark - 防止重复点击（间隔1秒）
#define CLICK_LOCK \
\
sender.enabled = NO; \
dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ \
sender.enabled = YES; \
}); \

#endif /* Codeing_h */
