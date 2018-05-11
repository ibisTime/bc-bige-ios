//
//  SimulationTradeDetailVC.m
//  bige
//
//  Created by 蔡卓越 on 2018/4/24.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "SimulationTradeDetailVC.h"

//Category
#import "UIButton+EnLargeEdge.h"
#import "NSString+Check.h"
//M
#import "PlatformModel.h"
#import "TradeManager.h"
#import "TradeListModel.h"
//V
#import "BaseView.h"
#import "SimulationTradeSliderView.h"
#import "SelectScrollView.h"
#import "TradeSelectScrollView.h"
#import "TradeListTableView.h"
#import "DivisionListTableView.h"
#import "TLPlaceholderView.h"
//C
#import "CurrencyDetailVC.h"
#import "SimulationQuotesListVC.h"
#import "TradeBuyChildVC.h"
#import "TradeSellChildVC.h"
#import "AllDivisionListVC.h"

@interface SimulationTradeDetailVC ()<RefreshDelegate>
//头部
@property (nonatomic, strong) BaseView *headerView;
//顶部
@property (nonatomic, strong) BaseView *topView;
//行情
@property (nonatomic, strong) UIButton *quotesBtn;
//平台
@property (nonatomic, strong) UILabel *symbolLbl;
//关注
@property (nonatomic, strong) UIButton *followBtn;
//交易界面
@property (nonatomic, strong) BaseView *tradeView;
//委托
//行情列表
@property (nonatomic, strong) SimulationTradeSliderView *sliderView;
@property (nonatomic, strong) SelectScrollView *selectSV;
@property (nonatomic, strong) NSArray *titles;
//买卖
@property (nonatomic, strong) TradeSelectScrollView *tradeSelectSV;
@property (nonatomic, strong) UIButton *limitBtn;
//
@property (nonatomic, strong) PlatformModel *platform;
//交易管理类
@property (nonatomic, strong) TradeManager *manager;
//委托列表
@property (nonatomic, strong) TradeListTableView *tradeTableView;
@property (nonatomic, strong) TradeListModel *tradeList;
//当前委托列表
@property (nonatomic, strong) DivisionListTableView *divisionTableView;
@property (nonatomic, strong) NSMutableArray <DivisionModel *>*divisionList;
//定时器
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation SimulationTradeDetailVC

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    //定时器刷起来
    [self startTimer];
}

- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
    //定时器停止
    [self stopTimer];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"模拟交易";
    //初始化买卖管理
    [self initTradeManager];
    //头部
    [self initHeaderView];
    //添加行情
    [self addQuotesChildVC];
    //添加买卖
    [self addTradeChildVC];
    //添加委托列表
    [self initTradeTableView];
    //添加我当前委托列表
    [self initDivisionTableView];
    //获取我当前委托列表
    [self requestDivisionList];
    //获取币种信息
    [self requestQuotesList];
}

#pragma mark - 定时器
- (void)startTimer {
    
    //开启定时器,实时刷新
    self.timer = [NSTimer timerWithTimeInterval:1
                                         target:self
                                       selector:@selector(requestTradeList)
                                       userInfo:nil
                                        repeats:YES];
    
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
}

//定时器停止
- (void)stopTimer {
    
    [self.timer invalidate];
    self.timer = nil;
}

#pragma mark - Init
- (SimulationTradeSliderView *)sliderView {
    
    if (!_sliderView) {
        
        _sliderView = [[SimulationTradeSliderView alloc] initWithFrame:CGRectMake(-kScreenWidth, 0, kScreenWidth, kScreenHeight)];
    }
    return _sliderView;
}

- (void)initTradeManager {
    
    self.manager = [TradeManager manager];
    
    self.manager.type = @"0";
    self.manager.direction = self.direction;
}

- (void)initHeaderView {
    
    self.headerView = [[BaseView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 361)];
    //顶部
    [self initTopView];
    
}

