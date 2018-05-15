//
//  CurrencyDetailVC.m
//  bige
//
//  Created by 蔡卓越 on 2018/4/25.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "CurrencyDetailVC.h"

//Category
#import "UILabel+Extension.h"
//M
#import "PlatformModel.h"
#import "PlatformTitleModel.h"
//V
#import "QuotesChangeView.h"
#import "CurrencyInfoView.h"
#import "CurrencyTrendMapView.h"
#import "SelectScrollView.h"
#import "CurrencyBottomView.h"
#import "CurrencyInfoTableView.h"
#import "SetWarningView.h"
//C
#import "CurrencyAnalysisChildVC.h"
#import "CurrencyExchangeChildVC.h"
#import "CurrencyInfoChildVC.h"
#import "CurrencyKLineVC.h"
#import "SimulationTradeDetailVC.h"

#define kBottomHeight 50

@interface CurrencyDetailVC ()<UIScrollViewDelegate>
//
@property (nonatomic, strong) SelectScrollView *selectSV;
//向下箭头
@property (nonatomic, strong) UIImageView *arrowIV;
//更换交易所和币种
@property (nonatomic, strong) QuotesChangeView *changeView;
//头部数据
@property (nonatomic, strong) CurrencyInfoView *infoView;
//趋势图
@property (nonatomic, strong) CurrencyTrendMapView *trendView;
//底部按钮
@property (nonatomic, strong) CurrencyBottomView *bottomView;
//设置预警
@property (nonatomic, strong) SetWarningView *warningView;
//币种信息
@property (nonatomic, strong) PlatformModel *platform;
//平台
@property (nonatomic, strong) NSArray <PlatformTitleModel *>*platformTitleList;
//标题
@property (nonatomic, strong) NSArray *titles;
//
@property (nonatomic, assign) BOOL canScroll;
//vcCanScroll
@property (nonatomic, assign) BOOL vcCanScroll;
//是否加载
@property (nonatomic, assign) BOOL isLoad;
//是否下拉
@property (nonatomic, assign) BOOL isDown;

@end

@implementation CurrencyDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _isLoad = NO;
    _isDown = NO;
    //获取行情详情
    [self requestQuotesInfo];
    //获取平台列表
    [self requestPlatformList];
}

#pragma mark - Init
- (QuotesChangeView *)changeView {
    
    if (!_changeView) {
        
        _changeView = [[QuotesChangeView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight)];
        
        [self.view addSubview:_changeView];
    }
    return _changeView;
}

- (SetWarningView *)warningView {
    
    if (!_warningView) {
        
        _warningView = [[SetWarningView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        
    }
    return _warningView;
}

- (void)initSubviews {
    
    //导航栏title
    [self initTitleView];
    //滚动视图
    [self initScrollView];
    //头部数据
    [self initInfoView];
    //趋势图
    [self initTrendView];
    //添加子控制器
    [self initSelectScrollView];
    //
    [self addSubViewController];
    //底部按钮
    [self initBottomView];
    //添加通知
    [self addNotification];
}

#pragma mark - 通知
- (void)addNotification {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(subVCLeaveTop) name:@"SubVCLeaveTop" object:nil];
    //点击关注
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(followOrCancelFollow) name:@"FollowOrCancelFollow" object:nil];
}

- (void)subVCLeaveTop {
    
    self.canScroll = YES;
    self.vcCanScroll = NO;
}

