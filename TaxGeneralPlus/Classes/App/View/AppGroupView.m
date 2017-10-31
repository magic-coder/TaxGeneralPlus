/************************************************************
 Class    : AppGroupView.m
 Describe : 自定义应用列表分组栏视图
 Company  : Prient
 Author   : Yanzheng 严正
 Date     : 2017-10-31
 Version  : 1.0
 Declare  : Copyright © 2017 Yanzheng. All rights reserved.
 ************************************************************/

#import "AppGroupView.h"

@interface AppGroupView ()


@property (nonatomic, strong) UIView *cutLine;
@property (nonatomic, strong) UIView *colorView;

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation AppGroupView

#pragma mark - 初始化方法
-(instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]){
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.cutLine];
        [self addSubview:self.colorView];
        [self addSubview:self.titleLabel];
    }
    return self;
}

#pragma mark - 布局方法
- (void)layoutSubviews {
    [super layoutSubviews];
    
    if(!_top)
        _cutLine.hidden = NO;
    
}

#pragma mark - 分组标题左侧色块视图
-(UIView *)colorView {
    if(!_colorView){
        _colorView = [[UIView alloc] initWithFrame:CGRectMake(8, 14, 5, 12)];
        _colorView.backgroundColor = DEFAULT_BLUE_COLOR;
    }
    return _colorView;
}

#pragma mark - 分组顶部分割线
- (UIView *)cutLine {
    if(!_cutLine){
        _cutLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frameWidth, 1.0f)];
        _cutLine.backgroundColor = DEFAULT_BACKGROUND_COLOR;
        _cutLine.hidden = YES;
    }
    return _cutLine;
}

#pragma mark - 分组标题组件
- (UILabel *)titleLabel {
    if(!_titleLabel){
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(18, self.frameHeight-20, self.frameWidth * 0.3f, 20)];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textColor = [UIColor grayColor];
    }
    return _titleLabel;
}

#pragma mark - 是否顶部组信息栏
- (void)setTop:(BOOL)top {
    _top = top;
    
    [self layoutSubviews];
}

#pragma mark - 设置标题title
- (void)setTitle:(NSString *)title {
    _title = title;
    _titleLabel.text = _title;
    
    [self layoutSubviews];
}

@end
