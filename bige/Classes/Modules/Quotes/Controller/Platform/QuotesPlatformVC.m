//
//  QuotesPlatformVC.m
//  bige
//
//  Created by 蔡卓越 on 2018/3/21.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "QuotesPlatformVC.h"

//Category
#import "NSString+CGSize.h"
//M
#import "PlatformModel.h"
//V
#import "BaseView.h"
//C
#import "CurrencyDetailVC.h"

@interface QuotesPlatformVC ()<RefreshDelegate>
//
@property (nonatomic, strong) NSArray <PlatformModel *>*platforms;
//平台
@property (nonatomic, strong) PlatformTableView *tableView;
//
@property (nonatomic, strong) BaseView *headerView;
//平台名称
@property (nonatomic, strong) UILabel *platformNameLbl;
//帖子数
@property (nonatomic, strong) UILabel *postNumLbl;
//定时器
@property (nonatomic, strong) NSTimer *timer;
//
@property (nonatomic, strong) TLPageDataHelper *helper;
//涨跌幅时长
@property (nonatomic, copy) NSString *percentPeriod;
//计价币种
@property (nonatomic, copy) NSString *toSymbol;

@end

@implementation QuotesPlatformVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //头部
    [self initHeaderView];
    //
    [self initTableView];
    //获取平台列表
    [self requestPlatformList];
    //刷新平台列表
    [self.tableView beginRefreshing];
    //添加通知
    [self addNotification];
}

#pragma mark - 通知
- (void)addNotification {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSwitchLabel:) name:@"DidSwitchLabel" object:nil];
    //点击关注
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(followOrCancelFollow) name:@"FollowOrCancelFollow" object:nil];
}

- (void)didSwitchLabel:(NSNotification *)notification {
    
    NSInteger segmentIndex = [notification.userInfo[@"segmentIndex"] integerValue];
    
    NSInteger labelIndex = [notification.userInfo[@"labelIndex"] integerValue];

    if (labelIndex == self.currentIndex && segmentIndex == 2) {
        //刷新列表
        [self.tableView beginRefreshing];
        //定时器刷起来
        [self startTimer];
        return ;
    }
    //定时器停止
    [self stopTimer];
}

- (void)followOrCancelFollow {
    
    //刷新列表
    [self.tableView beginRefreshing];
}

#pragma mark - 定时器
- (void)startTimer {
    
    //开启定时器,实时刷新
    self.timer = [NSTimer timerWithTimeInterval:10
                                         target:self
                                       selector:@selector(refreshPlatformList)
                                       userInfo:nil
                                        repeats:YES];
    
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
    NSLog(@"平台定时器开启, index = %ld", self.currentIndex);

}

- (void)refreshPlatformList {
    NSLog(@"平台定时器刷新中, index = %ld", self.currentIndex);

    BaseWeakSelf;
    //刷新平台列表
    [self.helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
        
        weakSelf.platforms = objs;
        
        weakSelf.tableView.platforms = objs;
        
        [weakSelf.tableView reloadData_tl];
        
    } failure:^(NSError *error) {
        
    }];
}

//定时器停止
- (void)stopTimer {
    
    [self.timer invalidate];
    self.timer = nil;
    NSLog(@"平台定时器停止, index = %ld", self.currentIndex);
}

