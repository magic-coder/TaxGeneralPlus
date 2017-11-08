//
//  MineUtil.h
//  TaxGeneralPlus
//
//  Created by Apple on 2017/11/7.
//  Copyright © 2017年 prient. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MineUtil : NSObject

SingletonH(MineUtil)

- (NSMutableArray *)loadMineData;

@end
