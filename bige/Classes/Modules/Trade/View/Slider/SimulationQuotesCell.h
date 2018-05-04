//
//  SimulationQuotesCell.h
//  bige
//
//  Created by 蔡卓越 on 2018/5/4.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BaseTableViewCell.h"

//M
#import "PlatformModel.h"
#import "OptionInfoModel.h"

@interface SimulationQuotesCell : BaseTableViewCell
//
@property (nonatomic, strong) PlatformModel *quotes;
@property (nonatomic, strong) OptionInfoModel *infoModel;

@end
