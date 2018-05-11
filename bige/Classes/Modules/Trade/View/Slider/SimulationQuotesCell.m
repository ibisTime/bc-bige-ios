//
//  SimulationQuotesCell.m
//  bige
//
//  Created by 蔡卓越 on 2018/5/4.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "SimulationQuotesCell.h"
//Category
#import "UILabel+Extension.h"
#import "NSString+CGSize.h"
#import "NSString+Extension.h"
#import <UIImageView+WebCache.h>
#import "NSNumber+Extension.h"

@interface SimulationQuotesCell()
//币种名称
@property (nonatomic, strong) UILabel *currencyNameLbl;
//当前对应币种
@property (nonatomic, strong) UILabel *opppsitePriceLbl;
//涨跌情况
@property (nonatomic, strong) UILabel *priceFluctLbl;

@end

@implementation SimulationQuotesCell

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
    //当前对应币种价格
    self.opppsitePriceLbl = [UILabel labelWithBackgroundColor:kClearColor
                                                    textColor:kTextColor4
                                                         font:13.0];
    
    [self addSubview:self.opppsitePriceLbl];
    //涨跌情况
    self.priceFluctLbl = [UILabel labelWithBackgroundColor:kClearColor
                                                 textColor:kWhiteColor
                                                      font:12.0];
    self.priceFluctLbl.textAlignment = NSTextAlignmentRight;
    
    [self addSubview:self.priceFluctLbl];

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
        
        make.centerY.equalTo(@0);
        make.left.equalTo(self.mas_left).offset(15);
    }];
    //涨幅
    [self.priceFluctLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(@(-15));
        make.centerY.equalTo(@0);
        make.height.equalTo(@37);
    }];
    //对应币种
    [self.opppsitePriceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(@0);
        make.centerX.equalTo(@0);
        make.width.equalTo(@120);
    }];
    
}

#pragma mark - Data
- (void)setQuotes:(PlatformModel *)quotes {
    
    _quotes = quotes;
    //币种名称
    self.currencyNameLbl.text = [quotes.symbol uppercaseString];
    //对应币种价格
    self.opppsitePriceLbl.text = [NSString stringWithFormat:@"￥%@", [quotes.lastCnyPrice convertToRealMoneyWithNum:8]];
    //涨跌幅
    NSString *fluctStr = [quotes getResultWithPercent:quotes.percentChange];
    self.priceFluctLbl.text = fluctStr;
    
    UIColor *fluctColor = [quotes getPercentColorWithPercent:quotes.percentChange];
    self.priceFluctLbl.textColor = fluctColor;
    self.opppsitePriceLbl.textColor = fluctColor;

    CGFloat btnW = [NSString getWidthWithString:fluctStr font:16.0] + 15;
    [self.priceFluctLbl mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(@(btnW > 75 ? btnW: 75));
    }];
}

- (void)setInfoModel:(OptionInfoModel *)infoModel {
    
    _infoModel = infoModel;
    
    //币种名称
    self.currencyNameLbl.text = [infoModel.symbol uppercaseString];
    //对应币种价格
    self.opppsitePriceLbl.text = [NSString stringWithFormat:@"￥%@", [infoModel.marketGlobal.lastCnyPrice convertToRealMoneyWithNum:8]];
    //涨跌幅
    NSString *fluctStr = [infoModel.marketGlobal getResultWithPercent:infoModel.marketGlobal.percentChange];
    self.priceFluctLbl.text = fluctStr;
    UIColor *fluctColor = [infoModel.marketGlobal getPercentColorWithPercent:infoModel.marketGlobal.percentChange];
    self.priceFluctLbl.textColor = fluctColor;
    self.opppsitePriceLbl.textColor = fluctColor;

    CGFloat btnW = [NSString getWidthWithString:fluctStr font:16.0] + 15;
    [self.priceFluctLbl mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(@(btnW > 75 ? btnW: 75));
    }];
    
}

@end
