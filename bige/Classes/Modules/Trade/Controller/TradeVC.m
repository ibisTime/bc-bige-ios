//
//  TradeVC.m
//  bige
//
//  Created by 蔡卓越 on 2018/4/23.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "TradeVC.h"
//Manager
#import "TradeManager.h"
//M
//V
#import "SelectScrollView.h"
#import "TopLabelUtil.h"
//C
#import "SimulationTradeVC.h"
#import "RealAssetLinkVC.h"

@interface TradeVC ()<SegmentDelegate>
//顶部切换
@property (nonatomic, strong) TopLabelUtil *labelUnil;
//大滚动
@property (nonatomic, strong) UIScrollView *switchSV;
//小滚动
@property (nonatomic, strong) SelectScrollView *selectSV;
//titles
@property (nonatomic, strong) NSMutableArray *titles;
//statusList
@property (nonatomic, strong) NSArray *statusList;
//类型
@property (nonatomic, copy) NSString *kind;

@end

@implementation TradeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //顶部切换
    [self initSegmentView];
}

#pragma mark - Init
- (void)initSegmentView {
    
    NSArray *titleArr = @[
                          @"模拟交易",
                          @"真实资产管理"];
    
    self.titles = [NSMutableArray array];
    
    CGFloat h = 34;
    
    self.labelUnil = [[TopLabelUtil alloc]initWithFrame:CGRectMake(kScreenWidth/2 - kWidth(200), (44-h), kWidth(199), h)];
    
    self.labelUnil.delegate = self;
    self.labelUnil.backgroundColor = [UIColor clearColor];
    self.labelUnil.titleNormalColor = kWhiteColor;
    self.labelUnil.titleSelectColor = kAppCustomMainColor;
    self.labelUnil.titleFont = Font(13);
    self.labelUnil.lineType = LineTypeButtonLength;
    self.labelUnil.titleArray = titleArr;
    self.labelUnil.layer.cornerRadius = 2.5;
    self.labelUnil.layer.borderWidth = 1;
    self.labelUnil.layer.borderColor = kWhiteColor.CGColor;
    
    self.navigationItem.titleView = self.labelUnil;
    
    //1.切换背景
    self.switchSV = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight - kTabBarHeight)];
    [self.view addSubview:self.switchSV];
    [self.switchSV setContentSize:CGSizeMake(titleArr.count*self.switchSV.width, self.switchSV.height)];
    self.switchSV.scrollEnabled = NO;
    //2.添加子控制器
    
    [self addSubViewController];

}

- (void)addSubViewController {
    
    BaseWeakSelf;
    
    for (NSInteger i = 0; i < 2; i++) {
        
        if (i == 0) {
            
            SimulationTradeVC *childVC = [SimulationTradeVC new];
            
            childVC.view.frame = CGRectMake(0, 0, kScreenWidth, kSuperViewHeight - kTabBarHeight);
            
            childVC.didSelectRealAsset = ^{
              
                [weakSelf.labelUnil selectSortBarWithIndex:1];
            };
            
            [self addChildViewController:childVC];
            [self.switchSV addSubview:childVC.view];

        } else {
            
            RealAssetLinkVC *childVC = [RealAssetLinkVC new];
            
            childVC.view.frame = CGRectMake(kScreenWidth, 0, kScreenWidth, kSuperViewHeight - kTabBarHeight);
            
            [self addChildViewController:childVC];
            [self.switchSV addSubview:childVC.view];
        }
    }
}

#pragma mark - SegmentDelegate
- (void)segment:(TopLabelUtil *)segment didSelectIndex:(NSInteger)index {
    
    [self.switchSV setContentOffset:CGPointMake((index - 1) * self.switchSV.width, 0)];
    [self.labelUnil dyDidScrollChangeTheTitleColorWithContentOfSet:(index-1)*kScreenWidth];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
