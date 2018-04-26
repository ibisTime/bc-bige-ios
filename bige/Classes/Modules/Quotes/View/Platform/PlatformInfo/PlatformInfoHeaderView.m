//
//  PlatformInfoHeaderView.m
//  bige
//
//  Created by 蔡卓越 on 2018/4/26.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "PlatformInfoHeaderView.h"

//Macro
#import "TLUIHeader.h"
#import "AppColorMacro.h"

@implementation PlatformInfoHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        
        [self initSubviews];
    }
    return self;
}

#pragma mark - Init
- (void)initSubviews {
    
    self.contentView.backgroundColor = kWhiteColor;
    //topLine
    UIView *topLine = [[UIView alloc] init];
    
    topLine.backgroundColor = kLineColor;
    
    [self addSubview:topLine];
    [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.top.equalTo(@0);
        make.height.equalTo(@0.5);
        
    }];
    //平台名称
    UILabel *platformNameLbl = [UILabel labelWithBackgroundColor:kClearColor
                                                       textColor:kTextColor
                                                            font:13.0];
    platformNameLbl.text = @"名称";
    [self addSubview:platformNameLbl];
    [platformNameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@15);
        make.centerY.equalTo(@0);
    }];
    //交易成交数
    UILabel *tradeNumLbl = [UILabel labelWithBackgroundColor:kClearColor
                                                       textColor:kTextColor
                                                            font:13.0];
    tradeNumLbl.text = @"成交笔数";

    [self addSubview:tradeNumLbl];
    [tradeNumLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@(kWidth(130)));
        make.centerY.equalTo(@0);
    }];
    //交易量
    UILabel *tradeVolumeLbl = [UILabel labelWithBackgroundColor:kClearColor
                                                      textColor:kTextColor
                                                           font:13.0];
    tradeVolumeLbl.text = @"交易量";

    [self addSubview:tradeVolumeLbl];
    [tradeVolumeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.mas_right).offset(-kWidth(155));
        make.centerY.equalTo(@0);
    }];
    //交易额
    UILabel *tradeAmountLbl = [UILabel labelWithBackgroundColor:kClearColor
                                                      textColor:kTextColor
                                                           font:13.0];
    tradeAmountLbl.textAlignment = NSTextAlignmentCenter;
    tradeAmountLbl.text = @"交易额";

    [self addSubview:tradeAmountLbl];
    [tradeAmountLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(@(-15));
        make.centerY.equalTo(@0);
    }];
}

@end
