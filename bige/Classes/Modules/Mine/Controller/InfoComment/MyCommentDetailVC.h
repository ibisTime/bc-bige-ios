//
//  MyCommentDetailVC.h
//  bige
//
//  Created by 蔡卓越 on 2018/3/24.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BaseViewController.h"

@interface MyCommentDetailVC : BaseViewController
//评论编号
@property (nonatomic, copy) NSString *code;
//文章编号
@property (nonatomic, copy) NSString *articleCode;
//文章title
@property (nonatomic, copy) NSString *typeName;

@end
