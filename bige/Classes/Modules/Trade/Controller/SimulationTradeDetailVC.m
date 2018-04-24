//
//  SimulationTradeDetailVC.m
//  bige
//
//  Created by 蔡卓越 on 2018/4/24.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "SimulationTradeDetailVC.h"

@interface SimulationTradeDetailVC ()
//顶部
@property (nonatomic, strong) UIView *topView;
//交易界面
@property (nonatomic, strong) UIView *tradeView;
//委托

@end

@implementation SimulationTradeDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"模拟交易";
    //顶部
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