- (void)initTopView {
    
    self.topView = [[BaseView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
    
    self.topView.backgroundColor = kWhiteColor;
    
    [self.headerView addSubview:self.topView];
    //行情
    self.quotesBtn = [UIButton buttonWithTitle:@""
                                    titleColor:kTextColor
                               backgroundColor:kClearColor
                                     titleFont:14.0];
    [self.quotesBtn setImage:kImage(@"列表展开") forState:UIControlStateNormal];
    [self.quotesBtn addTarget:self action:@selector(openQuotes) forControlEvents:UIControlEventTouchUpInside];
    [self.topView addSubview:self.quotesBtn];
    [self.quotesBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.equalTo(@0);
        make.width.equalTo(@130);
        make.height.equalTo(@44);
    }];
    
    [self.quotesBtn setTitleRight];
    //平台
    self.symbolLbl = [UILabel labelWithBackgroundColor:kClearColor
                                             textColor:kTextColor
                                                  font:16.0];
    self.symbolLbl.text = @"火币";
    [self.topView addSubview:self.symbolLbl];
    [self.symbolLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(@0);
        make.centerY.equalTo(@0);
    }];
    //向左
    UIButton *leftBtn = [UIButton buttonWithImageName:@"左"];
    
    leftBtn.contentMode = UIViewContentModeScaleAspectFit;
    
    [self.topView addSubview:leftBtn];
    [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.symbolLbl.mas_left);
        make.centerY.equalTo(@0);
        make.width.height.equalTo(@30);
    }];
    //向右
    UIButton *rightBtn = [UIButton buttonWithImageName:@"右"];
    
    rightBtn.contentMode = UIViewContentModeScaleAspectFit;
    
    [self.topView addSubview:rightBtn];
    [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.symbolLbl.mas_right);
        make.centerY.equalTo(@0);
        make.width.height.equalTo(@30);
    }];
    //详情
    UIButton *detailBtn = [UIButton buttonWithImageName:@"k线图分析"];
    
    detailBtn.contentMode = UIViewContentModeScaleAspectFit;
    
    [detailBtn addTarget:self action:@selector(lookDetailInfo) forControlEvents:UIControlEventTouchUpInside];
    [self.topView addSubview:detailBtn];
    [detailBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(@(-5));
        make.centerY.equalTo(@0);
        make.width.height.equalTo(@30);
    }];
    //关注
    self.followBtn = [UIButton buttonWithTitle:@""
                                    titleColor:kTextColor
                               backgroundColor:kClearColor
                                     titleFont:14.0];
    self.followBtn.contentMode = UIViewContentModeScaleAspectFit;
    [self.followBtn addTarget:self action:@selector(follow) forControlEvents:UIControlEventTouchUpInside];
    [self.followBtn setImage:kImage(@"币种未关注") forState:UIControlStateNormal];
    
    [self.topView addSubview:self.followBtn];
    [self.followBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(detailBtn.mas_left).offset(0);
        make.centerY.equalTo(@0);
        make.width.height.equalTo(@30);
    }];
    
    //bottomLine
    UIView *bottomLine = [[UIView alloc] init];
    
    bottomLine.backgroundColor = kLineColor;
    
    [self.topView addSubview:bottomLine];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.bottom.equalTo(@0);
        make.height.equalTo(@0.5);
    }];
}

