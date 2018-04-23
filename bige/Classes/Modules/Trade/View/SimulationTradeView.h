//
//  SimulationTradeView.h
//  bige
//
//  Created by 蔡卓越 on 2018/4/23.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BaseView.h"
//M
#import "SimulationTradeInfoModel.h"

typedef void(^SimulationTradeBlock)(NSString *type);

@interface SimulationTradeView : BaseView

@property (nonatomic, copy) SimulationTradeBlock tradeBlock;
//
@property (nonatomic, strong) SimulationTradeInfoModel *infoModel;

@end
