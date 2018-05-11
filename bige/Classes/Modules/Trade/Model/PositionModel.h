//
//  PositionModel.h
//  bige
//
//  Created by 蔡卓越 on 2018/5/11.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BaseModel.h"

@class AssetInfo, AccountInfo;

@interface PositionModel : BaseModel

//总市值
@property (nonatomic, strong) NSNumber *totalMarketPrice;
//总盈亏
@property (nonatomic, strong) NSNumber *totalProfit;
//交易所资产列表
@property (nonatomic, strong) NSArray <AssetInfo *>*assetList;

@end

@interface AssetInfo : NSObject
//交易所
@property (nonatomic, copy) NSString *exchange;
//总市值
@property (nonatomic, strong) NSNumber *totalMarketPrice;
//总成本
@property (nonatomic, strong) NSNumber *totalCost;
//总盈亏
@property (nonatomic, strong) NSNumber *totalProfit;
//涨幅
@property (nonatomic, strong) NSNumber *percentChange;

//账户列表
@property (nonatomic, strong) NSArray <AccountInfo *>*accountList;

/**
 获取涨跌颜色
 */
- (UIColor *)getPercentColorWithPercent:(NSNumber *)percent;
/**
 获取涨跌幅
 */
- (NSString *)getResultWithPercent:(NSNumber *)percent;

@end

@interface AccountInfo : NSObject
//币种名称
@property (nonatomic, copy) NSString *symbol;
//币种图标
@property (nonatomic, copy) NSString *symbolPic;
//平均持仓成本
@property (nonatomic, strong) NSNumber *avgCost;
//总市值
@property (nonatomic, strong) NSNumber *totalMarketPrice;
//总盈亏
@property (nonatomic, strong) NSNumber * totalProfit;

/**
 获取涨跌颜色
 */
- (UIColor *)getPercentColorWithPercent:(NSNumber *)percent;

@end
