//
//  SetWarningView.m
//  bige
//
//  Created by 蔡卓越 on 2018/4/27.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "SetWarningView.h"
//Macro
#import "CoinHeader.h"
//Category
#import "NSNumber+Extension.h"
#import "UILabel+Extension.h"

#define kBgViewHeight  350

@interface SetWarningView()
//背景
@property (nonatomic, strong) UIView *bgView;
//币种名称
@property (nonatomic, strong) UILabel *symbolLbl;
//当前人民币价格
@property (nonatomic, strong) UILabel *rmbPriceLbl;
//预警价格
@property (nonatomic, strong) UILabel *warningPriceLbl;
//预警涨跌幅
@property (nonatomic, strong) UILabel *warningPercentLbl;
//进度条
@property (nonatomic, strong) UISlider *slider;
//当前价格
@property (nonatomic, copy) NSString *currentPrice;
//预警价格
@property (nonatomic, copy) NSString *warningPrice;
//预警涨跌幅
@property (nonatomic, copy) NSString *warningPercent;

@end

@implementation SetWarningView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubviews];
    }
    return self;
}

#pragma mark - Init
- (void)initSubviews {
    
    self.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.7];

    //背景
    self.bgView = [[UIView alloc] initWithFrame:CGRectMake(15, kScreenHeight, kScreenWidth - 2*kWidth(36), kBgViewHeight)];
    
    self.bgView.center = CGPointMake(kScreenWidth/2.0, kScreenHeight/2.0);
    self.bgView.backgroundColor = kWhiteColor;
    self.bgView.layer.cornerRadius = 10;
    self.bgView.clipsToBounds = YES;
    
    [self addSubview:self.bgView];
    //币种名称
    self.symbolLbl = [UILabel labelWithBackgroundColor:kClearColor
                                                     textColor:kTextColor
                                                          font:18.0];
    self.symbolLbl.numberOfLines = 0;
    [self.bgView addSubview:self.symbolLbl];
    [self.symbolLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(@0);
        make.top.equalTo(@22);
    }];
    //当前人民币价格
    UILabel *rmbTextLbl = [UILabel labelWithBackgroundColor:kClearColor
                                                  textColor:kTextColor
                                                       font:14.0];
    rmbTextLbl.text = @"当前价格";
    
    [self.bgView addSubview:rmbTextLbl];
    [rmbTextLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@(kWidth(36)));
        make.top.equalTo(self.symbolLbl.mas_bottom).offset(20);
    }];
    
    self.rmbPriceLbl = [UILabel labelWithBackgroundColor:kClearColor
                                               textColor:kTextColor
                                                    font:14.0];
    [self.bgView addSubview:self.rmbPriceLbl];
    [self.rmbPriceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(@(-kWidth(36)));
        make.top.equalTo(rmbTextLbl.mas_top);
    }];
    //预警价格
    UILabel *warningPriceTextLbl = [UILabel labelWithBackgroundColor:kClearColor
                                                  textColor:kTextColor
                                                       font:14.0];
    warningPriceTextLbl.text = @"预警价格";
    
    [self.bgView addSubview:warningPriceTextLbl];
    [warningPriceTextLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(rmbTextLbl.mas_left);
        make.top.equalTo(rmbTextLbl.mas_bottom).offset(25);
    }];
    
    self.warningPriceLbl = [UILabel labelWithBackgroundColor:kClearColor
                                               textColor:kTextColor
                                                    font:14.0];
    
    [self.bgView addSubview:self.warningPriceLbl];
    [self.warningPriceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.rmbPriceLbl.mas_right);
        make.top.equalTo(warningPriceTextLbl.mas_top);
    }];
    //预警涨跌幅
    UILabel *warningPercentTextLbl = [UILabel labelWithBackgroundColor:kClearColor
                                                           textColor:kTextColor
                                                                font:14.0];
    warningPercentTextLbl.text = @"预警涨跌幅";
    
    [self.bgView addSubview:warningPercentTextLbl];
    [warningPercentTextLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(rmbTextLbl.mas_left);
        make.top.equalTo(warningPriceTextLbl.mas_bottom).offset(25);
    }];
    
    self.warningPercentLbl = [UILabel labelWithBackgroundColor:kClearColor
                                                   textColor:kTextColor4
                                                        font:14.0];
    self.warningPercentLbl.text = @"0%";
    
    [self.bgView addSubview:self.warningPercentLbl];
    [self.warningPercentLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.warningPriceLbl.mas_right);
        make.top.equalTo(warningPercentTextLbl.mas_top);
    }];
    //进度条
    self.slider = [[UISlider alloc] init];
    
