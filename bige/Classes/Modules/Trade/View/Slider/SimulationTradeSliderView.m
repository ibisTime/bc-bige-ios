//
//  SimulationTradeSliderView.m
//  bige
//
//  Created by 蔡卓越 on 2018/5/4.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "SimulationTradeSliderView.h"

#import "UIView+Responder.h"

#define kBgViewWidth  (kScreenWidth*0.8)

@interface SimulationTradeSliderView()

//背景
@property (nonatomic, strong) UIView *bgView;

@end

@implementation SimulationTradeSliderView

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
    self.bgView = [[UIView alloc] initWithFrame:CGRectMake(0, kStatusBarHeight, kBgViewWidth, kScreenHeight - kStatusBarHeight)];
    
    self.bgView.backgroundColor = kWhiteColor;
    
    [self addSubview:self.bgView];
    //行情数据
    UILabel *textLbl = [UILabel labelWithBackgroundColor:kClearColor
                                               textColor:kTextColor
                                                    font:18.0];
    
    textLbl.text = @"行情";
    
    [self.bgView addSubview:textLbl];
    [textLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@15);
        make.top.equalTo(@15);
    }];
    //展开
    UIButton *showBtn = [UIButton buttonWithImageName:@"列表收起"];
    
    showBtn.contentMode = UIViewContentModeScaleAspectFit;
    [showBtn addTarget:self action:@selector(closeQuotes) forControlEvents:UIControlEventTouchUpInside];
    [self.bgView addSubview:showBtn];
    [showBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.right.equalTo(@0);
        make.width.height.equalTo(@44);
    }];
}

#pragma mark - Events

- (void)closeQuotes {
    
    [self hide];
}

- (void)show {
        
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    [UIView animateWithDuration:0.5 animations:^{
        
        self.alpha = 1;
        
        self.transform = CGAffineTransformMakeTranslation(kScreenWidth, 0);
        
    } completion:^(BOOL finished) {
        
    }];
    
}

- (void)hide {
    
    [UIView animateWithDuration:0.5 animations:^{
        
        self.alpha = 0;
        
        self.transform = CGAffineTransformIdentity;
        
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
    }];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self hide];
}

@end
