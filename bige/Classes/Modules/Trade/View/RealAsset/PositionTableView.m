//
//  PositionTableView.m
//  bige
//
//  Created by 蔡卓越 on 2018/5/11.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "PositionTableView.h"

//V
#import "PositionCell.h"
#import "PositionHeaderView.h"

@interface PositionTableView()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation PositionTableView

static NSString *identifierCell = @"PositionCell";
static NSString *headerID = @"PositionHeaderView";

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    
    if (self = [super initWithFrame:frame style:style]) {
        
        self.dataSource = self;
        self.delegate = self;
        
        [self registerClass:[PositionCell class] forCellReuseIdentifier:identifierCell];
        [self registerClass:[PositionHeaderView class] forHeaderFooterViewReuseIdentifier:headerID];
    }
    
    return self;
}

#pragma mark - UITableViewDataSource;

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.position.assetList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    AssetInfo *asset = self.position.assetList[section];
    
    return asset.accountList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AssetInfo *asset = self.position.assetList[indexPath.section];
    
    AccountInfo *accountInfo = asset.accountList[indexPath.row];
    
    PositionCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierCell forIndexPath:indexPath];
    
    cell.accountInfo = accountInfo;
    
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
    
    return 100;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    AssetInfo *asset = self.position.assetList[section];

    PositionHeaderView *headerView = (PositionHeaderView *)[tableView dequeueReusableHeaderFooterViewWithIdentifier:headerID];
    
    headerView.asset = asset;
    
    return headerView;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    return [UIView new];
}

@end
