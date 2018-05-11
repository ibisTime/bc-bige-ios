//
//  CurrentDivisionTableView.h
//  bige
//
//  Created by 蔡卓越 on 2018/5/9.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "TLTableView.h"
//M
#import "DivisionModel.h"

/**
 当前委托
 */
@interface CurrentDivisionTableView : TLTableView
//
@property (nonatomic, strong) NSMutableArray <DivisionModel *>*divisionList;

@end
