//
//  OptionalInfoView.m
//  bige
//
//  Created by 蔡卓越 on 2018/5/2.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "OptionalInfoView.h"

//Category
#import "UILabel+Extension.h"

@interface OptionalInfoView()
//币种名称
@property (nonatomic, strong) UILabel *currencyNameLbl;
//平台名称
@property (nonatomic, strong) UILabel *symbolNameLbl;
//当前人民币价格
@property (nonatomic, strong) UILabel *rmbPriceLbl;
//涨跌情况
@property (nonatomic, strong) UILabel *priceFluctLbl;

@end

@implementation OptionalInfoView

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
    
    //币种名称
    self.currencyNameLbl = [UILabel labelWithBackgroundColor:kClearColor
                                                   textColor:kTextColor3
                                                        font:7.0];
    self.currencyNameLbl.layer.cornerRadius = 6;
    self.currencyNameLbl.clipsToBounds = YES;
    self.currencyNameLbl.layer.borderWidth = 0.5;
    self.currencyNameLbl.layer.borderColor = kTextColor3.CGColor;
    self.currencyNameLbl.textAlignment = NSTextAlignmentCenter;
    
    [self addSubview:self.currencyNameLbl];
    //平台名称
    self.symbolNameLbl = [UILabel labelWithBackgroundColor:kClearColor
                                                 textColor:kTextColor
                                                      font:13.0];
    self.symbolNameLbl.textAlignment = NSTextAlignmentCenter;
    
    [self addSubview:self.symbolNameLbl];
    //当前人民币价格
    self.rmbPriceLbl = [UILabel labelWithBackgroundColor:kClearColor
                                               textColor:kThemeColor
                                                    font:17.0];
    
    [self addSubview:self.rmbPriceLbl];
    //涨跌情况
    self.priceFluctLbl = [UILabel labelWithBackgroundColor:kClearColor
                                                 textColor:kClearColor
                                                      font:11.0];
    
    [self addSubview:self.priceFluctLbl];
    //布局
    [self setSubviewLayout];
}

- (void)setSubviewLayout {
    //币种名称
    [self.currencyNameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(@12);
        make.centerX.equalTo(@0);
        make.width.equalTo(@60);
        make.height.equalTo(@12);
    }];
    //平台名称
    [self.symbolNameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.currencyNameLbl.mas_bottom).offset(6);
        make.centerX.equalTo(self.currencyNameLbl.mas_centerX);
    }];
    //rmb价格
    [self.rmbPriceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.currencyNameLbl.mas_centerX);
        make.top.equalTo(self.symbolNameLbl.mas_bottom).offset(5);
    }];
    //涨跌情况
    [self.priceFluctLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.rmbPriceLbl.mas_bottom).offset(5);
        make.centerX.equalTo(self.currencyNameLbl.mas_centerX);
    }];
}

#pragma mark - Setting
- (void)setInfoModel:(OptionInfoModel *)infoModel {
    
    _infoModel = infoModel;
    
    //币种名称
    NSString *symbol = [infoModel.symbol uppercaseString];
    NSString *toSymbol = [infoModel.toSymbol uppercaseString];
    
    self.currencyNameLbl.text = [NSString stringWithFormat:@"%@/%@", symbol, toSymbol];
    //平台名称
    self.symbolNameLbl.text = infoModel.marketGlobal.exchangeCname;
    //当前人民币价格
    self.rmbPriceLbl.text = [NSString stringWithFormat:@"￥%.2lf", [infoModel.marketGlobal.lastCnyPrice doubleValue]];
    //涨跌情况
    NSString *priceFluctStr = [infoModel.marketGlobal getResultWithPercent:infoModel.marketGlobal.percentChange24h];
    UIColor *titleColor = [infoModel.marketGlobal getPercentColorWithPercent:infoModel.marketGlobal.percentChange24h];
    self.priceFluctLbl.text = priceFluctStr;
    self.priceFluctLbl.textColor = titleColor;
}

@end