#pragma mark - Init
- (void)initHeaderView {
    
    self.toSymbol = @"usdt";
    self.percentPeriod = @"24h";
    
    self.headerView = [[BaseView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 70)];
    
    self.headerView.backgroundColor = kWhiteColor;
    //单位
    UILabel *unitLbl = [UILabel labelWithBackgroundColor:kClearColor
                                               textColor:kTextColor4
                                                    font:11.0];
    unitLbl.text = @"单位:";
    [self.headerView addSubview:unitLbl];
    [unitLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@15);
        make.top.equalTo(@15);
    }];
    
    NSArray *textArr = @[@"USDT", @"BTC", @"ETH"];
    
    for (int i = 0; i < 3; i++) {
        
        CGFloat btnW = [NSString getWidthWithString:textArr[i] font:11.0];
        
        UIButton *symbolBtn = [UIButton buttonWithTitle:textArr[i]
                                             titleColor:kTextColor4
                                        backgroundColor:kClearColor
                                              titleFont:11.0];
        
        [symbolBtn setTitleColor:kAppCustomMainColor forState:UIControlStateSelected];
        [symbolBtn addTarget:self action:@selector(selectSymbol:) forControlEvents:UIControlEventTouchUpInside];
        symbolBtn.tag = 1800 + i;
        symbolBtn.selected = i == 0 ? YES: NO;

        [self.headerView addSubview:symbolBtn];
        [symbolBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(unitLbl.mas_right).offset(5+i*(btnW+20));
            make.width.equalTo(@(btnW));
            make.centerY.equalTo(unitLbl.mas_centerY);
        }];
    }
    //时长
    UILabel *timeLbl = [UILabel labelWithBackgroundColor:kClearColor
                                               textColor:kTextColor4
                                                    font:11.0];
    timeLbl.text = @"时长:";

    [self.headerView addSubview:timeLbl];
    [timeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(@(-125));
        make.top.equalTo(@15);
    }];
    
    NSArray *percentArr = @[@"24h", @"1W", @"1M"];
    
    for (int i = 0; i < 3; i++) {
        
        CGFloat btnW = [NSString getWidthWithString:percentArr[i] font:11.0];
        
        UIButton *percentBtn = [UIButton buttonWithTitle:percentArr[i]
                                             titleColor:kTextColor4
                                        backgroundColor:kClearColor
                                              titleFont:11.0];
        
        [percentBtn setTitleColor:kAppCustomMainColor forState:UIControlStateSelected];
        [percentBtn addTarget:self action:@selector(selectPercent:) forControlEvents:UIControlEventTouchUpInside];
        percentBtn.tag = 1810 + i;
        percentBtn.selected = i == 0 ? YES: NO;
        
        [self.headerView addSubview:percentBtn];
        [percentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(timeLbl.mas_right).offset(5+i*(btnW+20));
            make.width.equalTo(@(btnW));
            make.centerY.equalTo(timeLbl.mas_centerY);
        }];
    }
    
    //排行
    UILabel *rankLbl = [UILabel labelWithBackgroundColor:kClearColor
                                               textColor:kTextColor4
                                                    font:11.0];
    rankLbl.text = @"#";
    [self.headerView addSubview:rankLbl];
    [rankLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(unitLbl.mas_left);
        make.top.equalTo(unitLbl.mas_bottom).offset(20);
    }];
    //币种
    UILabel *symbolLbl = [UILabel labelWithBackgroundColor:kClearColor
                                               textColor:kTextColor4
                                                    font:11.0];
    symbolLbl.text = @"币种";
    [self.headerView addSubview:symbolLbl];
    [symbolLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@45);
        make.centerY.equalTo(rankLbl.mas_centerY);
    }];
    //关注
    UILabel *followLbl = [UILabel labelWithBackgroundColor:kClearColor
                                                 textColor:kTextColor4
                                                      font:11.0];
    followLbl.text = @"关注";
    [self.headerView addSubview:followLbl];
    [followLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(@(-15));
        make.centerY.equalTo(rankLbl.mas_centerY);
    }];
    //涨跌幅24h
    UILabel *percentLbl = [UILabel labelWithBackgroundColor:kClearColor
                                                 textColor:kTextColor4
                                                      font:11.0];
    percentLbl.text = @"涨跌幅24h";
    [self.headerView addSubview:percentLbl];
    [percentLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(followLbl.mas_left).offset(-25);
        make.centerY.equalTo(rankLbl.mas_centerY);
    }];
    //价格:￥
    UILabel *priceLbl = [UILabel labelWithBackgroundColor:kClearColor
                                                  textColor:kTextColor4
                                                       font:11.0];
    priceLbl.text = @"价格:￥";
    [self.headerView addSubview:priceLbl];
    [priceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(percentLbl.mas_left).offset(-20);
        make.centerY.equalTo(rankLbl.mas_centerY);
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
    
    self.tableView = [[PlatformTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    
    self.tableView.placeHolderView = [TLPlaceholderView placeholderViewWithImage:@"暂无行情" text:@"暂无行情"];
    self.tableView.refreshDelegate = self;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(0);
    }];
    
    self.tableView.tableHeaderView = self.headerView;
    
}

#pragma mark - Events

