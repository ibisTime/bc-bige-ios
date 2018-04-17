//
//  MyCommentModel.m
//  bige
//
//  Created by 蔡卓越 on 2018/3/24.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "MyCommentModel.h"
#import "NSString+Extension.h"

@implementation MyCommentModel

@end

@implementation ArticleInfo

- (NSArray *)pics {
    
    if (!_pics) {
        
        NSArray *imgs = [self.advPic componentsSeparatedByString:@"||"];
        NSMutableArray *newImgs = [NSMutableArray arrayWithCapacity:imgs.count];
        [imgs enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if ([obj convertImageUrl]) {
                
                [newImgs addObject:[obj convertImageUrl]];
            }
        }];
        
        _pics = newImgs;
    }
    
    return _pics;
}

@end
