//
//  TradeListCell.h
//  bige
//
//  Created by 蔡卓越 on 2018/5/8.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BaseTableViewCell.h"
//M
#import "TradeListModel.h"

@interface TradeListCell : BaseTableViewCell
//
@property (nonatomic, strong) TradeInfoModel *tradeInfo;
//价格
@property (nonatomic, strong) UILabel *priceLbl;

@end
