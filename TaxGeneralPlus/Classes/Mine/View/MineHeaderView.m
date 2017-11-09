/************************************************************
 Class    : MineHeaderView.m
 Describe : 我的界面顶部头视图展示基本信息
 Company  : Prient
 Author   : Yanzheng
 Date     : 2017-11-08
 Version  : 1.0
 Declare  : Copyright © 2017 Yanzheng. All rights reserved.
 ************************************************************/

#import "MineHeaderView.h"

@implementation MineHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        
        self.backgroundColor = DEFAULT_BACKGROUND_COLOR;
        
        // 初始化主视图（用户头像、姓名、部门等...）
        [self initializeMainView];
        // 初始化底部视图
        [self initializeBottomView];
        
        // 注册按钮点击事件
        
    }
    return self;
}

#pragma mark - 初始化主视图样式
- (void)initializeMainView{
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.originX, self.originY, self.frameWidth, self.frameHeight-70)];
    [_imageView sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"mine_account_bg_new"] options:SDWebImageAllowInvalidSSLCertificates completed:nil];
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:_imageView];
    
    _nightBtn = [[UIButton alloc] init];
    NSMutableDictionary *settingDict = [[BaseSettingUtil sharedBaseSettingUtil] loadSettingData];
    if([[settingDict objectForKey:@"night"] boolValue]){
        [_nightBtn setBackgroundImage:[UIImage imageNamed:@"mine_account_sun"] forState:UIControlStateNormal];
        [_nightBtn setBackgroundImage:[UIImage imageNamed:@"mine_account_sunHL"] forState:UIControlStateHighlighted];
    }else{
        [_nightBtn setBackgroundImage:[UIImage imageNamed:@"mine_account_moon"] forState:UIControlStateNormal];
        [_nightBtn setBackgroundImage:[UIImage imageNamed:@"mine_account_moonHL"] forState:UIControlStateHighlighted];
    }
    [_nightBtn addTarget:self action:@selector(nightAction:) forControlEvents:UIControlEventTouchUpInside];
    _nightBtn.frame = CGRectMake(self.frameWidth-35, HEIGHT_STATUS+10, 20, 20);
    [self addSubview:_nightBtn];
    
    _accountImageView = [[UIImageView alloc] init];
    _accountImageView.frame = CGRectMake(50, HEIGHT_STATUS+HEIGHT_NAVBAR, 70, 70);
    [self addSubview:_accountImageView];
    
    _accountBtn = [[UIButton alloc] init];
    [_accountBtn addTarget:self action:@selector(accountSelected:) forControlEvents:UIControlEventTouchUpInside];
    _accountBtn.frame = CGRectMake(50, HEIGHT_STATUS+HEIGHT_NAVBAR, 285, 70);
    [self addSubview:_accountBtn];
    
    _levelLabel = [self labelWithFrame:CGRectMake(85, _accountImageView.frameBottom-14, 32, 12)];
    _levelLabel.backgroundColor = RgbColor(240, 180, 0, 1.f);
    _levelLabel.font = [UIFont systemFontOfSize:13.0f];
    _levelLabel.text = @"Lv 0";
    _levelLabel.layer.masksToBounds = YES;
    _levelLabel.layer.cornerRadius = 6;
    [self addSubview:_levelLabel];
    
    _nameLabel = [self labelWithFrame:CGRectMake(120, _accountImageView.originY+15, self.frameWidth-120, 30)];
    _nameLabel.font = [UIFont boldSystemFontOfSize:26.0f];
    [self addSubview:_nameLabel];
    
    _orgNameLabel = [self labelWithFrame:CGRectMake(120, _nameLabel.frameBottom, self.frameWidth-120, 20)];
    _orgNameLabel.font = [UIFont systemFontOfSize:14.0f];
    [self addSubview:_orgNameLabel];
}

