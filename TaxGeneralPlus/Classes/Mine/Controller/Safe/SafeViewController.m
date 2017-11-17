/************************************************************
 Class    : SafeViewController.m
 Describe : 安全中心界面
 Company  : Prient
 Author   : Yanzheng 严正
 Date     : 2017-11-16
 Version  : 1.0
 Declare  : Copyright © 2017 Yanzheng. All rights reserved.
 ************************************************************/

#import "SafeViewController.h"
#import "YZTouchID.h"
#import "MineUtil.h"

@interface SafeViewController () <BaseTableViewControllerDelegate>

@end

@implementation SafeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"安全中心";
    self.delegate = self;
    self.data = [[MineUtil sharedMineUtil] safeData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    BaseTableModelGroup *group = [self.data objectAtIndex:indexPath.section];
    BaseTableModelItem *item = [group itemAtIndex:indexPath.row];
    
    UIViewController *viewController = nil;
    
    if([item.title isEqualToString:@"手势密码"]){
        
    }
    
    if(nil != viewController){
        viewController.title = item.title;
        [self.navigationController pushViewController:viewController animated:YES];
    }
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - <BaseTableViewControllerDelegate>代理方法
- (void)baseTableViewControllerSwitchChanged:(UISwitch *)sender{
    NSInteger tag =  sender.tag;
    if(tag == 423){// 指纹识别
        [self touchVerification:sender];
    }
}

#pragma mark - 验证TouchID
- (void)touchVerification:(UISwitch *)sender {
    
    YZTouchID *touchID = [[YZTouchID alloc] init];
    
    [touchID td_showTouchIDWithDescribe:nil BlockState:^(YZTouchIDState state, NSError *error) {
        
        if (state == YZTouchIDStateNotSupport) {    //不支持TouchID
            
            [UIAlertController showAlertInViewController:self withTitle:nil message:@"对不起，当前设备不支持指纹" cancelButtonTitle:@"确定" destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
            }];
            
            sender.on = !sender.isOn;
        } else if(state == YZTouchIDStateTouchIDLockout){ // 多次指纹错误被锁定
            
            [UIAlertController showAlertInViewController:self withTitle:nil message:@"多次错误，指纹已被锁定，请到手机解锁界面输入密码！" cancelButtonTitle:@"确定" destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
            }];
            sender.on = !sender.isOn;
            
        } else if (state == YZTouchIDStateSuccess) {    //TouchID验证成功
            sender.on = sender.isOn;
        }else{
            sender.on = !sender.isOn;
        }
        
        // ps:以上的状态处理并没有写完全!
        // 在使用中你需要根据回调的状态进行处理,需要处理什么就处理什么
        NSMutableDictionary *settingDict = [[BaseSettingUtil sharedBaseSettingUtil] loadSettingData];
        [settingDict setValue:[NSNumber numberWithBool:sender.isOn] forKey:@"touchID"];
        
        BOOL res = [[BaseSettingUtil sharedBaseSettingUtil] writeSettingData:settingDict];
        if(!res){
            [MBProgressHUD showHUDView:self.view text:@"设置异常！" progressHUDMode:YZProgressHUDModeShow];
        }
        
    }];
}

@end
