//
//  TradeSelectScrollView.h
//  bige
//
//  Created by 蔡卓越 on 2018/5/7.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BaseView.h"
//V
#import "TradeSortBar.h"

typedef void(^SelectBlock)(NSInteger index);

@interface TradeSelectScrollView : BaseView

@property (nonatomic, strong) UIScrollView *scrollView;
//头部
@property (nonatomic, strong) TradeSortBar *headView;
//设置当前索引
@property (nonatomic, assign) NSInteger currentIndex;
//当前索引
@property (nonatomic, assign) NSInteger selectIndex;

@property (nonatomic, copy) SelectBlock selectBlock;

- (instancetype)initWithFrame:(CGRect)frame itemTitles:(NSArray *)itemTitles;

@end