- (void)addQuotesChildVC {
    
    BaseWeakSelf;
    
    self.titles = @[@"自选", @"USDT", @"BTC", @"ETH"];
    
    self.selectSV = [[SelectScrollView alloc] initWithFrame:CGRectMake(0, 44 + kStatusBarHeight, kScreenWidth*0.8, kScreenHeight - (44 + kStatusBarHeight)) itemTitles:self.titles];
    
    [self.sliderView addSubview:self.selectSV];
    //添加子控制器
    for (NSInteger i = 0; i < self.titles.count; i++) {
        //平台
        SimulationQuotesListVC *childVC = [[SimulationQuotesListVC alloc] init];
        
        childVC.currentIndex = i;
        childVC.view.frame = CGRectMake(kScreenWidth*0.8*i, 1, kScreenWidth*0.8, kSuperViewHeight - 40);
        if (i == 0) {
            
            childVC.didSelectOptional = ^(OptionInfoModel *infoModel) {
                
                [weakSelf.sliderView hide];
                
                NSString *symbol = [NSString stringWithFormat:@"%@/%@", [infoModel.symbol uppercaseString], [infoModel.toSymbol uppercaseString]];
                
                [weakSelf.quotesBtn setTitle:symbol forState:UIControlStateNormal];
                
                weakSelf.manager.symbol = infoModel.symbol;
                weakSelf.manager.toSymbol = infoModel.toSymbol;
                weakSelf.manager.ID = infoModel.marketGlobal.ID;
                //刷新关注状态
                [weakSelf requestQuotesInfo];
                //刷新买卖五档
                [weakSelf requestTradeList];
                //刷新可用余额
                [[NSNotificationCenter defaultCenter] postNotificationName:@"QotesDidLoad" object:nil];
            };
        } else {
            
            childVC.didSelectQuotes = ^(PlatformModel *quotes) {
                
                
                [weakSelf.sliderView hide];
                
                NSString *symbol = [NSString stringWithFormat:@"%@/%@", [quotes.symbol uppercaseString], [quotes.toSymbol uppercaseString]];
                
                [weakSelf.quotesBtn setTitle:symbol forState:UIControlStateNormal];
                
                weakSelf.manager.symbol = quotes.symbol;
                weakSelf.manager.toSymbol = quotes.toSymbol;
                weakSelf.manager.ID = quotes.ID;
                //刷新关注状态
                [weakSelf requestQuotesInfo];
                //刷新买卖五档
                [weakSelf requestTradeList];
                //刷新可用余额
                [[NSNotificationCenter defaultCenter] postNotificationName:@"QotesDidLoad" object:nil];
            };
        }
        [self addChildViewController:childVC];
        
        [self.selectSV.scrollView addSubview:childVC.view];
    }
}

- (void)addTradeChildVC {
    
    BaseWeakSelf;
    
    NSArray *titles = @[@"买入", @"卖出"];
    
    self.tradeSelectSV = [[TradeSelectScrollView alloc] initWithFrame:CGRectMake(0, self.topView.yy, kScreenWidth/2.0, 305) itemTitles:titles];
    
    self.tradeSelectSV.currentIndex = [self.direction integerValue];
    
    self.tradeSelectSV.selectBlock = ^(NSInteger index) {
        
        weakSelf.manager.direction = index == 0 ? @"0": @"1";
        
        [weakSelf.tradeTableView reloadData];
    };
    
    [self.headerView addSubview:self.tradeSelectSV];
    //添加子控制器
    for (NSInteger i = 0; i < titles.count; i++) {
        
        if (i == 0) {
            
            TradeBuyChildVC *childVC = [TradeBuyChildVC new];
            
            childVC.view.frame = CGRectMake(kScreenWidth/2.0*i, 1, kScreenWidth/2.0, self.tradeSelectSV.height - 40);
            
            [self addChildViewController:childVC];
            
            [self.tradeSelectSV.scrollView addSubview:childVC.view];
            
        } else {
            
            TradeSellChildVC *childVC = [TradeSellChildVC new];
            
            childVC.view.frame = CGRectMake(kScreenWidth/2.0*i, 1, kScreenWidth/2.0, self.tradeSelectSV.height - 40);
            
            [self addChildViewController:childVC];
            
            [self.tradeSelectSV.scrollView addSubview:childVC.view];
        }
    }
    
    //限价
    UIButton *limitBtn = [UIButton buttonWithTitle:@"限价"
                                        titleColor:kTextColor2
                                   backgroundColor:kClearColor
                                         titleFont:13.0];
    [limitBtn setImage:kImage(@"火币下拉实心") forState:UIControlStateNormal];
    
    [limitBtn addTarget:self action:@selector(selectPriceMode) forControlEvents:UIControlEventTouchUpInside];
    [self.tradeSelectSV addSubview:limitBtn];
    [limitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(@0);
        make.right.equalTo(@(-5));
        make.height.equalTo(@40);
        make.width.equalTo(@40);
    }];
    [limitBtn setTitleLeft];
    
    self.limitBtn = limitBtn;
}

- (void)initTradeTableView {
    
    self.tradeTableView = [[TradeListTableView alloc] initWithFrame:CGRectMake(kScreenWidth/2.0, self.topView.yy, kScreenWidth/2.0, 305) style:UITableViewStylePlain];
    
    [self.headerView addSubview:self.tradeTableView];

}

