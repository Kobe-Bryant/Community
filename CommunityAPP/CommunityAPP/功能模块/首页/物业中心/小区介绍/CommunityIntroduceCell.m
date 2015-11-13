//
//  CommunityIntroduceCell.m
//  CommunityAPP
//
//  Created by Dream on 14-6-13.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import "CommunityIntroduceCell.h"
#import "Global.h"
#import "NSObject_extra.h"

@implementation CommunityIntroduceCell
@synthesize lable1;
@synthesize lable2;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        lable1 = [self newLabelWithText:@"名称" frame:CGRectMake(20, 10, 60, 20) font:[UIFont systemFontOfSize:15.0] textColor:RGB(51, 51, 51)];
        lable2 = [self newLabelWithText:@"你好" frame:CGRectMake(94, 10, 230, 20) font:[UIFont systemFontOfSize:15.0] textColor:RGB(102, 102, 102)];
        lable2.numberOfLines = 0;
        [self addSubview:lable1];
        [self addSubview:lable2];
        [lable1 release];
        [lable2 release];
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
