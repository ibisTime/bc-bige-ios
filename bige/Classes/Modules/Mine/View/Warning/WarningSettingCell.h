//
//  WarningSettingCell.h
//  bige
//
//  Created by 蔡卓越 on 2018/5/3.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BaseTableViewCell.h"
//M
#import "WarningModel.h"

@interface WarningSettingCell : BaseTableViewCell
//
@property (nonatomic, strong) WarningModel *warning;
//留言
@property (nonatomic, strong) UIButton *leaveBtn;

@end
