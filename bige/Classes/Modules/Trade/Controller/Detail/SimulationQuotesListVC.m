//
//  SimulationQuotesListVC.m
//  bige
//
//  Created by 蔡卓越 on 2018/5/4.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "SimulationQuotesListVC.h"

//Manager
#import "TradeManager.h"
//V
#import "SimulationQuotesTableView.h"

@interface SimulationQuotesListVC ()<RefreshDelegate>
//
@property (nonatomic, strong) NSMutableArray <PlatformModel *>*quotesList;
@property (nonatomic, strong) NSMutableArray <OptionInfoModel *> *options;
//
@property (nonatomic, strong) SimulationQuotesTableView *tableView;

@end

@implementation SimulationQuotesListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //
    [self initTableView];
    
    if (self.currentIndex == 0) {
        
        //自选列表
        [self requestOptionList];
        
    } else {
        
        //获取行情列表
        [self requestQuotesList];
    }
    
    //刷新行情列表
    [self.tableView beginRefreshing];
    //添加通知
    [self addNotification];
}

#pragma mark - Notification
- (void)addNotification {
    
    //改变交易所
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeExchange) name:@"DidChangeExchange" object:nil];
}

- (void)changeExchange {
    
    //刷新行情列表
    [self.tableView beginRefreshing];
}

#pragma mark - Init
- (void)initTableView {
    
    self.tableView = [[SimulationQuotesTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    
    self.tableView.placeHolderView = [TLPlaceholderView placeholderViewWithImage:@"暂无行情" text:@"暂无行情"];
    self.tableView.currentIndex = self.currentIndex;
    self.tableView.refreshDelegate = self;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(0);
    }];
    
}

#pragma mark - Data
/**
 获取行情列表
 */
- (void)requestOptionList {
    
    BaseWeakSelf;
    
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    
    helper.code = @"628336";
    helper.parameters[@"userId"] = [TLUser user].userId;
    
    helper.tableView = self.tableView;
    
    [helper modelClass:[OptionInfoModel class]];
    
    [self.tableView addRefreshAction:^{
        
        helper.parameters[@"exchangeEname"] = [TradeManager manager].exchange;

        [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.options = objs;
            
            weakSelf.tableView.options = objs;
            
            [weakSelf.tableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
        }];
    }];
    
    [self.tableView addLoadMoreAction:^{
        
        [helper loadMore:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.options = objs;
            
            weakSelf.tableView.options = objs;
            
            [weakSelf.tableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
        }];
    }];
    
    [self.tableView endRefreshingWithNoMoreData_tl];
}

- (void)requestQuotesList {
    
    NSArray *toSymbolArr = @[@"USDT", @"BTC", @"ETH"];
    
    BaseWeakSelf;
    
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    
    helper.code = @"628350";
    helper.parameters[@"percentPeriod"] = @"24h";
    helper.parameters[@"toSymbol"] = toSymbolArr[self.currentIndex - 1];
    
    helper.tableView = self.tableView;
    
    [helper modelClass:[PlatformModel class]];
    
    [self.tableView addRefreshAction:^{
        
        helper.parameters[@"exchangeEname"] = [TradeManager manager].exchange;

        [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.quotesList = objs;
            
            weakSelf.tableView.quotesList = objs;
            
            [weakSelf.tableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
        }];
    }];
    
    [self.tableView addLoadMoreAction:^{
        
        [helper loadMore:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.quotesList = objs;
            
            weakSelf.tableView.quotesList = objs;
            
            [weakSelf.tableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
        }];
    }];
    
    [self.tableView endRefreshingWithNoMoreData_tl];
}

#pragma mark - RefreshDelegate
- (void)refreshTableView:(TLTableView *)refreshTableview didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.currentIndex == 0) {
        
        OptionInfoModel *infoModel = self.options[indexPath.row];
        
        if (self.didSelectOptional) {
            
            self.didSelectOptional(infoModel);
        }
        return ;
    }
    
    PlatformModel *quotes = self.quotesList[indexPath.row];
    
    if (self.didSelectQuotes) {
        
        self.didSelectQuotes(quotes);
    }
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
