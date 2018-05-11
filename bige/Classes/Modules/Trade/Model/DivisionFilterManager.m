//
//  DivisionFilterManager.m
//  bige
//
//  Created by 蔡卓越 on 2018/5/9.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "DivisionFilterManager.h"

@implementation DivisionFilterManager

+ (instancetype)manager {
    
    static DivisionFilterManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        manager = [[DivisionFilterManager alloc] init];
    });
    return manager;
}

@end
