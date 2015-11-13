//
//  CarPoolingDetailCell.m
//  CommunityAPP
//
//  Created by yunlai on 14-3-17.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import "CarPoolingDetailCell.h"
#import "NSObject_extra.h"
#import "TQRichTextView.h"
#import "Global.h"

@implementation CarPoolingDetailCell
@synthesize iconImageBtn;
@synthesize maleImageView;
@synthesize titleLabel;
@synthesize timeLabel;
@synthesize contentLabel;

-(void)dealloc{
    [maleImageView release]; maleImageView= nil;
    [titleLabel release]; titleLabel = nil;
    [timeLabel release]; timeLabel= nil;
    [contentLabel release]; contentLabel= nil;
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        // 图片 
        //  图片icon
        UIImage *iconImage = [UIImage imageNamed:@"notice_icon.png"];
        iconImageBtn= [self newButtonWithImage:iconImage highlightedImage:nil frame:CGRectMake(12, (65-iconImage.size.height)/2, iconImage.size.width, iconImage.size.height) title:nil titleColor:nil titleShadowColor:nil font:nil target:self action:nil];
        iconImageBtn.layer.cornerRadius = 22.5f;
        iconImageBtn.layer.masksToBounds = YES;
        [self addSubview:iconImageBtn];

        //                性别男女
        UIImage *maleImage = [UIImage imageNamed:@"icon_male1.png"];
        maleImageView = [self newImageViewWithImage:maleImage frame:CGRectMake(iconImageBtn.frame.size.width+iconImageBtn.frame.origin.x+14, iconImageBtn.frame.origin.y+7, maleImage.size.width, maleImage.size.height)];
        [self addSubview:maleImageView];
        
        //                名称
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(maleImageView.frame.size.width+maleImageView.frame.origin.x+4, maleImageView.frame.origin.y-2, 140, maleImageView.frame.size.height+4)];
        titleLabel.text = @"二货";
        titleLabel.textColor = RGB(51, 51, 51);
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = [UIFont systemFontOfSize:15.0];
        [self addSubview:titleLabel];
        
        //                 时间
        UIImage *timeImage = [UIImage imageNamed:@"icon_time.png"];
        UIImageView *timeImageView = [self newImageViewWithImage:timeImage frame:CGRectMake(260, titleLabel.frame.origin.y, timeImage.size.width, timeImage.size.height)];
        [self addSubview:timeImageView];
        [timeImageView release];
        
        // 时间内容
        timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(timeImageView.frame.size.width+timeImageView.frame.origin.x+2, timeImageView.frame.origin.y-2, 140, timeImage.size.height+4)];
        timeLabel.text = @"28分钟前";
        timeLabel.textColor = RGB(153, 153, 153);
        timeLabel.textAlignment = NSTextAlignmentLeft;
        timeLabel.backgroundColor = [UIColor clearColor];
        timeLabel.font = [UIFont systemFontOfSize:11];
        [self addSubview:timeLabel];
        
        
        contentLabel= [[TQRichTextView alloc]initWithFrame:CGRectMake(maleImageView.frame.origin.x, titleLabel.frame.origin.y+titleLabel.frame.size.height+4, 250, 20)];
        contentLabel.textColor = RGB(102, 102, 102);
        contentLabel.font = [UIFont systemFontOfSize:14.0];
        contentLabel.backgroundColor = [UIColor clearColor];
        contentLabel.lineSpacing = 2.0f;
       
        [self addSubview:contentLabel];
        
        //     内容
//        contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(maleImageView.frame.origin.x, titleLabel.frame.origin.y+titleLabel.frame.size.height+4, 250, 20)];
//        contentLabel.text = @"有用，每天都用。。。";
//        contentLabel.textAlignment = NSTextAlignmentLeft;
//        contentLabel.backgroundColor = [UIColor clearColor];
//        contentLabel.textColor = [UIColor grayColor];
//        contentLabel.font = [UIFont systemFontOfSize:14.0];
//        [self addSubview:contentLabel];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
