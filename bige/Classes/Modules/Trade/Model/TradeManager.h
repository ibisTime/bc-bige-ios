//
//  TradeManager.h
//  bige
//
//  Created by 蔡卓越 on 2018/4/23.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BaseModel.h"

@interface TradeManager : BaseModel

@end

FOUNDATION_EXTERN  NSString *const kSimulationTrade;    //模拟交易
FOUNDATION_EXTERN  NSString *const kAssetManagement;    //真实资产管理

FOUNDATION_EXTERN  NSString *const kBuyCurrency;        //买币
FOUNDATION_EXTERN  NSString *const kSellCurrency;       //卖币
FOUNDATION_EXTERN  NSString *const kCancelOrder;        //撤单
FOUNDATION_EXTERN  NSString *const kHoldThePosition;    //持仓
FOUNDATION_EXTERN  NSString *const kInquire;            //查询




