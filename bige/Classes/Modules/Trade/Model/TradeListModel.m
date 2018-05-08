//
//  TradeListModel.m
//  bige
//
//  Created by 蔡卓越 on 2018/5/8.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "TradeListModel.h"

@implementation TradeListModel

+ (NSDictionary *)objectClassInArray {
    
    return @{@"bids" : [TradeInfoModel class],
             @"asks" : [TradeInfoModel class]};
}

@end

@implementation TradeInfoModel

@end
