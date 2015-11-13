//
//  NoticeTableViewCell.h
//  CommunityAPP
//
//  Created by yunlai on 14-3-5.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NoticeTableViewCell : UITableViewCell
@property(nonatomic,retain) UIImageView *iconImageView;
@property(nonatomic,retain) UILabel *redpointLable;
@property(nonatomic,retain)  UILabel *titleLabel;
@property(nonatomic,retain) UILabel *fromLabel;
@property(nonatomic,retain) UILabel *timeLabel;
@end
