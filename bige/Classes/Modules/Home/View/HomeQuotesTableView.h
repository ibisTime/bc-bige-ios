//
//  HomeQuotesTableView.h
//  bige
//
//  Created by 蔡卓越 on 2018/5/2.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "TLTableView.h"
//M
#import "PlatformModel.h"

@interface HomeQuotesTableView : TLTableView
//
@property (nonatomic, strong) NSArray <PlatformModel *>*platforms;

@end
