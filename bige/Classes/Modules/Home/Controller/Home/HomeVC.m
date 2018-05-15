//
//  HomeVC.m
//  bige
//
//  Created by 蔡卓越 on 2018/3/12.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "HomeVC.h"
//Category
#import "UIBarButtonItem+convience.h"
//M
#import "InformationModel.h"
#import "InfoManager.h"
#import "BannerModel.h"
#import "OptionInfoModel.h"
//V
#import "InformationListTableView.h"
#import "TLPlaceholderView.h"
#import "TLBannerView.h"
#import "BaseView.h"
#import "OptionalInfoView.h"
#import "HomeQuotesView.h"
//C
#import "InfoDetailVC.h"
#import "HomeChildVC.h"
#import "SearchCurrencyVC.h"
#import "NavigationController.h"
#import "CurrencyDetailVC.h"

@interface HomeVC ()<RefreshDelegate>
//头部
@property (nonatomic, strong) BaseView *headerView;
//自选
@property (nonatomic, strong) BaseView *optionalView;
@property (nonatomic, strong) NSArray <OptionInfoModel *>*platforms;
@property (nonatomic, strong) UIScrollView *optionalSV;
//今日要闻
@property (nonatomic, strong) BaseView *newsView;
//轮播图
@property (nonatomic, strong) TLBannerView *bannerView;
@property (nonatomic,strong) NSMutableArray <BannerModel *>*bannerRoom;
//行情
@property (nonatomic, strong) BaseView *fluctView;
@property (nonatomic, strong) HomeQuotesView *quotesView;
@property (nonatomic, strong) NSArray *titles;
//资讯
@property (nonatomic, strong) BaseView *infoView;
@property (nonatomic, strong) InformationListTableView *infoTableView;
//infoList
@property (nonatomic, strong) NSArray <InformationModel *>*infos;
//
@property (nonatomic, strong) TLPageDataHelper *flashHelper;

@end

@implementation HomeVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = @"币格财经";
    //添加通知
    //    [self addNotification];
    //搜索
    [self addItem];
    //HeaderView
    [self initHeaderView];
    //资讯
    [self initInfoTableView];
    //获取资讯列表
    [self requestInfoList];
    //刷新
    [self.infoTableView beginRefreshing];
}

#pragma mark - Init

- (BaseView *)headerView {
    
    if (!_headerView) {
        
        _headerView = [[BaseView alloc] init];
        
        _headerView.backgroundColor = kBackgroundColor;
        
    }
    return _headerView;
}

- (TLBannerView *)bannerView {
    
    if (!_bannerView) {
        
        _bannerView = [[TLBannerView alloc] initWithFrame:CGRectMake(0, 40, kScreenWidth, kWidth(150))];
        
        [self.newsView addSubview:_bannerView];
    }
    return _bannerView;
}

- (void)addItem {
    //搜索
    [UIBarButtonItem addRightItemWithImageName:@"搜索" frame:CGRectMake(0, 0, 40, 40) vc:self action:@selector(search)];
}

- (void)initHeaderView {
    
    //自选
    [self initOptionalView];
    //今日要闻
    [self initNewsView];
    //行情
    [self initFluctView];
    //资讯
    [self initInfoView];
}
/**
 自选
 */
- (void)initOptionalView {
    
    self.optionalView = [[BaseView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 140)];
    
    self.optionalView.backgroundColor = kWhiteColor;
    
    [self.headerView addSubview:self.optionalView];
    
    UIImageView *iconIV = [[UIImageView alloc] init];
    
    iconIV.image = kImage(@"自选信息");
    iconIV.centerX = kScreenWidth/2.0;
    
    [self.optionalView addSubview:iconIV];
    [iconIV mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@15);
        make.top.equalTo(@12.5);
    }];
    
    UILabel *textLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor2 font:14.0];
    
    textLbl.text = @"自选信息";
    textLbl.textAlignment = NSTextAlignmentCenter;
    
    [self.optionalView addSubview:textLbl];
    [textLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(iconIV.mas_centerY);
        make.left.equalTo(iconIV.mas_right).offset(12);
    }];
    
    //topLine
    UIView *topLine = [[UIView alloc] init];
    
    topLine.backgroundColor = kLineColor;
    
    [self.optionalView addSubview:topLine];
    [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.equalTo(@0);
        make.height.equalTo(@0.5);
        make.top.mas_equalTo(@40);
    }];
    
    self.optionalSV = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 40, kScreenWidth, 100)];
    
    [self.optionalView addSubview:self.optionalSV];
}