- (void)initDivisionTableView {
    
    self.divisionTableView = [[DivisionListTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    
    self.divisionTableView.placeHolderView = [TLPlaceholderView placeholderViewWithImage:@"暂无记录" text:@"暂无记录"];
    
    self.divisionTableView.refreshDelegate = self;
    
    [self.view addSubview:self.divisionTableView];
    [self.divisionTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(0);
    }];
    
    self.divisionTableView.tableHeaderView = self.headerView;
    
}

#pragma mark - Events

/**
 选择价格模式
 */
- (void)selectPriceMode {
    
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"" message:@"请对该商品做出评价" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *limitAction = [UIAlertAction actionWithTitle:@"限价" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        self.manager.type = @"0";
        
        [self.limitBtn setTitle:@"限价" forState:UIControlStateNormal];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"DidChangeLimitPrice" object:nil];
    }];
    
    UIAlertAction *marketAction = [UIAlertAction actionWithTitle:@"市价" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        self.manager.type = @"1";
        [self.limitBtn setTitle:@"市价" forState:UIControlStateNormal];

        [[NSNotificationCenter defaultCenter] postNotificationName:@"DidChangeLimitPrice" object:nil];
    }];
    
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
//        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    [actionSheet addAction:limitAction];
    [actionSheet addAction:marketAction];
    [actionSheet addAction:cancleAction];
    
    [self presentViewController:actionSheet animated:YES completion:nil];
}

/**
 行情列表
 */
- (void)openQuotes {
    
    [self.view addSubview:self.sliderView];
    
    [self.sliderView show];
}

/**
 查看详情
 */
- (void)lookDetailInfo {
    
    CurrencyDetailVC *detailVC = [CurrencyDetailVC new];
    
    detailVC.symbolID = self.manager.ID;
    
    [self.navigationController pushViewController:detailVC animated:YES];
}
/**
 关注
 */
