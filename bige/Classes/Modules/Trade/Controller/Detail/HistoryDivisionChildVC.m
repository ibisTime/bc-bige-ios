//
//  HistoryDivisionChildVC.m
//  bige
//
//  Created by 蔡卓越 on 2018/5/9.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "HistoryDivisionChildVC.h"

//M
#import "DivisionFilterManager.h"
//V
#import "HistoryDivisionTableView.h"

@interface HistoryDivisionChildVC ()

//历史委托列表
@property (nonatomic, strong) HistoryDivisionTableView *tableView;
@property (nonatomic, strong) NSMutableArray <DivisionModel *>*divisionList;
//交易管理类
@property (nonatomic, strong) DivisionFilterManager *manager;

@end

@implementation HistoryDivisionChildVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //添加历史委托列表
    [self initTableView];
    //获取历史委托列表
    [self requestDivisionList];
    //
    [self.tableView beginRefreshing];
    //添加通知
    [self addNotification];
}

#pragma mark - Notification
- (void)addNotification {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadDivisionList) name:@"DidReloadDivisionBlock" object:nil];
    
}

- (void)reloadDivisionList {
    
    [self.tableView beginRefreshing];
}

#pragma mark - Init
- (void)initTableView {
    
    self.manager = [DivisionFilterManager manager];
    
    self.tableView = [[HistoryDivisionTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    
    self.tableView.placeHolderView = [TLPlaceholderView placeholderViewWithImage:@"暂无记录" text:@"暂无记录"];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(0);
    }];
    
}

/**
 获取历史委托列表
 */
- (void)requestDivisionList {
    
    BaseWeakSelf;
    
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    
    helper.code = @"628508";
    helper.parameters[@"userId"] = [TLUser user].userId;
    
    helper.parameters[@"statusList"] = @[@"2", @"3", @"4"];
    
    helper.tableView = self.tableView;
    
    [helper modelClass:[DivisionModel class]];
    
    [self.tableView addRefreshAction:^{
        
        helper.parameters[@"direction"] = weakSelf.manager.direction;
        helper.parameters[@"symbol"] = weakSelf.manager.symbol;
        helper.parameters[@"toSymbol"] = weakSelf.manager.toSymbol;
        
        [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.divisionList = objs;
            
            weakSelf.tableView.divisionList = objs;
            
            [weakSelf.tableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
        }];
    }];
    
    [self.tableView addLoadMoreAction:^{
        
        [helper loadMore:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.divisionList = objs;
            
            weakSelf.tableView.divisionList = objs;
            
            [weakSelf.tableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
        }];
    }];
    
    [self.tableView endRefreshingWithNoMoreData_tl];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
