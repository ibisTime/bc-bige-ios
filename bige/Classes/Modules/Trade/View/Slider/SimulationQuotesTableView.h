//
//  SimulationQuotesTableView.h
//  bige
//
//  Created by 蔡卓越 on 2018/5/4.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "TLTableView.h"
//M
#import "PlatformModel.h"
#import "OptionInfoModel.h"

@interface SimulationQuotesTableView : TLTableView
//
@property (nonatomic, strong) NSMutableArray <PlatformModel *>*quotesList;
//
@property (nonatomic, strong) NSMutableArray <OptionInfoModel *>*options;
//
@property (nonatomic, assign) NSInteger currentIndex;

@end
