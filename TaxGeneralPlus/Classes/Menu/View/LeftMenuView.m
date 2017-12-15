//
//  LeftMenuViewDemo.m
//  MenuDemo
//
//  Created by Lying on 16/6/12.
//  Copyright © 2016年 Lying. All rights reserved.
//

#import "LeftMenuViewDemo.h"

@interface LeftMenuViewDemo ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UIImageView *headerView;
@property (nonatomic, strong) UIImageView *avatarView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *orgLabel;
@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, strong) UILabel *versionLabel;

@property (nonatomic, strong) UITableView *contentTableView;

@end

@implementation LeftMenuViewDemo

 
-(instancetype)initWithFrame:(CGRect)frame{

    if(self = [super initWithFrame:frame]){
        [self initView];
    }
    return  self;
}

-(void)initView{

    self.backgroundColor = DEFAULT_BACKGROUND_COLOR;
    
    //添加头部
    _headerView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"menu_bg"]];
    _headerView.frame = CGRectMake(0, 0, self.frameWidth, HEIGHT_STATUS+120);
    [self addSubview:_headerView];
    
    _avatarView = [[UIImageView alloc] initWithFrame:CGRectMake(20, HEIGHT_STATUS+30, 60, 60)];
    [_avatarView setImage:[UIImage imageNamed:@"mine_account_header_color"]];
    [_headerView addSubview:_avatarView];
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_avatarView.frameRight+20, _avatarView.originY+10, self.frameWidth-_avatarView.frameWidth-60, 20)];
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    _nameLabel.textColor = [UIColor whiteColor];
    _nameLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    [_headerView addSubview:_nameLabel];
    
    _orgLabel = [[UILabel alloc] initWithFrame:CGRectMake(_avatarView.frameRight+20, _avatarView.frameBottom-20, self.frameWidth-_avatarView.frameWidth-60, 20)];
    _orgLabel.textAlignment = NSTextAlignmentCenter;
    _orgLabel.textColor = [UIColor whiteColor];
    _orgLabel.font = [UIFont systemFontOfSize:14.0f];
    [_headerView addSubview:_orgLabel];
    
    //中间tableview
    _contentTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _headerView.frameBottom, self.frameWidth, self.frameHeight - _headerView.frameHeight) style:UITableViewStylePlain];
    [_contentTableView setBackgroundColor:[UIColor whiteColor]];
    _contentTableView.dataSource = self;
    _contentTableView.delegate = self;
    _contentTableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [_contentTableView setBackgroundColor:[UIColor whiteColor]];
    _contentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _contentTableView.tableFooterView = [UIView new];
    [self addSubview:_contentTableView];
    
    //添加尾部
    _footerView = [[UIView alloc]initWithFrame:CGRectMake(0, self.frameHeight - 60, self.frameWidth, 60)];
    [_footerView setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:_footerView];
    
    _versionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _footerView.frameWidth, 30)];
    _versionLabel.textAlignment = NSTextAlignmentCenter;
    _versionLabel.textColor = [UIColor lightGrayColor];
    _versionLabel.font = [UIFont systemFontOfSize:13.0f];
    _versionLabel.text = [NSString stringWithFormat:@"For iPhone V%@ build%@", [[Variable sharedVariable] appVersion], [[Variable sharedVariable] buildVersion]];
    [_footerView addSubview:_versionLabel];
}

#pragma mark - tableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 6;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 46;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //NSString *str = [NSString stringWithFormat:@"LeftView%li",indexPath.row];
    NSString *str = @"ssssllll";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    
    if(cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
    }
    [cell setBackgroundColor:[UIColor whiteColor]];
    [cell.textLabel setTextColor:[UIColor grayColor]];
    
    cell.hidden = NO;
    switch (indexPath.row) {
        case 0: {
            [cell.imageView setImage:[UIImage imageNamed:@"menu_mine"]];
            [cell.textLabel setText:@"个人信息"];
            break;
        }
        case 1: {
            [cell.imageView setImage:[UIImage imageNamed:@"menu_sign"]];
            [cell.textLabel setText:@"每日签到"];
            break;
        }
        case 2: {
            [cell.imageView setImage:[UIImage imageNamed:@"menu_introduce"]];
            [cell.textLabel setText:@"功能介绍"];
            break;
        }
        case 3: {
            [cell.imageView setImage:[UIImage imageNamed:@"menu_problem"]];
            [cell.textLabel setText:@"常见问题"];
            break;
        }
        case 4: {
            [cell.imageView setImage:[UIImage imageNamed:@"menu_service"]];
            [cell.textLabel setText:@"联系客服"];
            break;
        }
        case 5: {
            [cell.imageView setImage:[UIImage imageNamed:@"menu_setting"]];
            [cell.textLabel setText:@"设置"];
            break;
        }
        default:
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if([self.delegate respondsToSelector:@selector(LeftMenuViewClick:)]){
        [self.delegate LeftMenuViewClick:indexPath.row];
    }
    
}

#pragma mark - 设置数据（包含，姓名、机构等...）
- (void)loadData {
    NSDictionary *loginDict = [[NSUserDefaults standardUserDefaults] objectForKey:LOGIN_SUCCESS];// 登录基本信息
    [_nameLabel setText:[loginDict objectForKey:@"userName"]];
    [_orgLabel setText:[loginDict objectForKey:@"orgName"]];
}


@end
