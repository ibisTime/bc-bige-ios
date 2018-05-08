//
//  DivisionListTableView.m
//  bige
//
//  Created by 蔡卓越 on 2018/5/8.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "DivisionListTableView.h"
//Category
#import "UIButton+EnLargeEdge.h"
//V
#import "DivisionListCell.h"

@interface DivisionListTableView()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation DivisionListTableView

static NSString *identifierCell = @"DivisionListCell";

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    
    if (self = [super initWithFrame:frame style:style]) {
        
        self.dataSource = self;
        self.delegate = self;
        
        [self registerClass:[DivisionListCell class] forCellReuseIdentifier:identifierCell];
    }
    
    return self;
}

#pragma mark - UITableViewDataSource;

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.divisionList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DivisionListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierCell forIndexPath:indexPath];
    
    cell.division = self.divisionList[indexPath.row];
    
    cell.cancelBtn.tag = 2800 + indexPath.row;
    [cell.cancelBtn addTarget:self action:@selector(cancelDivision:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (void)cancelDivision:(UIButton *)sender {
    
    NSInteger index = sender.tag - 2800;
    
    if (self.refreshDelegate && [self.refreshDelegate respondsToSelector:@selector(refreshTableViewEventClick:selectRowAtIndex:)]) {
        
        [self.refreshDelegate refreshTableViewEventClick:self selectRowAtIndex:index];
    }
    
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 105;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth/2.0, 37)];
    
    headerView.backgroundColor = kWhiteColor;
    
    UILabel *divisionLbl = [UILabel labelWithBackgroundColor:kClearColor
                                                    textColor:kTextColor
                                                         font:15.0];
    divisionLbl.text = @"当前委托";
    [headerView addSubview:divisionLbl];
    [divisionLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@15);
        make.centerY.equalTo(@0);
    }];
    
    UIButton *allDivisionBtn = [UIButton buttonWithTitle:@"全部"
                                              titleColor:kTextColor2
                                         backgroundColor:kClearColor
                                               titleFont:12.0];
    
    [allDivisionBtn addTarget:self action:@selector(selectAllDivision:) forControlEvents:UIControlEventTouchUpInside];
    [allDivisionBtn setImage:kImage(@"全部委托单") forState:UIControlStateNormal];
    [headerView addSubview:allDivisionBtn];
    [allDivisionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(@(-5));
        make.height.equalTo(@40);
        make.width.equalTo(@45);
        make.centerY.equalTo(@0);
    }];
    
    [allDivisionBtn setTitleRight];
    
    return headerView;
    
}

- (void)selectAllDivision:(UIButton *)sender {
    
    if (self.refreshDelegate && [self.refreshDelegate respondsToSelector:@selector(refreshTableViewButtonClick:button:selectRowAtIndex:)]) {
        
        [self.refreshDelegate refreshTableViewButtonClick:self button:sender selectRowAtIndex:0];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    return [UIView new];
}

@end
