//
//  SearchCurrencyCell.m
//  bige
//
//  Created by 蔡卓越 on 2018/3/22.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "SearchCurrencyCell.h"
//Category
#import "UILabel+Extension.h"
#import "NSString+CGSize.h"
#import "NSString+Extension.h"
#import <UIImageView+WebCache.h>
#import "NSNumber+Extension.h"

@interface SearchCurrencyCell()
//币种名称
@property (nonatomic, strong) UILabel *currencyNameLbl;
//平台名称
@property (nonatomic, strong) UILabel *exchangeNameLbl;
//当前对应币种
@property (nonatomic, strong) UILabel *opppsitePriceLbl;
//当前人民币价格
@property (nonatomic, strong) UILabel *rmbPriceLbl;
//涨跌情况
@property (nonatomic, strong) UIButton *priceFluctBtn;

@end

@implementation SearchCurrencyCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self initSubviews];
    }
    
    return self;
}

#pragma mark - Init
- (void)initSubviews {
    
    //币种名称
    self.currencyNameLbl = [UILabel labelWithBackgroundColor:kClearColor
                                                   textColor:kTextColor
                                                        font:13.0];
    
    [self addSubview:self.currencyNameLbl];
    //平台名称
    self.exchangeNameLbl = [UILabel labelWithBackgroundColor:kClearColor
                                                  textColor:kTextColor
                                                       font:12.0];
    
    [self addSubview:self.exchangeNameLbl];
    //涨跌情况
    self.priceFluctBtn = [UIButton buttonWithTitle:@""
                                        titleColor:kWhiteColor
                                   backgroundColor:kClearColor
                                         titleFont:14.0 cornerRadius:5];
    
    [self addSubview:self.priceFluctBtn];
    
    //关注情况
    self.followBtn = [UIButton buttonWithImageName:@"币种未关注"];
    
    [self addSubview:self.followBtn];
    //当前对应币种价格
    self.opppsitePriceLbl = [UILabel labelWithBackgroundColor:kClearColor
                                                    textColor:kTextColor4
                                                         font:12.0];
    
    [self addSubview:self.opppsitePriceLbl];
    
    //当前人民币价格
    self.rmbPriceLbl = [UILabel labelWithBackgroundColor:kClearColor
                                               textColor:kTextColor
                                                    font:14.0];
    
    [self addSubview:self.rmbPriceLbl];
    //bottomLine
    UIView *bottomLine = [[UIView alloc] init];
    
    bottomLine.backgroundColor = kLineColor;
    
    [self addSubview:bottomLine];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.bottom.equalTo(@0);
        make.height.equalTo(@0.5);
        
    }];
    //布局
    [self setSubviewLayout];
}

- (void)setSubviewLayout {
    
    //币种名称
    [self.currencyNameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(@10);
        make.left.equalTo(@15);
    }];
    //平台名称
    [self.exchangeNameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.currencyNameLbl.mas_bottom).offset(10);
        make.left.equalTo(self.currencyNameLbl.mas_left);
    }];
    //关注
    [self.followBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(@0);
        make.centerY.equalTo(@0);
        make.width.height.equalTo(@45);
    }];
    //涨幅
    [self.priceFluctBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.followBtn.mas_left);
        make.centerY.equalTo(@0);
        make.height.equalTo(@27);
    }];
    //rmb价格
    [self.rmbPriceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.priceFluctBtn.mas_left).offset(-15);
        make.top.equalTo(self.currencyNameLbl.mas_top);
    }];
    //对应币种
    [self.opppsitePriceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.priceFluctBtn.mas_left).offset(-15);
        make.top.equalTo(self.exchangeNameLbl.mas_top);
    }];
    
}

#pragma mark - Setting
- (void)setPlatform:(PlatformModel *)platform {
    
    _platform = platform;
    
    //币种名称
    self.currencyNameLbl.text = [NSString stringWithFormat:@"%@/%@", [platform.symbol uppercaseString], [platform.toSymbol uppercaseString]];
    //平台名称
    self.exchangeNameLbl.text = [NSString stringWithFormat:@"%@", platform.exchangeCname];
    
    //对应币种价格
    self.opppsitePriceLbl.text = [NSString stringWithFormat:@"%@", [platform.lastPrice convertToRealMoneyWithNum:8]];
    //人民币价格
    self.rmbPriceLbl.text = [NSString stringWithFormat:@"￥%.2lf", [platform.lastCnyPrice doubleValue]];
    self.rmbPriceLbl.textColor = platform.bgColor;
    //涨跌情况
    NSString *priceFluctStr = platform.changeRate;
    CGFloat fluct = [priceFluctStr doubleValue];
    
    if (fluct > 0) {
        
        priceFluctStr = [NSString stringWithFormat:@"+%@%%", priceFluctStr];
        
    } else  {
        
        priceFluctStr = [NSString stringWithFormat:@"%@%%", priceFluctStr];
    }
    
    [self.priceFluctBtn setTitle:priceFluctStr forState:UIControlStateNormal];
    [self.priceFluctBtn setBackgroundColor:platform.bgColor forState:UIControlStateNormal];
    
    CGFloat btnW = [NSString getWidthWithString:priceFluctStr font:16.0] + 15;
    [self.priceFluctBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(@(btnW > 75 ? btnW: 75));
    }];
    //关注情况
    if ([platform.isChoice isEqualToString:@"0"]) {
        
        [self.followBtn setImage:kImage(@"币种未关注") forState:UIControlStateNormal];
    } else {
        
        [self.followBtn setImage:kImage(@"币种关注") forState:UIControlStateNormal];
    }
}

@end