//    self.slider.minimumTrackTintColor = kAppCustomMainColor;
//    self.slider.maximumTrackTintColor = kHexColor(@"#f0f0f0");
    self.slider.maximumValue = 1;
    self.slider.minimumValue = -1;
    self.slider.value = 0;
    
    [self.slider addTarget:self action:@selector(didChangeValue:) forControlEvents:UIControlEventValueChanged];
    [self.bgView addSubview:self.slider];
    [self.slider mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(warningPercentTextLbl.mas_bottom).offset(20);
        make.left.equalTo(rmbTextLbl.mas_left);
        make.right.equalTo(self.rmbPriceLbl.mas_right);
    }];
    UILabel *minPercentLbl = [UILabel labelWithBackgroundColor:kClearColor
                                                     textColor:kTextColor2
                                                          font:12.0];
    minPercentLbl.text = @"-100%";
    
    [self.bgView addSubview:minPercentLbl];
    [minPercentLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(rmbTextLbl.mas_left);
        make.top.equalTo(self.slider.mas_bottom).offset(10);
    }];
    
    UILabel *maxPercentLbl = [UILabel labelWithBackgroundColor:kClearColor
                                                     textColor:kTextColor2
                                                          font:12.0];
    maxPercentLbl.text = @"100%";

    [self.bgView addSubview:maxPercentLbl];
    [maxPercentLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.rmbPriceLbl.mas_right);
        make.top.equalTo(self.slider.mas_bottom).offset(10);
    }];
    //确定
    UIButton *confirmBtn = [UIButton buttonWithTitle:@"确定"
                                          titleColor:kWhiteColor
                                     backgroundColor:kAppCustomMainColor
                                           titleFont:16.0
                                        cornerRadius:5];
    
    [confirmBtn addTarget:self action:@selector(clickConfirm) forControlEvents:UIControlEventTouchUpInside];
    [self.bgView addSubview:confirmBtn];
    [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(@(kWidth(210)));
        make.height.equalTo(@40);
        make.top.equalTo(minPercentLbl.mas_bottom).offset(20);
        make.centerX.equalTo(@0);
    }];
}
#pragma mark - Setting
- (void)setPlatform:(PlatformModel *)platform {
    
    _platform = platform;
    //币种名称
    NSString *symbol = [platform.symbol uppercaseString];
    NSString *text = [NSString stringWithFormat:@"%@\n%@", symbol, platform.exchangeCname];
    [self.symbolLbl labelWithString:text
                              title:platform.exchangeCname
                               font:Font(15.0)
                              color:kTextColor
                          lineSpace:10];
    self.symbolLbl.textAlignment = NSTextAlignmentCenter;
    
    //当前价格
    self.rmbPriceLbl.text = [NSString stringWithFormat:@"￥%@", [platform.lastCnyPrice convertToRealMoneyWithNum:2]];
    self.currentPrice = [platform.lastCnyPrice convertToRealMoneyWithNum:2];
    self.warningPriceLbl.text = [NSString stringWithFormat:@"￥%@", [platform.lastCnyPrice convertToRealMoneyWithNum:2]];
    self.warningPrice = [platform.lastCnyPrice convertToRealMoneyWithNum:2];
    self.warningPercent = @"0";
}

#pragma mark - Events
- (void)didChangeValue:(UISlider *)sender {
    
    CGFloat value = sender.value*100;
    
    NSString *price = [NSNumber mult1:[self.platform.lastCnyPrice stringValue] mult2:[NSString stringWithFormat:@"%.2lf", (1 + sender.value)] scale:2];
    
    self.warningPriceLbl.text = [NSString stringWithFormat:@"￥%@", price];
    self.warningPrice = price;

    self.warningPercentLbl.text = [NSString stringWithFormat:@"%.0lf%%", value];
    self.warningPercent = [NSString stringWithFormat:@"%.2lf", sender.value];
    
    self.warningPriceLbl.textColor = [self.platform getPercentColorWithPercent:@(sender.value)];
    self.warningPercentLbl.textColor = [self.platform getPercentColorWithPercent:@(sender.value)];

}

- (void)clickConfirm {
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"628390";
    http.showView = self;
    http.parameters[@"exchangeEname"] = self.platform.exchangeEname;
    http.parameters[@"symbol"] = self.platform.symbol;
    http.parameters[@"toSymbol"] = self.platform.toSymbol;
    http.parameters[@"currentPrice"] = self.currentPrice;
    http.parameters[@"changeRate"] = self.warningPercent;
    http.parameters[@"warnPrice"] = self.warningPrice;

    
    [http postWithSuccess:^(id responseObject) {
        
        [TLAlert alertWithSucces:@"设置成功"];
        
        [self hide];

    } failure:^(NSError *error) {
        
        [self hide];

    }];
}

- (void)show {
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    [UIView animateWithDuration:0.5 animations:^{
        
        self.alpha = 1;
        
    } completion:^(BOOL finished) {
        
    }];
    
}

- (void)hide {
    
    [UIView animateWithDuration:0.5 animations:^{
        
        self.alpha = 0;
        
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
    }];
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self hide];
}

@end
