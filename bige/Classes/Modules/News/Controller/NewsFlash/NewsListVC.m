//
//  NewsListVC.m
//  bige
//
//  Created by 蔡卓越 on 2018/4/24.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "NewsListVC.h"
//M
#import "NewsFlashModel.h"
//V
#import "NewsFlashListTableView.h"
#import "TLPlaceholderView.h"
//C
#import "NewsFlashDetailVC.h"

@interface NewsListVC ()<RefreshDelegate>
//快讯
@property (nonatomic, strong) NewsFlashListTableView *flashTableView;
//news
@property (nonatomic, strong) NSArray <NewsFlashModel *>*news;
//
@property (nonatomic, strong) TLPageDataHelper *flashHelper;

@end

@implementation NewsListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //添加通知
    [self addNotification];
    //快讯
    [self initFlashTableView];
    //获取快讯列表
    [self requestFlashList];
    //刷新
    [self.flashTableView beginRefreshing];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DidLoadHomeVC"
                                                        object:nil];
    
}

#pragma mark - Init
- (void)addNotification {
    //用户登录刷新首页快讯
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshNewsFlash) name:kUserLoginNotification object:nil];
    //用户退出登录刷新首页快讯
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshNewsFlash) name:kUserLoginOutNotification object:nil];
    //收到推送刷新首页快讯
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshNewsFlash)
                                                 name:@"DidReceivePushNotification"
                                               object:nil];
}

- (void)refreshNewsFlash {
    
    //
    [self.flashTableView beginRefreshing];
}

- (void)initFlashTableView {
    
    self.flashTableView = [[NewsFlashListTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    
    self.flashTableView.refreshDelegate = self;
    self.flashTableView.placeHolderView = [TLPlaceholderView placeholderViewWithImage:@"" text:@"暂无快讯"];
    
    [self.view addSubview:self.flashTableView];
    [self.flashTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(0);
    }];
}

#pragma mark - Data
- (void)requestFlashList {
    
    BaseWeakSelf;
    
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    
    helper.code = @"628097";
    
//    helper.parameters[@"type"] = self.status;
    
    helper.tableView = self.flashTableView;
    self.flashHelper = helper;
    
    [helper modelClass:[NewsFlashModel class]];
    
    [self.flashTableView addRefreshAction:^{
        
        if ([TLUser user].isLogin) {
            
            helper.parameters[@"userId"] = [TLUser user].userId;
        } else {
            
            helper.parameters[@"userId"] = @"";
        }
        
        [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.news = objs;
            
            weakSelf.flashTableView.news = objs;
            
            [weakSelf.flashTableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
        }];
    }];
    
    [self.flashTableView addLoadMoreAction:^{
        
        [helper loadMore:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.news = objs;
            
            weakSelf.flashTableView.news = objs;
            
            [weakSelf.flashTableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
        }];
        
    }];
    
    [self.flashTableView endRefreshingWithNoMoreData_tl];
}

/**
 用户点击阅读快讯
 */
- (void)userClickNewsFlash:(NewsFlashModel *)flashModel {
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"628094";
    http.parameters[@"userId"] = [TLUser user].userId;
    http.parameters[@"code"] = flashModel.code;
    
    [http postWithSuccess:^(id responseObject) {
        
        flashModel.isRead = @"1";
        flashModel.isSelect = YES;
        [self.flashTableView reloadData];
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - RefreshDelegate
- (void)refreshTableView:(TLTableView *)refreshTableview didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    BaseWeakSelf;
    
//    NewsFlashModel *flashModel = self.news[indexPath.section];
    
//    if ([[TLUser user] isLogin] && [flashModel.isRead isEqualToString:@"0"]) {
//
//        //用户点击阅读快讯
//        [self userClickNewsFlash:flashModel];
//
//    }else {
//
        [self.flashTableView reloadData];
//    }
    
}

- (void)refreshTableViewButtonClick:(TLTableView *)refreshTableview button:(UIButton *)sender selectRowAtIndex:(NSInteger)index {
    
    NewsFlashModel *flashModel = self.news[index];
    
    NewsFlashDetailVC *detailVC = [NewsFlashDetailVC new];
    
    detailVC.code = flashModel.code;
    
    [self.navigationController pushViewController:detailVC animated:YES];
    return ;
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
