//
//  WarningSettingTableView.m
//  bige
//
//  Created by 蔡卓越 on 2018/5/3.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "WarningSettingTableView.h"

//V
#import "WarningSettingCell.h"

@interface WarningSettingTableView()<UITableViewDelegate, UITableViewDataSource>

@end
@implementation WarningSettingTableView

static NSString *identifierCell = @"WarningSettingCell";

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    
    if (self = [super initWithFrame:frame style:style]) {
        
        self.dataSource = self;
        self.delegate = self;
        
        [self registerClass:[WarningSettingCell class] forCellReuseIdentifier:identifierCell];
    }
    
    return self;
}

#pragma mark - UITableViewDataSource;

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.warnings.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WarningSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierCell forIndexPath:indexPath];
    
    cell.warning = self.warnings[indexPath.row];
    cell.leaveBtn.tag = 2600 + indexPath.row;
    
    [cell.leaveBtn addTarget:self action:@selector(leaveMessage:) forControlEvents:UIControlEventTouchUpInside];

    return cell;
}

- (void)leaveMessage:(UIButton *)sender {
    
    NSInteger index = sender.tag - 2600;
    
    if (self.refreshDelegate && [self.refreshDelegate respondsToSelector:@selector(refreshTableViewEventClick:selectRowAtIndex:)]) {
        
        [self.refreshDelegate refreshTableViewEventClick:self selectRowAtIndex:index];
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 55;
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
