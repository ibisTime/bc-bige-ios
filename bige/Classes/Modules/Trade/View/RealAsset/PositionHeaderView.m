//
//  PositionHeaderView.m
//  bige
//
//  Created by 蔡卓越 on 2018/5/11.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "PositionHeaderView.h"
//Macro
#import "TLUIHeader.h"
#import "AppColorMacro.h"
//Category
#import "NSNumber+Extension.h"

@interface PositionHeaderView()
//顶部
@property (nonatomic, strong) UIView *topView;
//交易所
@property (nonatomic, strong) UILabel *exchangeLbl;
//浮动盈亏
@property (nonatomic, strong) UILabel *profitLbl;
//成本
@property (nonatomic, strong) UILabel *costLbl;
//市值
@property (nonatomic, strong) UILabel *marketPriceLbl;
//涨跌幅
@property (nonatomic, strong) UILabel *percentLbl;
//底部
@property (nonatomic, strong) UIView *bottomView;

@end

@implementation PositionHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        
        //
        [self initTopView];
        //
        [self initBottomView];
    }
    return self;
}

#pragma mark - Init
- (void)initTopView {
    
    //topLine
    UIView *topLine = [[UIView alloc] init];
    
    topLine.backgroundColor = kBackgroundColor;
    
    [self addSubview:topLine];
    [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.top.equalTo(@0);
        make.height.equalTo(@10);
    }];
    self.topView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, kScreenWidth, 60)];
    
    self.topView.backgroundColor = kWhiteColor;
    
    [self addSubview:self.topView];
    //交易所
    self.exchangeLbl = [UILabel labelWithBackgroundColor:kClearColor
                                               textColor:kTextColor
                                                    font:15.0];
    [self.topView addSubview:self.exchangeLbl];
    [self.exchangeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@15);
        make.centerY.equalTo(@0);
    }];
    //浮动盈亏
    self.profitLbl = [UILabel labelWithBackgroundColor:kClearColor
                                               textColor:kTextColor
                                                    font:15.0];
    [self.topView addSubview:self.profitLbl];
    [self.profitLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.exchangeLbl.mas_right).offset(kWidth(15));
        make.centerY.equalTo(@0);
    }];
    //成本
    self.costLbl = [UILabel labelWithBackgroundColor:kClearColor
                                             textColor:kTextColor
                                                  font:12.0];
    [self.topView addSubview:self.costLbl];
    [self.costLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.profitLbl.mas_right).offset(kWidth(44));
        make.bottom.equalTo(self.topView.mas_centerY).offset(-5);
    }];
    //市值
    self.marketPriceLbl = [UILabel labelWithBackgroundColor:kClearColor
                                           textColor:kTextColor
                                                font:12.0];
    [self.topView addSubview:self.marketPriceLbl];
    [self.marketPriceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.profitLbl.mas_right).offset(kWidth(44));
        make.top.equalTo(self.topView.mas_centerY).offset(5);
    }];
    //涨跌幅
    self.percentLbl = [UILabel labelWithBackgroundColor:kClearColor
                                              textColor:kTextColor
                                                   font:15.0];
    [self.topView addSubview:self.percentLbl];
    [self.percentLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(@(-15));
        make.centerY.equalTo(@0);
    }];
}

- (void)initBottomView {
    
    self.bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 70, kScreenWidth, 30)];
    
    self.bottomView.backgroundColor = kHexColor(@"#fbfbfc");
    
    [self addSubview:self.bottomView];
    //币种名称
    UILabel *symbolLbl = [UILabel labelWithBackgroundColor:kClearColor
                                                       textColor:kTextColor2
                                                            font:12.0];
    symbolLbl.text = @"币种";
    [self.bottomView addSubview:symbolLbl];
    [symbolLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@15);
        make.centerY.equalTo(@0);
    }];
    //浮动盈亏
    UILabel *profitLbl = [UILabel labelWithBackgroundColor:kClearColor
                                                 textColor:kTextColor2
                                                      font:12.0];
    profitLbl.text = @"浮动盈亏";
    [self.bottomView addSubview:profitLbl];
    [profitLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@(kWidth(95)));
        make.centerY.equalTo(@0);
    }];
    //总市值
    UILabel *marketPriceLbl = [UILabel labelWithBackgroundColor:kClearColor
                                                 textColor:kTextColor2
                                                      font:12.0];
    marketPriceLbl.text = @"总市值";
    [self.bottomView addSubview:marketPriceLbl];
    [marketPriceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@(kWidth(180)));
        make.centerY.equalTo(@0);
    }];
    //平均持仓成本
    UILabel *avgCostLbl = [UILabel labelWithBackgroundColor:kClearColor
                                                 textColor:kTextColor2
                                                      font:12.0];
    avgCostLbl.text = @"平均持仓成本";
    [self.bottomView addSubview:avgCostLbl];
    [avgCostLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(@(-15));
        make.centerY.equalTo(@0);
    }];
    
}

#pragma mark - Setting
- (void)setAsset:(AssetInfo *)asset {
    
    _asset = asset;
    
    //交易所
    self.exchangeLbl.text = asset.exchange;
    //浮动盈亏
    self.profitLbl.text = [asset.totalProfit convertToRealMoneyWithNum:2];
    //成本
    self.costLbl.text = [NSString stringWithFormat:@"成本 %@", [asset.totalCost convertToRealMoneyWithNum:2]];
    //市值
    self.marketPriceLbl.text = [NSString stringWithFormat:@"市值 %@", [asset.totalMarketPrice convertToRealMoneyWithNum:2]];
    //涨跌幅
    self.percentLbl.text = [asset getResultWithPercent:asset.percentChange];
    self.percentLbl.textColor = [asset getPercentColorWithPercent:asset.percentChange];
    
}

@end