- (void)follow {
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"628330";
    http.showView = self.view;
    http.parameters[@"exchangeEname"] = self.manager.exchange;
    http.parameters[@"userId"] = [TLUser user].userId;
    http.parameters[@"symbol"] = self.manager.symbol;
    http.parameters[@"toSymbol"] = self.manager.toSymbol;
    
    [http postWithSuccess:^(id responseObject) {
        
        NSString *promptStr = [self.platform.isChoice isEqualToString:@"1"] ? @"删除自选成功": @"添加自选成功";
        [TLAlert alertWithSucces:promptStr];
        
        if ([self.platform.isChoice isEqualToString:@"1"]) {
            
            self.platform.isChoice = @"0";
            
        } else {
            
            self.platform.isChoice = @"1";
        }
        
        NSString *imgName = [self.platform.isChoice isEqualToString:@"0"] ? @"币种未关注": @"币种关注";
        [self.followBtn setImage:kImage(imgName) forState:UIControlStateNormal];
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - Data

/**
 获取币种信息
 */
- (void)requestQuotesList {
    
    BaseWeakSelf;
    
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    
    helper.code = @"628350";
    helper.parameters[@"exchangeEname"] = @"huobiPro";
    helper.parameters[@"percentPeriod"] = @"24h";
    helper.parameters[@"toSymbol"] = @"USDT";
    
    [helper modelClass:[PlatformModel class]];
    
    [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
        
        if (objs.count > 0) {
            
            weakSelf.platform = objs[0];
            
            NSString *symbol = [NSString stringWithFormat:@"%@/%@", [weakSelf.platform.symbol uppercaseString], [weakSelf.platform.toSymbol uppercaseString]];
            
            [weakSelf.quotesBtn setTitle:symbol forState:UIControlStateNormal];
            
            weakSelf.manager.symbol = weakSelf.platform.symbol;
            weakSelf.manager.toSymbol = weakSelf.platform.toSymbol;
            weakSelf.manager.exchange = weakSelf.platform.exchangeEname;
            weakSelf.manager.ID = weakSelf.platform.ID;
            //刷新关注状态
            [weakSelf requestQuotesInfo];
            //获取买卖五档
            [weakSelf requestTradeList];
            //获取可用余额
            [[NSNotificationCenter defaultCenter] postNotificationName:@"QotesDidLoad" object:nil];
            //刷新当前委托列表
            [weakSelf.divisionTableView beginRefreshing];
        }
        
    } failure:^(NSError *error) {
        
    }];
    
}

/**
 获取委托列表
 */
- (void)requestTradeList {
    
    if (![self.manager.symbol valid] || ![self.manager.toSymbol valid] || ![self.manager.exchange valid]) {
        
        return ;
    }
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"628380";
    http.parameters[@"symbol"] = [NSString stringWithFormat:@"%@/%@", self.manager.symbol, self.manager.toSymbol];
;
    http.parameters[@"exchange"] = self.manager.exchange;
    
    [http postWithSuccess:^(id responseObject) {
        
        self.tradeList = [TradeListModel mj_objectWithKeyValues:responseObject[@"data"]];
        
        self.tradeTableView.tradeList = self.tradeList;
        
        [self.tradeTableView reloadData];
        
        [self getRmbAmount];
        
    } failure:^(NSError *error) {
        
    }];
}

/**
 查询交易所下计价币种兑换成人民币的金额
 */
- (void)getRmbAmount {
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"628923";
//    http.showView = self.view;
    http.parameters[@"exchange"] = self.manager.exchange;
    http.parameters[@"toSymbol"] = self.manager.toSymbol;
    
    [http postWithSuccess:^(id responseObject) {
        
        self.manager.cnyPrice = responseObject[@"data"][@"cnyPrice"];
        
        [self.tradeTableView reloadData];
        
    } failure:^(NSError *error) {
        
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
    helper.parameters[@"exchange"] = self.manager.exchange;
    helper.parameters[@"symbol"] = self.manager.symbol;
    helper.parameters[@"toSymbol"] = self.manager.toSymbol;
    
    helper.parameters[@"statusList"] = @[@"0", @"1"];
    
    helper.tableView = self.divisionTableView;
    
    [helper modelClass:[DivisionModel class]];
    
    [self.divisionTableView addRefreshAction:^{
        
        [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.divisionList = objs;
            
            weakSelf.divisionTableView.divisionList = objs;
            
            [weakSelf.divisionTableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
        }];
    }];
    
    [self.divisionTableView addLoadMoreAction:^{
        
        [helper loadMore:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.divisionList = objs;
            
            weakSelf.divisionTableView.divisionList = objs;
            
            [weakSelf.divisionTableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
        }];
    }];
    
    [self.divisionTableView endRefreshingWithNoMoreData_tl];
}

/**
 查询币种详情
 */
- (void)requestQuotesInfo {
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"628352";
    http.showView = self.view;
    http.parameters[@"id"] = self.platform.ID;
    if ([TLUser user].userId) {
        
        http.parameters[@"userId"] = [TLUser user].userId;
    }
    
    [http postWithSuccess:^(id responseObject) {
        
        self.platform = [PlatformModel mj_objectWithKeyValues:responseObject[@"data"]];
        
        NSString *imgName = [self.platform.isChoice isEqualToString:@"0"] ? @"币种未关注": @"币种关注";
        [self.followBtn setImage:kImage(imgName) forState:UIControlStateNormal];
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)cancelDivision:(NSInteger)index {
    
    DivisionModel *division = self.divisionList[index];
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"628501";
    http.showView = self.view;
    http.parameters[@"code"] = division.code;
    
    [http postWithSuccess:^(id responseObject) {
        
        [TLAlert alertWithSucces:@"撤销成功"];
        
        [self.divisionTableView beginRefreshing];
        
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

- (void)refreshTableViewButtonClick:(TLTableView *)refreshTableview button:(UIButton *)sender selectRowAtIndex:(NSInteger)index {
    
    AllDivisionListVC *divisionVC = [AllDivisionListVC new];
    
    [self.navigationController pushViewController:divisionVC animated:YES];
}

- (void)dealloc {
    
    self.manager.type = @"0";
    //定时器停止
    [self stopTimer];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
