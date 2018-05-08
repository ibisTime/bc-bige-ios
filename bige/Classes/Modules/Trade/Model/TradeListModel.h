//
//  TradeListModel.h
//  bige
//
//  Created by 蔡卓越 on 2018/5/8.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BaseModel.h"

@class TradeInfoModel;

@interface TradeListModel : BaseModel

@property (nonatomic, strong) NSArray <TradeInfoModel *>*bids;

@property (nonatomic, strong) NSArray <TradeInfoModel *>*asks;

@end

@interface TradeInfoModel : NSObject
//价格
@property (nonatomic, strong) NSNumber *price;
//数量
@property (nonatomic, strong) NSNumber *amount;

@end
