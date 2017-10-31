//
//  AppEditViewCell.h
//  TaxGeneralPlus
//
//  Created by Apple on 2017/10/31.
//  Copyright © 2017年 prient. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AppModelItem;

// 自定义编辑按钮样式
typedef NS_ENUM(NSInteger, AppCellEditBtnStyle) {
    AppCellEditBtnStyleAdd,     // 编辑按钮为添加
    AppCellEditBtnStyleDelete,  // 编辑按钮为删除
    AppCellEditBtnStyleSelected // 编辑按钮为已选择
};

@protocol AppEditViewCellDelegate <NSObject>

@optional
-(void)appEditViewCellEditBtnClick:(UIButton *)sender;

@end

@interface AppEditViewCell : UICollectionViewCell

@property (nonatomic, assign) AppCellEditBtnStyle editBtnStyle;  // 编辑按钮样式

@property (nonatomic, strong) AppModelItem *item;

@property (nonatomic, weak) id<AppEditViewCellDelegate> delegate;

@end
