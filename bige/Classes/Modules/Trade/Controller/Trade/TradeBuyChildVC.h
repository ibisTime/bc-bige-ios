//
//  TradeBuyChildVC.h
//  bige
//
//  Created by 蔡卓越 on 2018/5/7.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BaseViewController.h"

/**
 买
 */
@interface TradeBuyChildVC : BaseViewController
//刷新委托单
@property (nonatomic, copy) void(^refreshDivision)();

@end
