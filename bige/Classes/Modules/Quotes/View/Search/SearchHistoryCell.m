//
//  SearchHistoryCell.m
//  bige
//
//  Created by 蔡卓越 on 2018/3/22.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "SearchHistoryCell.h"

@implementation SearchHistoryCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self initSubviews];
        
    }
    
    return self;
}

#pragma mark - Init
- (void)initSubviews {
    //内容
    self.contentLbl = [UILabel labelWithBackgroundColor:kClearColor
                                              textColor:kTextColor
                                                   font:14.0];
    
    [self addSubview:self.contentLbl];
    [self.contentLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@20);
        make.centerY.equalTo(@0);
    }];
    //icon
        UIImageView *iconIV = [[UIImageView alloc] initWithImage:kImage(@"更多-灰色")];
    
        [self addSubview:iconIV];
        [iconIV mas_makeConstraints:^(MASConstraintMaker *make) {
    
            make.right.equalTo(@(-15));
            make.centerY.equalTo(@0);
        }];
}

@end
