/************************************************************
 Class    : YZBottomSelectView.m
 Describe : 自己扩展封装的底部选择框
 Company  : Prient
 Author   : Yanzheng 严正
 Date     : 2017-10-24
 Version  : 1.0
 Declare  : Copyright © 2017 Yanzheng. All rights reserved.
 ************************************************************/

#import "YZBottomSelectView.h"

static const CGFloat kRowHeight = 46.0f;
static const CGFloat kRowLineHeight = 0.5f;
static const CGFloat kSeparatorHeight = 6.0f;
static const CGFloat kTitleFontSize = 13.0f;
static const CGFloat kButtonTitleFontSize = 16.0f;
static const NSTimeInterval kAnimateDuration = 0.5f;

@interface YZBottomSelectView ()

/** block回调 */
@property (copy, nonatomic) YZBottomSelectViewBlock bottomSelectViewBlock;
/** 背景图片 */
@property (strong, nonatomic) UIView *backgroundView;
/** 弹出视图 */
@property (strong, nonatomic) UIView *bottomSelectView;

@end

@implementation YZBottomSelectView

#pragma mark - 初始化创建选择视图
- (instancetype)initWithTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSArray *)otherButtonTitles handler:(YZBottomSelectViewBlock)bottomSelectViewBlock {
    
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.frame = CGRectMake(0, 0, WIDTH_SCREEN, HEIGHT_SCREEN);
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        _bottomSelectViewBlock = bottomSelectViewBlock;
        
        CGFloat bootomSelectViewHeight = 0;
        
        _backgroundView = [[UIView alloc] initWithFrame:self.frame];
        _backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _backgroundView.backgroundColor = RgbColor(0, 0, 0, 0.4f);
        _backgroundView.alpha = 0;
        [self addSubview:_backgroundView];
        
        _bottomSelectView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height, self.frame.size.width, 0)];
        _bottomSelectView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
        _bottomSelectView.backgroundColor = RgbColor(238.0f, 238.0f, 238.0f, 1.0f);
        [self addSubview:_bottomSelectView];
        
        UIImage *normalImage = [UIImage imageWithColor:RgbColor(255.0f, 255.0f, 255.0f, 1.0f)];
        UIImage *highlightedImage = [UIImage imageWithColor:RgbColor(242.0f, 242.0f, 242.0f, 1.0f)];
        
        if (title && title.length > 0) {
            bootomSelectViewHeight += kRowLineHeight;
            
            CGFloat titleHeight = ceil([title boundingRectWithSize:CGSizeMake(self.frame.size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:kTitleFontSize]} context:nil].size.height) + 15*2;
            UILabel *titleLabel = [[UILabel alloc] init];
            if(DeviceScreenInch_5_8 == DEVICE_SCREEN_INCH) {
                // 设置 iPhoneX 中安全区域
                titleLabel.frame = CGRectMake(0, bootomSelectViewHeight-34.0f, self.frame.size.width, titleHeight);
            } else {
                titleLabel.frame = CGRectMake(0, bootomSelectViewHeight, self.frame.size.width, titleHeight);
            }
            titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            titleLabel.text = title;
            titleLabel.backgroundColor = RgbColor(255.0f, 255.0f, 255.0f, 1.0f);
            titleLabel.textColor = RgbColor(135.0f, 135.0f, 135.0f, 1.0f);
            titleLabel.textAlignment = NSTextAlignmentCenter;
            titleLabel.font = [UIFont systemFontOfSize:kTitleFontSize];
            titleLabel.numberOfLines = 0;
            [_bottomSelectView addSubview:titleLabel];
            
            bootomSelectViewHeight += titleHeight;
        }
        
        if (destructiveButtonTitle && destructiveButtonTitle.length > 0) {
            bootomSelectViewHeight += kRowLineHeight;
            
            UIButton *destructiveButton = [UIButton buttonWithType:UIButtonTypeCustom];
            if(DeviceScreenInch_5_8 == DEVICE_SCREEN_INCH) {
                // 设置 iPhoneX 中安全区域
                destructiveButton.frame = CGRectMake(0, bootomSelectViewHeight-34.0f, self.frame.size.width, kRowHeight);
            } else {
                destructiveButton.frame = CGRectMake(0, bootomSelectViewHeight, self.frame.size.width, kRowHeight);
            }
            destructiveButton.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            destructiveButton.tag = 1;
            destructiveButton.titleLabel.font = [UIFont systemFontOfSize:kButtonTitleFontSize];
            [destructiveButton setTitle:destructiveButtonTitle forState:UIControlStateNormal];
            [destructiveButton setTitleColor:RgbColor(230.0f, 66.0f, 66.0f, 1.0f) forState:UIControlStateNormal];
            [destructiveButton setBackgroundImage:normalImage forState:UIControlStateNormal];
            [destructiveButton setBackgroundImage:highlightedImage forState:UIControlStateHighlighted];
            [destructiveButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [_bottomSelectView addSubview:destructiveButton];
            
            bootomSelectViewHeight += kRowHeight;
        }
        
        if (otherButtonTitles && [otherButtonTitles count] > 0) {
            for (int i = 0; i < otherButtonTitles.count; i++) {
                bootomSelectViewHeight += kRowLineHeight;
                
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                if(DeviceScreenInch_5_8 == DEVICE_SCREEN_INCH) {
                    // 设置 iPhoneX 中安全区域
                    button.frame = CGRectMake(0, bootomSelectViewHeight-34.0f, self.frame.size.width, kRowHeight);
                } else {
                    button.frame = CGRectMake(0, bootomSelectViewHeight, self.frame.size.width, kRowHeight);
                }
                button.autoresizingMask = UIViewAutoresizingFlexibleWidth;
                button.tag = i+2;
                button.titleLabel.font = [UIFont systemFontOfSize:kButtonTitleFontSize];
                [button setTitle:otherButtonTitles[i] forState:UIControlStateNormal];
                [button setTitleColor:RgbColor(64.0f, 64.0f, 64.0f, 1.0f) forState:UIControlStateNormal];
                [button setBackgroundImage:normalImage forState:UIControlStateNormal];
                [button setBackgroundImage:highlightedImage forState:UIControlStateHighlighted];
                [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
                [_bottomSelectView addSubview:button];
                
                bootomSelectViewHeight += kRowHeight;
            }
        }
        
        if (cancelButtonTitle && cancelButtonTitle.length > 0) {
            bootomSelectViewHeight += kSeparatorHeight;
            
            UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
            if(DeviceScreenInch_5_8 == DEVICE_SCREEN_INCH) {
                // 设置 iPhoneX 中安全区域
                cancelButton.frame = CGRectMake(0, bootomSelectViewHeight-34.0f, self.frame.size.width, kRowHeight);
            } else {
                cancelButton.frame = CGRectMake(0, bootomSelectViewHeight, self.frame.size.width, kRowHeight);
            }
            cancelButton.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            cancelButton.tag = 0;
            cancelButton.titleLabel.font = [UIFont systemFontOfSize:kButtonTitleFontSize];
            [cancelButton setTitle:cancelButtonTitle ?: @"取消" forState:UIControlStateNormal];
            [cancelButton setTitleColor:RgbColor(64.0f, 64.0f, 64.0f, 1.0f) forState:UIControlStateNormal];
            [cancelButton setBackgroundImage:normalImage forState:UIControlStateNormal];
            [cancelButton setBackgroundImage:highlightedImage forState:UIControlStateHighlighted];
            [cancelButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [_bottomSelectView addSubview:cancelButton];
            
            bootomSelectViewHeight += kRowHeight;
        }
        
        _bottomSelectView.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, bootomSelectViewHeight);
    }
    
    return self;
    
}

