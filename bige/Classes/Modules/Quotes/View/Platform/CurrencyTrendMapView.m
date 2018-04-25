//
//  CurrencyTrendMapView.m
//  bige
//
//  Created by 蔡卓越 on 2018/4/25.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "CurrencyTrendMapView.h"

//Manager
#import "AppConfig.h"
//Category
#import "UILabel+Extension.h"
//V
#import "DetailWebView.h"

@interface CurrencyTrendMapView()

//一天涨跌幅
@property (nonatomic, strong) UILabel *oneDayPercentLbl;
//一周涨跌幅
@property (nonatomic, strong) UILabel *oneWeekPercentLbl;
//一月涨跌幅
@property (nonatomic, strong) UILabel *oneMonthPercentLbl;
//趋势图
@property (nonatomic, strong) DetailWebView *trendView;

@end

@implementation CurrencyTrendMapView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubviews];
    }
    return self;
}

#pragma mark - Init
- (void)initSubviews {
    
    self.backgroundColor = kWhiteColor;
    //一天涨跌幅
    self.oneDayPercentLbl = [UILabel labelWithBackgroundColor:kClearColor
                                                     textColor:kTextColor4
                                                          font:11.0];
    [self addSubview:self.oneDayPercentLbl];
    [self.oneDayPercentLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@15);
        make.top.equalTo(@15);
    }];
    //一周涨跌幅
    self.oneWeekPercentLbl = [UILabel labelWithBackgroundColor:kClearColor
                                                     textColor:kTextColor4
                                                          font:11.0];
    self.oneWeekPercentLbl.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.oneWeekPercentLbl];
    [self.oneWeekPercentLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(@0);
        make.top.equalTo(@15);
    }];
    //一月涨跌幅
    self.oneMonthPercentLbl = [UILabel labelWithBackgroundColor:kClearColor
                                                    textColor:kTextColor4
                                                         font:11.0];
    [self addSubview:self.oneMonthPercentLbl];
    [self.oneMonthPercentLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(@(-15));
        make.top.equalTo(@15);
    }];
    
}

- (DetailWebView *)trendView {
    
    if (!_trendView) {
        
        BaseWeakSelf;
        
        _trendView = [[DetailWebView alloc] initWithFrame:CGRectMake(0, 35, kScreenWidth, 155)];
        
        _trendView.webViewBlock = ^(CGFloat height) {
            
            [weakSelf setSubViewLayoutWithHeight:height];
        };
        [self addSubview:_trendView];
    }
    return _trendView;
}

/**
 调整视图高度
 */
- (void)setSubViewLayoutWithHeight:(CGFloat)height {
    
    
}

#pragma mark - Setting
- (void)setPlatform:(PlatformModel *)platform {
    
    _platform = platform;
    //一天涨跌幅
    NSString *oneDayPercent = [platform getResultWithPercent:platform.percentChange24h];
    NSString *oneDay = [NSString stringWithFormat:@"1天: %@", oneDayPercent];
    UIColor *oneDayPercentColor = [platform getPercentColorWithPercent:platform.percentChange24h];
    [self.oneDayPercentLbl labelWithString:oneDay
                                     title:oneDayPercent
                                      font:Font(11.0)
                                     color:oneDayPercentColor];
    //一周涨跌幅
    NSString *oneWeekPercent = [platform getResultWithPercent:platform.percentChange7d];
    NSString *oneWeek = [NSString stringWithFormat:@"1周: %@", oneWeekPercent];
    UIColor *oneWeekPercentColor = [platform getPercentColorWithPercent:platform.percentChange7d];
    [self.oneWeekPercentLbl labelWithString:oneWeek
                                     title:oneWeekPercent
                                      font:Font(11.0)
                                     color:oneWeekPercentColor];
    //一月涨跌幅
    NSString *oneMonthPercent = [platform getResultWithPercent:platform.percentChange1m];
    NSString *oneMonth = [NSString stringWithFormat:@"1月: %@", oneMonthPercent];
    UIColor *oneMonthPercentColor = [platform getPercentColorWithPercent:platform.percentChange1m];
    [self.oneMonthPercentLbl labelWithString:oneMonth
                                     title:oneMonthPercent
                                      font:Font(11.0)
                                     color:oneMonthPercentColor];
    //趋势图
    //交易对
    NSString *symbol = [NSString stringWithFormat:@"%@%@", platform.symbol, platform.toSymbol];
    NSString *html = [NSString stringWithFormat:@"%@/charts/marketLine.html?symbol=%@&exchange=%@&period=60min",@"http://47.52.236.63:2303", symbol, platform.exchangeEname];
    NSLog(@"html = %@", html);
    
    [self.trendView loadRequestWithString:html];
}

@end
