//
//  TradeSellView.m
//  bige
//
//  Created by 蔡卓越 on 2018/5/7.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "TradeSellView.h"

//Manager
#import "TradeManager.h"
//Macro
#import "CoinHeader.h"
//Category
#import "NSString+Check.h"
#import "NSNumber+Extension.h"
#import "NSString+Extension.h"

//V
#import "TLTextField.h"

@interface TradeSellView()
//
@property (nonatomic, strong) TLTextField *priceTF;
//人民币价格
@property (nonatomic, strong) UILabel *rmbPriceLbl;
//数量
@property (nonatomic, strong) UIView *numberView;
//减号
@property (nonatomic, strong) UIButton *reduceBtn;

@property (nonatomic, strong) TLTextField *numTF;
//交易额
@property (nonatomic, strong) UILabel *totalNumLbl;
//
@property (nonatomic, strong) TradeManager *manager;
//每次相加的值
@property (nonatomic, copy) NSString *value;

@end

@implementation TradeSellView

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
    
    self.manager = [TradeManager manager];
    
    //限价
    [self initLimitPriceView];
    //市价
    [self initMarketPriceView];
    //人民币价格
    self.rmbPriceLbl = [UILabel labelWithBackgroundColor:kClearColor
                                               textColor:kTextColor2
                                                    font:10.0];
    self.rmbPriceLbl.frame = CGRectMake(15, self.limitPriceView.yy + 10, self.width - 15, 10);
    
    [self addSubview:self.rmbPriceLbl];
    //数量
    [self initNumView];
    //可用币种数
    self.useNumLbl = [UILabel labelWithBackgroundColor:kClearColor
                                             textColor:kTextColor
                                                  font:11.0];
    
    [self addSubview:self.useNumLbl];
    [self.useNumLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.numberView.mas_bottom).offset(10);
        make.left.equalTo(@15);
    }];
    //交易额
    self.totalNumLbl = [UILabel labelWithBackgroundColor:kClearColor
                                               textColor:kTextColor
                                                    font:15.0];
    self.totalNumLbl.text = @"交易额 -- ";
    [self addSubview:self.totalNumLbl];
    [self.totalNumLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@15);
        make.top.equalTo(self.useNumLbl.mas_bottom).offset(12.5);
    }];
    //卖出
    UIButton *sellBtn = [UIButton buttonWithTitle:@"卖出"
                                      titleColor:kWhiteColor
                                 backgroundColor:kThemeColor
                                       titleFont:17.0];
    [sellBtn addTarget:self action:@selector(sell) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:sellBtn];
    [sellBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@(15));
        make.top.equalTo(self.totalNumLbl.mas_bottom).offset(22.5);
        make.width.equalTo(@(self.width - 15));
        make.height.equalTo(@45);
    }];
}

- (void)initLimitPriceView {
    
    self.backgroundColor = kWhiteColor;
    
    self.limitPriceView = [[UIView alloc] initWithFrame:CGRectMake(15, 10, self.width - 15, 45)];
    
    self.limitPriceView.layer.borderWidth = 1;
    self.limitPriceView.layer.borderColor = kLineColor.CGColor;
    
    [self addSubview:self.limitPriceView];
    //加
    UIButton *addBtn = [UIButton buttonWithImageName:@"加"];
    
    addBtn.layer.borderWidth = 1;
    addBtn.layer.borderColor = kLineColor.CGColor;
    [addBtn addTarget:self action:@selector(addPrice) forControlEvents:UIControlEventTouchUpInside];
    
    [self.limitPriceView addSubview:addBtn];
    [addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.right.equalTo(@0);
        make.width.equalTo(@36);
        make.height.equalTo(@45);
    }];
    //减
    UIButton *reduceBtn = [UIButton buttonWithImageName:@"减"];
    
    reduceBtn.layer.borderWidth = 1;
    reduceBtn.layer.borderColor = kLineColor.CGColor;
    [reduceBtn addTarget:self action:@selector(reducePrice:) forControlEvents:UIControlEventTouchUpInside];
    reduceBtn.enabled = NO;
    
    [self.limitPriceView addSubview:reduceBtn];
    [reduceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(@0);
        make.right.equalTo(addBtn.mas_left);
        make.width.equalTo(@36);
        make.height.equalTo(@45);
    }];
    
    self.reduceBtn = reduceBtn;
    
    //价格
    self.priceTF = [[TLTextField alloc] initWithFrame:CGRectZero];
    
    self.priceTF.textColor = kTextColor;
    self.priceTF.font = Font(14.0);
    self.priceTF.text = @"0.00";
    self.priceTF.keyboardType = UIKeyboardTypeDecimalPad;
    [self.priceTF addTarget:self action:@selector(changePrice:) forControlEvents:UIControlEventEditingChanged];
    [self.limitPriceView addSubview:self.priceTF];
    [self.priceTF mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@15);
        make.centerY.equalTo(@0);
        make.right.equalTo(reduceBtn.mas_left);
    }];
}