- (void)followOrCancelFollow {
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"628352";
    http.showView = self.view;
    http.parameters[@"id"] = self.symbolID;
    if ([TLUser user].userId) {
        
        http.parameters[@"userId"] = [TLUser user].userId;
    }
    
    [http postWithSuccess:^(id responseObject) {
        
        self.platform = [PlatformModel mj_objectWithKeyValues:responseObject[@"data"]];
        
        self.infoView.platform = self.platform;
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - Init
- (void)initTitleView {
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 120, 44)];
    
    //币种名称
    UILabel *symbolNameLbl = [UILabel labelWithBackgroundColor:kClearColor
                                                     textColor:kWhiteColor
                                                          font:14.0];
    symbolNameLbl.textAlignment = NSTextAlignmentCenter;
    symbolNameLbl.numberOfLines = 0;
    
    NSString *toSymbol = [self.platform.toSymbol uppercaseString];
    
    NSString *text = [NSString stringWithFormat:@"%@\n%@", self.platform.exchangeCname, toSymbol];
    
    [symbolNameLbl labelWithString:text
                             title:toSymbol
                              font:Font(11.0)
                             color:kWhiteColor];
    
    [titleView addSubview:symbolNameLbl];
    [symbolNameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(@0);
//        make.centerX.equalTo(@(-15));
        make.centerX.equalTo(@(-5));
    }];

    //向下箭头
//    self.arrowIV = [[UIImageView alloc] initWithImage:kImage(@"下拉")];
//
//    [titleView addSubview:self.arrowIV];
//    [self.arrowIV mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.left.equalTo(symbolNameLbl.mas_right).offset(12);
//        make.centerY.equalTo(symbolNameLbl.mas_centerY);
//    }];
    
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickPullDown:)];
    [titleView addGestureRecognizer:tapGR];

    self.navigationItem.titleView = titleView;

}

- (void)initScrollView {
    
    self.canScroll = YES;
    self.bgSV.delegate = self;
    self.bgSV.height = kSuperViewHeight - kBottomHeight - kBottomInsetHeight;
}

- (void)initInfoView {
    
    self.infoView = [[CurrencyInfoView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 95)];
    
    [self.bgSV addSubview:self.infoView];
}

- (void)initTrendView {
    
    BaseWeakSelf;
    
    self.trendView = [[CurrencyTrendMapView alloc] initWithFrame:CGRectMake(0, self.infoView.yy + 10, kScreenWidth, 220)];
    
    self.trendView.arrowEventBlock = ^{
        
        CurrencyKLineVC *kLineVC = [CurrencyKLineVC new];
        
        kLineVC.symbolID = weakSelf.symbolID;
        
        [weakSelf.navigationController pushViewController:kLineVC animated:YES];
    };
    
    [self.bgSV addSubview:self.trendView];
}

- (void)initSelectScrollView {
    
    BaseWeakSelf;
    
    self.titles = @[@"分析", @"交易所", @"项目信息"];
    
    self.selectSV = [[SelectScrollView alloc] initWithFrame:CGRectMake(0, self.trendView.yy + 10, kScreenWidth, kSuperViewHeight - kBottomHeight - kBottomInsetHeight) itemTitles:self.titles];
    
    self.selectSV.selectBlock = ^(NSInteger index) {
        
        [weakSelf didSelectWithIndex:index];

    };
    [self.bgSV addSubview:self.selectSV];
    
}

/**
 切换标签
 */
- (void)didSelectWithIndex:(NSInteger)index {
    
    //圈子
    if (index == 0) {
        
        self.selectSV.height = 230;
        
    } else {
        
        self.selectSV.height = kSuperViewHeight - kBottomInsetHeight - kBottomHeight;
    }
    
    self.bgSV.contentSize = CGSizeMake(kScreenWidth, self.selectSV.yy);
}

