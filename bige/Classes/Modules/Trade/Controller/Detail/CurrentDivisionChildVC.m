//
//  CurrentDivisionChildVC.m
//  bige
//
//  Created by 蔡卓越 on 2018/5/9.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "CurrentDivisionChildVC.h"

//M
#import "DivisionFilterManager.h"
//V
#import "CurrentDivisionTableView.h"

@interface CurrentDivisionChildVC ()<RefreshDelegate>
//当前委托列表
@property (nonatomic, strong) CurrentDivisionTableView *tableView;
@property (nonatomic, strong) NSMutableArray <DivisionModel *>*divisionList;
//交易管理类
@property (nonatomic, strong) DivisionFilterManager *manager;

@end

@implementation CurrentDivisionChildVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //添加我当前委托列表
    [self initTableView];
    //获取我当前委托列表
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
    
    self.tableView = [[CurrentDivisionTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    
    self.tableView.placeHolderView = [TLPlaceholderView placeholderViewWithImage:@"暂无记录" text:@"暂无记录"];
    
    self.tableView.refreshDelegate = self;
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(0);
    }];
    
}

/**
 获取我当前委托列表
 */
- (void)requestDivisionList {
    
    BaseWeakSelf;
    
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    
    helper.code = @"628508";
    helper.parameters[@"userId"] = [TLUser user].userId;
    
    helper.parameters[@"statusList"] = @[@"0", @"1"];

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

/**
 撤销委托单
 */
- (void)cancelDivision:(NSInteger)index {
    
    DivisionModel *division = self.divisionList[index];
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"628501";
    http.showView = self.view;
    http.parameters[@"code"] = division.code;
    
    [http postWithSuccess:^(id responseObject) {
        
        [TLAlert alertWithSucces:@"撤销成功"];
        
        [self.tableView beginRefreshing];
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - RefreshDelegate
- (void)refreshTableViewEventClick:(TLTableView *)refreshTableview selectRowAtIndex:(NSInteger)index {
    
    [TLAlert alertWithTitle:@"温馨提示" msg:@"确定要撤销该委托单?" confirmMsg:@"确定" cancleMsg:@"取消" cancle:^(UIAlertAction *action) {
        
    } confirm:^(UIAlertAction *action) {
        
        [self cancelDivision:index];
        
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
