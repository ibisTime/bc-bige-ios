//
//  NewsFlashListCell.m
//  bige
//
//  Created by 蔡卓越 on 2018/3/12.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "NewsFlashListCell.h"
//Category
#import "NSString+Date.h"
#import "UILabel+Extension.h"
#import "NSString+Extension.h"

@interface NewsFlashListCell()

//时间
@property (nonatomic, strong) UILabel *timeLbl;
//来源
@property (nonatomic, strong) UILabel *sourceLbl;
//内容
@property (nonatomic, strong) UILabel *contentLbl;

@end

@implementation NewsFlashListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self initSubviews];
        
    }
    
    return self;
}

#pragma mark - Init
- (void)initSubviews {
    
    //时间
    self.timeLbl = [UILabel labelWithBackgroundColor:kClearColor
                                             textColor:kTextColor2
                                                  font:14.0];
    
    [self addSubview:self.timeLbl];
    //来源
    self.sourceLbl = [UILabel labelWithBackgroundColor:kClearColor
                                              textColor:kTextColor
                                                   font:15.0];
    [self addSubview:self.sourceLbl];
    //内容
    self.contentLbl = [UILabel labelWithBackgroundColor:kClearColor
                                                textColor:kAppCustomMainColor
                                                     font:15.0];
    self.contentLbl.numberOfLines = 3;
    
    [self addSubview:self.contentLbl];
    //分享
    self.shareBtn = [UIButton buttonWithTitle:@"分享"
                                   titleColor:kTextColor2
                              backgroundColor:kClearColor
                                    titleFont:14.0];
    [self.shareBtn setImage:kImage(@"分享") forState:UIControlStateNormal];
    
    [self addSubview:self.shareBtn];
    //bottomLine
    UIView *bottomLine = [[UIView alloc] init];
    
    bottomLine.backgroundColor = kLineColor;
    
    [self addSubview:bottomLine];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.bottom.equalTo(@0);
        make.height.equalTo(@0.5);
    }];
    //布局
    [self setSubviewLayout];
}

- (void)setSubviewLayout {
    
    CGFloat x = 15;
    //时间
    [self.timeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(@10);
        make.left.equalTo(@15);
        make.height.equalTo(@20);
        make.width.equalTo(@(160));
    }];
    
    //来源
    [self.sourceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.timeLbl.mas_bottom).offset(10);
        make.left.equalTo(self.timeLbl.mas_left);
    }];
    //内容
    [self.contentLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.sourceLbl.mas_bottom).offset(10);
        make.left.equalTo(self.timeLbl.mas_left);
        make.right.equalTo(@(-x));
    }];
    //分享
    [self.shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.contentLbl.mas_bottom).offset(20);
        make.right.equalTo(@(-x));
        make.width.equalTo(@50);
        make.height.equalTo(@20);
    }];
    [self.shareBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
}

#pragma mark - Setting
- (void)setFlashModel:(NewsFlashModel *)flashModel {
    
    _flashModel = flashModel;
    
    self.timeLbl.text = [flashModel.showDatetime convertDateWithFormat:@"MM.dd HH:mm:ss"];
    //来源
    self.sourceLbl.text = flashModel.source;
    
    //过滤特殊字符串
    NSString *content = [NSString filterHTML:flashModel.content];
    
    self.contentLbl.numberOfLines = flashModel.isSelect ? 0: 3;
    [self.contentLbl labelWithTextString:content lineSpace:5];
    
    if ([flashModel.type isEqualToString:@"1"]) {
        
        self.contentLbl.textColor = [flashModel.isRead isEqualToString:@"1"] ? kTextColor2: kAppCustomMainColor;

    } else {
        
        self.contentLbl.textColor = [flashModel.isRead isEqualToString:@"1"] ? kTextColor2: kTextColor;
    }
    //
    [self layoutSubviews];
    
    flashModel.cellHeight = self.shareBtn.yy + 10;
}

@end
