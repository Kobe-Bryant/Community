//
//  ConvenienceTableViewCell.m
//  CommunityAPP
//
//  Created by yunlai on 14-4-8.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import "ConvenienceTableViewCell.h"
#import "Global.h"
#import "NSObject_extra.h"

@implementation ConvenienceTableViewCell
@synthesize iconImageView;
@synthesize titleLabel;
@synthesize addressLabel;
@synthesize disLabel;
//@synthesize starImageView;

-(void)dealloc{
    [iconImageView release];
    [titleLabel release];
    [addressLabel release];
    [disLabel release];
//    [starImageView release];
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        UIImage *defaultImage = [UIImage imageNamed:@"bg_sample_6.png"];
        iconImageView = [self newImageViewWithImage:defaultImage frame:CGRectMake(10, 12, 70, 70)];
        [self addSubview:iconImageView];

        titleLabel = [self newLabelWithText:@"和气生财" frame:CGRectMake(iconImageView.frame.origin.x+iconImageView.frame.size.width+11,iconImageView.frame.origin.y, 210, 20) font:[UIFont systemFontOfSize:15] textColor:RGB(84, 84, 84)];
        titleLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:titleLabel];
        
        addressLabel  = [self newLabelWithText:@"深南大道" frame:CGRectMake(titleLabel.frame.origin.x,titleLabel.frame.size.height+titleLabel.frame.origin.y+8, 200, 20) font:[UIFont systemFontOfSize:12] textColor:RGB(153, 153, 153)];
        addressLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:addressLabel];
        
        disLabel  = [self newLabelWithText:@"256 m" frame:CGRectMake(240,addressLabel.frame.origin.y, 70, 20) font:[UIFont systemFontOfSize:12] textColor:RGB(153, 153, 153)];
        disLabel.textAlignment  = NSTextAlignmentRight;
        disLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:disLabel];
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
