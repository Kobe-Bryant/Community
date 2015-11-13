//
//  NoticeTableViewCell.m
//  CommunityAPP
//
//  Created by yunlai on 14-3-5.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import "NoticeTableViewCell.h"
#import "NSObject_extra.h"
#import "Global.h"
#import "NOticeModel.h"
@implementation NoticeTableViewCell
@synthesize iconImageView;
@synthesize titleLabel;
@synthesize fromLabel;
@synthesize timeLabel;
@synthesize redpointLable;

-(void)dealloc{
    [timeLabel release]; timeLabel = nil;
    [fromLabel release];  fromLabel = nil;
    [titleLabel release]; titleLabel = nil;
    [iconImageView release]; iconImageView = nil;
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        //        图片
        UIImage *iconImage = [UIImage imageNamed:@"notice_icon.png"];
        iconImageView = [self newImageViewWithImage:iconImage frame:CGRectMake(17, 10, iconImage.size.width, iconImage.size.height)];
        [self addSubview:iconImageView];

        redpointLable = [self newLabelWithText:@"●" frame:CGRectMake(iconImageView.frame.origin.x+iconImageView.frame.size.width+8,iconImageView.frame.origin.y, 14, 20) font:[UIFont systemFontOfSize:20.0] textColor:[UIColor redColor]];
            [self addSubview:redpointLable];
            
            //        title
        titleLabel = [self newLabelWithText:@"尊敬的客户：根据广东省物价局" frame:CGRectMake(iconImageView.frame.origin.x+iconImageView.frame.size.width+21,iconImageView.frame.origin.y, 235, 20) font:[UIFont boldSystemFontOfSize:15] textColor:RGB(69, 69, 69)];
            titleLabel.backgroundColor = [UIColor clearColor];
            [self addSubview:titleLabel];
      //  }
      
        
//        fromLabel = [[UILabel alloc]initWithFrame:CGRectMake(iconImageView.frame.origin.x+iconImageView.frame.size.width+9, titleLabel.frame.size.height+titleLabel.frame.origin.y+4, 150, 20)];
//        fromLabel.backgroundColor = [UIColor clearColor];
//        fromLabel.text = @"管理处";
//        fromLabel.textColor = RGB(126, 126, 126);
//        [fromLabel setFont:[UIFont systemFontOfSize:13]];
//        [self addSubview:fromLabel];
        
//        时间图片
        UIImage *timeImage = [UIImage imageNamed:@"icon_time.png"];
        UIImageView *timeImageView = [self newImageViewWithImage:timeImage frame:CGRectMake(iconImageView.frame.origin.x+iconImageView.frame.size.width+11, titleLabel.frame.size.height+titleLabel.frame.origin.y+10.5, timeImage.size.width, timeImage.size.height)];
        timeImageView.image = timeImage;
        [self addSubview:timeImageView];
        [timeImageView release];
        
        timeLabel  = [self newLabelWithText:@"2小时前" frame:CGRectMake(timeImageView.frame.origin.x+timeImageView.frame.size.width+5,titleLabel.frame.size.height+titleLabel.frame.origin.y+5, 100, 20) font:[UIFont systemFontOfSize:12] textColor:RGB(132, 132, 132)];
        timeLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:timeLabel];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
    
//    titleLabel = [self newLabelWithText:@"尊敬的客户：根据广东省物价局" frame:CGRectMake(iconImageView.frame.origin.x+iconImageView.frame.size.width+8,iconImageView.frame.origin.y, 235, 20) font:[UIFont systemFontOfSize:15] textColor:RGB(18, 18, 18)];
//    titleLabel.backgroundColor = [UIColor clearColor];
//    [self addSubview:titleLabel];
}

@end
