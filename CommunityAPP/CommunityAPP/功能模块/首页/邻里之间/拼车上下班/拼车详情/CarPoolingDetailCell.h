//
//  CarPoolingDetailCell.h
//  CommunityAPP
//
//  Created by yunlai on 14-3-17.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TQRichTextView.h"

@interface CarPoolingDetailCell : UITableViewCell
@property(nonatomic,retain)UIButton *iconImageBtn;
@property(nonatomic,retain)UIImageView *maleImageView;
@property(nonatomic,retain)UILabel *titleLabel;
@property(nonatomic,retain)UILabel *timeLabel;
@property(nonatomic,retain)TQRichTextView *contentLabel;
@end
