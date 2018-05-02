//
//  InfoListVC.m
//  bige
//
//  Created by 蔡卓越 on 2018/4/24.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "InfoListVC.h"
//M
#import "InformationModel.h"
#import "InfoManager.h"
//V
#import "InformationListTableView.h"
#import "TLPlaceholderView.h"
//C
#import "InfoDetailVC.h"

@interface InfoListVC ()<RefreshDelegate>
//资讯
@property (nonatomic, strong) InformationListTableView *infoTableView;
//infoList
@property (nonatomic, strong) NSArray <InformationModel *>*infos;
//
@property (nonatomic, strong) TLPageDataHelper *flashHelper;

@end

@implementation InfoListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //添加通知
//    [self addNotification];
    //资讯
    [self initInfoTableView];
    //获取资讯列表
    [self requestInfoList];
    //刷新
    [self.infoTableView beginRefreshing];
}

#pragma mark - Init

- (void)initInfoTableView {
    
    self.infoTableView = [[InformationListTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    
    self.infoTableView.refreshDelegate = self;
    self.infoTableView.placeHolderView = [TLPlaceholderView placeholderViewWithImage:@"" text:@"暂无新闻"];
    
    [self.view addSubview:self.infoTableView];
    [self.infoTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(0);
    }];
}

#pragma mark - Data

- (void)requestInfoList {
    
    BaseWeakSelf;
    
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    
    helper.code = @"628205";
    
    helper.tableView = self.infoTableView;
    
    [helper modelClass:[InformationModel class]];
    
    [self.infoTableView addRefreshAction:^{
        
        [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.infos = objs;
            
            weakSelf.infoTableView.infos = objs;
            
            [weakSelf.infoTableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
        }];
    }];
    
    [self.infoTableView addLoadMoreAction:^{
        
        [helper loadMore:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.infos = objs;
            
            weakSelf.infoTableView.infos = objs;
            
            [weakSelf.infoTableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
        }];
    }];
    
    [self.infoTableView endRefreshingWithNoMoreData_tl];
}

#pragma mark - RefreshDelegate
- (void)refreshTableView:(TLTableView *)refreshTableview didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BaseWeakSelf;
    
    InfoDetailVC *detailVC = [InfoDetailVC new];
    
    detailVC.code = self.infos[indexPath.row].code;
//    detailVC.title = self.titleStr;
    detailVC.collectionBlock = ^{
        
        [weakSelf.infoTableView beginRefreshing];
    };
    
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