- (void)clickPlatformWithIndex:(NSInteger)index {

    //刷新平台列表
    [self.tableView beginRefreshing];
    //判断是否当前子控制器,是则开启定时器。否则关闭
    if (index == self.currentIndex) {
        
        //定时器开启
        [self startTimer];
        return ;
    }
    //定时器停止
    [self stopTimer];
}

- (void)selectSymbol:(UIButton *)sender {
    
    NSInteger index = sender.tag - 1800;
    
    for (int i = 0; i < 3; i++) {
        
        UIButton *btn = [self.headerView viewWithTag:1800 + i];
        
        btn.selected = sender.tag == btn.tag ? YES: NO;
    }
    
    NSArray *symbolArr = @[@"usdt", @"btc", @"eth"];
    
    self.toSymbol = symbolArr[index];
    //刷新列表
    [self.tableView beginRefreshing];
}

- (void)selectPercent:(UIButton *)sender {
    
    NSInteger index = sender.tag - 1810;

    for (int i = 0; i < 3; i++) {
        
        UIButton *btn = [self.headerView viewWithTag:1810 + i];
        
        btn.selected = sender.tag == btn.tag ? YES: NO;
    }
    
    NSArray *percentArr = @[@"24h", @"7d", @"1m"];
    
    self.percentPeriod = percentArr[index];
    //刷新列表
    [self.tableView beginRefreshing];
}

/**
 关注
 */
- (void)followCurrency:(NSInteger)index {
    
    PlatformModel *platformModel = self.platforms[index];
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"628330";
    http.showView = self.view;
    http.parameters[@"exchangeEname"] = platformModel.exchangeEname;
    http.parameters[@"userId"] = [TLUser user].userId;
    http.parameters[@"symbol"] = platformModel.symbol;
    http.parameters[@"toSymbol"] = platformModel.toSymbol;

    [http postWithSuccess:^(id responseObject) {
        
        NSString *promptStr = [platformModel.isChoice isEqualToString:@"1"] ? @"删除自选成功": @"添加自选成功";
        [TLAlert alertWithSucces:promptStr];
        
        if ([platformModel.isChoice isEqualToString:@"1"]) {
            
            platformModel.isChoice = @"0";
            
        } else {
            
            platformModel.isChoice = @"1";
        }
        
        [self.tableView reloadData];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"FollowOrCancelFollow" object:nil];
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - Data
/**
 获取平台列表
 */
- (void)requestPlatformList {
    
    BaseWeakSelf;
    
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    
    helper.code = @"628350";
    
    helper.parameters[@"exchangeEname"] = self.titleModel.ename;

    helper.tableView = self.tableView;
    
    [helper modelClass:[PlatformModel class]];
    
    self.helper = helper;
    
    [self.tableView addRefreshAction:^{
        
        if ([TLUser user].isLogin) {
            
            helper.parameters[@"userId"] = [TLUser user].userId;
        }
        helper.parameters[@"percentPeriod"] = weakSelf.percentPeriod;
        helper.parameters[@"toSymbol"] = weakSelf.toSymbol;
        
        [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.platforms = objs;
            
            weakSelf.tableView.platforms = objs;
            
            [weakSelf.tableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
        }];
    }];
    
    [self.tableView addLoadMoreAction:^{
        
        [helper loadMore:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.platforms = objs;
            
            weakSelf.tableView.platforms = objs;
            
            [weakSelf.tableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
        }];
    }];
    
    [self.tableView endRefreshingWithNoMoreData_tl];
}

#pragma mark - RefreshDelegate
- (void)refreshTableView:(TLTableView *)refreshTableview didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PlatformModel *platform = self.platforms[indexPath.row];
    
    if ([platform.exchangeEname isEqualToString:@"marketGlobal"]) {
        
        return ;
    }
    CurrencyDetailVC *detailVC = [CurrencyDetailVC new];
    
    detailVC.symbolID = platform.ID;
    
    [self.navigationController pushViewController:detailVC animated:YES];
    
}

- (void)refreshTableViewEventClick:(TLTableView *)refreshTableview selectRowAtIndex:(NSInteger)index {
    
    BaseWeakSelf;
    [self checkLogin:^{
        
        //刷新关注状态
        [weakSelf.tableView beginRefreshing];
        
    } event:^{
        
        [weakSelf followCurrency:index];
    }];
}
/**
 VC被释放时移除通知
 */
- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
