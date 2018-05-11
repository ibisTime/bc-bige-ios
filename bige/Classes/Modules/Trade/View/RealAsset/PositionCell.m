//
//  PositionCell.m
//  bige
//
//  Created by 蔡卓越 on 2018/5/11.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "PositionCell.h"
//Category
#import "UILabel+Extension.h"
#import "NSString+Extension.h"
#import <UIImageView+WebCache.h>
#import "NSNumber+Extension.h"

@interface PositionCell()
//币种名称
@property (nonatomic, strong) UILabel *symbolLbl;
//币种图片
@property (nonatomic, strong) UIImageView *iconIV;
//浮动盈亏
@property (nonatomic, strong) UILabel *profitLbl;
//总市值
@property (nonatomic, strong) UILabel *marketPriceLbl;
//平均持仓成本
@property (nonatomic, strong) UILabel *avgCostLbl;

@end

@implementation PositionCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self initSubviews];
        
    }
    
    return self;
}

#pragma mark - Init
- (void)initSubviews {
    
    //币种图片
    self.iconIV = [[UIImageView alloc] init];
    
    [self addSubview:self.iconIV];
    //币种名称
    self.symbolLbl = [UILabel labelWithBackgroundColor:kClearColor
                                                 textColor:kTextColor
                                                      font:13.0];
    [self addSubview:self.symbolLbl];
    //浮动盈亏
    self.profitLbl = [UILabel labelWithBackgroundColor:kClearColor
                                                 textColor:kTextColor2
                                                      font:12.0];
    [self addSubview:self.profitLbl];
    
    //总市值
    self.marketPriceLbl = [UILabel labelWithBackgroundColor:kClearColor
                                                      textColor:kTextColor
                                                           font:12.0];
    [self addSubview:self.marketPriceLbl];
    
    //平均持仓成本
    self.avgCostLbl = [UILabel labelWithBackgroundColor:kClearColor
                                                  textColor:kTextColor
                                                       font:12.0];
    [self addSubview:self.avgCostLbl];
    //布局
    [self setSubviewLayout];
}

- (void)setSubviewLayout {
    
    //币种图片
    [self.iconIV mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@15);
        make.width.height.equalTo(@16);
        make.centerY.equalTo(@0);
    }];
    //币种名称
    [self.symbolLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.iconIV.mas_right).offset(10);
        make.centerY.equalTo(@0);
    }];
    //浮动盈亏
    [self.profitLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@(kWidth(95)));
        make.centerY.equalTo(@0);
    }];
    //总市值
    [self.marketPriceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@(kWidth(180)));
        make.centerY.equalTo(@0);
    }];
    //平均持仓成本
    [self.avgCostLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.mas_right).offset(-90);
        make.centerY.equalTo(@0);
    }];
}

#pragma mark - Setting
- (void)setAccountInfo:(AccountInfo *)accountInfo {
    
    _accountInfo = accountInfo;
    //图片
    [self.iconIV sd_setImageWithURL:[NSURL URLWithString:[accountInfo.symbolPic convertImageUrl]]
                   placeholderImage:kImage(@"默认图标")];
    //币种名称
    self.symbolLbl.text = [accountInfo.symbol uppercaseString];
    //浮动盈亏
    self.profitLbl.text = [accountInfo.totalProfit convertToRealMoneyWithNum:2];
    self.profitLbl.textColor = [accountInfo getPercentColorWithPercent:accountInfo.totalProfit];
    //总市值
    self.marketPriceLbl.text = [accountInfo.totalMarketPrice convertToRealMoneyWithNum:2];
    //平均持仓成本
    self.avgCostLbl.text = [accountInfo.avgCost convertToRealMoneyWithNum:2];
}

@end
