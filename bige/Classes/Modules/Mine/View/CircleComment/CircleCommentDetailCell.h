//
//  CircleCommentDetailCell.h
//  bige
//
//  Created by 蔡卓越 on 2018/3/26.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BaseTableViewCell.h"
//M
#import "InfoCommentModel.h"

@interface CircleCommentDetailCell : BaseTableViewCell
//
@property (nonatomic, strong) InfoCommentModel *commentModel;
//点赞按钮
@property (nonatomic, strong) UIButton *zanBtn;
//是否回复
@property (nonatomic, assign) BOOL isReply;
//点击回复
@property (nonatomic, copy) void(^circleReplyBlock)(NSInteger index);
@end
