//
//  CurrencyExchangeChildVC.m
//  bige
//
//  Created by 蔡卓越 on 2018/4/25.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "CurrencyExchangeChildVC.h"

//M
#import "PlatformModel.h"
//V
#import "PlatformInfoTableView.h"
//C

@interface CurrencyExchangeChildVC ()
//
@property (nonatomic, strong) PlatformInfoTableView *tableView;
//
@property (nonatomic, strong) NSMutableArray <PlatformModel *>*platforms;


@end

@implementation CurrencyExchangeChildVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //
    [self initTableView];
    //获取当前币种相关的平台列表
    [self requestPlatformList];
    
}

#pragma mark - Init
- (void)initTableView {
    
    self.tableView = [[PlatformInfoTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    
    self.tableView.tag = 1800 + self.index;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(0);
    }];
}

#pragma mark - Setting
- (void)setVcCanScroll:(BOOL)vcCanScroll {
    
    _vcCanScroll = vcCanScroll;
    
    self.tableView.vcCanScroll = vcCanScroll;
    
    self.tableView.contentOffset = CGPointZero;
}

#pragma mark - Data
- (void)requestPlatformList {
    
    BaseWeakSelf;
    
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    
    helper.code = @"628353";
    helper.parameters[@"symbol"] = self.platform.symbol;
    helper.parameters[@"toSymbol"] = self.platform.toSymbol;
    helper.isList = YES;
    
    helper.tableView = self.tableView;
    
    [helper modelClass:[PlatformModel class]];
    
    [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
        
        weakSelf.platforms = objs;
        
        weakSelf.tableView.platforms = objs;
        
        [weakSelf.tableView reloadData_tl];
        
    } failure:^(NSError *error) {
        
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
