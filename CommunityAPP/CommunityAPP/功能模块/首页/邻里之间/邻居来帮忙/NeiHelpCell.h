//
//  NeiHelpCell.h
//  CommunityAPP
//
//  Created by Dream on 14-3-10.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NeiHelpCell : UITableViewCell

@property (nonatomic,retain) UIImageView *headImageView;//头像
@property (nonatomic,retain) UIImageView *sexImageView;//性别
@property (nonatomic,retain) UIImageView *questionImageView;
@property (nonatomic,retain) UIImageView *clockImageView; //时间图像
@property (nonatomic,retain) UIImageView *commentImageView;//评论图片

@property (nonatomic,retain) UILabel *nameLab;//名字
@property (nonatomic,retain) UILabel *commentLab;//评论
@property (nonatomic,retain) UILabel *clockLab;//时间
@property (nonatomic,retain) UILabel *contentLab;//内容

@end