/**
 今日要闻
 */
- (void)initNewsView {
    
    self.newsView = [[BaseView alloc] initWithFrame:CGRectMake(0, self.optionalView.yy + 10, kScreenWidth, 40 + kWidth(150))];
    
    self.newsView.backgroundColor = kWhiteColor;
    
    [self.headerView addSubview:self.newsView];
    
    UIImageView *iconIV = [[UIImageView alloc] init];
    iconIV.image = kImage(@"今日要闻");
    iconIV.centerX = kScreenWidth/2.0;
    
    [self.newsView addSubview:iconIV];
    [iconIV mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@15);
        make.top.equalTo(@12.5);
    }];
    
    UILabel *textLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor2 font:14.0];
    
    textLbl.text = @"今日要闻";
    textLbl.textAlignment = NSTextAlignmentCenter;
    
    [self.newsView addSubview:textLbl];
    [textLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(iconIV.mas_centerY);
        make.left.equalTo(iconIV.mas_right).offset(12);
    }];
    
    //bottomLine
    UIView *bottomLine = [[UIView alloc] init];
    
    bottomLine.backgroundColor = kLineColor;
    
    [self.optionalView addSubview:bottomLine];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.bottom.equalTo(@0);
        make.height.equalTo(@0.5);
    }];
}

/**
 行情
 */
- (void)initFluctView {
    
    BaseWeakSelf;
    
    self.titles = @[@"涨幅榜", @"跌幅榜"];
    
    self.quotesView = [[HomeQuotesView alloc] initWithFrame:CGRectMake(0, self.newsView.yy + 10, kScreenWidth, 490) itemTitles:self.titles];
    
    self.quotesView.selectBlock = ^(NSInteger index) {
        
        //点击标签
    };
    
    [self.headerView addSubview:self.quotesView];
    //添加子控制器
    for (NSInteger i = 0; i < self.titles.count; i++) {
        //平台
        HomeChildVC *childVC = [[HomeChildVC alloc] init];
        
        childVC.currentIndex = i;
        childVC.view.frame = CGRectMake(kScreenWidth*i, 1, kScreenWidth, kSuperViewHeight - 40 - kTabBarHeight);
        
        [self addChildViewController:childVC];
        
        [self.quotesView.scrollView addSubview:childVC.view];
    }
    
    UIButton *moreBtn = [UIButton buttonWithTitle:@"查看更多"
                                       titleColor:kTextColor2
                                  backgroundColor:kWhiteColor
                                        titleFont:13.0];
    moreBtn.frame = CGRectMake(0, 445, kScreenWidth, 45);
    [moreBtn addTarget:self action:@selector(clickMore) forControlEvents:UIControlEventTouchUpInside];
    [moreBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
    
    [self.quotesView addSubview:moreBtn];
    
    //右箭头
    CGFloat arrowW = 6;
    CGFloat arrowH = 10;
    
    UIImageView *arrowIV = [[UIImageView alloc] initWithImage:kImage(@"更多-灰色")];
    
    [moreBtn addSubview:arrowIV];
    [arrowIV mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(@(arrowW));
        make.height.equalTo(@(arrowH));
        make.centerY.equalTo(@0);
        make.centerX.equalTo(@(30));
    }];
}

/**
 资讯
 */
- (void)initInfoView {
    
    self.infoView = [[BaseView alloc] initWithFrame:CGRectMake(0, self.quotesView.yy + 10, kScreenWidth, 40)];
    
    self.infoView.backgroundColor = kWhiteColor;

    [self.headerView addSubview:self.infoView];
    
    UIImageView *iconIV = [[UIImageView alloc] init];
    iconIV.image = kImage(@"资讯");
    iconIV.centerX = kScreenWidth/2.0;
    
    [self.infoView addSubview:iconIV];
    [iconIV mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@15);
        make.top.equalTo(@12.5);
    }];
    
    UILabel *textLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor2 font:14.0];
    
    textLbl.text = @"资讯";
    textLbl.textAlignment = NSTextAlignmentCenter;
    
    [self.infoView addSubview:textLbl];
    [textLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(iconIV.mas_centerY);
        make.left.equalTo(iconIV.mas_right).offset(12);
    }];
}

