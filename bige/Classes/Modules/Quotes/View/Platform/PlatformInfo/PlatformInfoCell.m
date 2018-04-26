//
//  PlatformInfoCell.m
//  bige
//
//  Created by 蔡卓越 on 2018/4/26.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "PlatformInfoCell.h"

//Category
#import "UILabel+Extension.h"
#import "NSString+CGSize.h"
#import "NSString+Extension.h"
#import "NSNumber+Extension.h"

@interface PlatformInfoCell()
//平台名称
@property (nonatomic, strong) UILabel *platformNameLbl;
//交易成交数
@property (nonatomic, strong) UILabel *tradeNumLbl;
//交易量
@property (nonatomic, strong) UILabel *tradeVolumeLbl;
//交易额
@property (nonatomic, strong) UILabel *tradeAmountLbl;

@end

@implementation PlatformInfoCell

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
                                                        font:13.0];
    //字体加粗
    [self.platformNameLbl setFont:[UIFont fontWithName:@"Helvetica-Bold" size:13.0]];
    [self addSubview:self.platformNameLbl];
    //交易成交数
    self.tradeNumLbl = [UILabel labelWithBackgroundColor:kClearColor
                                                  textColor:kTextColor
                                                       font:13.0];
    [self addSubview:self.tradeNumLbl];
    //交易量
    self.tradeVolumeLbl = [UILabel labelWithBackgroundColor:kClearColor
                                                 textColor:kTextColor
                                                      font:13.0];
    [self addSubview:self.tradeVolumeLbl];
    //交易额
    self.tradeAmountLbl = [UILabel labelWithBackgroundColor:kClearColor
                                              textColor:kTextColor
                                                   font:13.0];
    self.tradeAmountLbl.textAlignment = NSTextAlignmentCenter;

    [self addSubview:self.tradeAmountLbl];
    //topLine
    UIView *topLine = [[UIView alloc] init];
    
    topLine.backgroundColor = kLineColor;
    
    [self addSubview:topLine];
    [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.top.equalTo(@0);
        make.height.equalTo(@0.5);
        
    }];
    //布局
    [self setSubviewLayout];
}

- (void)setSubviewLayout {
    
    //平台名称
    [self.platformNameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@15);
        make.centerY.equalTo(@0);
    }];
    //交易成交数
    [self.tradeNumLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@(kWidth(130)));
        make.centerY.equalTo(@0);
    }];
    //交易量
    [self.tradeVolumeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.mas_right).offset(-kWidth(155));
        make.centerY.equalTo(@0);
    }];
    //交易额
    [self.tradeAmountLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(@(-15));
        make.centerY.equalTo(@0);
    }];
}

#pragma mark - Setting
- (void)setPlatform:(PlatformModel *)platform {
    
    _platform = platform;
    //平台名称
    self.platformNameLbl.text = platform.exchangeCname;
    //交易成交数
    self.tradeNumLbl.text = [NSString stringWithFormat:@"%ld", platform.count];
    //交易量
    self.tradeVolumeLbl.text = [platform getNumWithVolume:platform.amount];
    //交易额
    self.tradeAmountLbl.text = [platform getNumWithVolume:platform.volume];
}

@end
