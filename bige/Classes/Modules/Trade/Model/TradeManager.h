//
//  TradeManager.h
//  bige
//
//  Created by 蔡卓越 on 2018/4/23.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BaseModel.h"

@interface TradeManager : BaseModel

//编号
@property (nonatomic, copy) NSString *ID;
//币种名称
@property (nonatomic, copy) NSString *symbol;
//参考币种
@property (nonatomic, copy) NSString *toSymbol;
//交易所
@property (nonatomic, copy) NSString *exchange;
//相对于某币种的价格
@property (nonatomic, strong) NSNumber *price;
//交易类型（0=市价，1=限价）type=1时必填，委托价格
@property (nonatomic, copy) NSString *type;
//交易买卖方向(0=买入，1=卖出)
@property (nonatomic, copy) NSString *direction;
//toSymbol
@property (nonatomic, strong) NSNumber *totalCount;
//对应币种相对于人民币的价格
@property (nonatomic, strong) NSNumber *cnyPrice;

+ (instancetype)manager;

@end

FOUNDATION_EXTERN  NSString *const kSimulationTrade;    //模拟交易
FOUNDATION_EXTERN  NSString *const kAssetManagement;    //真实资产管理

FOUNDATION_EXTERN  NSString *const kBuyCurrency;        //买币
FOUNDATION_EXTERN  NSString *const kSellCurrency;       //卖币
FOUNDATION_EXTERN  NSString *const kCancelOrder;        //撤单
FOUNDATION_EXTERN  NSString *const kHoldThePosition;    //持仓
FOUNDATION_EXTERN  NSString *const kInquire;            //查询




