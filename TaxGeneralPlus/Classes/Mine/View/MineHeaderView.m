/************************************************************
 Class    : MineHeaderView.m
 Describe : 我的界面顶部头视图展示基本信息
 Company  : Prient
 Author   : Yanzheng 严正
 Date     : 2017-11-08
 Version  : 1.0
 Declare  : Copyright © 2017 Yanzheng. All rights reserved.
 ************************************************************/

#import "MineHeaderView.h"

@interface MineHeaderView ()

@property (nonatomic, assign) float bottomH;

@end

@implementation MineHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        
        self.backgroundColor = DEFAULT_BACKGROUND_COLOR;
        
        // 初始化底部通用菜单视图高度
        if(DEVICE_SCREEN_INCH_IPAD){
            _bottomH = floorf(self.frameHeight*0.2f);
        }else{
            _bottomH = 70.0f;
        }
        
        // 初始化主视图（用户头像、姓名、部门等...）
        [self initializeMainView];
        // 初始化底部视图
        [self initializeBottomView];
        
    }
    return self;
}

#pragma mark - 初始化主视图样式
- (void)initializeMainView{
    
    _imageView = [UIImageView new];
    [_imageView sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"mine_account_bg"] options:SDWebImageAllowInvalidSSLCertificates completed:nil];
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:_imageView];
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).with.insets(UIEdgeInsetsMake(0, 0, _bottomH, 0));
    }];
    
    CGSize nightShiftSize = CGSizeMake(20, 20);
    
    _nightShiftBtn = [UIButton new];
    NSMutableDictionary *settingDict = [[BaseSettingUtil sharedBaseSettingUtil] loadSettingData];
    if([[settingDict objectForKey:@"nightShift"] boolValue]){
        [_nightShiftBtn setBackgroundImage:[UIImage imageNamed:@"mine_account_sun"] forState:UIControlStateNormal];
        [_nightShiftBtn setBackgroundImage:[UIImage imageNamed:@"mine_account_sunHL"] forState:UIControlStateHighlighted];
    }else{
        [_nightShiftBtn setBackgroundImage:[UIImage imageNamed:@"mine_account_moon"] forState:UIControlStateNormal];
        [_nightShiftBtn setBackgroundImage:[UIImage imageNamed:@"mine_account_moonHL"] forState:UIControlStateHighlighted];
    }
    [_nightShiftBtn addTarget:self action:@selector(nightShiftAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_nightShiftBtn];
    [_nightShiftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).with.offset(HEIGHT_STATUS+10);
        make.right.equalTo(self).with.offset(-15);
        make.size.mas_equalTo(nightShiftSize);
    }];
    
    CGSize accountImageSize = CGSizeMake(70, 70);
    
    _accountImageView = [UIImageView new];
    [self addSubview:_accountImageView];
    [_accountImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self).with.offset(-10);
        make.left.equalTo(self).with.offset(ceilf(WIDTH_SCREEN*0.125f));
        make.size.mas_equalTo(accountImageSize);
    }];
    
    _accountBtn = [UIButton new];
    [_accountBtn addTarget:self action:@selector(btnDidSelected:) forControlEvents:UIControlEventTouchUpInside];
    _accountBtn.tag = 0;
    [self addSubview:_accountBtn];
    [_accountBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(_accountImageView);
        make.right.equalTo(self).with.mas_offset(-ceilf(WIDTH_SCREEN*0.125f));
        make.height.equalTo(_accountImageView);
    }];
    
    CGSize levelSize = CGSizeMake(32, 12);
    
    _levelLabel = [self initializeHeaderLabel];
    _levelLabel.backgroundColor = RgbColor(240, 180, 0, 1.f);
    _levelLabel.font = [UIFont systemFontOfSize:13.0f];
    _levelLabel.text = @"Lv 0";
    _levelLabel.layer.masksToBounds = YES;
    _levelLabel.layer.cornerRadius = 6;
    [self addSubview:_levelLabel];
    [_levelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_accountImageView.mas_right).with.offset(-20);
        make.bottom.equalTo(_accountBtn);
        make.size.mas_equalTo(levelSize);
    }];
    
    float nameFontSize = 26.0f;
    float nameHeight = 30.0f;
    
    _nameLabel = [self initializeHeaderLabel];
    _nameLabel.font = [UIFont boldSystemFontOfSize:nameFontSize];
    [self addSubview:_nameLabel];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_accountImageView).with.offset(15);
        make.left.mas_equalTo(ceilf(WIDTH_SCREEN*0.32f));
        make.width.mas_equalTo(WIDTH_SCREEN-ceilf(WIDTH_SCREEN*0.32f));
        make.height.mas_equalTo(nameHeight);
    }];
    
    float orgNnameFontSize = 14.0f;
    float orgNameHeight = 20.0f;
    
    _orgNameLabel = [self initializeHeaderLabel];
    _orgNameLabel.font = [UIFont systemFontOfSize:orgNnameFontSize];
    [self addSubview:_orgNameLabel];
    [_orgNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_nameLabel.mas_bottom).offset(5);
        make.left.equalTo(_nameLabel);
        make.width.equalTo(_nameLabel);
        make.height.mas_equalTo(orgNameHeight);
    }];
}

