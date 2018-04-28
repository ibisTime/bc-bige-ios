//
//  CurrencyAnalysisChildVC.m
//  bige
//
//  Created by 蔡卓越 on 2018/4/25.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "CurrencyAnalysisChildVC.h"

//V
#import "CurrencyTradeMapView.h"

@interface CurrencyAnalysisChildVC ()
//买卖实图
@property (nonatomic, strong) CurrencyTradeMapView *tradeView;

@end

@implementation CurrencyAnalysisChildVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //买卖实图
    [self initTradeView];
}

#pragma mark - Init
- (void)initTradeView {
    
    self.tradeView = [[CurrencyTradeMapView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 180)];
    
    self.tradeView.platform = self.platform;
    
    [self.bgSV addSubview:self.tradeView];
}

#pragma mark - Setting
- (void)setVcCanScroll:(BOOL)vcCanScroll {
    
    _vcCanScroll = vcCanScroll;
    
    self.tradeView.vcCanScroll = vcCanScroll;
    
    self.tradeView.contentOffset = CGPointZero;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
