//
//  InformationListCell.m
//  bige
//
//  Created by 蔡卓越 on 2018/3/12.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "InformationListCell.h"

//Category
#import "NSString+Date.h"
#import "NSString+Extension.h"
#import <UIImageView+WebCache.h>
#import "UILabel+Extension.h"
//V
#import "ImageLabel.h"

@interface InformationListCell()
//缩略图
@property (nonatomic, strong) UIImageView *infoIV;
//标题
@property (nonatomic, strong) UILabel *titleLbl;
//时间
@property (nonatomic, strong) UILabel *timeLbl;
//阅读量
@property (nonatomic, strong) ImageLabel *readLbl;
//评论量
@property (nonatomic, strong) ImageLabel *commentLbl;

@end

@implementation InformationListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self initSubviews];
    }
    return self;
}

#pragma mark - Init
- (void)initSubviews {
    
    //缩略图
    self.infoIV = [[UIImageView alloc] init];
    
    self.infoIV.contentMode = UIViewContentModeScaleAspectFill;
    self.infoIV.clipsToBounds = YES;
//    self.infoIV.layer.cornerRadius = 4;
    
    [self addSubview:self.infoIV];
    //标题
    self.titleLbl = [UILabel labelWithBackgroundColor:kClearColor
                                            textColor:kTextColor
                                                 font:17.0];
    self.titleLbl.numberOfLines = 0;
    
    [self addSubview:self.titleLbl];
    //时间
    self.timeLbl = [UILabel labelWithBackgroundColor:kClearColor
                                           textColor:kTextColor2
                                                font:12.0];
    [self addSubview:self.timeLbl];
    //阅读数
    self.readLbl = [[ImageLabel alloc] initWithFrame:CGRectZero];
    [self.readLbl.iconIV setImage:kImage(@"浏览")];
    self.readLbl.textLbl.textColor = kTextColor2;
    self.readLbl.textLbl.font = Font(12.0);
    self.readLbl.margin = 5;

    [self addSubview:self.readLbl];
    //评论数
    self.commentLbl = [[ImageLabel alloc] initWithFrame:CGRectZero];
    [self.commentLbl.iconIV setImage:kImage(@"留言小图")];
    self.commentLbl.textLbl.textColor = kTextColor2;
    self.commentLbl.textLbl.font = Font(12.0);
    
    self.commentLbl.margin = 5;

    [self addSubview:self.commentLbl];
    
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
    
    //缩略图
    [self.infoIV mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(@(-x));
        make.top.equalTo(@10);
        make.width.equalTo(@113);
        make.height.equalTo(@75);
    }];
    //标题
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.infoIV.mas_top);
        make.left.equalTo(@(x));
        make.right.equalTo(self.infoIV.mas_left).offset(-10);
        make.height.lessThanOrEqualTo(@60);
    }];
    //时间
    [self.timeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@(x));
        make.bottom.equalTo(self.infoIV.mas_bottom).offset(0);
    }];
    //评论数
    [self.commentLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.titleLbl.mas_right);
        make.centerY.equalTo(self.timeLbl.mas_centerY);
    }];

    //阅读数
    [self.readLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.commentLbl.mas_left).offset(-x);
        make.centerY.equalTo(self.timeLbl.mas_centerY);
    }];

}

#pragma mark - Setting
- (void)setInfoModel:(InformationModel *)infoModel {
    
    _infoModel = infoModel;
    
    [self.titleLbl labelWithTextString:infoModel.title lineSpace:5];
    [self.infoIV sd_setImageWithURL:[NSURL URLWithString:[infoModel.advPic convertImageUrl]] placeholderImage:kImage(PLACEHOLDER_SMALL)];
    self.timeLbl.text = [infoModel.showDatetime convertToDetailDate];
    self.readLbl.textLbl.text = [NSString stringWithFormat:@"%ld", infoModel.readCount];
    self.commentLbl.textLbl.text = [NSString stringWithFormat:@"%ld", infoModel.commentCount];
    
}

@end