- (void)addSubViewController {
    
    BaseWeakSelf;
    
    for (NSInteger i = 0; i < self.titles.count; i++) {
        
        if (i == 0) {
            
            CurrencyAnalysisChildVC *childVC = [[CurrencyAnalysisChildVC alloc] init];
            
            childVC.platform = self.platform;
//            childVC.refreshSuccess = ^{
//
//                [weakSelf.tableView endRefreshHeader];
//            };
            childVC.index = i;
            childVC.view.frame = CGRectMake(kScreenWidth*i, 1, kScreenWidth, 230);
            
            [self addChildViewController:childVC];
            
            [_selectSV.scrollView addSubview:childVC.view];
            
        } else if (i == 1) {
            
            CurrencyExchangeChildVC *childVC = [[CurrencyExchangeChildVC alloc] init];
            
//            childVC.refreshSuccess = ^{
//
//                [weakSelf.tableView endRefreshHeader];
//            };
            childVC.index = i;
            childVC.platform = self.platform;
            childVC.view.frame = CGRectMake(kScreenWidth*i, 1, kScreenWidth, kSuperViewHeight - 40 - kBottomInsetHeight - kBottomHeight);
            
            [self addChildViewController:childVC];
            
            [_selectSV.scrollView addSubview:childVC.view];
            
        } else {
            
            CurrencyInfoChildVC *childVC = [[CurrencyInfoChildVC alloc] init];
            
//            childVC.refreshSuccess = ^{
//
//                [weakSelf.tableView endRefreshHeader];
//            };
            childVC.index = i;
            childVC.platform = self.platform;
            childVC.view.frame = CGRectMake(kScreenWidth*i, 1, kScreenWidth, kSuperViewHeight - 40 - kBottomInsetHeight - kBottomHeight);
            
            [self addChildViewController:childVC];
            
            [_selectSV.scrollView addSubview:childVC.view];
        }
    }
    
    _selectSV.height = 230;
    self.bgSV.contentSize = CGSizeMake(kScreenWidth, self.selectSV.yy);

    //转移手势
    CurrencyInfoTableView *tableView = (CurrencyInfoTableView *)[self.view viewWithTag:1802];

    UIPanGestureRecognizer *panGR = tableView.panGestureRecognizer;

    [self.bgSV addGestureRecognizer:panGR];

//
    //已加载子控制器
    _isLoad = YES;
}

- (void)initBottomView {
    
    BaseWeakSelf;
    
    self.bottomView = [[CurrencyBottomView alloc] initWithFrame:CGRectMake(0, kSuperViewHeight - kBottomHeight - kBottomInsetHeight, kScreenWidth, kBottomHeight)];
    
    self.bottomView.bottomBlock = ^(BottomEventType type) {
        
        [weakSelf bottomEventType:type];
    };
    
    [self.view addSubview:self.bottomView];
}


#pragma mark - Events
- (void)bottomEventType:(BottomEventType)type {
    
    BaseWeakSelf;
    
    switch (type) {
            
        case BottomEventTypeEarlyWarning:
        {
            
            [self checkLogin:^{
                
                weakSelf.warningView.platform = weakSelf.platform;
                
                [weakSelf.warningView show];
            }];
            
        }break;
            
        case BottomEventTypeFollow:
        {
            BaseWeakSelf;
            [self checkLogin:^{
                
                TLNetworking *http = [TLNetworking new];
                
                http.code = @"628352";
                http.showView = self.view;
                http.parameters[@"id"] = self.symbolID;
                if ([TLUser user].userId) {
                    
                    http.parameters[@"userId"] = [TLUser user].userId;
                }
                [http postWithSuccess:^(id responseObject) {
                    //刷新关注状态
                    weakSelf.platform = [PlatformModel mj_objectWithKeyValues:responseObject[@"data"]];
                    weakSelf.infoView.platform = weakSelf.platform;
                    weakSelf.bottomView.platform = weakSelf.platform;
                    
                } failure:^(NSError *error) {
                    
                }];
                
            } event:^{
                
                [weakSelf followCurrency];
            }];
            
        }break;
            
        case BottomEventTypeBuy:
        {
            SimulationTradeDetailVC *detailVC = [SimulationTradeDetailVC new];
            
            detailVC.direction = @"0";
            
            [self.navigationController pushViewController:detailVC animated:YES];
        }break;
            
        case BottomEventTypeSell:
        {
            SimulationTradeDetailVC *detailVC = [SimulationTradeDetailVC new];
            
            detailVC.direction = @"1";
            
            [self.navigationController pushViewController:detailVC animated:YES];
        }break;
            
        default:
            break;
    }
}

- (void)clickPullDown:(UITapGestureRecognizer *)tapGR {
    
    if (!_isDown) {
        
        [self.changeView show];
        
        [UIView animateWithDuration:0.25 animations:^{
            
            self.arrowIV.transform = CGAffineTransformMakeRotation(M_PI);
            
        } completion:^(BOOL finished) {
            
            _isDown = YES;
        }];
        
    } else {
        
        [self.changeView hide];

        [UIView animateWithDuration:0.25 animations:^{
            
            self.arrowIV.transform = CGAffineTransformIdentity;
            
        } completion:^(BOOL finished) {
            
            _isDown = NO;
        }];
    }
}

