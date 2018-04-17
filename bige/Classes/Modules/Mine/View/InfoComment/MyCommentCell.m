//
//  MyCommentCell.m
//  bige
//
//  Created by 蔡卓越 on 2018/3/24.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "MyCommentCell.h"
//
#import "TLUser.h"
//Category
#import <UIImageView+WebCache.h>
#import "NSString+Extension.h"
#import "NSString+Date.h"
#import "UIButton+EnLargeEdge.h"
#import "UILabel+Extension.h"
#import "NSString+Check.h"
//V
#import "LinkLabel.h"
#import "UserPhotoView.h"

#define kHeadIconW 40

@interface MyCommentCell ()
//头像
@property (nonatomic, strong) UserPhotoView *photoIV;
//昵称
@property (nonatomic, strong) UILabel *nameLbl;
//回复的人
@property (nonatomic, strong) UILabel *replyNameLbl;
//时间
@property (nonatomic, strong) UILabel *timeLbl;
//评论
@property (nonatomic, strong) LinkLabel *contentLbl;
//缩略图
@property (nonatomic, strong) UIImageView *infoIV;
//标题
@property (nonatomic, strong) UILabel *titleLbl;
//
@property (nonatomic, assign) BOOL isFirst;

@end

@implementation MyCommentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self initSubviews];
    }
    
    return self;
}

#pragma mark - Init
- (void)initSubviews {
    
    self.isFirst = YES;
    //头像
    self.photoIV = [[UserPhotoView alloc] init];
    self.photoIV.layer.cornerRadius = kHeadIconW/2.0;
    self.photoIV.layer.masksToBounds = YES;
    self.photoIV.backgroundColor = kClearColor;
    self.photoIV.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:self.photoIV];
    //昵称
    self.nameLbl = [UILabel labelWithFrame:CGRectZero
                              textAligment:NSTextAlignmentLeft
                           backgroundColor:kWhiteColor
                                      font:Font(14)
                                 textColor:kTextColor];
    [self addSubview:self.nameLbl];
    //回复我的
    self.replyNameLbl = [UILabel labelWithBackgroundColor:kClearColor
                                                textColor:kTextColor2
                                                     font:12.0];
    
    [self addSubview:self.replyNameLbl];
    //时间
    self.timeLbl = [UILabel labelWithFrame:CGRectZero
                              textAligment:NSTextAlignmentLeft
                           backgroundColor:kClearColor
                                      font:Font(14.0)
                                 textColor:kTextColor2];
    [self addSubview:self.timeLbl];
    //评论
    self.contentLbl = [[LinkLabel alloc] initWithFrame:CGRectZero];
    self.contentLbl.font = Font(16.0);
    self.contentLbl.textColor = [UIColor textColor];
    self.contentLbl.numberOfLines = 0;
    [self addSubview:self.contentLbl];
    //文章
    self.articleView = [[UIView alloc] init];
    
    self.articleView.backgroundColor = kHexColor(@"#F6F6F6");
    self.articleView.userInteractionEnabled = YES;
    self.articleView.layer.cornerRadius = 4;
    self.articleView.clipsToBounds = YES;
    
    [self addSubview:self.articleView];
    
    
    //缩略图
    self.infoIV = [[UIImageView alloc] init];
    
    self.infoIV.contentMode = UIViewContentModeScaleAspectFill;
    self.infoIV.clipsToBounds = YES;
    self.infoIV.layer.cornerRadius = 4;
    
    [self.articleView addSubview:self.infoIV];
    //标题
    self.titleLbl = [UILabel labelWithBackgroundColor:kHexColor(@"#F6F6F6")
                                            textColor:kTextColor
                                                 font:14.0];
    self.titleLbl.numberOfLines = 0;
    
    [self.articleView addSubview:self.titleLbl];
    
}

- (void)setSubviewLayout {
    
    CGFloat leftMargin = 15;
    //头像
    [self.photoIV mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.equalTo(@(leftMargin));
        make.width.height.equalTo(@(kHeadIconW));
    }];
    //昵称
    [self.nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.photoIV.mas_top).offset(0);
        make.left.equalTo(self.photoIV.mas_right).offset(leftMargin);
    }];
    //时间
    [self.timeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.nameLbl.mas_top);
        make.right.equalTo(@(-leftMargin));
    }];
    //回复我的
    [self.replyNameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.nameLbl.mas_bottom).offset(6);
        make.left.equalTo(self.nameLbl.mas_left);
    }];
    //评论
    [self.contentLbl mas_makeConstraints:^(MASConstraintMaker *make) {

        make.left.equalTo(self.nameLbl.mas_left);
        make.height.lessThanOrEqualTo(@(MAXFLOAT));
        make.right.equalTo(@(-leftMargin));
        make.top.equalTo(self.replyNameLbl.mas_bottom).offset(10);
    }];
    
    //
    [self.articleView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.nameLbl.mas_left);
        make.right.equalTo(@(-leftMargin));
        make.top.equalTo(self.contentLbl.mas_bottom).offset(10);
        make.height.equalTo(@65);
    }];
    //缩略图
    [self.infoIV mas_makeConstraints:^(MASConstraintMaker *make) {

        make.left.top.equalTo(@0);
        make.width.equalTo(@95);
        make.height.equalTo(@65);
    }];
    //标题
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {

        make.top.equalTo(self.infoIV.mas_top).offset(10);
        make.left.equalTo(self.infoIV.mas_right).offset(10);
        make.right.equalTo(@(-10));
        make.bottom.equalTo(@(-10));
    }];
}

#pragma mark - Setting
- (void)setCommentModel:(MyCommentModel *)commentModel {
    
    _commentModel = commentModel;
    
    ArticleInfo *info = commentModel.news;
    
    NSString *photo = commentModel.photo;
    //1:资讯 2:圈子
    self.photoIV.commentType = @"1";
    self.photoIV.userId = commentModel.userId;
    [self.photoIV sd_setImageWithURL:[NSURL URLWithString:[photo convertImageUrl]]
                    placeholderImage:USER_PLACEHOLDER_SMALL];
    
    self.nameLbl.text = commentModel.nickname;
    self.timeLbl.text = [commentModel.commentDatetime convertToDetailDate];
    
    NSString *nickname = self.isReplyMe ? @"我":commentModel.parentNickName;
    
    NSString *replyName = [nickname valid] ? [NSString stringWithFormat:@"回复 %@", nickname]: @"评论";
    self.replyNameLbl.text = replyName;
    self.contentLbl.text = commentModel.content;
    [self.titleLbl labelWithTextString:info.title lineSpace:5];
    if (info.pics > 0) {
        
        [self.infoIV sd_setImageWithURL:[NSURL URLWithString:[info.pics[0] convertImageUrl]] placeholderImage:kImage(PLACEHOLDER_SMALL)];
    }
    
    //
    [self setSubviewLayout];
    //
    [self layoutSubviews];
    
    commentModel.cellHeight = self.articleView.yy + 15;
}

@end