- (void)initMarketPriceView {
    
    self.marketPriceView = [[UIView alloc] initWithFrame:CGRectMake(15, 10, self.width - 15, 45)];
    
    self.marketPriceView.backgroundColor = kHexColor(@"#fafafa");
    self.marketPriceView.layer.borderWidth = 1;
    self.marketPriceView.layer.borderColor = kLineColor.CGColor;
    
    [self addSubview:self.marketPriceView];
    //
    UILabel *textLbl = [UILabel labelWithBackgroundColor:kClearColor
                                               textColor:kTextColor2
                                                    font:14.0];
    textLbl.text = @"以当前最优价格交易";
    [self.marketPriceView addSubview:textLbl];
    [textLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(@0);
        make.left.equalTo(@15);
    }];
}

- (void)initNumView {
    
    self.numberView = [[UIView alloc] initWithFrame:CGRectMake(15, self.rmbPriceLbl.yy + 12, self.width - 15, 45)];
    
    self.numberView.backgroundColor = kHexColor(@"#fafafa");
    self.numberView.layer.borderWidth = 1;
    self.numberView.layer.borderColor = kLineColor.CGColor;
    
    [self addSubview:self.numberView];
    
    //对应币种名称
    self.symbolLbl = [UILabel labelWithBackgroundColor:kClearColor
                                             textColor:kTextColor
                                                  font:14.0];
    self.symbolLbl.textAlignment = NSTextAlignmentCenter;
    
    [self.numberView addSubview:self.symbolLbl];
    [self.symbolLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(@(-15));
        make.centerY.equalTo(@0);
        make.width.equalTo(@45);
    }];
    //数量
    self.numTF = [[TLTextField alloc] initWithFrame:CGRectZero];
    
    self.numTF.textColor = kTextColor;
    self.numTF.font = Font(14.0);
    self.numTF.placeholder = @"数量";
    self.numTF.keyboardType = UIKeyboardTypeDecimalPad;
    [self.numTF addTarget:self action:@selector(changeNum:) forControlEvents:UIControlEventEditingChanged];
    [self.numberView addSubview:self.numTF];
    [self.numTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(@0);
        make.left.equalTo(@15);
        make.height.equalTo(@45);
        make.right.equalTo(self.symbolLbl.mas_left);
    }];
}

#pragma mark - Events
- (void)changePrice:(UITextField *)sender {
    
    if ([sender.text valid] && [[self.manager.cnyPrice stringValue] valid]) {
    
        NSString *cnyPrice = [NSNumber mult1:sender.text mult2:[self.manager.cnyPrice stringValue] scale:2];
        
        self.rmbPriceLbl.text = [NSString stringWithFormat:@"≈%@CNY", cnyPrice];
    }
    //交易额变更
    if ([sender.text valid] && [self.numTF.text valid]) {
        
        NSString *tradeAmount = [NSNumber mult1:self.priceTF.text mult2:self.numTF.text scale:8];
        
        self.totalNumLbl.text = [NSString stringWithFormat:@"交易额 %@%@", tradeAmount, [self.manager.toSymbol uppercaseString]];
    }
}

