/************************************************************
 Class    : BaseTableViewController.h
 Describe : 基本的表格视图控制器，提供Table布局界面
 Company  : Prient
 Author   : Yanzheng 严正
 Date     : 2017-11-08
 Version  : 1.0
 Declare  : Copyright © 2017 Yanzheng. All rights reserved.
 ************************************************************/

#import <UIKit/UIKit.h>

@protocol BaseTableViewControllerDelegate <NSObject>

@optional
- (void)baseTableViewControllerBtnClick:(UIButton *)sender;
- (void)baseTableViewControllerSwitchChanged:(UISwitch *)sender;

@end

@interface BaseTableViewController : UITableViewController

@property (nonatomic, strong) NSMutableArray *data;

@property (nonatomic, weak) id<BaseTableViewControllerDelegate> delegate;

@end
