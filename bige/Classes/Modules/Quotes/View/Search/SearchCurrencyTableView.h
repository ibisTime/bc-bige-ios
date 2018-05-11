//
//  SearchCurrencyTableView.h
//  bige
//
//  Created by 蔡卓越 on 2018/3/21.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "TLTableView.h"
//M
#import "PlatformModel.h"

@interface SearchCurrencyTableView : TLTableView
//
@property (nonatomic, strong) NSMutableArray <PlatformModel *>*currencys;

@end
