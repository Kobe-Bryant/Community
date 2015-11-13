//
//  PushNotificationCell.m
//  CommunityAPP
//
//  Created by Stone on 14-6-19.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import "PushNotificationCell.h"

@implementation PushNotificationCell

- (void)dealloc{
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self initNoticeSwitch];
    }
    return self;
}

- (void)initNoticeSwitch{
    self.noticeSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(250, 6, 60, 25)];
    self.noticeSwitch.on = YES;
    [self addSubview:self.noticeSwitch];
    [self.noticeSwitch release];
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
