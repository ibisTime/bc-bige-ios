//
//  QuotesCurrencyVC.h
//  bige
//
//  Created by 蔡卓越 on 2018/3/21.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BaseViewController.h"
//M
#import "CurrencyTitleModel.h"
//V
#import "CurrencyTableVIew.h"
/**
 币种
 */
@interface QuotesCurrencyVC : BaseViewController
//
@property (nonatomic, assign) CurrencyType type;
//类型
@property (nonatomic, copy) NSString *kind;
//币种编号
@property (nonatomic, copy) NSString *code;
//title
@property (nonatomic, strong) CurrencyTitleModel *titleModel;
//当前索引
@property (nonatomic, assign) NSInteger currentIndex;

@end
