//
//  TradeSellChildVC.m
//  bige
//
//  Created by 蔡卓越 on 2018/5/7.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "TradeSellChildVC.h"

//Manager
#import "TradeManager.h"
//Category
#import "NSNumber+Extension.h"
//M
#import "AccountModel.h"
//V
#import "TradeSellView.h"

@interface TradeSellChildVC ()

//
@property (nonatomic, strong) TradeSellView *sellView;
//
@property (nonatomic, strong) TradeManager *manager;
//人民币账户余额
@property (nonatomic, strong) NSNumber *cnyBalanceAmount;

@end

@implementation TradeSellChildVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.manager = [TradeManager manager];
    
    [self initBuyView];
    //添加通知
    [self addNotification];
}

#pragma mark - Notification
- (void)addNotification {
    //监听限价和市价的改变
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(limitDidChange) name:@"DidChangeLimitPrice" object:nil];
    //币种信息已获取
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(quotesDidLoad) name:@"QotesDidLoad" object:nil];
    
}

- (void)limitDidChange {
    
    self.sellView.limitPriceView.hidden = [self.manager.type isEqualToString:@"0"] ? NO: YES;
    self.sellView.marketPriceView.hidden = [self.manager.type isEqualToString:@"1"] ? NO: YES;
}

- (void)quotesDidLoad {
    
    self.sellView.symbolLbl.text = [self.manager.symbol uppercaseString];
    //详情模拟资产账户
    [self getAccountDetail];
    
}

#pragma mark - Init
- (void)initBuyView {
    
    self.sellView = [[TradeSellView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth/2.0, 265)];
    
    self.sellView.limitPriceView.hidden = [self.manager.type isEqualToString:@"0"] ? NO: YES;
    self.sellView.marketPriceView.hidden = [self.manager.type isEqualToString:@"1"] ? NO: YES;
    
    [self.view addSubview:self.sellView];
    
}

#pragma mark - Data

/**
 查询交易所下计价币种兑换成人民币的金额
 */
- (void)getRmbAmount {
    
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"628923";
    http.parameters[@"exchange"] = self.manager.exchange;
    http.parameters[@"toSymbol"] = self.manager.toSymbol;
    
    [http postWithSuccess:^(id responseObject) {
        
        self.manager.cnyPrice = responseObject[@"data"][@"cnyPrice"];
        
        //可用余额
        NSString *leftAmount = [NSNumber div1:[self.cnyBalanceAmount stringValue] div2:[self.manager.cnyPrice stringValue] scale:8];
        
        self.sellView.useNumLbl.text = [NSString stringWithFormat:@"可用 %@%@", leftAmount, [self.manager.symbol uppercaseString]];
        
    } failure:^(NSError *error) {
        
    }];
}

/**
 详情模拟资产账户
 */
- (void)getAccountDetail {
    
    BaseWeakSelf;
    
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    
    helper.code = @"628513";
    helper.parameters[@"userId"] = [TLUser user].userId;
    helper.parameters[@"currency"] = self.manager.symbol;
    helper.isList = YES;
    [helper modelClass:[AccountModel class]];
    
    [helper refresh:^(NSMutableArray <AccountModel *>*objs, BOOL stillHave) {
        //没有账户，那可用余额就为0
        if (objs.count == 0) {
            
            weakSelf.sellView.useNumLbl.text = [NSString stringWithFormat:@"可用 0%@", [weakSelf.manager.symbol uppercaseString]];

            return ;
        }
        
        [objs enumerateObjectsUsingBlock:^(AccountModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            NSString *str = [obj.amount subNumber:obj.frozenAmount];
            weakSelf.cnyBalanceAmount = @([str doubleValue]);
            //查询交易所下计价币种兑换成人民币的金额
            [weakSelf getRmbAmount];
            
        }];
        
    } failure:^(NSError *error) {
        
        
    }];
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
