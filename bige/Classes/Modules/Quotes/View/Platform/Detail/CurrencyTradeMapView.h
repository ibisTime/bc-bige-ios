//
//  CurrencyTradeMapView.h
//  bige
//
//  Created by 蔡卓越 on 2018/4/25.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import <UIKit/UIKit.h>
//M
#import "PlatformModel.h"

/**
 买卖实图
 */
@interface CurrencyTradeMapView : UIScrollView
//币种信息
@property (nonatomic, strong) PlatformModel *platform;
//vc是否可滚动
@property (nonatomic, assign) BOOL vcCanScroll;

@end
