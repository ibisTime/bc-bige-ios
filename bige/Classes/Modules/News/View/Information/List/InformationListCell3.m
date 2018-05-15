//
//  InformationListCell3.m
//  bige
//
//  Created by 蔡卓越 on 2018/5/14.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "InformationListCell3.h"
//Category
#import "NSString+Date.h"
#import "NSString+Extension.h"
#import "NSString+Check.h"
#import <UIImageView+WebCache.h>
#import "UILabel+Extension.h"

#define kHeadIconW 22

@interface InformationListCell3()
//头像
@property (nonatomic, strong) UIImageView *photoIV;
//昵称
@property (nonatomic, strong) UILabel *nameLbl;
//缩略图
@property (nonatomic, strong) UIImageView *infoIV;
//时间
@property (nonatomic, strong) UILabel *timeLbl;
//阅读量
@property (nonatomic, strong) ImageLabel *readLbl;
//评论量
@property (nonatomic, strong) ImageLabel *commentLbl;

@end

@implementation InformationListCell3

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self initSubviews];
    }
    return self;
}

#pragma mark - Init
- (void)initSubviews {
    //头像
    self.photoIV = [[UIImageView alloc] init];
    
    self.photoIV.layer.cornerRadius = kHeadIconW/2.0;
    self.photoIV.layer.masksToBounds = YES;
    self.photoIV.backgroundColor = kClearColor;
    self.photoIV.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:self.photoIV];;
    //昵称
    self.nameLbl = [UILabel labelWithBackgroundColor:kClearColor
                                           textColor:kTextColor
                                                font:14.0];
    [self addSubview:self.nameLbl];
    
    //缩略图
    self.infoIV = [[UIImageView alloc] init];
    
    self.infoIV.contentMode = UIViewContentModeScaleAspectFill;
    self.infoIV.clipsToBounds = YES;
    //    self.infoIV.layer.cornerRadius = 4;
    
    [self addSubview:self.infoIV];

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
    //分享
    self.shareLbl = [[ImageLabel alloc] initWithFrame:CGRectZero];
    [self.shareLbl.iconIV setImage:kImage(@"分享")];
    self.shareLbl.textLbl.textColor = kTextColor2;
    self.shareLbl.textLbl.font = Font(12.0);
    self.shareLbl.textLbl.text = @"分享";
    
    self.shareLbl.margin = 5;

    [self addSubview:self.shareLbl];
    
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
    //头像
    [self.photoIV mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.equalTo(@(x));
        make.width.height.equalTo(@(kHeadIconW));
    }];
    //昵称
    [self.nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.photoIV.mas_right).offset(10);
        make.centerY.equalTo(self.photoIV.mas_centerY);
    }];
    //缩略图
    [self.infoIV mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@(x));
        make.right.equalTo(@(-x));
        make.top.equalTo(self.photoIV.mas_bottom).offset(15);
        make.height.equalTo(@(kWidth(195)));
    }];
    //阅读数
    [self.readLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@(kWidth(38)));
        make.top.equalTo(self.infoIV.mas_bottom).offset(15);
    }];
    //评论数
    [self.commentLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@0);
        make.centerY.equalTo(self.readLbl.mas_centerY);
    }];
    //分享
    [self.shareLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(@(-kWidth(38)));
        make.centerY.equalTo(self.readLbl.mas_centerY);
        make.height.equalTo(@40);
    }];
    
}

#pragma mark - Setting
- (void)setInfoModel:(InformationModel *)infoModel {
    
    _infoModel = infoModel;
    //头像
    [self.photoIV sd_setImageWithURL:[NSURL URLWithString:[infoModel.autherPic convertImageUrl]] placeholderImage:kImage(PLACEHOLDER_SMALL)];
    //作者
    NSString *auther = [infoModel.auther valid] ? infoModel.auther: @"- -";
    self.nameLbl.text = auther;
    //大图
    [self.infoIV sd_setImageWithURL:[NSURL URLWithString:[infoModel.advPic convertImageUrl]] placeholderImage:kImage(PLACEHOLDER_SMALL)];
    //阅读数
    self.readLbl.textLbl.text = [NSString stringWithFormat:@"%ld", infoModel.readCount];
    //评论数
    self.commentLbl.textLbl.text = [NSString stringWithFormat:@"%ld", infoModel.commentCount];
    
}

@end
