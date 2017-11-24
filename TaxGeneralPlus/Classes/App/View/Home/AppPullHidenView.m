/************************************************************
 Class    : AppPullHidenView.m
 Describe : 自定义应用列表下拉显示logo视图
 Company  : Prient
 Author   : Yanzheng 严正
 Date     : 2017-10-31
 Version  : 1.0
 Declare  : Copyright © 2017 Yanzheng. All rights reserved.
 ************************************************************/

#import "AppPullHidenView.h"

@interface AppPullHidenView ()

@property (nonatomic, strong) UIImageView *imageView;

@end


@implementation AppPullHidenView

- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]){
        self.backgroundColor = DEFAULT_BACKGROUND_COLOR;
        [self addSubview:self.imageView];
    }
    return self;
}

#pragma mark - 添加下拉显示的图片
- (UIImageView *)imageView {
    if(!_imageView){
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.frameWidth/2-83, self.frameHeight-90, 166, 45)];
        _imageView.image = [UIImage imageNamed:@"app_common_pull_logo"];
    }
    return _imageView;
}

@end
