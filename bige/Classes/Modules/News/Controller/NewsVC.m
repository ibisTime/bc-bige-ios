//
//  NewsVC.m
//  bige
//
//  Created by 蔡卓越 on 2018/4/23.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "NewsVC.h"
//Manager
#import "InfoManager.h"
//M
#import "NewsFlashModel.h"
#import "InfoTypeModel.h"
//V
#import "SelectScrollView.h"
//C
#import "NewsListVC.h"
#import "InfoListVC.h"

@interface NewsVC ()

//滚动
@property (nonatomic, strong) SelectScrollView *selectSV;
//titles
@property (nonatomic, strong) NSArray *titles;
//类型
@property (nonatomic, copy) NSString *kind;

@end

@implementation NewsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"币格财经";
    //顶部切换
    [self initSegmentView];
}

#pragma mark - Notification


#pragma mark - Init
- (void)initSegmentView {
    
    self.titles = @[
                    @"新闻",
                    @"快讯"];
    
    SelectScrollView *selectSV = [[SelectScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight - kTabBarHeight) itemTitles:self.titles];

    [self.view addSubview:selectSV];
    
    for (NSInteger i = 0; i < self.titles.count; i++) {
        
        if (i == 0) {
            
            InfoListVC *childVC = [InfoListVC new];
            
            childVC.view.frame = CGRectMake(kScreenWidth*i, 1, kScreenWidth, kSuperViewHeight - 40 - kTabBarHeight);
            [self addChildViewController:childVC];
            
            [selectSV.scrollView addSubview:childVC.view];
            
        } else {
            
            NewsListVC *childVC = [NewsListVC new];
            
            childVC.view.frame = CGRectMake(kScreenWidth*i, 1, kScreenWidth, kSuperViewHeight - 40 - kTabBarHeight);
            [self addChildViewController:childVC];
            
            [selectSV.scrollView addSubview:childVC.view];
        }
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