#pragma mark - 初始化底部视图样式（3个操作性按钮）
- (void)initializeBottomView{
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frameHeight-70, self.frameWidth, 70)];
    _bottomView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_bottomView];
    
    CGFloat viewWidth = floorf((CGFloat)self.frameWidth/3);
    
    _leftImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mine_rule"]];
    _leftImageView.frame = CGRectMake(floorf((CGFloat)self.frameWidth/6)-15, 10, 30, 30);
    [_bottomView addSubview:_leftImageView];
    
    _leftTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, _leftImageView.frameBottom+5, viewWidth-20, 20)];
    _leftTitleLabel.font = [UIFont systemFontOfSize:13.0f];
    _leftTitleLabel.textAlignment = NSTextAlignmentCenter;
    _leftTitleLabel.textColor = [UIColor grayColor];
    _leftTitleLabel.text = @"升级详细规则";
    [_bottomView addSubview:_leftTitleLabel];
    
    _firstLineView = [[UIView alloc] initWithFrame:CGRectMake(viewWidth, 15, 0.5f, 40)];
    _firstLineView.backgroundColor = DEFAULT_LINE_GRAY_COLOR;
    [_bottomView addSubview:_firstLineView];
    
    
    _middleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mine_level"]];
    _middleImageView.frame = CGRectMake(floorf((CGFloat)self.frameWidth/2)-15, 10, 30, 30);
    [_bottomView addSubview:_middleImageView];
    
    _middleTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(viewWidth+10, _middleImageView.frameBottom+5, viewWidth-20, 20)];
    _middleTitleLabel.font = [UIFont systemFontOfSize:13.0f];
    _middleTitleLabel.textAlignment = NSTextAlignmentCenter;
    _middleTitleLabel.textColor = [UIColor grayColor];
    _middleTitleLabel.text = @"黄金等级";
    [_bottomView addSubview:_middleTitleLabel];
    
    _secondLineView = [[UIView alloc] initWithFrame:CGRectMake(viewWidth*2, 15, 0.5f, 40)];
    _secondLineView.backgroundColor = DEFAULT_LINE_GRAY_COLOR;
    [_bottomView addSubview:_secondLineView];
    
    _rightImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mine_sign"]];
    _rightImageView.frame = CGRectMake(floorf((CGFloat)self.frameWidth/6*5)-15, 10, 30, 30);
    [_bottomView addSubview:_rightImageView];
    
    _rightTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(viewWidth*2+10, _rightImageView.frameBottom+5, viewWidth-20, 20)];
    _rightTitleLabel.font = [UIFont systemFontOfSize:13.0f];
    _rightTitleLabel.textAlignment = NSTextAlignmentCenter;
    _rightTitleLabel.textColor = [UIColor grayColor];
    _rightTitleLabel.text = @"每日签到";
    [_bottomView addSubview:_rightTitleLabel];
    
}

#pragma mark - 创建基本通用样式的Label
- (UILabel *)labelWithFrame:(CGRect)frame{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.numberOfLines = 0;
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont boldSystemFontOfSize:16.0f];
    //label.font = [UIFont fontWithName:@"Helvetica" size:13.0f];
    //字体自适应
    label.adjustsFontSizeToFitWidth = YES;
    
    return label;
}

// 点击方法
- (void)nightAction:(UIButton *)sender{
    NSMutableDictionary *settingDict = [[BaseSettingUtil sharedBaseSettingUtil] loadSettingData];
    if(![[settingDict objectForKey:@"night"] boolValue]){
        [sender setBackgroundImage:[UIImage imageNamed:@"mine_account_sun"] forState:UIControlStateNormal];
        [sender setBackgroundImage:[UIImage imageNamed:@"mine_account_sunHL"] forState:UIControlStateHighlighted];
        [[UIScreen mainScreen] setBrightness:0];
        [settingDict setObject:[NSNumber numberWithBool:YES] forKey:@"night"];
    }else{
        [sender setBackgroundImage:[UIImage imageNamed:@"mine_account_moon"] forState:UIControlStateNormal];
        [sender setBackgroundImage:[UIImage imageNamed:@"mine_account_moonHL"] forState:UIControlStateHighlighted];
        [[UIScreen mainScreen] setBrightness:0.5f];
        [settingDict setObject:[NSNumber numberWithBool:NO] forKey:@"night"];
    }
    [[BaseSettingUtil sharedBaseSettingUtil] writeSettingData:settingDict];
}

#pragma mark - 点击代理方法
- (void)accountSelected:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(mineHeaderViewDidSelected)]) {
        [self.delegate mineHeaderViewDidSelected];
    }
}

// 重写Setter 方法
- (void)setNameText:(NSString *)nameText{
    _nameLabel.text = nameText;
    if([nameText isEqualToString:@"未登录"]){
        _levelLabel.backgroundColor = [UIColor lightGrayColor];
        _levelLabel.text = @"Lv 0";
        _orgNameLabel.text = @"登录后，即可享用更多功能！";
        
        [_accountImageView setImage:[UIImage imageNamed:@"mine_account_header_grey"]];
    }else{
        _levelLabel.backgroundColor = RgbColor(240, 180, 0, 1.f);
        //_levelLabel.text = [NSString stringWithFormat:@"Lv %@", [[[NSUserDefaults standardUserDefaults] objectForKey:LOGIN_SUCCESS] objectForKey:@"level"]];
        _levelLabel.text = @"Lv 0";
        _orgNameLabel.text = [[[NSUserDefaults standardUserDefaults] objectForKey:LOGIN_SUCCESS] objectForKey:@"orgName"];
        
        [_accountImageView setImage:[UIImage imageNamed:@"mine_account_header_color"]];
    }
}

@end
