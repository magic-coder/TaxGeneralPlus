/************************************************************
 Class    : Log.h
 Describe : 设置调试日志Log的输出
 Company  : Prient
 Author   : Yanzheng 严正
 Date     : 2017-10-25
 Version  : 1.0
 Declare  : Copyright © 2017 Yanzheng. All rights reserved.
 ************************************************************/

#ifndef Log_h
#define Log_h


#ifdef  DEBUG
// 在控制台输出Log日志
#define DLog(FORMAT, ...) NSLog((@"Yan输出[Debug Log]%s [Line %d] " FORMAT), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define DLog(...)
#endif


#endif /* Log_h */
