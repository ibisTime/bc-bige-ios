//
//  RealAssetLinkVC.m
//  bige
//
//  Created by 蔡卓越 on 2018/5/4.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "RealAssetLinkVC.h"
//V
#import "TLPlaceholderView.h"

@interface RealAssetLinkVC ()
//敬请期待
@property (nonatomic, strong) TLPlaceholderView *waitView;

@end

@implementation RealAssetLinkVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"真实资产链接";
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
