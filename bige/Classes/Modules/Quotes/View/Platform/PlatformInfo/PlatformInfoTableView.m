//
//  PlatformInfoTableView.m
//  bige
//
//  Created by 蔡卓越 on 2018/4/26.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "PlatformInfoTableView.h"

//V
#import "PlatformInfoCell.h"
#import "PlatformInfoHeaderView.h"

@interface PlatformInfoTableView()<UITableViewDelegate, UITableViewDataSource>

@end
@implementation PlatformInfoTableView

static NSString *identifierCell = @"PlatformInfoCell";
static NSString *headerID = @"PlatformInfoHeaderView";

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    
    if (self = [super initWithFrame:frame style:style]) {
        
        self.dataSource = self;
        self.delegate = self;
        
        [self registerClass:[PlatformInfoCell class] forCellReuseIdentifier:identifierCell];
        [self registerClass:[PlatformInfoHeaderView class] forHeaderFooterViewReuseIdentifier:headerID];
    }
    
    return self;
}

#pragma mark - UITableViewDataSource;

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.platforms.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PlatformInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierCell forIndexPath:indexPath];
    
    cell.platform = self.platforms[indexPath.row];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    PlatformInfoHeaderView *headerView = (PlatformInfoHeaderView *)[tableView dequeueReusableHeaderFooterViewWithIdentifier:headerID];
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    return [UIView new];
}

#pragma mark - UIScrollView
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat scrollOffset = scrollView.contentOffset.y;
    
    if (!self.vcCanScroll) {
        //处理tableview和scrollView同时滚的问题（当vc不能滚动时，设置scrollView偏移量为0）
        scrollView.contentOffset = CGPointZero;
    }
    
    if (scrollOffset < 0) {
        
        //偏移量小于等于零说明tableview到顶了
        self.vcCanScroll = NO;
        
        scrollView.contentOffset = CGPointZero;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SubVCLeaveTop" object:nil];
    }
}

//tableview和scrollView可以同时滚动,解决手势冲突问题
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    
    return YES;
}

@end
