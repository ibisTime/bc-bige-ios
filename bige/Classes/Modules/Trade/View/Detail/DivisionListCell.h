//
//  DivisionListCell.h
//  bige
//
//  Created by 蔡卓越 on 2018/5/8.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BaseTableViewCell.h"
//M
#import "DivisionModel.h"

@interface DivisionListCell : BaseTableViewCell
//
@property (nonatomic, strong) DivisionModel *division;
//撤消
@property (nonatomic, strong) UIButton *cancelBtn;

@end
