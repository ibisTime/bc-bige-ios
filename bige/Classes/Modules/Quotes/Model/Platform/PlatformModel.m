//
//  PlatformModel.m
//  bige
//
//  Created by 蔡卓越 on 2018/3/21.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "PlatformModel.h"
#import "AppColorMacro.h"
#import "NSNumber+Extension.h"

@implementation PlatformModel

/**
 小写转大写
 */
- (NSString *)symbol {
    
    return [_symbol uppercaseString];
}

- (UIColor *)bgColor {
    
    CGFloat fluct = [self.percentChange doubleValue];
    
    if (fluct > 0) {
        
        return kRiseColor;
        
    } else if (fluct == 0) {
        
        return kHexColor(@"#979797");
    }
    
    return kThemeColor;
}

/**
 排名背景色
 */
- (UIColor *)rankColor {
    
    if (self.rank == 1) {
        
        return kHexColor(@"#348ff6");
        
    } else if (self.rank == 2) {
        
        return kHexColor(@"#73b3fc");
        
    } else if (self.rank == 3) {
        
        return kHexColor(@"#a4cdfc");
    }
    
    return kWhiteColor;
}

- (UIColor *)flowBgColor {
    
    CGFloat fluct = [self.flow_percent_change_24h doubleValue];
    
    if (fluct > 0) {
        
        return kRiseColor;
        
    } else if (fluct == 0) {
        
        return kHexColor(@"#979797");
    }
    
    return kThemeColor;
}

- (NSString *)tradeVolume {
    
    CGFloat volume = [self.volume doubleValue];
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

/**
 转换百分比
 */
- (NSString *)changeRate {
    
    return [NSNumber mult1:[self.percentChange stringValue] mult2:@"100" scale:2];
}

@end
