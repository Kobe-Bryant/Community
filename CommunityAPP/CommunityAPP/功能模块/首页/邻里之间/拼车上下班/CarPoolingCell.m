//
//  CarPoolingCell.m
//  CommunityAPP
//
//  Created by Dream on 14-3-7.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import "CarPoolingCell.h"
#import "NSObject_extra.h"
#import "Global.h"
@implementation CarPoolingCell
@synthesize headImageView,sexImageView,carImageView,arriveImageView,returnImageView,clockImageView,noticeImageView;
@synthesize nameLable,carLable,goWorkLable,offWorkLable,timeLable,commentLable,arriveLable,returnLable;

- (void)dealloc
{
    [headImageView release]; headImageView = nil;
    [sexImageView release]; sexImageView = nil;
    [carImageView release]; carImageView = nil;
    [arriveImageView release]; arriveImageView = nil;
    [returnImageView release]; returnImageView = nil;
    [clockImageView release]; clockImageView = nil;
    [noticeImageView release]; noticeImageView = nil;
    [nameLable release]; nameLable = nil;
    [carLable release]; carLable = nil;
    [goWorkLable release]; goWorkLable = nil;
    [offWorkLable release]; offWorkLable = nil;
    [timeLable release]; timeLable = nil;
    [commentLable release]; commentLable = nil;
    [arriveLable release]; arriveLable = nil;
    [returnLable release]; returnLable = nil;
    [super dealloc];
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // 头像 图片
        UIImage *headImage = [UIImage imageNamed:@"default_head.png"];
        
//        headImageView = [self newButtonWithImage:headImage highlightedImage:nil frame:CGRectMake(12, 10, headImage.size.width, headImage.size.height) title:nil titleColor:nil titleShadowColor:nil font:nil target:self action:nil];
//        
//        headImageView.layer.cornerRadius = 25.0f;
//        headImageView.layer.masksToBounds = YES;
//        [self addSubview:headImageView];
        
        headImageView = [self newImageViewWithImage:headImage frame:CGRectMake(11, 11, headImage.size.width, headImage.size.height)];
        headImageView.layer.cornerRadius = 25.0f;
        headImageView.layer.masksToBounds = YES;
        [self addSubview:headImageView];
        
        //性别图片
        UIImage *sexImage = [UIImage imageNamed:@"icon_female1.png"];
        sexImageView = [self newImageViewWithImage:sexImage frame:CGRectMake(headImage.size.width+26, 10, sexImage.size.width, sexImage.size.height)];
        [self addSubview:sexImageView];
        //car类型图片
        UIImage *carImage = [UIImage imageNamed:@"TAXI1.png"];
        carImageView = [self newImageViewWithImage:carImage frame:CGRectMake(headImage.size.width+26, sexImage.size.height+17, carImage.size.width, carImage.size.height)];
        [self addSubview:carImageView];
        //clock 图片
        UIImage *clockImage = [UIImage imageNamed:@"icon_time.png"];
        clockImageView = [self newImageViewWithImage:clockImage frame:CGRectMake(headImage.size.width+198, 10, clockImage.size.width, clockImage.size.height)];
        [self addSubview:clockImageView];
        //评论图片
        UIImage *noticeView = [UIImage imageNamed:@"icon_comment.png"];
        noticeImageView = [self newImageViewWithImage:noticeView frame:CGRectMake(headImage.size.width+198, sexImage.size.height+17, noticeView.size.width, noticeView.size.height)];
        [self addSubview:noticeImageView];
        //到达图片
        UIImage *arriveView = [UIImage imageNamed:@"to_color.png"];
        arriveImageView = [self newImageViewWithImage:arriveView frame:CGRectMake(headImage.size.width+140, carImageView.frame.origin.y+carImageView.frame.size.height+8, arriveView.size.width, arriveView.size.height)];
        [self addSubview:arriveImageView];
        //返回图片
        UIImage *returnView = [UIImage imageNamed:@"back_color.png"];
        returnImageView = [self newImageViewWithImage:returnView frame:CGRectMake(headImage.size.width+140, carImageView.frame.origin.y+carImageView.frame.size.height+25, returnView.size.width, returnView.size.height)];
        [self addSubview:returnImageView];
        
        // 昵称title
        nameLable = [self newLabelWithText:@"哈哈" frame:CGRectMake(sexImageView.frame.origin.x+sexImageView.frame.size.width+4,sexImageView.frame.origin.y-3, 100, 20) font:[UIFont systemFontOfSize:16] textColor:RGB(84, 84, 84)];
        nameLable.backgroundColor = [UIColor clearColor];
        [self addSubview:nameLable];
        //car   title   add by devin
//        carLable = [self newLabelWithText:@"1221133" frame:CGRectMake(carImageView.frame.origin.x+carImageView.frame.size.width+5,carImageView.frame.origin.y-4, 100, 20) font:[UIFont systemFontOfSize:12] textColor:RGB(80, 80, 80)];
//        carLable.backgroundColor = [UIColor clearColor];
//        [self addSubview:carLable];
        //上班  title
        goWorkLable = [self newLabelWithText:@"上班" frame:CGRectMake(headImage.size.width+26,carImageView.frame.origin.y+carImageView.frame.size.height+2, 200, 20) font:[UIFont systemFontOfSize:13] textColor:RGB(102, 102, 102)];
        goWorkLable.backgroundColor = [UIColor clearColor];
        [self addSubview:goWorkLable];
        //下班  title
        offWorkLable = [self newLabelWithText:@"下班" frame:CGRectMake(headImage.size.width+26,carImageView.frame.origin.y+carImageView.frame.size.height+23, 200, 20) font:[UIFont systemFontOfSize:13] textColor:RGB(102, 102, 102)];
        offWorkLable.backgroundColor = [UIColor clearColor];
        [self addSubview:offWorkLable];
        // 时间  title
        timeLable = [self newLabelWithText:@"多少时间前" frame:CGRectMake(headImage.size.width+210, 10, 80, clockImageView.frame.size.height) font:[UIFont systemFontOfSize:11] textColor:RGB(153, 153, 153)];
        timeLable.backgroundColor = [UIColor clearColor];
        [self addSubview:timeLable];
        //评论  title
        commentLable = [self newLabelWithText:@"评论" frame:CGRectMake(timeLable.frame.origin.x, noticeImageView.frame.origin.y, 80, noticeImageView.frame.size.height) font:[UIFont systemFontOfSize:11] textColor:RGB(153, 153, 153)];
        commentLable.backgroundColor = [UIColor clearColor];
        [self addSubview:commentLable];
        
        //到达  title
        arriveLable = [self newLabelWithText:@"到达" frame:CGRectMake(headImage.size.width+160,carImageView.frame.origin.y+carImageView.frame.size.height+7, 150, arriveImageView.frame.size.height) font:[UIFont systemFontOfSize:13] textColor:RGB(102, 102, 102)];
        arriveLable.backgroundColor = [UIColor clearColor];
        [self addSubview:arriveLable];
        
        //返回  title
        returnLable = [self newLabelWithText:@"返回" frame:CGRectMake(headImage.size.width+160,returnImageView.frame.origin.y, 150, arriveImageView.frame.size.height) font:[UIFont systemFontOfSize:13] textColor:RGB(102, 102, 102)];
        returnLable.backgroundColor = [UIColor clearColor];
        [self addSubview:returnLable];

    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
