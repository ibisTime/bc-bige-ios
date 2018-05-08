//
//  SimulationQuotesListVC.h
//  bige
//
//  Created by 蔡卓越 on 2018/5/4.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BaseViewController.h"

//M
#import "PlatformModel.h"
#import "OptionInfoModel.h"

//
@interface SimulationQuotesListVC : BaseViewController
//
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, copy) void(^didSelectOptional)(OptionInfoModel *infoModel);
@property (nonatomic, copy) void(^didSelectQuotes)(PlatformModel *quotes);

@end
