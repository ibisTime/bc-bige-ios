//
//  QuotesVC.m
//  bige
//
//  Created by 蔡卓越 on 2018/3/12.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "QuotesVC.h"
//Category
#import "UIBarButtonItem+convience.h"
//M
#import "QuotesManager.h"
#import "PlatformTitleModel.h"
//V
#import "BaseView.h"
#import "SelectScrollView.h"
#import "TopLabelUtil.h"
#import "OptionalTableView.h"
//C
#import "QuotesPlatformVC.h"
#import "SearchCurrencyVC.h"
#import "NavigationController.h"

@interface QuotesVC ()
//滚动
@property (nonatomic, strong) SelectScrollView *selectSV;
//当前大标签索引
@property (nonatomic, assign) NSInteger currentSegmentIndex;
//类型
@property (nonatomic, copy) NSString *kind;
//
@property (nonatomic, strong) NSMutableArray *titles;
//类型
@property (nonatomic, strong) NSMutableArray *kinds;
//平台
@property (nonatomic, strong) NSArray <PlatformTitleModel *>*platformTitleList;
//定时器
@property (nonatomic, strong) NSTimer *timer;
//
@property (nonatomic, strong) TLPageDataHelper *helper;
//当前平台索引
@property (nonatomic, assign) NSInteger platformLabelIndex;

@end

@implementation QuotesVC

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self startCurrencyTimerWithSegmentIndex:self.currentSegmentIndex
                                  labelIndex:self.platformLabelIndex];
}

- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
    
    [self startCurrencyTimerWithSegmentIndex:1
                                  labelIndex:0];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //
    self.title = @"币格行情";
    //顶部切换
    [self initSegmentView];
    //搜索
    [self addItem];
    //获取平台title列表
    [self requestPlatformTitleList];
    //添加通知
    [self addNotification];
}

#pragma mark - addNotification
- (void)addNotification {
    //登录后刷新列表
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLogin) name:kUserLoginNotification object:nil];
    //退出登录刷新列表
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLogout) name:kUserLoginOutNotification object:nil];
}

- (void)userLogin {
    
}

- (void)userLogout {
    
}

#pragma mark - Init
- (void)addItem {
    //搜索
    [UIBarButtonItem addRightItemWithImageName:@"搜索" frame:CGRectMake(0, 0, 40, 40) vc:self action:@selector(search)];
}

- (void)initSegmentView {
    
    self.currentSegmentIndex = 1;
    self.platformLabelIndex = 0;
}

- (void)initSelectScrollView {
    
    BaseWeakSelf;

    SelectScrollView *selectSV = [[SelectScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight - kTabBarHeight) itemTitles:self.titles];
    
    selectSV.selectBlock = ^(NSInteger index) {
        
        //点击标签
        [weakSelf startCurrencyTimerWithSegmentIndex:weakSelf.currentSegmentIndex
                                          labelIndex:index];
    };
    
    [self.view addSubview:selectSV];
    
    self.selectSV = selectSV;
}

- (void)addSubViewController {
    
    for (NSInteger i = 0; i < self.titles.count; i++) {
        //平台
        QuotesPlatformVC *childVC = [[QuotesPlatformVC alloc] init];
        
        childVC.currentIndex = i;
        childVC.titleModel = self.platformTitleList[i];
        childVC.view.frame = CGRectMake(kScreenWidth*i, 1, kScreenWidth, kSuperViewHeight - 40 - kTabBarHeight);
        
        [self addChildViewController:childVC];
        
        [self.selectSV.scrollView addSubview:childVC.view];
    }
}

#pragma mark - Events
/**
 搜索
 */
- (void)search {
    
    BaseWeakSelf;
    
    SearchCurrencyVC *searchVC = [SearchCurrencyVC new];
    
    NavigationController *nav = [[NavigationController alloc] initWithRootViewController:searchVC];
    
    [self presentViewController:nav animated:YES completion:nil];
}

/**
 点击标签
 */
- (void)didSelectIndex:(NSInteger)index {
    
    
}

/**
 开启当前显示页面的定时器
 */
- (void)startCurrencyTimerWithSegmentIndex:(NSInteger)segmentIndex
                                labelIndex:(NSInteger)labelIndex {
    
    NSDictionary *dic = @{
                          @"segmentIndex": @(segmentIndex),
                          @"labelIndex": @(labelIndex),
                          };
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DidSwitchLabel"
                                                        object:nil
                                                      userInfo:dic];
}

#pragma mark - Data
/**
 获取平台title列表
 */
- (void)requestPlatformTitleList {
    
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
        //遍历标题
        weakSelf.titles = [NSMutableArray array];
        
        [weakSelf.platformTitleList enumerateObjectsUsingBlock:^(PlatformTitleModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if (obj.cname) {
                
                [weakSelf.titles addObject:obj.cname];
            }
        }];
        
        weakSelf.kind = kPlatform;
        //添加滚动
        [self initSelectScrollView];
        //添加子控制器
        [weakSelf addSubViewController];
        
    } failure:^(NSError *error) {
        
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
