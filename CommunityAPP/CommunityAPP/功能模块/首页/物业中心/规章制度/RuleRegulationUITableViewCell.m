
//
//  RuleRegulationUITableViewCell.m
//  CommunityAPP
//
//  Created by yunlai on 14-3-6.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import "RuleRegulationUITableViewCell.h"
#import "Global.h"
#import "NSObject_extra.h"

@implementation RuleRegulationUITableViewCell
@synthesize iconImageView;
@synthesize titleLabel;
@synthesize redpointLable;
@synthesize timeLabel;

-(void)dealloc{
    [titleLabel release]; titleLabel = nil;
    [iconImageView release]; iconImageView = nil;
    [redpointLable release]; redpointLable = nil;
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        UIImage *iconImage = [UIImage imageNamed:@"bg_sample_1.png"];
        iconImageView = [self newImageViewWithImage:iconImage frame:CGRectMake(17, (75-iconImage.size.height)/2, iconImage.size.width, iconImage.size.height)];
        [self addSubview:iconImageView];
        
        redpointLable = [self newLabelWithText:@"●" frame:CGRectMake(iconImageView.frame.origin.x+iconImageView.frame.size.width+8,iconImageView.frame.origin.y+5, 14, 20) font:[UIFont systemFontOfSize:20.0] textColor:[UIColor redColor]];
        [self addSubview:redpointLable];
        
        //        title
        titleLabel = [self newLabelWithText:nil frame:CGRectMake(iconImageView.frame.origin.x+iconImageView.frame.size.width+6,iconImageView.frame.origin.y+5, 235, 20) font:[UIFont systemFontOfSize:15] textColor:RGB(18, 18, 18)];
        titleLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:titleLabel];
        
        //        时间图片
        UIImage *timeImage = [UIImage imageNamed:@"icon_time.png"];
        UIImageView *timeImageView = [self newImageViewWithImage:timeImage frame:CGRectMake(iconImageView.frame.origin.x+iconImageView.frame.size.width+11, titleLabel.frame.size.height+titleLabel.frame.origin.y+12.5, timeImage.size.width, timeImage.size.height)];
        timeImageView.image = timeImage;
        [self addSubview:timeImageView];
        [timeImageView release];
        
        timeLabel  = [self newLabelWithText:nil frame:CGRectMake(timeImageView.frame.origin.x+timeImageView.frame.size.width+5,titleLabel.frame.size.height+titleLabel.frame.origin.y+7, 100, 20) font:[UIFont systemFontOfSize:12] textColor:RGB(132, 132, 132)];
        timeLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:timeLabel];

        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
