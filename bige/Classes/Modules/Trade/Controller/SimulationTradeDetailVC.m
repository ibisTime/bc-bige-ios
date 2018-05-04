//
//  SimulationTradeDetailVC.m
//  bige
//
//  Created by 蔡卓越 on 2018/4/24.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "SimulationTradeDetailVC.h"

//Macro
//Framework
//Category
#import "UIButton+EnLargeEdge.h"
//Extension
//M
#import "PlatformModel.h"
//V
#import "BaseView.h"
#import "SimulationTradeSliderView.h"
#import "SelectScrollView.h"
//C
#import "CurrencyDetailVC.h"
#import "SimulationQuotesListVC.h"

@interface SimulationTradeDetailVC ()
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

//
@property (nonatomic, strong) PlatformModel *platform;

@end

@implementation SimulationTradeDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"模拟交易";
    //头部
    [self initHeaderView];
    //添加子控制器
    [self addChildVC];
    //获取币种信息
    [self requestQuotesList];
}

#pragma mark - Init
- (SimulationTradeSliderView *)sliderView {
    
    if (!_sliderView) {
        
        _sliderView = [[SimulationTradeSliderView alloc] initWithFrame:CGRectMake(-kScreenWidth, 0, kScreenWidth, kScreenHeight)];
    }
    return _sliderView;
}

- (void)initHeaderView {
    
    self.headerView = [[BaseView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 386)];
    
    [self.view addSubview:self.headerView];
    
    //顶部
    [self initTopView];
    
}

- (void)initTopView {
    
    self.topView = [[BaseView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
    
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

- (void)addChildVC {
    
    BaseWeakSelf;
    
    self.titles = @[@"自选", @"USDT", @"BTC", @"ETH"];
    
    self.selectSV = [[SelectScrollView alloc] initWithFrame:CGRectMake(0, 44 + kStatusBarHeight, kScreenWidth*0.8, kScreenHeight - (44 + kStatusBarHeight)) itemTitles:self.titles];
    
    [self.sliderView addSubview:self.selectSV];
    //添加子控制器
    for (NSInteger i = 0; i < self.titles.count; i++) {
        //平台
        SimulationQuotesListVC *childVC = [[SimulationQuotesListVC alloc] init];
        
        childVC.currentIndex = i;
        childVC.view.frame = CGRectMake(kScreenWidth*0.8*i, 1, kScreenWidth*0.8, kSuperViewHeight - 40 - kTabBarHeight);
        if (i == 0) {
            
            childVC.didSelectOptional = ^(OptionInfoModel *infoModel) {
                
                [weakSelf.sliderView hide];
                
                NSString *symbol = [NSString stringWithFormat:@"%@/%@", [infoModel.symbol uppercaseString], [infoModel.toSymbol uppercaseString]];
                
                [weakSelf.quotesBtn setTitle:symbol forState:UIControlStateNormal];
            };
        } else {
            
            childVC.didSelectQuotes = ^(PlatformModel *quotes) {
                
                [weakSelf.sliderView hide];

                NSString *symbol = [NSString stringWithFormat:@"%@/%@", [quotes.symbol uppercaseString], [quotes.toSymbol uppercaseString]];
                
                [weakSelf.quotesBtn setTitle:symbol forState:UIControlStateNormal];
            };
        }
        [self addChildViewController:childVC];
        
        [self.selectSV.scrollView addSubview:childVC.view];
    }
}

#pragma mark - Events

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
    
    detailVC.symbolID = self.platform.ID;
    
    [self.navigationController pushViewController:detailVC animated:YES];
}
/**
 关注
 */
- (void)follow {
    
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
        
        NSString *imgName = [self.platform.isChoice isEqualToString:@"0"] ? @"币种未关注": @"币种关注";
        [self.followBtn setImage:kImage(imgName) forState:UIControlStateNormal];
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - Data
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
            
            PlatformModel *quotes = objs[0];
            
            NSString *symbol = [NSString stringWithFormat:@"%@/%@", [quotes.symbol uppercaseString], [quotes.toSymbol uppercaseString]];
            
            [weakSelf.quotesBtn setTitle:symbol forState:UIControlStateNormal];
        }
        
    } failure:^(NSError *error) {
        
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