- (void)addPrice {
    
    self.reduceBtn.enabled = YES;
    
    self.priceTF.text = [NSNumber add1:self.priceTF.text add2:self.value scale:8];
    //人民币价格
    if ([self.priceTF.text valid] && [[self.manager.cnyPrice stringValue] valid]) {
    
        NSString *cnyPrice = [NSNumber mult1:self.priceTF.text mult2:[self.manager.cnyPrice stringValue] scale:2];
        
        self.rmbPriceLbl.text = [NSString stringWithFormat:@"≈%@CNY", cnyPrice];
    }
    //交易额变更
    if ([self.priceTF.text valid] && [self.numTF.text valid]) {
        
        NSString *tradeAmount = [NSNumber mult1:self.priceTF.text mult2:self.numTF.text scale:8];
        
        self.totalNumLbl.text = [NSString stringWithFormat:@"交易额 %@%@", tradeAmount, [self.manager.toSymbol uppercaseString]];
    }
}

- (void)reducePrice:(UIButton *)sender {
    
    //相减
    self.priceTF.text = [NSNumber sub1:self.priceTF.text sub2:self.value scale:8];
    
    if ([self.priceTF.text valid] && [[self.manager.cnyPrice stringValue] valid]) {
        
        NSString *cnyPrice = [NSNumber mult1:self.priceTF.text mult2:[self.manager.cnyPrice stringValue] scale:2];
        
        self.rmbPriceLbl.text = [NSString stringWithFormat:@"≈%@CNY", cnyPrice];
    }
    //交易额变更
    if ([self.priceTF.text valid] && [self.numTF.text valid]) {
        
        NSString *tradeAmount = [NSNumber mult1:self.priceTF.text mult2:self.numTF.text scale:8];
        
        self.totalNumLbl.text = [NSString stringWithFormat:@"交易额 %@%@", tradeAmount, [self.manager.toSymbol uppercaseString]];
    }
    //判断价格是否等于0
    if ([self.priceTF.text doubleValue] == 0) {
        
        sender.enabled = NO;
    }
}

- (void)changeNum:(UITextField *)sender {
    
    if ([sender.text valid] && [self.priceTF.text valid]) {
    
        NSString *tradeAmount = [NSNumber mult1:sender.text mult2:self.priceTF.text scale:8];
        
        self.totalNumLbl.text = [NSString stringWithFormat:@"交易额 %@%@", tradeAmount, [self.manager.toSymbol uppercaseString]];
    }
    
}

- (void)sell {
    
    if ([self.priceTF.text doubleValue] == 0) {
        
        [TLAlert alertWithInfo:@"请输入大于0的价格"];
        return;
    }
    
    if ([self.numTF.text doubleValue] == 0) {
        
        [TLAlert alertWithInfo:@"请输入大于0的数量"];
        return;
    }
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"628500";
    http.showView = self;
    http.parameters[@"userId"] = [TLUser user].userId;
    http.parameters[@"exchange"] = self.manager.exchange;
    http.parameters[@"symbol"] = self.manager.symbol;
    http.parameters[@"toSymbol"] = self.manager.toSymbol;
    http.parameters[@"type"] = self.manager.type;
    http.parameters[@"price"] = self.priceTF.text;
    http.parameters[@"direction"] = self.manager.direction;
    http.parameters[@"totalCount"] = self.numTF.text;
    
    [http postWithSuccess:^(id responseObject) {
        
        [TLAlert alertWithSucces:@"下单成功"];
        //刷新数量和可用余额
        self.totalNumLbl.text = @"交易额 -- ";
        self.numTF.text = @"";
        if (self.sellSuccess) {
            
            self.sellSuccess();
        }
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - Setting
- (void)setPrice:(NSString *)price {
    
    _price = price;
    
    self.priceTF.text = price;
    //相加的值
    NSInteger count = [self.priceTF.text subStringWithSpecialString:@"."].length;
    self.value = [NSString stringWithFormat:@"1.0e-%ld", count];
    
    //判断价格是否大于0
    if ([price doubleValue] > 0) {
        
        self.reduceBtn.enabled = YES;
    }
}

@end
