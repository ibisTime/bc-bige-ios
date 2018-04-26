//
//  CurrencyBottomView.m
//  bige
//
//  Created by 蔡卓越 on 2018/4/25.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "CurrencyBottomView.h"

//V
#import "UIButton+EnLargeEdge.h"

@interface CurrencyBottomView()
//关注
@property (nonatomic, strong) UIButton *followBtn;

@end

@implementation CurrencyBottomView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {
    
    //topLine
    UIView *topLine = [[UIView alloc] init];
    
    topLine.backgroundColor = kLineColor;
    
    [self addSubview:topLine];
    [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.top.equalTo(@0);
        make.height.equalTo(@0.5);
    }];
    //设置预警
    UIButton *warningBtn = [UIButton buttonWithTitle:@"设置预警"
                                          titleColor:kTextColor
                                     backgroundColor:kClearColor
                                           titleFont:14.0];
    [warningBtn addTarget:self action:@selector(settingWarning) forControlEvents:UIControlEventTouchUpInside];
    [warningBtn setImage:kImage(@"设置预警") forState:UIControlStateNormal];

    [self addSubview:warningBtn];
    [warningBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@10);
        make.centerY.equalTo(@0);
        make.height.equalTo(@50);
        make.width.equalTo(@(kWidth(90)));
    }];
    [warningBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
    //关注
    UIButton *followBtn = [UIButton buttonWithTitle:@"关注"
                                          titleColor:kTextColor
                                     backgroundColor:kClearColor
                                           titleFont:14.0];
    [followBtn addTarget:self action:@selector(follow) forControlEvents:UIControlEventTouchUpInside];
    [followBtn setImage:kImage(@"币种未关注") forState:UIControlStateNormal];
    [self addSubview:followBtn];
    [followBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(warningBtn.mas_right).offset(15);
        make.centerY.equalTo(@0);
        make.height.equalTo(@50);
        make.width.equalTo(@(kWidth(70)));
    }];
    [followBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
    self.followBtn = followBtn;
    //卖
    UIButton *sellBtn = [UIButton buttonWithTitle:@"卖"
                                       titleColor:kWhiteColor
                                  backgroundColor:kHexColor(@"#fc5858")
                                        titleFont:14.0
                                     cornerRadius:5];
    [sellBtn addTarget:self action:@selector(sellCurrency) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:sellBtn];
    [sellBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(@(-15));
        make.centerY.equalTo(@0);
        make.height.equalTo(@30);
        make.width.equalTo(@(kWidth(75)));
    }];
    //买
    UIButton *buyBtn = [UIButton buttonWithTitle:@"买"
                                          titleColor:kWhiteColor
                                 backgroundColor:kHexColor(@"#3cbc98")
                                           titleFont:14.0
                                        cornerRadius:5];
    [buyBtn addTarget:self action:@selector(buyCurrency) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:buyBtn];
    [buyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(sellBtn.mas_left).offset(-10);
        make.centerY.equalTo(@0);
        make.height.equalTo(@30);
        make.width.equalTo(@(kWidth(75)));
    }];
    
}

#pragma mark - Setting
- (void)setPlatform:(PlatformModel *)platform {
    
    _platform = platform;
    
    NSString *imgName = [platform.isChoice isEqualToString:@"0"] ? @"币种未关注": @"币种关注";
    [self.followBtn setImage:kImage(imgName) forState:UIControlStateNormal];
}

#pragma mark - Events

/**
 设置预警
 */
- (void)settingWarning {
    
    if (self.bottomBlock) {
        
        self.bottomBlock(BottomEventTypeEarlyWarning);
    }
}

/**
 关注
 */
- (void)follow {
    
    if (self.bottomBlock) {
        
        self.bottomBlock(BottomEventTypeFollow);
    }
}

/**
 买币
 */
- (void)buyCurrency {
    
    if (self.bottomBlock) {
        
        self.bottomBlock(BottomEventTypeBuy);
    }
}

/**
 卖币
 */
- (void)sellCurrency {
    
    if (self.bottomBlock) {
        
        self.bottomBlock(BottomEventTypeSell);
    }
}

@end
