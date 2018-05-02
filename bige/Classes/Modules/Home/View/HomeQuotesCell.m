//
//  HomeQuotesCell.m
//  bige
//
//  Created by 蔡卓越 on 2018/5/2.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "HomeQuotesCell.h"
//Category
#import "UILabel+Extension.h"
#import "NSString+CGSize.h"
#import "NSString+Extension.h"
#import <UIImageView+WebCache.h>
#import "NSNumber+Extension.h"

@interface HomeQuotesCell()
//排行
@property (nonatomic, strong) UILabel *rankLbl;
//图标
@property (nonatomic, strong) UIImageView *iconIV;
//币种名称
@property (nonatomic, strong) UILabel *currencyNameLbl;
//24H交易量
@property (nonatomic, strong) UILabel *tradeVolumeLbl;
//当前对应币种
@property (nonatomic, strong) UILabel *opppsitePriceLbl;
//当前人民币价格
@property (nonatomic, strong) UILabel *rmbPriceLbl;
//涨跌情况
@property (nonatomic, strong) UIButton *priceFluctBtn;

@end

@implementation HomeQuotesCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self initSubviews];
    }
    
    return self;
}

#pragma mark - Init
- (void)initSubviews {
    
    //排名
    self.rankLbl = [UILabel labelWithBackgroundColor:kClearColor
                                           textColor:kTextColor
                                                font:12.0];
    self.rankLbl.layer.cornerRadius = 2.5;
    self.rankLbl.clipsToBounds = YES;
    self.rankLbl.textAlignment = NSTextAlignmentCenter;
    
    [self addSubview:self.rankLbl];
    //图标
    self.iconIV = [[UIImageView alloc] init];
    
    [self addSubview:self.iconIV];
    //币种名称
    self.currencyNameLbl = [UILabel labelWithBackgroundColor:kClearColor
                                                   textColor:kTextColor
                                                        font:17.0];
    
    [self addSubview:self.currencyNameLbl];
    //24H交易量
    self.tradeVolumeLbl = [UILabel labelWithBackgroundColor:kClearColor
                                                  textColor:kTextColor4
                                                       font:12.0];
    
    [self addSubview:self.tradeVolumeLbl];
    //涨跌情况
    self.priceFluctBtn = [UIButton buttonWithTitle:@""
                                        titleColor:kWhiteColor
                                   backgroundColor:kClearColor
                                         titleFont:17.0 cornerRadius:5];
    
    [self addSubview:self.priceFluctBtn];
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
    
    //排行
    [self.rankLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@15);
        make.centerY.equalTo(@0);
        make.width.height.equalTo(@16);
    }];
    //图标
    [self.iconIV mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.rankLbl.mas_right).offset(15);
        make.centerY.equalTo(@0);
        make.width.height.equalTo(@16);
    }];
    //币种名称
    [self.currencyNameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(@10);
        make.left.equalTo(self.iconIV.mas_right).offset(10);
    }];
    //一日交易量
    [self.tradeVolumeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.currencyNameLbl.mas_bottom).offset(10);
        make.left.equalTo(self.currencyNameLbl.mas_left);
        
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
        make.top.equalTo(self.currencyNameLbl.mas_top);
    }];
    //对应币种
    [self.opppsitePriceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.priceFluctBtn.mas_left).offset(-15);
        make.top.equalTo(self.tradeVolumeLbl.mas_top);
    }];
    
}

#pragma mark - Setting
- (void)setPlatform:(PlatformModel *)platform {
    
    _platform = platform;
    
    //排名
    self.rankLbl.text = [NSString stringWithFormat:@"%ld", platform.rank];
    
    self.rankLbl.textColor = platform.rank < 4 ? kWhiteColor: kTextColor;
    
    self.rankLbl.backgroundColor = platform.rankColor;
    
    //图标
    self.iconIV.backgroundColor = kAppCustomMainColor;
    
    [self.iconIV sd_setImageWithURL:[NSURL URLWithString:[platform.pic convertImageUrl]]
                   placeholderImage:kImage(@"")];
    //币种名称
    self.currencyNameLbl.text = [platform.symbol uppercaseString];
    //一日交易量
    NSString *volumeStr = platform.tradeVolume;
    self.tradeVolumeLbl.text = [NSString stringWithFormat:@"交易量:%@", volumeStr];
    
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
    
}

@end
