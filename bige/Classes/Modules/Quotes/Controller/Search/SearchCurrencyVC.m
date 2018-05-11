//
//  SearchCurrencyVC.m
//  bige
//
//  Created by 蔡卓越 on 2018/3/21.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "SearchCurrencyVC.h"

//Category
#import "UIBarButtonItem+convience.h"
//Extension
#import <IQKeyboardManager.h>
//M
#import "PlatformModel.h"
//V
#import "SelectScrollView.h"
#import "TLTextField.h"
#import "SearchHistoryTableView.h"
#import "SearchCurrencyTableView.h"
#import "TLPlaceholderView.h"
//C
#import "SearchCurrcneyChildVC.h"
#import "SearchHistoryChildVC.h"
#import "CurrencyDetailVC.h"

@interface SearchCurrencyVC ()<UITextFieldDelegate, RefreshDelegate>
//
@property (nonatomic, strong) SelectScrollView *selectSV;
//titles
@property (nonatomic, strong) NSArray *titles;
//statusList
@property (nonatomic, strong) NSArray *statusList;
//搜索
@property (nonatomic, strong) TLTextField *searchTF;
//行情列表
@property (nonatomic, strong) SearchCurrencyTableView *currencyTableView;
//
@property (nonatomic, strong) NSMutableArray <PlatformModel *>*currencys;
//搜索内容
@property (nonatomic, copy) NSString *searchStr;
//
@property (nonatomic, strong) TLPageDataHelper *helper;
//热门
@property (nonatomic, strong) SearchCurrcneyChildVC *currencyVC;
//搜索历史
@property (nonatomic, strong) SearchHistoryChildVC *historyVC;

@end

@implementation SearchCurrencyVC

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    //隐藏第三方键盘
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    [[IQKeyboardManager sharedManager] setEnable:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    //显示第三方键盘
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
    [[IQKeyboardManager sharedManager] setEnable:YES];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //取消
    [self addCancelItem];
    //搜索
    [self initSearchBar];
    //搜索结果
    [self initResultTableView];
    //获取搜索结果
    [self requestSearchList];
    //
    [self addSubViewController];
}

#pragma mark - Init
- (void)addCancelItem {
    
    [UIBarButtonItem addRightItemWithTitle:@"取消" titleColor:kWhiteColor frame:CGRectMake(0, 0, 35, 44) vc:self action:@selector(back)];
}

- (void)initSearchBar {
    
    [UINavigationBar appearance].barTintColor = kAppCustomMainColor;
    CGFloat height = 35;
    //搜索
    UIView *searchBgView = [[UIView alloc] init];
    //    UIView *searchBgView = [[UIView alloc] init];
    
    searchBgView.backgroundColor = kWhiteColor;
    searchBgView.userInteractionEnabled = YES;
    searchBgView.layer.cornerRadius = height/2.0;
    searchBgView.clipsToBounds = YES;

    self.navigationItem.titleView = searchBgView;
    
    [searchBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(height);
    }];
    //搜索输入框
    self.searchTF = [[TLTextField alloc] initWithFrame:CGRectZero
                                             leftTitle:@""
                                            titleWidth:0
                                           placeholder:@"请输入平台/币种"];
    self.searchTF.delegate = self;
    self.searchTF.returnKeyType = UIReturnKeySearch;
    
    [self.searchTF addTarget:self action:@selector(textDidChange:) forControlEvents:UIControlEventEditingChanged];
    [searchBgView addSubview:self.searchTF];
    [self.searchTF mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 13, 0, 0));
        
        make.width.mas_greaterThanOrEqualTo(kScreenWidth - 20 - 40 -  15 - 13);
    }];
    
}

