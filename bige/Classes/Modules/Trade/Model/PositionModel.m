//
//  PositionModel.m
//  bige
//
//  Created by 蔡卓越 on 2018/5/11.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "PositionModel.h"
#import "AppColorMacro.h"
#import "NSNumber+Extension.h"

@implementation PositionModel

+ (NSDictionary *)objectClassInArray {
    
    return @{@"assetList" : [AssetInfo class]};
}
    
@end

@implementation AssetInfo

+ (NSDictionary *)objectClassInArray {
    
    return @{@"accountList" : [AccountInfo class]};
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

@implementation AccountInfo

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

@end
