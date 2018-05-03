//
//  WarningSettingTableView.h
//  bige
//
//  Created by 蔡卓越 on 2018/5/3.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "TLTableView.h"
//V
#import "WarningModel.h"

@interface WarningSettingTableView : TLTableView
//
@property (nonatomic, strong) NSMutableArray <WarningModel *>*warnings;

@end
