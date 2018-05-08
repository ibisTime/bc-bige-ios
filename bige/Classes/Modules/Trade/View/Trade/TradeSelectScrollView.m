//
//  TradeSelectScrollView.m
//  bige
//
//  Created by 蔡卓越 on 2018/5/7.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "TradeSelectScrollView.h"
//Category
#import "UIView+Responder.h"
#import <UIScrollView+TLAdd.h>
//Macro
#import "TLUIHeader.h"
#import "AppColorMacro.h"

#define kHeadBarHeight 45

@interface TradeSelectScrollView()<UIScrollViewDelegate>

@property (nonatomic, strong) NSArray *itemTitles;

@property (nonatomic, strong) NSMutableArray *btnArray;

@property (nonatomic, assign) CGFloat leftLength;

@end

@implementation TradeSelectScrollView

- (instancetype)initWithFrame:(CGRect)frame itemTitles:(NSArray *)itemTitles {
    
    if (self = [super initWithFrame:frame]) {
        
        _itemTitles = itemTitles;
        
        _btnArray = [NSMutableArray array];
        
        [self initTopView];
        
        [self initScrollView];
    }
    
    return self;
}


#pragma mark - Init

- (void)initTopView {
    
    BaseWeakSelf;
    
    _headView = [[TradeSortBar alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, kHeadBarHeight) sortNames:_itemTitles sortBlock:^(NSInteger index) {
        
        weakSelf.selectIndex = index;
        
        [weakSelf.scrollView scrollRectToVisible:CGRectMake(weakSelf.width*index, 0, weakSelf.width, weakSelf.scrollView.height) animated:NO];
        if (weakSelf.selectBlock) {
            
            weakSelf.selectBlock(index);
        }
    }];
    
    [self addSubview:_headView];
    
}

- (void)initScrollView {
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kHeadBarHeight, self.frame.size.width, self.frame.size.height - 40)];
    _scrollView.contentSize = CGSizeMake(self.frame.size.width * _itemTitles.count, self.height - kHeadBarHeight);
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
    _scrollView.bounces = NO;
    _scrollView.scrollEnabled = NO;
    
    [_scrollView adjustsContentInsets];
    
    [self insertSubview:_scrollView belowSubview:_headView];
    
    _scrollView.contentOffset = CGPointMake(0, 0);
    
    [self addSubview:_scrollView];
}

#pragma mark - Setting

- (void)setCurrentIndex:(NSInteger)currentIndex {
    
    _currentIndex = currentIndex;
    
    _headView.curruntIndex = _currentIndex;
}

@end
