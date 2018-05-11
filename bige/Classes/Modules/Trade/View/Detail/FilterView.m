//
//  FilterView.m
//  bige
//
//  Created by 蔡卓越 on 2018/5/9.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "FilterView.h"

//Macro
//Framework
//Category
//Extension
//M
#import "DivisionFilterManager.h"
//V
#import "TLTextField.h"

@interface FilterView()
//币种名称
@property (nonatomic, strong) TLTextField *symbolTF;
//对应币种名称
@property (nonatomic, strong) TLTextField *toSymbolTF;
//
@property (nonatomic, strong) DivisionFilterManager *manager;
//
@property (nonatomic, strong) UIView *whiteView;
//
@property (nonatomic, strong) UIView *toSymbolView;
//底部
@property (nonatomic, strong) UIView *bottomView;
//是否下拉
@property (nonatomic, assign) BOOL isUp;

@end

@implementation FilterView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.isUp = NO;
        
        self.manager = [DivisionFilterManager manager];
        
        [self initSubviews];
        //底部
        [self initBottomView];
    }
    return self;
}

#pragma mark - Init
- (void)initSubviews {
    
    self.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.5];
    self.hidden = YES;
    
    UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 290)];
    
    whiteView.backgroundColor = kWhiteColor;
    
    [self addSubview:whiteView];
    self.whiteView = whiteView;
    
    //交易对
    [self initToSymbolView];
    //
    UILabel *textLbl = [UILabel labelWithBackgroundColor:kClearColor
                                               textColor:kTextColor
                                                    font:15.0];
    textLbl.text = @"交易对";
    textLbl.frame = CGRectMake(15, 25, 100, 16);

    [whiteView addSubview:textLbl];
    //币种名称
    self.symbolTF = [[TLTextField alloc] initWithFrame:CGRectMake(15, textLbl.yy + 18, kWidth(160), 35)
                                             leftTitle:@""
                                            titleWidth:10
                                           placeholder:@"币种"];
    
    self.symbolTF.layer.borderWidth = 1;
    self.symbolTF.layer.borderColor = kLineColor.CGColor;
    
    [whiteView addSubview:self.symbolTF];
    //Line
    UILabel *lineLbl = [UILabel labelWithBackgroundColor:kClearColor
                                               textColor:kTextColor
                                                    font:15.0];
    lineLbl.text = @"/";
    lineLbl.frame = CGRectMake((kScreenWidth - 25)/2.0, self.symbolTF.y, 25, 35);
    lineLbl.textAlignment = NSTextAlignmentCenter;
    
    [whiteView addSubview:lineLbl];
    //对应币种名称
    self.toSymbolTF = [[TLTextField alloc] initWithFrame:CGRectMake(kScreenWidth - 15 - kWidth(160), textLbl.yy + 18, kWidth(160), 35)
                                             leftTitle:@""
                                            titleWidth:10
                                           placeholder:@"币种"];
    
    self.toSymbolTF.layer.borderWidth = 1;
    self.toSymbolTF.layer.borderColor = kLineColor.CGColor;
    [self.toSymbolTF setEnabled:NO];
    
    [whiteView addSubview:self.toSymbolTF];
    //选择交易对
    UIButton *selectBtn = [UIButton buttonWithImageName:@"火币下拉实心"];
    
    selectBtn.contentMode = UIViewContentModeScaleAspectFit;
    
    [selectBtn addTarget:self action:@selector(selectToSymbol:) forControlEvents:UIControlEventTouchUpInside];
    
    [whiteView addSubview:selectBtn];
    [selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.toSymbolTF.mas_right);
        make.centerY.equalTo(self.toSymbolTF.mas_centerY);
        make.width.width.height.equalTo(@25);
    }];
    
}

- (void)initToSymbolView {
    
    self.toSymbolView = [[UIView alloc] initWithFrame:CGRectMake(0, 35, kScreenWidth, 60)];
    
    self.toSymbolView.hidden = YES;
    
    [self.whiteView addSubview:self.toSymbolView];
    
    NSArray *toSymbolArr = @[@"USDT", @"BTC", @"ETH"];
    
    [toSymbolArr enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        UIButton *toSymoblBtn = [UIButton buttonWithTitle:toSymbolArr[idx]
                                          titleColor:kTextColor
                                     backgroundColor:kHexColor(@"#f5f7fa")
                                           titleFont:14.0];
        
        [toSymoblBtn setTitleColor:kWhiteColor forState:UIControlStateSelected];
        [toSymoblBtn setBackgroundColor:kAppCustomMainColor forState:UIControlStateSelected];
        toSymoblBtn.tag = 2900 + idx;
        
        [toSymoblBtn addTarget:self action:@selector(toSymbol:) forControlEvents:UIControlEventTouchUpInside];
        //取消高亮
        [toSymoblBtn addTarget:self action:@selector(cancelHighLighted:) forControlEvents:UIControlEventAllEvents];
        
        [self.toSymbolView addSubview:toSymoblBtn];
        [toSymoblBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(@(15+idx*(90)));
            make.top.equalTo(@30);
            make.width.equalTo(@75);
            make.height.equalTo(@30);
        }];
    }];
}

