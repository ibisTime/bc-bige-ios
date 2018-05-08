//
//  DivisionModel.h
//  bige
//
//  Created by 蔡卓越 on 2018/5/8.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BaseModel.h"

@interface DivisionModel : BaseModel

//编号
@property (nonatomic, copy) NSString *code;
//状态（0=已提交，1=部分成交，2=部分成交撤销，3=完全成交，4=已撤销）
@property (nonatomic, copy) NSString *status;
//币种名称
@property (nonatomic, copy) NSString *symbol;
//参考币种
@property (nonatomic, copy) NSString *toSymbol;
//交易所
@property (nonatomic, copy) NSString *exchange;
//交易类型（0=市价，1=限价）type=1时必填，委托价格
@property (nonatomic, copy) NSString *type;
//交易买卖方向(0=买入，1=卖出)
@property (nonatomic, copy) NSString *direction;
//下单时间
@property (nonatomic, copy) NSString *createDatetime;
//实际交易数量
@property (nonatomic, strong) NSNumber *tradedCount;
//总数量
@property (nonatomic, strong) NSNumber *totalCount;
//价格
@property (nonatomic, strong) NSNumber *price;

@end
