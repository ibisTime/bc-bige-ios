//
//  AccountModel.h
//  bige
//
//  Created by 蔡卓越 on 2018/5/7.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BaseModel.h"

@interface AccountModel : BaseModel

@property (nonatomic,copy) NSString *accountNumber;
//总额
@property (nonatomic,strong) NSNumber *amount;
//冻结金额
@property (nonatomic,strong) NSNumber *frozenAmount;
@property (nonatomic,copy) NSString *currency;

@property (nonatomic,copy) NSString *status;
@property (nonatomic,copy) NSString *systemCode;
@property (nonatomic,copy) NSString *type;
@property (nonatomic,copy) NSString *userId;

@end