- (void)initBottomView {
    
    self.bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.symbolTF.yy, kScreenWidth, 195)];
    
    [self.whiteView addSubview:self.bottomView];
    //选择状态
    UILabel *typeLbl = [UILabel labelWithBackgroundColor:kClearColor
                                               textColor:kTextColor
                                                    font:15.0];
    typeLbl.text = @"选择状态";
    typeLbl.frame = CGRectMake(15, 35, 100, 16);
    
    [self.bottomView addSubview:typeLbl];
    //买入
    UIButton *buyBtn = [UIButton buttonWithTitle:@"买入"
                                      titleColor:kTextColor
                                 backgroundColor:kHexColor(@"#f5f7fa")
                                       titleFont:14.0];
    
    buyBtn.selected = NO;
    buyBtn.frame = CGRectMake(15, typeLbl.yy + 20, kWidth(90), 30);
    [buyBtn setTitleColor:kWhiteColor forState:UIControlStateSelected];
    [buyBtn setBackgroundColor:kAppCustomMainColor forState:UIControlStateSelected];
    buyBtn.tag = 2910;
    
    [buyBtn addTarget:self action:@selector(buy:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:buyBtn];
    //卖出
    UIButton *sellBtn = [UIButton buttonWithTitle:@"卖出"
                                       titleColor:kTextColor
                                  backgroundColor:kHexColor(@"#f5f7fa")
                                        titleFont:14.0];
    sellBtn.selected = NO;
    sellBtn.tag = 2911;
    sellBtn.frame = CGRectMake(buyBtn.xx + 15, typeLbl.yy + 20, kWidth(90), 30);
    [sellBtn setTitleColor:kWhiteColor forState:UIControlStateSelected];
    [sellBtn setBackgroundColor:kAppCustomMainColor forState:UIControlStateSelected];
    
    [sellBtn addTarget:self action:@selector(sell:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:sellBtn];
    //bottomLine
    UIView *bottomLine = [[UIView alloc] init];
    
    bottomLine.backgroundColor = kLineColor;
    
    [self.bottomView addSubview:bottomLine];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.equalTo(@0);
        make.bottom.equalTo(@(-45));
        make.height.equalTo(@0.5);
    }];
    //重置
    UIButton *resetBtn = [UIButton buttonWithTitle:@"重置"
                                        titleColor:kTextColor2
                                   backgroundColor:kWhiteColor
                                         titleFont:14.0];
    [resetBtn addTarget:self action:@selector(reset) forControlEvents:UIControlEventTouchUpInside];
    
    [self.bottomView addSubview:resetBtn];
    [resetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(bottomLine.mas_bottom);
        make.width.equalTo(@(kScreenWidth/2.0));
        make.height.equalTo(@45);
        make.left.equalTo(@0);
    }];
    //确认
    UIButton *confirmBtn = [UIButton buttonWithTitle:@"确定"
                                          titleColor:kWhiteColor
                                     backgroundColor:kAppCustomMainColor
                                           titleFont:14.0];
    
    [confirmBtn addTarget:self action:@selector(confirm) forControlEvents:UIControlEventTouchUpInside];
    
    [self.bottomView addSubview:confirmBtn];
    [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(bottomLine.mas_bottom);
        make.width.equalTo(@(kScreenWidth/2.0));
        make.height.equalTo(@45);
        make.left.equalTo(@(kScreenWidth/2.0));
    }];
}

#pragma mark - Events

/**
 选择交易对
 */
- (void)selectToSymbol:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    
    if (sender.selected) {
        
        
        [UIView animateWithDuration:0.25 animations:^{
            
            self.toSymbolView.hidden = NO;

            self.whiteView.height += 60;

            sender.transform = CGAffineTransformMakeRotation(M_PI);
            self.toSymbolView.transform = CGAffineTransformMakeTranslation(0, 60);
            self.bottomView.transform = CGAffineTransformMakeTranslation(0, 60);
        }];
    } else {
        
        [UIView animateWithDuration:0.25 animations:^{
            
            self.whiteView.height -= 60;

            sender.transform = CGAffineTransformIdentity;
            self.toSymbolView.transform = CGAffineTransformIdentity;
            self.bottomView.transform = CGAffineTransformIdentity;
            
            self.toSymbolView.hidden = YES;
        }];
        
    }
    
}

- (void)toSymbol:(UIButton *)sender {
    
    //如果已经选中那就跳过
    if (sender.selected) {
        
        return ;
    }
    sender.selected = !sender.selected;
    
    self.manager.toSymbol = sender.selected == YES ? [sender.titleLabel.text lowercaseString]: nil;
    
    self.toSymbolTF.text = sender.titleLabel.text;
    
    self.manager.toSymbol = [sender.titleLabel.text lowercaseString];
    
    for (int i = 0; i < 3; i++) {
        
        UIButton *btn = [self viewWithTag:2900+i];
        
        if (btn != sender) {
            
            btn.selected = NO;
        }
    };
}

- (void)cancelHighLighted:(UIButton *)sender {
    
    sender.highlighted = NO;
}

- (void)buy:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    
    self.manager.direction = sender.selected == YES ? @"0": nil;
    
    UIButton *sellBtn = [self viewWithTag:2911];
    
    sellBtn.selected = NO;
    
}

- (void)sell:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    
    self.manager.direction = sender.selected == YES ? @"1": nil;
    
    UIButton *buyBtn = [self viewWithTag:2910];
    
    buyBtn.selected = NO;
}

/**
 重置筛选
 */
- (void)reset {
    
    self.symbolTF.text = @"";
    self.toSymbolTF.text = @"";
    self.manager.symbol = @"";
    self.manager.toSymbol = @"";
    self.manager.direction = @"";
    //
    UIButton *buyBtn = [self viewWithTag:2910];
    
    buyBtn.selected = NO;
    
    UIButton *sellBtn = [self viewWithTag:2911];
    
    sellBtn.selected = NO;
    
    for (int i = 0; i < 3; i++) {
        
        UIButton *btn = [self viewWithTag:2900+i];
        
        btn.selected = NO;
    }
}

- (void)confirm {
    
    [self hide];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DidReloadDivisionBlock" object:nil];
}

- (void)show {
    
    self.hidden = NO;
}

- (void)hide {
    
    self.hidden = YES;
}

@end
