//
//  DivisionListCell.m
//  bige
//
//  Created by 蔡卓越 on 2018/5/8.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "DivisionListCell.h"

//Category
#import "NSString+Date.h"
#import "NSNumber+Extension.h"

@interface DivisionListCell()
//交易买卖方向(0=买入，1=卖出)
@property (nonatomic, strong) UILabel *directionLbl;
//下单时间
@property (nonatomic, strong) UILabel *timeLbl;
//价格
@property (nonatomic, strong) UILabel *priceLbl;
@property (nonatomic, strong) UILabel *toSymbolLbl;
//总数量
@property (nonatomic, strong) UILabel *totalCountLbl;
@property (nonatomic, strong) UILabel *totalSymbolLbl;
//实际交易数量
@property (nonatomic, strong) UILabel *tradedCountLbl;
@property (nonatomic, strong) UILabel *tradedSymbolLbl;

@end

@implementation DivisionListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self initSubviews];
        
    }
    
    return self;
}

#pragma mark - Init
- (void)initSubviews {
    
    //交易买卖方向
    self.directionLbl = [UILabel labelWithBackgroundColor:kClearColor
                                                textColor:kRiseColor
                                                     font:15.0];
    
    [self addSubview:self.directionLbl];
    //下单时间
    self.timeLbl = [UILabel labelWithBackgroundColor:kClearColor
                                           textColor:kTextColor2
                                                font:12.0];
    [self addSubview:self.timeLbl];
    //撤销
    self.cancelBtn = [UIButton buttonWithTitle:@"撤销"
                                    titleColor:kHexColor(@"#348ff6")
                               backgroundColor:kClearColor
                                     titleFont:12.0];
    [self addSubview:self.cancelBtn];
    //价格
    
    self.priceLbl = [UILabel labelWithBackgroundColor:kClearColor
                                            textColor:kTextColor
                                                 font:14.0];
    [self addSubview:self.priceLbl];
    
    self.toSymbolLbl = [UILabel labelWithBackgroundColor:kClearColor
                                            textColor:kTextColor2
                                                 font:12.0];
    [self addSubview:self.toSymbolLbl];
    //总数量
    self.totalCountLbl = [UILabel labelWithBackgroundColor:kClearColor
                                            textColor:kTextColor
                                                 font:14.0];
    [self addSubview:self.totalCountLbl];
    
    self.totalSymbolLbl = [UILabel labelWithBackgroundColor:kClearColor
                                            textColor:kTextColor2
                                                 font:12.0];
    [self addSubview:self.totalSymbolLbl];
    //实际交易数量
    self.tradedCountLbl = [UILabel labelWithBackgroundColor:kClearColor
                                            textColor:kTextColor
                                                 font:14.0];
    [self addSubview:self.tradedCountLbl];
    
    self.tradedSymbolLbl = [UILabel labelWithBackgroundColor:kClearColor
                                            textColor:kTextColor2
                                                 font:12.0];
    [self addSubview:self.tradedSymbolLbl];
    
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
    
    //交易买卖方向
    [self.directionLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@15);
        make.top.equalTo(@20);
    }];
    //下单时间
    [self.timeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.directionLbl.mas_right).offset(18);
        make.centerY.equalTo(self.directionLbl.mas_centerY);
    }];
    //撤销
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(-15));
        make.centerY.equalTo(self.directionLbl.mas_centerY);
    }];
    //价格
    [self.toSymbolLbl mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.directionLbl.mas_left);
        make.top.equalTo(self.directionLbl.mas_bottom).offset(16);
    }];
    [self.priceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.directionLbl.mas_left);
        make.top.equalTo(self.toSymbolLbl.mas_bottom).offset(8);
    }];
    //总数量
    [self.totalSymbolLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(@0);
        make.top.equalTo(self.directionLbl.mas_bottom).offset(20);
    }];
    [self.totalCountLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.totalSymbolLbl.mas_left);
        make.top.equalTo(self.totalSymbolLbl.mas_bottom).offset(8);
    }];
    
    //实际交易数量
    [self.tradedSymbolLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(@(-15));
        make.top.equalTo(self.directionLbl.mas_bottom).offset(20);
    }];
    [self.tradedCountLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(@(-15));
        make.top.equalTo(self.tradedSymbolLbl.mas_bottom).offset(8);
    }];
}

#pragma mark - Setting
- (void)setDivision:(DivisionModel *)division {
    
    _division = division;
    //买卖
    self.directionLbl.text = [division.type isEqualToString:@"0"] ? @"买入": @"卖出";
    self.directionLbl.textColor = [division.type isEqualToString:@"0"] ? kRiseColor: kThemeColor;
    //下单时间
    self.timeLbl.text = [division.createDatetime convertToDetailDate];
    //价格
    self.toSymbolLbl.text = [NSString stringWithFormat:@"价格(%@)", [division.toSymbol uppercaseString]];
    self.priceLbl.text = [division.price convertToRealMoneyWithNum:8];
    //总数量
    self.totalSymbolLbl.text = [NSString stringWithFormat:@"数量(%@)", [division.symbol uppercaseString]];
    self.totalCountLbl.text = [division.totalCount stringValue];
    //成交量
    self.tradedSymbolLbl.text = [NSString stringWithFormat:@"实际成交(%@)", [division.symbol uppercaseString]];
    self.tradedCountLbl.text = [division.tradedCount stringValue];
}

@end
