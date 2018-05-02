//
//  OptionInfoModel.h
//  bige
//
//  Created by 蔡卓越 on 2018/5/2.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BaseModel.h"

@class MarketGlobal;

@interface OptionInfoModel : BaseModel
//币种名称
@property (nonatomic, copy) NSString *symbol;
//参考币种
@property (nonatomic, copy) NSString *toSymbol;
//交易所英文
@property (nonatomic, copy) NSString *exchangeEname;
//
@property (nonatomic, strong) MarketGlobal *marketGlobal;

@end

@interface MarketGlobal : NSObject
//编号
@property (nonatomic, copy) NSString *ID;
//交易所中文
@property (nonatomic, copy) NSString *exchangeCname;
//rmb价格
@property (nonatomic, strong) NSNumber *lastCnyPrice;
//24小时交易量
@property (nonatomic, strong) NSNumber *volume;
//24小时交易额
@property (nonatomic, strong) NSNumber *amount;
//
@property (nonatomic, copy) NSString *tradeVolume;
//相对于某币种的价格
@property (nonatomic, strong) NSNumber *lastPrice;
//涨幅
@property (nonatomic, strong) NSNumber *percentChange1m;
@property (nonatomic, strong) NSNumber *percentChange24h;
@property (nonatomic, strong) NSNumber *percentChange7d;
@property (nonatomic, strong) NSNumber *percentChange;

@property (nonatomic, copy) NSString *changeRate;
//涨跌颜色
@property (nonatomic, strong) UIColor *bgColor;
//排名颜色
@property (nonatomic, strong) UIColor *rankColor;
//是否选择(1是 0否)
@property (nonatomic, copy) NSString *isChoice;
//最高价
@property (nonatomic, strong) NSNumber *high;
//最低价
@property (nonatomic, strong) NSNumber *low;
//开盘价
@property (nonatomic, strong) NSNumber *open;
//收盘价
@property (nonatomic, strong) NSNumber *close;
//市值
@property (nonatomic, strong) NSNumber *maxMarketCapCny;
//关注人数
@property (nonatomic, assign) NSInteger choiceCount;
//交易成交数量
@property (nonatomic, assign) NSInteger count;

/**
 获取涨跌颜色
 */
- (UIColor *)getPercentColorWithPercent:(NSNumber *)percent;
/**
 获取涨跌幅
 */
- (NSString *)getResultWithPercent:(NSNumber *)percent;

@end