#pragma mark - 初始化底部视图样式（3个操作性按钮）
- (void)initializeBottomView{
    
    _bottomView = [UIView new];
    _bottomView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_bottomView];
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.width.equalTo(self);
        make.height.mas_equalTo(_bottomH);
    }];
    
    _topLineView = [UIView new];
    _topLineView.backgroundColor = DEFAULT_LINE_GRAY_COLOR;
    [_bottomView addSubview:_topLineView];
    [_topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(_bottomView);
        make.height.mas_equalTo(0.5f);
    }];
    
    CGFloat viewWidth = floorf((CGFloat)self.frameWidth/3);
    
    CGSize bottomImageSize = CGSizeMake(30, 30);
    
    _leftImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mine_rule"]];
    [_bottomView addSubview:_leftImageView];
    [_leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(-floorf((CGFloat)self.frameWidth/3));
        make.centerY.equalTo(_bottomView).with.offset(-10);
        make.size.mas_equalTo(bottomImageSize);
    }];
    
    _leftTitleLabel = [self initializeBottomLabel];
    _leftTitleLabel.text = @"升级详细规则";
    [_bottomView addSubview:_leftTitleLabel];
    [_leftTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_bottomView).with.offset(10);
        make.bottom.equalTo(_bottomView).with.offset(-5);
        make.size.mas_equalTo(CGSizeMake(viewWidth-20, 20));
    }];
    
    _leftBtn = [UIButton new];
    [_leftBtn addTarget:self action:@selector(btnDidSelected:) forControlEvents:UIControlEventTouchUpInside];
    _leftBtn.tag = 1;
    [_bottomView addSubview:_leftBtn];
    [_leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_leftTitleLabel);
        make.top.equalTo(_leftImageView);
        make.bottom.equalTo(_leftTitleLabel);
        make.width.mas_equalTo(viewWidth-20);
    }];
    
    _firstLineView = [UIView new];
    _firstLineView.backgroundColor = DEFAULT_LINE_GRAY_COLOR;
    [_bottomView addSubview:_firstLineView];
    [_firstLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_bottomView).with.offset(10);
        make.bottom.equalTo(_bottomView).with.offset(-10);
        make.width.mas_equalTo(0.5f);
        make.centerX.equalTo(_bottomView).with.offset(-floorf((CGFloat)self.frameWidth/6));
    }];
    
    _middleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mine_level"]];
    [_bottomView addSubview:_middleImageView];
    [_middleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_bottomView);
        make.centerY.equalTo(_bottomView).with.offset(-10);
        make.size.mas_equalTo(bottomImageSize);
    }];
    
    _middleTitleLabel = [self initializeBottomLabel];
    _middleTitleLabel.text = @"黄金等级";
    [_bottomView addSubview:_middleTitleLabel];
    [_middleTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_firstLineView.mas_right).with.offset(10);
        make.bottom.equalTo(_bottomView).with.offset(-5);
        make.size.mas_equalTo(CGSizeMake(viewWidth-20, 20));
    }];
    
    _middleBtn = [UIButton new];
    [_middleBtn addTarget:self action:@selector(btnDidSelected:) forControlEvents:UIControlEventTouchUpInside];
    _middleBtn.tag = 2;
    [_bottomView addSubview:_middleBtn];
    [_middleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_middleImageView);
        make.left.equalTo(_middleTitleLabel);
        make.bottom.equalTo(_middleTitleLabel);
        make.width.mas_equalTo(viewWidth-20);
    }];
    
    _secondLineView = [UIView new];
    _secondLineView.backgroundColor = DEFAULT_LINE_GRAY_COLOR;
    [_bottomView addSubview:_secondLineView];
    [_secondLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_bottomView).with.offset(floorf((CGFloat)self.frameWidth/6));
        make.top.equalTo(_bottomView).with.offset(10);
        make.bottom.equalTo(_bottomView).with.offset(-10);
        make.width.mas_equalTo(0.5f);
    }];
    
    _rightImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mine_sign"]];
    [_bottomView addSubview:_rightImageView];
    [_rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_bottomView).with.offset(floorf((CGFloat)self.frameWidth/3));
        make.centerY.equalTo(_bottomView).with.offset(-10);
        make.size.mas_equalTo(bottomImageSize);
    }];
    
    _rightTitleLabel = [self initializeBottomLabel];
    _rightTitleLabel.text = @"每日签到";
    [_bottomView addSubview:_rightTitleLabel];
    [_rightTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_bottomView).with.offset(-10);
        make.bottom.equalTo(_bottomView).with.offset(-5);
        make.width.mas_equalTo(viewWidth-20);
    }];
    
    _rightBtn = [UIButton new];
    [_rightBtn addTarget:self action:@selector(btnDidSelected:) forControlEvents:UIControlEventTouchUpInside];
    _rightBtn.frame = CGRectMake(_rightTitleLabel.originX, 10, viewWidth-20, 50);
    _rightBtn.tag = 3;
    [_bottomView addSubview:_rightBtn];
    [_rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_rightImageView);
        make.left.equalTo(_rightTitleLabel);
        make.bottom.mas_equalTo(-5);
        make.width.mas_equalTo(viewWidth-20);
    }];
    
    // 生成底部横线
    _bottomLineView = [UIView new];
    _bottomLineView.backgroundColor = DEFAULT_LINE_GRAY_COLOR;
    [_bottomView addSubview:_bottomLineView];
    [_bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(_bottomView);
        make.height.mas_equalTo(0.5f);
    }];
    
}

