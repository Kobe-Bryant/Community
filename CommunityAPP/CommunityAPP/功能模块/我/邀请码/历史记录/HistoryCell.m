//
//  HistoryCell.m
//  CommunityAPP
//
//  Created by Dream on 14-4-3.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import "HistoryCell.h"
#import "Global.h"
#import "NSObject_extra.h"
@implementation HistoryCell
@synthesize inviteLable;
@synthesize timeLable;
@synthesize sendButton;
@synthesize numberInviteLable;

- (void)dealloc
{
    [self.inviteLable release]; self.inviteLable = nil;
    [self.numberInviteLable release]; self.numberInviteLable = nil;
    [self.timeLable release]; self.timeLable = nil;
    [self.sendButton release]; self.sendButton = nil;
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //邀请码
        self.inviteLable = [self newLabelWithText:@"邀请码：" frame:CGRectMake(20, 5, 80, 30) font:[UIFont systemFontOfSize:16.0] textColor:RGB(1, 1, 1)];
        [self addSubview:self.inviteLable];
        //邀请码号码
        self.numberInviteLable = [self newLabelWithText:@"5859595" frame:CGRectMake(self.inviteLable.frame.size.width+self.inviteLable.frame.origin.x-10, 5, 120, 30) font:[UIFont systemFontOfSize:16.0] textColor:RGB(1, 1, 1)];
        [self addSubview:self.numberInviteLable];
        
        //时间
        self.timeLable = [self newLabelWithText:@"2014-02-04 06:30" frame:CGRectMake(20, self.inviteLable.frame.size.height+self.inviteLable.frame.origin.y, 150, 10) font:[UIFont systemFontOfSize:12.0] textColor:RGB(182, 182, 182)];
        [self addSubview:self.timeLable];
        //发送button
        UIImage *sendImg = [UIImage imageNamed:@"sender_button.png"];
        self.sendButton = [self newButtonWithImage:sendImg highlightedImage:nil frame:CGRectMake(240, 11, sendImg.size.width, sendImg.size.height) title:@"发送" titleColor:RGB(255, 255, 255) titleShadowColor:nil font:[UIFont systemFontOfSize:18.0] target:self action:nil];
        [self addSubview:self.sendButton];
        
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