- (void)initInfoTableView {
    
    self.infoTableView = [[InformationListTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    
    self.infoTableView.refreshDelegate = self;
    self.infoTableView.placeHolderView = [TLPlaceholderView placeholderViewWithImage:@"暂无记录" text:@"暂无资讯"];
    
    [self.view addSubview:self.infoTableView];
    [self.infoTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(0);
    }];
    
    self.headerView.height = self.infoView.yy;
    
    self.infoTableView.tableHeaderView = self.headerView;
}

#pragma mark - Events
- (void)clickMore {
    
    self.tabBarController.selectedIndex = 1;
}

/**
 搜索
 */
- (void)search {
    
    BaseWeakSelf;
    
    SearchCurrencyVC *searchVC = [SearchCurrencyVC new];
    
    NavigationController *nav = [[NavigationController alloc] initWithRootViewController:searchVC];
    
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark - Data

/**
 获取自选列表
 */
- (void)requestOptionalList {
    
    BaseWeakSelf;
    
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    
    helper.code = @"628338";
    if ([TLUser user].isLogin) {
        
        helper.parameters[@"userId"] = [TLUser user].userId;
    }
    helper.isList = YES;
    
    [helper modelClass:[OptionInfoModel class]];
    
    [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
        
        weakSelf.platforms = objs;
        
        weakSelf.optionalSV.contentSize = CGSizeMake(objs.count*kScreenWidth/3.0, 100);
        
        for (UIView *subview in weakSelf.optionalSV.subviews) {
        
            [subview removeFromSuperview];
        }
        
        [weakSelf.platforms enumerateObjectsUsingBlock:^(OptionInfoModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            CGFloat w = kScreenWidth/3.0;
            
            OptionalInfoView *infoView = [[OptionalInfoView alloc] initWithFrame:CGRectMake((idx%3)*w, (idx/3)*100, w, 100)];
            
            infoView.tag = 2500 + idx;
            infoView.infoModel = obj;
            
            [weakSelf.optionalSV addSubview:infoView];
            
            UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectOptional:)];
            [infoView addGestureRecognizer:tapGR];
        }];
        //重新布局
        weakSelf.optionalSV.frame = CGRectMake(0, 40, kScreenWidth, (weakSelf.platforms.count+2)/3*100);
        
        weakSelf.optionalView.frame = CGRectMake(0, 0, kScreenWidth, (weakSelf.platforms.count+2)/3*100 + 40);

        weakSelf.newsView.y = weakSelf.optionalView.yy + 10;
        weakSelf.quotesView.y = weakSelf.newsView.yy + 10;
        weakSelf.infoView.y = weakSelf.quotesView.yy + 10;
        weakSelf.headerView.height = weakSelf.infoView.yy;
        
        weakSelf.infoTableView.tableHeaderView = weakSelf.headerView;
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)selectOptional:(UITapGestureRecognizer *)tapGR {
    
    NSInteger index = tapGR.view.tag - 2500;
    
    OptionInfoModel *optional = self.platforms[index];
    
    if ([optional.exchangeEname isEqualToString:@"marketGlobal"]) {
        
        return ;
    }
    CurrencyDetailVC *detailVC = [CurrencyDetailVC new];
    
    detailVC.symbolID = optional.marketGlobal.ID;
    
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (void)requestBannerList {
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"805806";
    
    [http postWithSuccess:^(id responseObject) {
        
        self.bannerRoom = [BannerModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        
        NSMutableArray *imgUrls = [NSMutableArray array];
        
        [self.bannerRoom enumerateObjectsUsingBlock:^(BannerModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if (obj.pic) {
                
                [imgUrls addObject:obj.pic];
            }
        }];
        self.bannerView.imgUrls = imgUrls;
        
//        self.infoTableView.tableHeaderView = self.headerView;
        
    } failure:^(NSError *error) {
        
    }];
}

/**
 获取资讯列表
 */
- (void)requestInfoList {
    
    BaseWeakSelf;
    
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    
    helper.code = @"628205";
    
    helper.parameters[@"location"] = @"1";
    
    helper.tableView = self.infoTableView;
    
    [helper modelClass:[InformationModel class]];
    
    [self.infoTableView addRefreshAction:^{
        
        //自选列表
        [weakSelf requestOptionalList];
        //轮播图
        [weakSelf requestBannerList];
        
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
