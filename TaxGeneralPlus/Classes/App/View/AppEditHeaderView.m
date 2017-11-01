/************************************************************
 Class    : AppEditHeaderView.m
 Describe : 自定义应用管理编辑模块组视图栏
 Company  : Prient
 Author   : Yanzheng 严正
 Date     : 2017-10-31
 Version  : 1.0
 Declare  : Copyright © 2017 Yanzheng. All rights reserved.
 ************************************************************/

#import "AppEditHeaderView.h"

@interface AppEditHeaderView ()

@property (nonatomic, strong) UIView *colorView;
@property (nonatomic, strong) UILabel *titleLabel;      // 标签

@end

@implementation AppEditHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self initialize];
    }
    return self;
}

#pragma mark - 初始化方法
- (void)initialize{
    
    self.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.colorView];
    
    [self addSubview:self.titleLabel];
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    // 如果标题存在，进行设置标签样式
    if(self.title){
        // float x = self.frameWidth * 0.035;
        float w = self.frameWidth * 0.89;
        CGSize size = [self.titleLabel sizeThatFits:CGSizeMake(w, MAXFLOAT)];   // 根据text计算大小
        [_titleLabel setFrame:CGRectMake(16, self.frameHeight/2-size.height/2, w, size.height)];
        // 居中布局
        //[_titleLabel setFrame:CGRectMake(self.frameWidth/2-size.width/2, self.frameHeight/2-size.height/2, w, size.height)];
    }
}

#pragma mark - 重写Getter用于组件初始化方法
- (UIView *)colorView {
    if(!_colorView){
        _colorView = [[UIView alloc] initWithFrame:CGRectMake(8, 10, 5, 12)];
        _colorView.backgroundColor = DEFAULT_BLUE_COLOR;
    }
    return _colorView;
}

- (UILabel *)titleLabel {
    if(!_titleLabel){
        _titleLabel = [[UILabel alloc] init];
        
        [_titleLabel setNumberOfLines:0];// 自动换行
        [_titleLabel setTextColor:[UIColor grayColor]];
        [_titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    }
    return _titleLabel;
}

#pragma mark - 重写text的Setter方法
- (void)setTitle:(NSString *)title {
    _title = title;
    [self.titleLabel setText:_title];
    
    [self layoutSubviews];
}

@end
