//
//  ForumInfoChildVC.h
//  bige
//
//  Created by 蔡卓越 on 2018/3/23.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BaseViewController.h"

@interface ForumInfoChildVC : BaseViewController
//索引
@property (nonatomic, assign) NSInteger index;
//是否滚动
@property (nonatomic, assign) BOOL vcCanScroll;
//编号
@property (nonatomic, copy) NSString *toCoin;
//刷新数据
@property (nonatomic, copy)  void(^refreshSuccess)();

@end
