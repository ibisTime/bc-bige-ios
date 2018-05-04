//
//  SimulationTradeInfoModel.h
//  bige
//
//  Created by 蔡卓越 on 2018/4/23.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BaseModel.h"

/**
 模拟交易信息
 */
@interface SimulationTradeInfoModel : BaseModel
//成绩
@property (nonatomic, strong) NSNumber *rank;
//总资产
@property (nonatomic, strong) NSNumber *cnyAmount;
//浮动盈亏
@property (nonatomic, strong) NSNumber *totalFloat;
//交易所数量
@property (nonatomic, strong) NSNumber *exchangeCount;
//总市值
@property (nonatomic, strong) NSNumber *marketAmount;
//当日参考盈亏
@property (nonatomic, strong) NSNumber *dailyFloat;
//持有币种
@property (nonatomic, strong) NSNumber *symbolCount;
//用户头像
@property (nonatomic, copy) NSString *userPhoto;

@end

