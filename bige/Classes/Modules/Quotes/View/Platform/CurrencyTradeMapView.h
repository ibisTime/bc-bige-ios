//
//  CurrencyTradeMapView.h
//  bige
//
//  Created by 蔡卓越 on 2018/4/25.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BaseView.h"
//M
#import "PlatformModel.h"

/**
 买卖实图
 */
@interface CurrencyTradeMapView : BaseView
//币种信息
@property (nonatomic, strong) PlatformModel *platform;

@end