#pragma mark - 快速构建并显示选择视图
+ (void)showBottomSelectViewWithTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSArray *)otherButtonTitles handler:(YZBottomSelectViewBlock)bottomSelectViewBlock {
    YZBottomSelectView *bottomSelectView = [[self alloc] initWithTitle:title cancelButtonTitle:cancelButtonTitle destructiveButtonTitle:destructiveButtonTitle otherButtonTitles:otherButtonTitles handler:bottomSelectViewBlock];
    [bottomSelectView show];
}

#pragma mark - 视图展示
- (void)show {
    // 在主线程中处理,否则在viewDidLoad方法中直接调用,会先加本视图,后加控制器的视图到UIWindow上,导致本视图无法显示出来,这样处理后便会优先加控制器的视图到UIWindow上
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        
        NSEnumerator *frontToBackWindows = [UIApplication.sharedApplication.windows reverseObjectEnumerator];
        for (UIWindow *window in frontToBackWindows) {
            BOOL windowOnMainScreen = window.screen == UIScreen.mainScreen;
            BOOL windowIsVisible = !window.hidden && window.alpha > 0;
            BOOL windowLevelNormal = window.windowLevel == UIWindowLevelNormal;
            
            if(windowOnMainScreen && windowIsVisible && windowLevelNormal) {
                [window addSubview:self];
                break;
            }
        }
        
        [UIView animateWithDuration:kAnimateDuration delay:0 usingSpringWithDamping:1.0f initialSpringVelocity:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.backgroundView.alpha = 1.0f;
            self.bottomSelectView.frame = CGRectMake(0, self.frame.size.height-self.bottomSelectView.frame.size.height, self.frame.size.width, self.bottomSelectView.frame.size.height);
        } completion:nil];
    }];
}

#pragma mark - 视图收起（隐藏）
- (void)dismiss {
    [UIView animateWithDuration:kAnimateDuration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.backgroundView.alpha = 0.0f;
        self.bottomSelectView.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, self.bottomSelectView.frame.size.height);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - 非选择区域点击，触发视图收起隐藏事件
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.backgroundView];
    if (!CGRectContainsPoint(self.bottomSelectView.frame, point)) {
        if (self.bottomSelectViewBlock) {
            self.bottomSelectViewBlock(self, 0);
        }
        [self dismiss];
    }
}

#pragma mark - 选择按钮点击事件
- (void)buttonClicked:(UIButton *)button {
    if (self.bottomSelectViewBlock) {
        self.bottomSelectViewBlock(self, button.tag);
    }
    [self dismiss];
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end

