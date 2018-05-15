//
//  TradeListCell.m
//  bige
//
//  Created by 蔡卓越 on 2018/5/8.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "TradeListCell.h"

//Category
#import "NSNumber+Extension.h"

@interface TradeListCell()
//数量
@property (nonatomic, strong) UILabel *numLbl;

@end

@implementation TradeListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self initSubviews];
        
    }
    
    return self;
}

#pragma mark - Init
- (void)initSubviews {
    
    self.priceLbl = [UILabel labelWithBackgroundColor:kClearColor
                                                    textColor:kTextColor2
                                                         font:12.0];
    self.priceLbl.text = @"--";
    [self addSubview:self.priceLbl];
    [self.priceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@15);
        make.centerY.equalTo(@0);
    }];
    
    self.numLbl = [UILabel labelWithBackgroundColor:kClearColor
                                                  textColor:kTextColor2
                                                       font:12.0];
    self.numLbl.text = @"--";
    [self addSubview:self.numLbl];
    [self.numLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(@(-15));
        make.centerY.equalTo(@0);
    }];
}

#pragma mark - Setting
- (void)setTradeInfo:(TradeInfoModel *)tradeInfo {
    
    _tradeInfo = tradeInfo;
    
    self.priceLbl.text = [tradeInfo.price convertToRealMoneyWithNum:8];
    
    self.numLbl.text = [tradeInfo.amount convertToRealMoneyWithNum:8];
}

@end
