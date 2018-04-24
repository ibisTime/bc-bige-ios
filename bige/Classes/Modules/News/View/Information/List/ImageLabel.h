//
//  ImageLabel.h
//  bige
//
//  Created by 蔡卓越 on 2018/4/24.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BaseView.h"

@interface ImageLabel : BaseView
//icon
@property (nonatomic, strong) UIImageView *iconIV;
//text
@property (nonatomic, strong) UILabel *textLbl;
//图片和文字的间距
@property (nonatomic, assign) CGFloat margin;

@end
