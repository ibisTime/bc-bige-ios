//
//  IntegralCenterVC.m
//  bige
//
//  Created by 蔡卓越 on 2018/5/11.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "IntegralCenterVC.h"

//V
#import "TLPlaceholderView.h"

@interface IntegralCenterVC ()

//敬请期待
@property (nonatomic, strong) TLPlaceholderView *waitView;

@end

@implementation IntegralCenterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"积分中心";
    //敬请期待
    [self initPlaceholderView];
}

#pragma mark - Init
- (void)initPlaceholderView {
    
    self.waitView = [TLPlaceholderView placeholderViewWithImage:@"敬请期待" text:@"敬请期待"];
    
    [self.view addSubview:self.waitView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
