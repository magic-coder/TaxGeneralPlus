/************************************************************
 Class    : MineHeaderView.h
 Describe : 我的界面顶部头视图展示基本信息
 Company  : Prient
 Author   : Yanzheng
 Date     : 2017-11-08
 Version  : 1.0
 Declare  : Copyright © 2017 Yanzheng. All rights reserved.
 ************************************************************/

#import <UIKit/UIKit.h>

// 设置accountHeaderView点击的代理方法
@protocol MineHeaderViewDelegate <NSObject>

@optional
- (void)mineHeaderViewDidSelected;

@end

@interface MineHeaderView : UIView

@property (nonatomic, strong) UIImageView *imageView;           // 背景图
@property (nonatomic, strong) UIImageView *accountImageView;    // 用户头像视图
@property (nonatomic, strong) UIButton *nightBtn;               // 夜间模式按钮
@property (nonatomic, strong) UIButton *accountBtn;             // 用户信息按钮
@property (nonatomic, strong) UILabel *levelLabel;              // 用户等级
@property (nonatomic, strong) UILabel *nameLabel;             // 用户名称
@property (nonatomic, strong) UILabel *orgNameLabel;            // 机构名称

@property (nonatomic, strong) NSString *nameText;

@property (nonatomic, weak) id<MineHeaderViewDelegate> delegate;

@end
