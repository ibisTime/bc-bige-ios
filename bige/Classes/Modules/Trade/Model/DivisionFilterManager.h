//
//  DivisionFilterManager.h
//  bige
//
//  Created by 蔡卓越 on 2018/5/9.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BaseModel.h"

@interface DivisionFilterManager : BaseModel
//币种名称
@property (nonatomic, copy) NSString *symbol;
//参考币种
@property (nonatomic, copy) NSString *toSymbol;
//交易买卖方向(0=买入，1=卖出)
@property (nonatomic, copy) NSString *direction;

+ (instancetype)manager;

@end
