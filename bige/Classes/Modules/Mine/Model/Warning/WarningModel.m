//
//  WarningModel.m
//  bige
//
//  Created by 蔡卓越 on 2018/5/3.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "WarningModel.h"

#import "AppColorMacro.h"
#import "NSNumber+Extension.h"

@implementation WarningModel

+ (NSString *)mj_replacedKeyFromPropertyName121:(NSString *)propertyName {
    
    if ([propertyName isEqualToString:@"ID"]) {
        return @"id";
    }
    
    return propertyName;
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

/**
 获取币种数量
 */
- (NSString *)getNumWithVolume:(NSNumber *)volumeNum {
    
    CGFloat volume = [volumeNum doubleValue];
    
    if (volumeNum == 0) {
        
        return @"-";
    }
    
    NSString *result;
    
    if (volume > 1000000000000) {
        
        result = [NSString stringWithFormat:@"%.0lft", volume/1000000000000];
        return result;
    }
    
    if (volume > 1000000000) {
        
        result = [NSString stringWithFormat:@"%.0lfb", volume/1000000000];
        return result;
    }
    
    if (volume > 1000000) {
        
        result = [NSString stringWithFormat:@"%.0lfm", volume/1000000];
        return result;
    }
    
    result = [NSString stringWithFormat:@"%.0lf", volume];
    
    return result;
}

@end
