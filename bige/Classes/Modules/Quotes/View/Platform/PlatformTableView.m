//
//  PlatformTableView.m
//  bige
//
//  Created by 蔡卓越 on 2018/3/21.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "PlatformTableView.h"
//V
#import "PlatformCell.h"

@interface PlatformTableView()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation PlatformTableView

static NSString *platformCell = @"PlatformCell";

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    
    if (self = [super initWithFrame:frame style:style]) {
        
        self.dataSource = self;
        self.delegate = self;
        //具体平台
        [self registerClass:[PlatformCell class] forCellReuseIdentifier:platformCell];
    }
    
    return self;
}

#pragma mark - UITableViewDataSource;

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.platforms.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PlatformModel *platform = self.platforms[indexPath.row];
    
    platform.rank = indexPath.row+1;
    
    PlatformCell *cell = [tableView dequeueReusableCellWithIdentifier:platformCell forIndexPath:indexPath];
    
    cell.platform = platform;
    cell.followBtn.tag = 2000 + indexPath.row;
    [cell.followBtn addTarget:self action:@selector(selectFollow:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (void)selectFollow:(UIButton *)sender {
    
    NSInteger index = sender.tag - 2000;
    
    if (self.refreshDelegate && [self.refreshDelegate respondsToSelector:@selector(refreshTableViewEventClick:selectRowAtIndex:)]) {
        
        [self.refreshDelegate refreshTableViewEventClick:self selectRowAtIndex:index];
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 68;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    return [UIView new];
}

@end
