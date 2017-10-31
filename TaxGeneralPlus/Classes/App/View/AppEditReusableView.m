//
//  AppEditReusableView.m
//  TaxGeneralPlus
//
//  Created by Apple on 2017/10/31.
//  Copyright © 2017年 prient. All rights reserved.
//

#import "AppEditReusableView.h"

@interface AppEditReusableView ()

@property (nonatomic, strong) UILabel *titleLabel;      // 标签

@end

@implementation AppEditReusableView

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self initialize];
    }
    return self;
}

#pragma mark - 初始化方法
- (void)initialize{
    
    self.backgroundColor = [UIColor whiteColor];
    
    _titleLabel = [[UILabel alloc] init];
    [self addSubview:_titleLabel];
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    // 如果标题存在，进行设置标签样式
    if(self.title){
        [_titleLabel setTextColor:[UIColor grayColor]];
        
        [_titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
        [_titleLabel setNumberOfLines:0];   // 设置为自动换行
        [_titleLabel setText:_title];
        
        // float x = self.frameWidth * 0.035;
        float w = self.frameWidth * 0.89;
        CGSize size = [self.titleLabel sizeThatFits:CGSizeMake(w, MAXFLOAT)];   // 根据text计算大小
        [_titleLabel setFrame:CGRectMake(16, self.frameHeight/2-size.height/2, w, size.height)];
        // 居中布局
        //[_titleLabel setFrame:CGRectMake(self.frameWidth/2-size.width/2, self.frameHeight/2-size.height/2, w, size.height)];
    }
}

#pragma mark - 重写text的Setter方法
- (void)setTitle:(NSString *)title {
    _title = title;
    [self layoutSubviews];
}

#pragma mark - 重写isTop的Setter方法
- (void)setTop:(BOOL)top {
    _top = top;
    [self layoutSubviews];
}

@end
