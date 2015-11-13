//
//  MyPublishCell.m
//  CommunityAPP
//
//  Created by Dream on 14-4-2.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import "MyPublishCell.h"
#import "Global.h"
#import "NSObject_extra.h"
@implementation MyPublishCell
@synthesize iconImage =_iconImage ;
@synthesize timeLable = _timeLable;
@synthesize titleLable = _titleLable;

- (void)dealloc
{
    [_iconImage release]; _iconImage = nil;
    [_titleLable release]; _titleLable = nil;
    [_timeLable release]; _timeLable = nil;
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        // 头像 图片
        UIImage *iconImage = [UIImage imageNamed:@"middle_neighbor_car_pic.png"];
        _iconImage = [self newImageViewWithImage:iconImage frame:CGRectMake(7, 9, iconImage.size.width, iconImage.size.height)];
        
        [self addSubview:_iconImage];
        
        // 标题title
        _titleLable = [self newLabelWithText:@"郑重睡姿第一次见到呢，还没有谁家猫水试这样子睡觉的，真有意思，号啊" frame:CGRectMake(_iconImage.frame.size.width+_iconImage.frame.origin.y+5 ,5,240, 40) font:[UIFont systemFontOfSize:14.0] textColor:RGB(52, 52, 52)];
        _titleLable.numberOfLines = 2;
        _titleLable.backgroundColor = [UIColor clearColor];
        [self addSubview:_titleLable];
        
        // 时间title
        _timeLable = [self newLabelWithText:@"2014-12-20 06:30" frame:CGRectMake(190, 55,120, 20) font:[UIFont systemFontOfSize:12.0] textColor:RGB(144, 144, 144)];
        _timeLable.backgroundColor = [UIColor clearColor];
        [self addSubview:_timeLable];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
