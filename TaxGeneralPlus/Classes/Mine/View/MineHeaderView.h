/************************************************************
 Class    : MineHeaderView.h
 Describe : 我的界面顶部头视图展示基本信息
 Company  : Prient
 Author   : Yanzheng 严正
 Date     : 2017-11-08
 Version  : 1.0
 Declare  : Copyright © 2017 Yanzheng. All rights reserved.
 ************************************************************/

#import <UIKit/UIKit.h>

// 设置accountHeaderView点击的代理方法
@protocol MineHeaderViewDelegate <NSObject>

@optional
- (void)mineHeaderViewBtnDidSelected:(UIButton *)sender;

@end

@interface MineHeaderView : UIView

@property (nonatomic, strong) UIImageView *imageView;           // 背景图
@property (nonatomic, strong) UIImageView *accountImageView;    // 用户头像视图
@property (nonatomic, strong) UIButton *nightShiftBtn;          // 夜间模式按钮
@property (nonatomic, strong) UIButton *accountBtn;             // 用户信息按钮
@property (nonatomic, strong) UILabel *levelLabel;              // 用户等级
@property (nonatomic, strong) UILabel *nameLabel;               // 用户名称
@property (nonatomic, strong) UILabel *orgNameLabel;            // 机构名称

@property (nonatomic, strong) UIView *bottomView;               // 底部操作视图

@property (nonatomic, strong) UIImageView *leftImageView;       // 左边图标视图
@property (nonatomic, strong) UIImageView *middleImageView;     // 中间图标视图
@property (nonatomic, strong) UIImageView *rightImageView;      // 右边图标视图

@property (nonatomic, strong) UILabel *leftTitleLabel;          // 左侧标签
@property (nonatomic, strong) UILabel *middleTitleLabel;        // 中间标签
@property (nonatomic, strong) UILabel *rightTitleLabel;         // 右侧标签

@property (nonatomic, strong) UIButton *leftBtn;                // 左边按钮
@property (nonatomic, strong) UIButton *middleBtn;              // 中间按钮
@property (nonatomic, strong) UIButton *rightBtn;               // 右边按钮

@property (nonatomic, strong) UIView *firstLineView;            // 第一条竖线
@property (nonatomic, strong) UIView *secondLineView;           // 第二条竖线

@property (nonatomic, strong) NSString *nameText;               // 名字

@property (nonatomic, weak) id<MineHeaderViewDelegate> delegate;

@end
