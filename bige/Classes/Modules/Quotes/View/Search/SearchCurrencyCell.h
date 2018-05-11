//
//  SearchCurrencyCell.h
//  bige
//
//  Created by 蔡卓越 on 2018/3/22.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BaseTableViewCell.h"
//M
#import "PlatformModel.h"

@interface SearchCurrencyCell : BaseTableViewCell
//
@property (nonatomic, strong) PlatformModel *platform;
//关注情况
@property (nonatomic, strong) UIButton *followBtn;

@end
