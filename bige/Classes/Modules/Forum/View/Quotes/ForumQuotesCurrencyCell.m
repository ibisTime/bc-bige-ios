//
//  ForumQuotesCurrencyCell.m
//  bige
//
//  Created by 蔡卓越 on 2018/4/4.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "ForumQuotesCurrencyCell.h"
//Category
#import "UILabel+Extension.h"
#import "NSString+CGSize.h"
#import "NSString+Extension.h"

@interface ForumQuotesCurrencyCell()

//平台名称
@property (nonatomic, strong) UILabel *platformNameLbl;
//币种/对应币种
@property (nonatomic, strong) UILabel *opppsiteNameLbl;
//当前对应币种
@property (nonatomic, strong) UILabel *opppsitePriceLbl;
//当前人民币价格
@property (nonatomic, strong) UILabel *rmbPriceLbl;
//涨跌情况
@property (nonatomic, strong) UIButton *priceFluctBtn;

@end

@implementation ForumQuotesCurrencyCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self initSubviews];
    }
    
    return self;
}

#pragma mark - Init
- (void)initSubviews {
    
    //平台名称
    self.platformNameLbl = [UILabel labelWithBackgroundColor:kClearColor
                                                   textColor:kTextColor
                                                        font:17.0];
    
    [self addSubview:self.platformNameLbl];
    //币种/对应币种
    self.opppsiteNameLbl = [UILabel labelWithBackgroundColor:kClearColor
                                                textColor:kTextColor2
                                                     font:15.0];
    
    [self addSubview:self.opppsiteNameLbl];
    //涨跌情况
    self.priceFluctBtn = [UIButton buttonWithTitle:@""
                                        titleColor:kWhiteColor
                                   backgroundColor:kClearColor
                                         titleFont:17.0 cornerRadius:5];
    
    [self addSubview:self.priceFluctBtn];
    //当前对应币种价格
    self.opppsitePriceLbl = [UILabel labelWithBackgroundColor:kClearColor
                                                    textColor:kHexColor(@"#595A6E")
                                                         font:12.0];
    
    [self addSubview:self.opppsitePriceLbl];
    
    //当前人民币价格
    self.rmbPriceLbl = [UILabel labelWithBackgroundColor:kClearColor
                                               textColor:kTextColor
                                                    font:14.0];
    
    [self addSubview:self.rmbPriceLbl];
    //布局
    [self setSubviewLayout];
}

- (void)setSubviewLayout {
    
    //平台
    [self.platformNameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@15);
        make.centerY.equalTo(@0);
    }];
    //币种/对应币种
    [self.opppsiteNameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.platformNameLbl.mas_right).offset(10);
        make.centerY.equalTo(@0);
    }];
    //涨幅
    [self.priceFluctBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(@(-15));
        make.centerY.equalTo(@0);
        make.height.equalTo(@37);
    }];
    //rmb价格
    [self.rmbPriceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.priceFluctBtn.mas_left).offset(-15);
        make.top.equalTo(@10);
    }];
    //对应币种
    [self.opppsitePriceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.priceFluctBtn.mas_left).offset(-15);
        make.top.equalTo(self.rmbPriceLbl.mas_bottom).offset(10);
    }];
    
}

#pragma mark - Setting
- (void)setCurrency:(CurrencyModel *)currency {
    
    _currency = currency;
    
    //平台名称
    self.platformNameLbl.text = [NSString stringWithFormat:@"%@", currency.exchangeCname];
    //币种/对应币种
    self.opppsiteNameLbl.text = [NSString stringWithFormat:@"%@/%@", currency.coinSymbol,currency.toCoinSymbol];
    //对应币种价格
    self.opppsitePriceLbl.text = [NSString stringWithFormat:@"%@", currency.lastPrice];
    
    //人民币价格
    self.rmbPriceLbl.text = [NSString stringWithFormat:@"￥%@", currency.lastCnyPrice];
    self.rmbPriceLbl.textColor = currency.bgColor;
    
    //涨跌情况
    NSString *priceFluctStr = currency.percentChange;
    CGFloat fluct = [priceFluctStr doubleValue];
    
    if (fluct > 0) {
        
        priceFluctStr = [NSString stringWithFormat:@"+%@%%", priceFluctStr];
        
    } else  {
        
        priceFluctStr = [NSString stringWithFormat:@"%@%%", priceFluctStr];
    }
    
    [self.priceFluctBtn setTitle:priceFluctStr forState:UIControlStateNormal];
    [self.priceFluctBtn setBackgroundColor:currency.bgColor forState:UIControlStateNormal];
    
    CGFloat btnW = [NSString getWidthWithString:priceFluctStr font:16.0] + 15;
    [self.priceFluctBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(@(btnW > 75 ? btnW: 75));
    }];
    
}

@end
