//
//  HomeChildVC.h
//  bige
//
//  Created by 蔡卓越 on 2018/5/2.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BaseViewController.h"
//M
#import "PlatformTitleModel.h"

@interface HomeChildVC : BaseViewController
//当前索引
@property (nonatomic, assign) NSInteger currentIndex;

//点击刷新
- (void)clickPlatformWithIndex:(NSInteger)index;

@end
