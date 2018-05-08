//
//  DivisionListTableView.h
//  bige
//
//  Created by 蔡卓越 on 2018/5/8.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "TLTableView.h"
//M
#import "DivisionModel.h"

/**
 委托列表
 */
@interface DivisionListTableView : TLTableView
//
@property (nonatomic, strong) NSMutableArray <DivisionModel *>*divisionList;

@end
