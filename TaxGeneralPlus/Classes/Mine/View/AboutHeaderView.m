/************************************************************
 Class    : AboutHeaderView.m
 Describe : 关于界面头部视图
 Company  : Prient
 Author   : Yanzheng 严正
 Date     : 2017-11-16
 Version  : 1.0
 Declare  : Copyright © 2017 Yanzheng. All rights reserved.
 ************************************************************/

#import "AboutHeaderView.h"

@implementation AboutHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.backgroundColor = DEFAULT_BACKGROUND_COLOR;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH_SCREEN/2-80, 20, 160, 160)];
        imageView.image = [UIImage imageNamed:@"common_barcode"];
        //imageView.image = [UIImage imageNamed:@"about_logo" scaleToSize:imageView.size];
        
        //imageView.layer.masksToBounds = YES;// 隐藏边界
        //imageView.layer.cornerRadius = 12;// 将图层的边框设置为圆角
        [self addSubview:imageView];
        
        UILabel *nameLabel = [self labelWithFrame:CGRectMake(0, 185, WIDTH_SCREEN, 20)];
        nameLabel.font = [UIFont boldSystemFontOfSize:14.0f];
        nameLabel.text = [[Variable sharedVariable] appName];
        [self addSubview:nameLabel];
        
        UILabel *versionLabel = [self labelWithFrame:CGRectMake(0, 205, WIDTH_SCREEN, 20)];
        versionLabel.text = [NSString stringWithFormat:@"For iPhone V%@ build%@", [[Variable sharedVariable] appVersion], [[Variable sharedVariable] buildVersion]];
        versionLabel.font = [UIFont systemFontOfSize:12.0f];
        versionLabel.textColor = [UIColor grayColor];
        [self addSubview:versionLabel];
        
    }
    return self;
}

#pragma mark - 创建基本通用样式的Label
- (UILabel *)labelWithFrame:(CGRect)frame{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.numberOfLines = 0;
    label.textColor = [UIColor blackColor];
    label.textAlignment = NSTextAlignmentCenter;
    //label.font = [UIFont fontWithName:@"Helvetica" size:13.0f];
    //字体自适应
    label.adjustsFontSizeToFitWidth = YES;
    
    return label;
}

@end
