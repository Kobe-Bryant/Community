//
//  CarPoolingCell.h
//  CommunityAPP
//
//  Created by Dream on 14-3-7.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CarPoolingCell : UITableViewCell
@property(nonatomic,retain) UIImageView *headImageView;// 头像 图片
@property(nonatomic,retain) UIImageView *sexImageView;//性别图片
@property(nonatomic,retain) UIImageView *carImageView;//car类型图片
@property(nonatomic,retain) UIImageView *arriveImageView;//到达图片
@property(nonatomic,retain) UIImageView *returnImageView;//返回图片
@property(nonatomic,retain) UIImageView *clockImageView;//clock 图片
@property(nonatomic,retain) UIImageView *noticeImageView;//评论图片

@property(nonatomic,retain) UILabel *nameLable;
@property(nonatomic,retain) UILabel *carLable;
@property(nonatomic,retain) UILabel *goWorkLable;
@property(nonatomic,retain) UILabel *offWorkLable;
@property(nonatomic,retain) UILabel *timeLable;
@property(nonatomic,retain) UILabel *commentLable;
@property(nonatomic,retain) UILabel *arriveLable;
@property(nonatomic,retain) UILabel *returnLable;

@end
