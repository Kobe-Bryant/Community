//
//  NeiHelpCell.m
//  CommunityAPP
//
//  Created by Dream on 14-3-10.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import "NeiHelpCell.h"
#import "Global.h"
#import "NSObject_extra.h"
@implementation NeiHelpCell
@synthesize headImageView,sexImageView,questionImageView,clockImageView,commentImageView,nameLab,commentLab,clockLab,contentLab;

- (void)dealloc
{
    [headImageView release]; headImageView = nil;
    [sexImageView release]; sexImageView = nil;
    [questionImageView release]; questionImageView = nil;
    [clockImageView release]; clockImageView = nil;
    [commentImageView release]; commentImageView = nil;
    [nameLab release]; nameLab = nil;
    [commentLab release]; commentLab = nil;
    [clockLab release]; clockLab = nil;
    [contentLab release]; contentLab = nil;
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // 头像 图片
        UIImage *headImage = [UIImage imageNamed:@"default_head.png"];
        headImageView = [self newImageViewWithImage:headImage frame:CGRectMake(12, 10, headImage.size.width, headImage.size.height)];
        [self addSubview:headImageView];
        //性别图片
        UIImage *sexImage = [UIImage imageNamed:@"icon_female.png"];
        sexImageView = [self newImageViewWithImage:sexImage frame:CGRectMake(headImage.size.width+25, 10, sexImage.size.width, sexImage.size.height)];
        [self addSubview:sexImageView];
        
        // 问题类型图片
        UIImage *questionImage = [UIImage imageNamed:@"TAXI.png"];
        questionImageView = [self newImageViewWithImage:questionImage frame:CGRectMake(headImage.size.width+25, sexImage.size.height+15, questionImage.size.width, questionImage.size.height)];
        [self addSubview:questionImageView];
        
        //clock 图片
        UIImage *clockImage = [UIImage imageNamed:@"icon_time.png"];
        clockImageView = [self newImageViewWithImage:clockImage frame:CGRectMake(headImage.size.width+198, 10, clockImage.size.width, clockImage.size.height)];
        [self addSubview:clockImageView];
        //评论图片
        UIImage *commentView = [UIImage imageNamed:@"icon_comment.png"];
        commentImageView = [self newImageViewWithImage:commentView frame:CGRectMake(headImage.size.width+198, sexImage.size.height+20, commentView.size.width, commentView.size.height)];
        [self addSubview:commentImageView];
        
        // 昵称title
        nameLab = [self newLabelWithText:@"棉花糖" frame:CGRectMake(sexImageView.frame.origin.x+sexImageView.frame.size.width+4,sexImageView.frame.origin.y-4, 100, 20) font:[UIFont systemFontOfSize:15] textColor:RGB(42, 42, 42)];
        nameLab.backgroundColor = [UIColor clearColor];
        [self addSubview:nameLab];
        
        // 时间  title
        clockLab = [self newLabelWithText:@"20分钟前" frame:CGRectMake(headImage.size.width+211, 10, 80, 10) font:[UIFont systemFontOfSize:11] textColor:RGB(136, 136, 136)];
        clockLab.backgroundColor = [UIColor clearColor];
        [self addSubview:clockLab];
        //评论  title
        commentLab = [self newLabelWithText:@"14条评论" frame:CGRectMake(headImage.size.width+211, sexImage.size.height+20, 80, 10) font:[UIFont systemFontOfSize:11] textColor:RGB(136, 136, 136)];
        commentLab.backgroundColor = [UIColor clearColor];
        [self addSubview:commentLab];
        
        //上班  title
        contentLab = [self newLabelWithText:@"冯绍峰v无法如法国热隔热我发个人广泛而 个人个人个人个人各如歌如果发生法人。。。。" frame:CGRectMake(headImage.size.width+25,questionImageView.frame.origin.y+questionImageView.frame.size.height+2, 240, 50) font:[UIFont systemFontOfSize:12] textColor:RGB(80, 80, 80)];
        contentLab.backgroundColor = [UIColor clearColor];
        contentLab.numberOfLines= 0;
        [self addSubview:contentLab];

    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