#pragma mark - 创建头部通用样式的Label
- (UILabel *)initializeHeaderLabel{
    UILabel *label = [UILabel new];
    label.numberOfLines = 0;
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    //label.font = [UIFont boldSystemFontOfSize:16.0f];
    //label.font = [UIFont fontWithName:@"Helvetica" size:13.0f];
    //字体自适应
    label.adjustsFontSizeToFitWidth = YES;
    
    return label;
}

#pragma mark - 创建底部通用样式的Label
- (UILabel *)initializeBottomLabel{
    UILabel *label = [UILabel new];
    label.font = [UIFont systemFontOfSize:13.0f];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor grayColor];
    return label;
}

#pragma mark - 夜间护眼模式按钮点击方法
- (void)nightShiftAction:(UIButton *)sender{
    NSMutableDictionary *settingDict = [[BaseSettingUtil sharedBaseSettingUtil] loadSettingData];
    if(![[settingDict objectForKey:@"nightShift"] boolValue]){
        [sender setBackgroundImage:[UIImage imageNamed:@"mine_account_sun"] forState:UIControlStateNormal];
        [sender setBackgroundImage:[UIImage imageNamed:@"mine_account_sunHL"] forState:UIControlStateHighlighted];
        [[UIScreen mainScreen] setBrightness:0];
        [settingDict setObject:[NSNumber numberWithBool:YES] forKey:@"nightShift"];
    }else{
        [sender setBackgroundImage:[UIImage imageNamed:@"mine_account_moon"] forState:UIControlStateNormal];
        [sender setBackgroundImage:[UIImage imageNamed:@"mine_account_moonHL"] forState:UIControlStateHighlighted];
        [[UIScreen mainScreen] setBrightness:0.5f];
        [settingDict setObject:[NSNumber numberWithBool:NO] forKey:@"nightShift"];
    }
    [[BaseSettingUtil sharedBaseSettingUtil] writeSettingData:settingDict];
}

#pragma mark - 按钮点击代理方法
- (void)btnDidSelected:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(mineHeaderViewBtnDidSelected:)]) {
        [self.delegate mineHeaderViewBtnDidSelected:sender];
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
