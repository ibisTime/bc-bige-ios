//
//  ForumListTableView.h
//  bige
//
//  Created by 蔡卓越 on 2018/3/13.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "TLTableView.h"
//M
#import "ForumModel.h"

@interface ForumListTableView : TLTableView
//
@property (nonatomic, strong) NSArray <ForumModel *>*forums;
//类型
@property (nonatomic, copy) NSString *postType;

@end