#pragma mark - Data
- (void)requestQuotesInfo {
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"628352";
    http.showView = self.view;
    http.parameters[@"id"] = self.symbolID;
    if ([TLUser user].userId) {
        
        http.parameters[@"userId"] = [TLUser user].userId;
    }
    
    [http postWithSuccess:^(id responseObject) {
        
        self.platform = [PlatformModel mj_objectWithKeyValues:responseObject[@"data"]];
        
        [self initSubviews];

        self.infoView.platform = self.platform;
        self.trendView.platform = self.platform;
        self.bottomView.platform = self.platform;
        
    } failure:^(NSError *error) {
        
    }];
}

/**
 获取平台列表
 */
- (void)requestPlatformList {
    
    BaseWeakSelf;
    
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    
    helper.code = @"628317";
    helper.isList = YES;
    helper.showView = self.view;
    
    if ([TLUser user].isLogin) {
        
        helper.parameters[@"userId"] = [TLUser user].userId;
    }
    
    [helper modelClass:[PlatformTitleModel class]];
    
    [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
        
        weakSelf.platformTitleList = objs;
        
    } failure:^(NSError *error) {
        
    }];
}

/**
 关注
 */
- (void)followCurrency {
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"628330";
    http.showView = self.view;
    http.parameters[@"exchangeEname"] = self.platform.exchangeEname;
    http.parameters[@"userId"] = [TLUser user].userId;
    http.parameters[@"symbol"] = self.platform.symbol;
    http.parameters[@"toSymbol"] = self.platform.toSymbol;
    
    [http postWithSuccess:^(id responseObject) {
        
        NSString *promptStr = [self.platform.isChoice isEqualToString:@"1"] ? @"删除自选成功": @"添加自选成功";
        [TLAlert alertWithSucces:promptStr];
        
        if ([self.platform.isChoice isEqualToString:@"1"]) {
            
            self.platform.isChoice = @"0";
            
        } else {
            
            self.platform.isChoice = @"1";
        }
        
        self.bottomView.platform = self.platform;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"FollowOrCancelFollow" object:nil];
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - UIScrollView
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat bottomOffset = self.selectSV.y;
    
    CGFloat scrollOffset = scrollView.contentOffset.y;
    
    //子视图已经到顶部
    if (
        scrollOffset >= bottomOffset) {
        
        //当视图到达顶部时，使视图悬停
        scrollView.contentOffset = CGPointMake(0, bottomOffset);
        
        if (self.canScroll) {
            
            self.canScroll = NO;
            self.vcCanScroll = YES;
        }
        
        if (self.selectSV.selectIndex != 0) {
            
            //转移手势
            TLTableView *tableView = (TLTableView *)[self.view viewWithTag:1800+self.selectSV.selectIndex];
            
            UIPanGestureRecognizer *panGR = tableView.panGestureRecognizer;
            
            [scrollView addGestureRecognizer:panGR];
        }
        
    } else {
        
        //处理tableview和scrollView同时滚的问题（当vc不能滚动时，设置scrollView悬停）
        
        if (!self.canScroll) {
            
            scrollView.contentOffset = CGPointMake(0, bottomOffset);
        }
    }
    
    self.bgSV.showsVerticalScrollIndicator = _canScroll ? YES: NO;
    
}

- (void)setVcCanScroll:(BOOL)vcCanScroll {
    
    for (CurrencyAnalysisChildVC *vc in self.childViewControllers) {
        
        vc.vcCanScroll = vcCanScroll;
    }
    
    for (CurrencyExchangeChildVC *vc in self.childViewControllers) {
        
        vc.vcCanScroll = vcCanScroll;
    }
    
    for (CurrencyInfoChildVC *vc in self.childViewControllers) {
        
        vc.vcCanScroll = vcCanScroll;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
