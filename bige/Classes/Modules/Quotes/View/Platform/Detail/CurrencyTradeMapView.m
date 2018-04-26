//
//  CurrencyTradeMapView.m
//  bige
//
//  Created by 蔡卓越 on 2018/4/25.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "CurrencyTradeMapView.h"
//Manager
#import "AppConfig.h"
//Category
#import "UILabel+Extension.h"
//V
#import "DetailWebView.h"

@interface CurrencyTradeMapView()

//买卖实图
@property (nonatomic, strong) DetailWebView *tradeView;

@end

@implementation CurrencyTradeMapView

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
    //买
    UILabel *buyLbl = [UILabel labelWithBackgroundColor:kClearColor
                                                    textColor:kTextColor4
                                                         font:11.0];
    buyLbl.text = @"买";
    [self addSubview:buyLbl];
    [buyLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@15);
        make.top.equalTo(@15);
    }];
    //卖
    UILabel *sellLbl = [UILabel labelWithBackgroundColor:kClearColor
                                              textColor:kTextColor4
                                                   font:11.0];
    sellLbl.text = @"卖";
    [self addSubview:sellLbl];
    [sellLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(@(-15));
        make.top.equalTo(@15);
    }];
    
}

- (DetailWebView *)tradeView {
    
    if (!_tradeView) {
        
        BaseWeakSelf;
        
        _tradeView = [[DetailWebView alloc] initWithFrame:CGRectMake(0, 30, kScreenWidth, 150)];
        
        _tradeView.webViewBlock = ^(CGFloat height) {
            
            [weakSelf setSubViewLayoutWithHeight:height];
        };
        
        [self addSubview:_tradeView];
    }
    return _tradeView;
}

/**
 调整视图高度
 */
- (void)setSubViewLayoutWithHeight:(CGFloat)height {
    
    
}

#pragma mark - Setting
- (void)setPlatform:(PlatformModel *)platform {
    
    _platform = platform;
    
    //买卖实图
    //交易对
    NSString *symbol = [NSString stringWithFormat:@"%@%@", platform.symbol, platform.toSymbol];
    NSString *html = [NSString stringWithFormat:@"%@/charts/buySellBar.html?symbol=%@&exchange=%@",@"http://47.52.236.63:2303", symbol, platform.exchangeEname];
    NSLog(@"html = %@", html);
    
    [self.tradeView loadRequestWithString:html];
}

@end