- (void)initResultTableView {
    
    self.currencyTableView = [[SearchCurrencyTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    
    self.currencyTableView.placeHolderView = [TLPlaceholderView placeholderViewWithImage:@"" text:@"没有搜索到币种或平台"];
    self.currencyTableView.refreshDelegate = self;
    
    [self.view addSubview:self.currencyTableView];
    [self.currencyTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(0);
    }];
    
    self.currencyTableView.hidden = YES;
}

#pragma mark -
- (void)initSelectScrollView {
    
    self.titles = @[@"热门币种", @"历史搜索"];
    
    SelectScrollView *selectSV = [[SelectScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight) itemTitles:self.titles];
    
    [self.view addSubview:selectSV];
    
    self.selectSV = selectSV;
}

- (void)addSubViewController {
    
    BaseWeakSelf;
    
    //
    SearchHistoryChildVC *childVC = [[SearchHistoryChildVC alloc] init];
    
    childVC.view.frame = CGRectMake(0, 0, kScreenWidth, kSuperViewHeight);
    
    childVC.historyBlock = ^(NSString *searchStr) {
        
        weakSelf.searchTF.text = searchStr;
        
        weakSelf.historyVC.view.hidden = YES;
        //获取搜索结果
        weakSelf.helper.parameters[@"keywords"] = searchStr;
        
        [weakSelf.currencyTableView beginRefreshing];
    };
    
    [self addChildViewController:childVC];
    
    [self.view addSubview:childVC.view];
    
    self.historyVC = childVC;
}

#pragma mark - Events

- (void)textDidChange:(UITextField *)sender {
    
    self.currencyTableView.hidden = sender.text.length == 0 ? YES: NO;
    //搜索框没有搜索时，显示
    if (sender.text.length == 0) {
        
        self.historyVC.view.hidden = NO;
    }
}

- (void)back {
    
    [self.searchTF resignFirstResponder];

    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Data
/**
 获取搜索结果
 */
- (void)requestSearchList {
    
    BaseWeakSelf;
    
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    
    helper.code = @"628350";
    
    if ([TLUser user].userId) {
        
        helper.parameters[@"userId"] = [TLUser user].userId;
    }
    
    helper.parameters[@"keywords"] = self.searchStr;
    helper.parameters[@"percentPeriod"] = @"24h";

    helper.tableView = self.currencyTableView;
    
    [helper modelClass:[PlatformModel class]];
    
    self.helper = helper;
    
    [self.currencyTableView addRefreshAction:^{
        
        [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.currencys = objs;
            
            weakSelf.currencyTableView.currencys = objs;
            
            [weakSelf.currencyTableView reloadData_tl];
            
            weakSelf.currencyTableView.hidden = NO;

        } failure:^(NSError *error) {
            
        }];
    }];
    
    [self.currencyTableView addLoadMoreAction:^{
        
        [helper loadMore:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.currencys = objs;
            
            weakSelf.currencyTableView.currencys = objs;
            
            [weakSelf.currencyTableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
        }];
    }];
    
    [self.currencyTableView endRefreshingWithNoMoreData_tl];
}

/**
 添加自选
 */
- (void)addCurrency:(NSInteger)index {
    
    PlatformModel *currency = self.currencys[index];
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"628330";
    http.showView = self.view;
    http.parameters[@"userId"] = [TLUser user].userId;
    http.parameters[@"exchangeEname"] = currency.exchangeEname;
    http.parameters[@"coin"] = currency.symbol;
    http.parameters[@"toCoin"] = currency.toSymbol;
    
    [http postWithSuccess:^(id responseObject) {
        
        [TLAlert alertWithSucces:@"添加成功"];
        
        currency.isChoice = @"1";
        
        [self.currencyTableView reloadData];

        if (self.currencyBlock) {
            
            self.currencyBlock();
        }
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    
    self.searchStr = textField.text;
    
    self.historyVC.view.hidden = YES;
    //保存搜索记录
    [self.historyVC saveSearchRecord:textField.text];
    //获取搜索结果
    self.helper.parameters[@"keywords"] = self.searchStr;
    [self.currencyTableView beginRefreshing];
    
    return YES;
}

/**
 关注
 */
- (void)followCurrency:(NSInteger)index {
    
    PlatformModel *platformModel = self.currencys[index];
    
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
        
        [self.currencyTableView reloadData];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"FollowOrCancelFollow" object:nil];
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - RefreshDelegate
- (void)refreshTableView:(TLTableView *)refreshTableview didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PlatformModel *platform = self.currencys[indexPath.row];
    
    CurrencyDetailVC *detailVC = [CurrencyDetailVC new];
    
    detailVC.symbolID = platform.ID;
    
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (void)refreshTableViewEventClick:(TLTableView *)refreshTableview selectRowAtIndex:(NSInteger)index {
    
    BaseWeakSelf;
    [self checkLogin:^{
        
        //刷新关注状态
        [weakSelf.currencyTableView beginRefreshing];
        
    } event:^{
        
        [weakSelf followCurrency:index];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
