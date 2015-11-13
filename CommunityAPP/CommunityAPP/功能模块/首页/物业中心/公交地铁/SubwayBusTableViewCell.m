//
//  SubwayBusTableViewCell.m
//  CommunityAPP
//
//  Created by yunlai on 14-3-20.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import "SubwayBusTableViewCell.h"

@implementation SubwayBusTableViewCell
@synthesize iconImageView;
@synthesize nameLabel;
@synthesize stationLabel;
@synthesize distanceLabel;
-(void)dealloc{
    [iconImageView release]; iconImageView = nil;
    [nameLabel release]; nameLabel = nil;
    [stationLabel release]; stationLabel= nil;
    [distanceLabel release]; distanceLabel= nil;
    [super dealloc];
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        UIImage *backImage = [UIImage imageNamed:@"bg_List.png"];
//        UIImageView *backImageView = [[UIImageView alloc] initWithImage:
//                                backImage];
//        backImageView.frame = CGRectMake(0, 0, backImage.size.width, backImage.size.height);
//        [backImageView setBackgroundColor:[UIColor clearColor]];
//        [self addSubview:backImageView];
//        [backImageView release];
        
        UIImage *accessoryImage = [UIImage imageNamed:@"bg_arrow.png"];
        UIImageView *accessoryImageView = [[UIImageView alloc] initWithImage:accessoryImage];
        accessoryImageView.frame = CGRectMake(275, (backImage.size.height-accessoryImage.size.height)/2, accessoryImage.size.width, accessoryImage.size.height);
        [self addSubview:accessoryImageView];
        [accessoryImageView release];
        
        UIImage *iconImage = [UIImage imageNamed:@"bg_buy.png"];
        iconImageView = [[UIImageView alloc] initWithFrame:
                                      CGRectMake(10,(68-iconImage.size.height)/2, iconImage.size.width, iconImage.size.height)];
        [self addSubview:iconImageView];
        
        //名称
        nameLabel = [[UILabel alloc ]  initWithFrame:
                              CGRectMake(iconImageView.frame.origin.x+iconImageView.frame.size.width+7, 6, 210, 23)];
        nameLabel.textColor=[UIColor grayColor];
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.font=[UIFont systemFontOfSize:15];
        [self addSubview:nameLabel];
        
        //站点名称
        stationLabel = [[UILabel alloc ]  initWithFrame:
                                 CGRectMake(nameLabel.frame.origin.x,
                                            nameLabel.frame.origin.y+nameLabel.frame.size.height+1, 210, 20)];
        stationLabel.textColor=[UIColor blackColor];
        stationLabel.backgroundColor = [UIColor clearColor];
        stationLabel.font=[UIFont systemFontOfSize:16];
        [self addSubview:stationLabel];
        
        //距离
        distanceLabel = [[UILabel alloc ]  initWithFrame:
                                  CGRectMake(230,
                                             nameLabel.frame.origin.y, 60, 17)];
        distanceLabel.textColor=[UIColor grayColor];
        distanceLabel.backgroundColor = [UIColor clearColor];
        distanceLabel.font=[UIFont systemFontOfSize:15];
        [self addSubview:distanceLabel];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
