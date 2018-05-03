//
//  WarningSettingVC.m
//  bige
//
//  Created by 蔡卓越 on 2018/5/3.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "WarningSettingVC.h"

//M
#import "WarningModel.h"
//V
#import "BaseView.h"
#import "WarningSettingTableView.h"
//C
#import "WarningLeaveMessageVC.h"

@interface WarningSettingVC ()<RefreshDelegate>
//
@property (nonatomic, strong) BaseView *headerView;
//
@property (nonatomic, strong) WarningSettingTableView *tableView;
//
@property (nonatomic, strong) NSMutableArray <WarningModel *>*warnings;

@end

@implementation WarningSettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"预警管理";
    
    [self initHeaderView];
    
    [self initTableView];
    //获取预警列表
    [self requestWarningList];
    //刷新列表
    [self.tableView beginRefreshing];
}

#pragma mark - Init
- (void)initHeaderView {
    
    self.headerView = [[BaseView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 32)];
    
    self.headerView.backgroundColor = kWhiteColor;
    
    //币种
    UILabel *symbolLbl = [UILabel labelWithBackgroundColor:kClearColor
                                                 textColor:kTextColor2
                                                      font:12.0];
    symbolLbl.text = @"币种";
    [self.headerView addSubview:symbolLbl];
    [symbolLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@15);
        make.centerY.equalTo(@0);
    }];
    //当前价格
    UILabel *priceLbl = [UILabel labelWithBackgroundColor:kClearColor
                                                 textColor:kTextColor2
                                                      font:12.0];
    priceLbl.text = @"当前价格";
    [self.headerView addSubview:priceLbl];
    [priceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@(kWidth(140)));
        make.centerY.equalTo(@0);
    }];
    //留言
    UIButton *leaveBtn = [UIButton buttonWithTitle:@"留言"
                                        titleColor:kTextColor2
                                   backgroundColor:kClearColor
                                         titleFont:12.0];
//    [leaveBtn addTarget:self action:@selector(leaveMessage) forControlEvents:UIControlEventTouchUpInside];
    
    [self.headerView addSubview:leaveBtn];
    [leaveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(@(0));
        make.centerY.equalTo(@0);
        make.width.equalTo(@50);
        make.height.equalTo(@32);
    }];
    
    //预警幅度/价格
    UILabel *percentLbl = [UILabel labelWithBackgroundColor:kClearColor
                                                textColor:kTextColor2
                                                     font:12.0];
    percentLbl.text = @"预警幅度/价格";
    [self.headerView addSubview:percentLbl];
    [percentLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(leaveBtn.mas_left).offset(-15);
        make.centerY.equalTo(@0);
    }];
    //bottomLine
    UIView *bottomLine = [[UIView alloc] init];
    
    bottomLine.backgroundColor = kLineColor;
    
    [self.headerView addSubview:bottomLine];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.bottom.equalTo(@0);
        make.height.equalTo(@0.5);
        
    }];
}

- (void)initTableView {
    
    self.tableView = [[WarningSettingTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    
    self.tableView.placeHolderView = [TLPlaceholderView placeholderViewWithImage:@"" text:@"暂无预警"];
    self.tableView.refreshDelegate = self;
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(0);
    }];
}

#pragma mark - Data
- (void)requestWarningList {
    
    BaseWeakSelf;
    
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    
    helper.code = @"628395";
    helper.parameters[@"userId"] = [TLUser user].userId;
    
    helper.tableView = self.tableView;
    
    [helper modelClass:[WarningModel class]];
    
    [self.tableView addRefreshAction:^{
        
        [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.warnings = objs;
            
            weakSelf.tableView.warnings = objs;
            
            weakSelf.tableView.tableHeaderView = objs.count > 0 ? weakSelf.headerView: nil;
            
            [weakSelf.tableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
        }];
    }];
    
    [self.tableView addLoadMoreAction:^{
        
        [helper loadMore:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.warnings = objs;
            
            weakSelf.tableView.warnings = objs;
            
            [weakSelf.tableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
        }];
    }];
    
    [self.tableView endRefreshingWithNoMoreData_tl];
}

#pragma mark - RefreshDelegate
- (void)refreshTableViewEventClick:(TLTableView *)refreshTableview selectRowAtIndex:(NSInteger)index {
    
    BaseWeakSelf;
    
    WarningModel *warnModel = self.warnings[index];
    
    WarningLeaveMessageVC *messageVC = [WarningLeaveMessageVC new];
    
    messageVC.message = warnModel.warnContent;
    messageVC.ID = warnModel.ID;
    
    messageVC.leaveMessageBlock = ^{
      
        [weakSelf.tableView beginRefreshing];
    };
    
    [self.navigationController pushViewController:messageVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
