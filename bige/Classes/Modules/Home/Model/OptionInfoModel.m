//
//  OptionInfoModel.m
//  bige
//
//  Created by 蔡卓越 on 2018/5/2.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "OptionInfoModel.h"
#import "AppColorMacro.h"
#import "NSNumber+Extension.h"

@implementation OptionInfoModel

@end

@implementation MarketGlobal

+ (NSString *)mj_replacedKeyFromPropertyName121:(NSString *)propertyName {
    
    if ([propertyName isEqualToString:@"ID"]) {
        return @"id";
    }
    return propertyName;
}

- (UIColor *)bgColor {
    
    return [self getPercentColorWithPercent:self.percentChange];
}

/**
 获取涨跌颜色
 */
- (UIColor *)getPercentColorWithPercent:(NSNumber *)percent {
    
    CGFloat fluct = [percent doubleValue];
    
    if (fluct > 0) {
        
        return kRiseColor;
        
    } else if (fluct == 0) {
        
        return kHexColor(@"#979797");
    }
    
    return kThemeColor;
}

/**
 获取涨跌幅
 */
- (NSString *)getResultWithPercent:(NSNumber *)percent {
    
    NSString *priceFluctStr;
    
    CGFloat fluct = [percent doubleValue]*100;
    
    if (fluct > 0) {
        
        priceFluctStr = [NSString stringWithFormat:@"+%.2lf%%", fluct];
        
    } else  {
        
        priceFluctStr = [NSString stringWithFormat:@"%.2lf%%", fluct];
    }
    
    return priceFluctStr;
}

@end
