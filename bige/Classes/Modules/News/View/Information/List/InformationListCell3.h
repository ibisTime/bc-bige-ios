//
//  InformationListCell3.h
//  bige
//
//  Created by 蔡卓越 on 2018/5/14.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BaseTableViewCell.h"
//M
#import "InformationModel.h"
//V
#import "ImageLabel.h"

@interface InformationListCell3 : BaseTableViewCell
//
@property (nonatomic, strong) InformationModel *infoModel;
//分享
@property (nonatomic, strong) ImageLabel *shareLbl;

@end
