//
//  PositionVC.m
//  bige
//
//  Created by 蔡卓越 on 2018/5/11.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "PositionVC.h"

//Macro
//Framework
//Category
#import "NSNumber+Extension.h"
//Extension
//M
#import "PositionModel.h"
//V
#import "PositionTableView.h"
//C

@interface PositionVC ()
//
@property (nonatomic, strong) UIView *topView;
//总收益
@property (nonatomic, strong) UILabel *totalAmountLbl;
//
@property (nonatomic, strong) PositionTableView *tableView;
//
@property (nonatomic, strong) PositionModel *position;

@end

@implementation PositionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"模拟资产";
    //总收益
    [self initTopView];
    //
    [self initTableView];
    //获取模拟资产信息
    [self requestRealAssetInfo];
}

#pragma mark - Init
- (void)initTopView {
    
    self.topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 80)];
    
    self.topView.backgroundColor = kWhiteColor;
    
    [self.view addSubview:self.topView];
    //总收益
    UILabel *textLbl = [UILabel labelWithBackgroundColor:kClearColor
                                               textColor:kTextColor2
                                                    font:12.0];
    textLbl.text = @"总收益";
    
    [self.topView addSubview:textLbl];
    [textLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@15);
        make.top.equalTo(@15);
    }];
    self.totalAmountLbl = [UILabel labelWithBackgroundColor:kClearColor
                                                  textColor:kTextColor
                                                       font:21.0];
    
    [self.topView addSubview:self.totalAmountLbl];
    [self.totalAmountLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@15);
        make.top.equalTo(textLbl.mas_bottom).offset(15);
    }];
}

- (void)initTableView {
    
    self.tableView = [[PositionTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(0);
    }];
    
    self.tableView.tableHeaderView = self.topView;
}

#pragma mark - Data

/**
 获取模拟资产信息
 */
- (void)requestRealAssetInfo {
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"628512";
    http.showView = self.view;
    http.parameters[@"userId"] = [TLUser user].userId;
    
    [http postWithSuccess:^(id responseObject) {
        
        self.position = [PositionModel mj_objectWithKeyValues:responseObject[@"data"]];
        
        self.tableView.position = self.position;
        [self.tableView reloadData];
        self.totalAmountLbl.text = [self.position.totalProfit convertToRealMoneyWithNum:2];

    } failure:^(NSError *error) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
