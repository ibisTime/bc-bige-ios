//
//  CurrencyDetailVC.m
//  bige
//
//  Created by 蔡卓越 on 2018/4/25.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "CurrencyDetailVC.h"

//Macro
//Framework
//Category
#import "UILabel+Extension.h"
//Extension
//M
#import "PlatformModel.h"
#import "PlatformTitleModel.h"

//V
#import "QuotesChangeView.h"
#import "CurrencyInfoView.h"
#import "CurrencyTrendMapView.h"
#import "SelectScrollView.h"
#import "CurrencyBottomView.h"
//C
#import "CurrencyAnalysisChildVC.h"
#import "CurrencyExchangeChildVC.h"
#import "CurrencyInfoChildVC.h"

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
}

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
    self.bgSV.height = kSuperViewHeight - kBottomHeight - kBottomInsetHeight;
}

- (void)initInfoView {
    
    self.infoView = [[CurrencyInfoView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 95)];
    
    [self.bgSV addSubview:self.infoView];
}

- (void)initTrendView {
    
    self.trendView = [[CurrencyTrendMapView alloc] initWithFrame:CGRectMake(0, self.infoView.yy + 10, kScreenWidth, 190)];
    
    [self.bgSV addSubview:self.trendView];
}

- (void)initSelectScrollView {
    
    BaseWeakSelf;
    
    self.titles = @[@"分析", @"交易所", @"项目信息"];
    
    self.selectSV = [[SelectScrollView alloc] initWithFrame:CGRectMake(0, self.trendView.yy + 10, kScreenWidth, kSuperViewHeight - kBottomHeight - kBottomInsetHeight) itemTitles:self.titles];
    
    self.selectSV.selectBlock = ^(NSInteger index) {
        
    };
    [self.bgSV addSubview:self.selectSV];
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
//            childVC.index = i;
//            childVC.detailModel = self.detailModel;
            
            childVC.view.frame = CGRectMake(kScreenWidth*i, 1, kScreenWidth, self.selectSV.height - 40);
            
            [self addChildViewController:childVC];
            
            [_selectSV.scrollView addSubview:childVC.view];
            
        } else if (i == 1) {
            
            CurrencyExchangeChildVC *childVC = [[CurrencyExchangeChildVC alloc] init];
            
//            childVC.refreshSuccess = ^{
//
//                [weakSelf.tableView endRefreshHeader];
//            };
//            childVC.index = i;
//            childVC.toCoin = self.detailModel.code;
            
            childVC.view.frame = CGRectMake(kScreenWidth*i, 1, kScreenWidth, kSuperViewHeight - 40 - kBottomInsetHeight);
            
            [self addChildViewController:childVC];
            
            [_selectSV.scrollView addSubview:childVC.view];
            
        } else {
            
            CurrencyInfoChildVC *childVC = [[CurrencyInfoChildVC alloc] init];
            
//            childVC.refreshSuccess = ^{
//
//                [weakSelf.tableView endRefreshHeader];
//            };
//            childVC.index = i;
//            //detailModel不为空则是币种
//            childVC.toCoin = self.detailModel.toCoin;
            childVC.view.frame = CGRectMake(kScreenWidth*i, 1, kScreenWidth, kSuperViewHeight - 40 - kBottomInsetHeight);
            
            [self addChildViewController:childVC];
            
            [_selectSV.scrollView addSubview:childVC.view];
        }
    }
    
    //转移手势
//    ForumCircleTableView *tableView = (ForumCircleTableView *)[self.view viewWithTag:1800];
//
//    UIPanGestureRecognizer *panGR = tableView.panGestureRecognizer;
//
//    [self.tableView addGestureRecognizer:panGR];
//
//    self.tableView.contentSize = CGSizeMake(kScreenWidth, self.selectScrollView.yy+10000);
    
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
    
    switch (type) {
            
        case BottomEventTypeEarlyWarning:
        {
            
            
        }break;
            
        case BottomEventTypeFollow:
        {
            BaseWeakSelf;
            [self checkLogin:^{
                
                TLNetworking *http = [TLNetworking new];
                
                http.code = @"628352";
                http.showView = self.view;
                http.parameters[@"id"] = self.symbolID;
                
                [http postWithSuccess:^(id responseObject) {
                    //刷新关注状态
                    weakSelf.platform = [PlatformModel mj_objectWithKeyValues:responseObject[@"data"]];
                    weakSelf.infoView.platform = weakSelf.platform;
                    weakSelf.bottomView.platform = weakSelf.platform;
                    
                } failure:^(NSError *error) {
                    
                }];
                
            } event:^{
                
                [self followCurrency];
            }];
            
        }break;
            
        case BottomEventTypeBuy:
        {
            
            
        }break;
            
        case BottomEventTypeSell:
        {
            
            
        }break;
        default:
            break;
    }
}

- (void)subVCLeaveTop {
    
    self.canScroll = YES;
    self.vcCanScroll = NO;
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
        
        NSString *promptStr = [self.platform.isChoice isEqualToString:@"1"] ? @"添加自选成功": @"删除自选成功";
        [TLAlert alertWithSucces:promptStr];
        
        if ([self.platform.isChoice isEqualToString:@"1"]) {
            
            self.platform.isChoice = @"0";
            
        } else {
            
            self.platform.isChoice = @"1";
        }
        
        self.bottomView.platform = self.platform;
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
