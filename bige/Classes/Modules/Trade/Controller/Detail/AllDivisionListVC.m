//
//  AllDivisionListVC.m
//  bige
//
//  Created by 蔡卓越 on 2018/5/8.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "AllDivisionListVC.h"
//Macro
//Framework
//Category
#import "UIButton+EnLargeEdge.h"
//Extension
//M
#import "DivisionFilterManager.h"
//V
#import "SelectScrollView.h"
#import "FilterView.h"
//C
#import "CurrentDivisionChildVC.h"
#import "HistoryDivisionChildVC.h"

@interface AllDivisionListVC ()

@property (nonatomic, strong) SelectScrollView *selectSV;
//筛选
@property (nonatomic, strong) FilterView *filterView;
//交易管理类
@property (nonatomic, strong) DivisionFilterManager *manager;

@end

@implementation AllDivisionListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"委托单";
    //
    [self initTradeData];
    //筛选
    [self addFilterItem];
    //添加子控制器
    [self addChildVC];
}

#pragma mark - Init
- (FilterView *)filterView {
    
    if (!_filterView) {
        
        _filterView = [[FilterView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight)];
        
        [self.view addSubview:_filterView];
    }
    return _filterView;
}

- (void)addFilterItem {
    
    UIButton *filterBtn = [UIButton buttonWithTitle:@"筛选"
                                         titleColor:kWhiteColor
                                    backgroundColor:kClearColor
                                          titleFont:16.0];
    filterBtn.frame = CGRectMake(0, 0, 75, 44);
    [filterBtn setImage:kImage(@"筛选") forState:UIControlStateNormal];
    [filterBtn addTarget:self action:@selector(fliter) forControlEvents:UIControlEventTouchUpInside];
    [filterBtn setTitleRight];
    
    UIView *customView = [[UIView alloc] initWithFrame:filterBtn.bounds];
    
    [customView addSubview:filterBtn];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:customView];
}

- (void)fliter {
    
    [self.filterView show];
}

- (void)initTradeData {
    
    self.manager = [DivisionFilterManager manager];
    
    self.manager.symbol = @"";
    self.manager.toSymbol = @"";
    self.manager.direction = @"";
}

- (void)addChildVC {
    
    NSArray *titles = @[@"当前委托", @"历史委托"];
    
    self.selectSV = [[SelectScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight) itemTitles:titles];
    
    [self.view addSubview:self.selectSV];
    //添加子控制器
    for (NSInteger i = 0; i < titles.count; i++) {
        
        if (i == 0) {
            
            //当前委托
            CurrentDivisionChildVC *childVC = [[CurrentDivisionChildVC alloc] init];
            
            childVC.currentIndex = i;
            childVC.view.frame = CGRectMake(kScreenWidth*i, 0, kScreenWidth, kSuperViewHeight - 40);
            
            [self addChildViewController:childVC];
            
            [self.selectSV.scrollView addSubview:childVC.view];
            
        } else {
            
            //历史委托
            HistoryDivisionChildVC *childVC = [[HistoryDivisionChildVC alloc] init];
            
            childVC.currentIndex = i;
            childVC.view.frame = CGRectMake(kScreenWidth*i, 0, kScreenWidth, kSuperViewHeight - 40);
            
            [self addChildViewController:childVC];
            
            [self.selectSV.scrollView addSubview:childVC.view];
        }
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
