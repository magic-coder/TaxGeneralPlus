//
//  LeftMenuViewDemo.m
//  MenuDemo
//
//  Created by Lying on 16/6/12.
//  Copyright © 2016年 Lying. All rights reserved.
//
#define ImageviewWidth    18

#import "LeftMenuViewDemo.h"

@interface LeftMenuViewDemo ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic ,strong)UITableView    *contentTableView;

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
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frameWidth, HEIGHT_STATUS+HEIGHT_NAVBAR+100)];
    headerView.backgroundColor = DEFAULT_BLUE_COLOR;
    [self addSubview:headerView];
    
    UIImageView *avatarView = [[UIImageView alloc] initWithFrame:CGRectMake(15, headerView.frameHeight/2-20, 60, 60)];
    [avatarView setImage:[UIImage imageNamed:@"mine_account_header_color"]];
    [headerView addSubview:avatarView];
    
    NSDictionary *loginDict = [[NSUserDefaults standardUserDefaults] objectForKey:LOGIN_SUCCESS];// 登录基本信息
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(avatarView.frameRight+15, avatarView.originY+10, self.frameWidth-avatarView.frameWidth-45, 20)];
    [nameLabel setText:[loginDict objectForKey:@"userName"]];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.textColor = [UIColor whiteColor];
    nameLabel.font = [UIFont boldSystemFontOfSize:20.0f];
    [headerView addSubview:nameLabel];
    
    UILabel *orgLabel = [[UILabel alloc] initWithFrame:CGRectMake(avatarView.frameRight+15, nameLabel.frameBottom+5, self.frameWidth-avatarView.frameWidth-45, 20)];
    [orgLabel setText:[loginDict objectForKey:@"orgName"]];
    orgLabel.textAlignment = NSTextAlignmentCenter;
    orgLabel.textColor = [UIColor whiteColor];
    orgLabel.font = [UIFont systemFontOfSize:16.0f];
    [headerView addSubview:orgLabel];
    
    //中间tableview
    UITableView *contentTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, headerView.frameBottom, self.frameWidth, self.frameHeight - headerView.frameHeight) style:UITableViewStylePlain];
    [contentTableView setBackgroundColor:[UIColor whiteColor]];
    contentTableView.dataSource = self;
    contentTableView.delegate = self;
    contentTableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [contentTableView setBackgroundColor:[UIColor whiteColor]];
    contentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    contentTableView.tableFooterView = [UIView new];
    self.contentTableView = contentTableView;
    [self addSubview:contentTableView];
    
    //添加尾部
    /*
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height - 50, self.frameWidth, 50)];
    [footerView setBackgroundColor:[UIColor lightGrayColor]];
    [self addSubview:footerView];
    */
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
    
    if([self.customDelegate respondsToSelector:@selector(LeftMenuViewClick:)]){
        [self.customDelegate LeftMenuViewClick:indexPath.row];
    }
    
}



@end
