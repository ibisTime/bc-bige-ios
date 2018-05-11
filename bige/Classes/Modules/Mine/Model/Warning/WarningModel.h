//
//  WarningModel.h
//  bige
//
//  Created by 蔡卓越 on 2018/5/3.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BaseModel.h"

@interface WarningModel : BaseModel
//图标
@property (nonatomic, copy) NSString *symbolPic;
//编号
@property (nonatomic, copy) NSString *ID;
//类型
@property (nonatomic, copy) NSString *type;
//币种名称
@property (nonatomic, copy) NSString *symbol;
//参考币种
@property (nonatomic, copy) NSString *toSymbol;
//交易所英文
@property (nonatomic, copy) NSString *exchangeEname;
//涨跌幅
@property (nonatomic, strong) NSNumber *changeRate;
//当前价格
@property (nonatomic, strong) NSNumber *currentPrice;
//预警留言
@property (nonatomic, copy) NSString *warnContent;
//预警价格
@property (nonatomic, strong) NSNumber *warnPrice;
//状态
@property (nonatomic, copy) NSString *status;

/**
 获取涨跌颜色
 */
- (UIColor *)getPercentColorWithPercent:(NSNumber *)percent;
/**
 获取涨跌幅
 */
- (NSString *)getResultWithPercent:(NSNumber *)percent;
/**
 获取币种数量
 */
- (NSString *)getNumWithVolume:(NSNumber *)volumeNum;

@end
