# TaxGeneralPlus（税务通+）IOS移动端项目重构版

### 一、简介

项目Devices采用Universal，同时支持**iPhone & iPad**，技术重新选型，UI渲染更细腻，代码清晰简洁，兼容IOS11，适配iPhoneX，便于后期维护<br>
主界面框架模式采用目前主流的**UINavigationController**与**UITabBarController**整合模式（既：导航控制器与选项卡整合模式）
整屏切换效果，集成了全新的动画效果，视觉感强烈。

### 二、开发环境

* MacOS High Sierra
* IOS10+
* Xcode 9.0+

### 三、项目结构

```lua
TaxGeneralPlus -- 根目录
├── Classes -- 类路径
|    ├── News -- 首页税闻模块
|    ├── App -- 应用模块
|    ├── Map -- 地图模块
|    ├── Msg -- 消息模块
|    ├── Mine -- 我的模块
|    ├── Login -- 登录模块
|    ├── Base -- 基础模块
|    ├── Main -- 主视图模块
|    ├── Gesture -- 手势密码
|    ├── TouchID -- TouchID/FaceID解锁识别模块
|    ├── Custom -- 自定义类
|    ├── Global -- 全局类
├── Expands -- 扩展路径
├── Plugins -- 插件路径
├── Resources -- 资源文件
├── Supporting Files -- 支持文件
```
### 一、其他
##### 1.系统使用的色彩值
* 红 #E8453C RGB(232,69,60)
* 橙 #F6BC2D RGB(246,188,45)
* 蓝 #4587F7 RGB(69,135,247)
* 绿 #3AA756 RGB(58,167,86)

##### 2.自己扩展的类库

* YZTouchID
* YZCycleScrollView
* YZBottomSelectView

##### 3.使用到的第三方库

* Masonry
* YYModel
* MJRefresh
* SDWebImage
* AFNetworking
* YBPopupMenu
* MBProgressHUD
* PCGestureUnlock
* TTTAttributedLabel
* UIAlertControllerBlocks
* YALSunnyRefreshControll