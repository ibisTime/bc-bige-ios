//
//  MyCollectionTableView.h
//  bige
//
//  Created by 蔡卓越 on 2018/3/24.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "TLTableView.h"
//M
#import "MyCollectionModel.h"

@interface MyCollectionTableView : TLTableView
//
@property (nonatomic, strong) NSArray <MyCollectionModel *>*collections;

@end
