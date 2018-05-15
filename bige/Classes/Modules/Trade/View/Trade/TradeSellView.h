//
//  TradeSellView.h
//  bige
//
//  Created by 蔡卓越 on 2018/5/7.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BaseView.h"

@interface TradeSellView : BaseView
//限价
@property (nonatomic, strong) UIView *limitPriceView;
//市价
@property (nonatomic, strong) UIView *marketPriceView;
//可用货币数量
@property (nonatomic, strong) UILabel *useNumLbl;
//对应币种名称
@property (nonatomic, strong) UILabel *symbolLbl;
//价格
@property (nonatomic, copy) NSString *price;
//下单成功
@property (nonatomic, copy) void (^sellSuccess)();

@end
