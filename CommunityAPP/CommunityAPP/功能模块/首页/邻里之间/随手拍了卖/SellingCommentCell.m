//
//  SellingCommentCell.m
//  CommunityAPP
//
//  Created by Stone on 14-3-19.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import "SellingCommentCell.h"
#import "NSObject_extra.h"
#import "AuctionCommentModel.h"
#import "Common.h"

@implementation SellingCommentCell
@synthesize iconImageBtn;
@synthesize maleImageView;
@synthesize titleLabel;
@synthesize timeLabel;
@synthesize contentLabel;
@synthesize commentModel = _commentModel;

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
        //                图片icon
        UIImage *iconImage = [UIImage imageNamed:@"selling_2.png"];
        iconImageBtn= [self newButtonWithImage:iconImage highlightedImage:nil frame:CGRectMake(12, (65-iconImage.size.height)/2, 45, 45) title:nil titleColor:nil titleShadowColor:nil font:nil target:self action:nil];
        iconImageBtn.layer.cornerRadius = 22.5;
        iconImageBtn.layer.masksToBounds = YES;
        [self addSubview:iconImageBtn];
        
        //                性别男女
        UIImage *maleImage = [UIImage imageNamed:@"icon_male1.png"];
        maleImageView = [self newImageViewWithImage:nil frame:CGRectMake(iconImageBtn.frame.size.width+iconImageBtn.frame.origin.x+14, iconImageBtn.frame.origin.y+7, maleImage.size.width, maleImage.size.height)];
        [self addSubview:maleImageView];
        
        //                名称
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(maleImageView.frame.size.width+maleImageView.frame.origin.x+4, maleImageView.frame.origin.y-2, 140, maleImageView.frame.size.height+4)];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:titleLabel];
        
        //                 时间
        UIImage *timeImage = [UIImage imageNamed:@"icon_time.png"];
        UIImageView *timeImageView = [self newImageViewWithImage:timeImage frame:CGRectMake(260, titleLabel.frame.origin.y, timeImage.size.width, timeImage.size.height)];
        [self addSubview:timeImageView];
        [timeImageView release];
        
        // 时间内容
        timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(timeImageView.frame.size.width+timeImageView.frame.origin.x+4, timeImageView.frame.origin.y-2, 140, timeImage.size.height+4)];
        timeLabel.textColor = [UIColor grayColor];
        timeLabel.textAlignment = NSTextAlignmentLeft;
        timeLabel.backgroundColor = [UIColor clearColor];
        timeLabel.font = [UIFont systemFontOfSize:11];
        [self addSubview:timeLabel];
        
        
        //     内容
        contentLabel = [[TQRichTextView alloc] initWithFrame:CGRectMake(maleImageView.frame.origin.x, titleLabel.frame.origin.y+titleLabel.frame.size.height+4, 140, 20)];
        contentLabel.font = [UIFont systemFontOfSize:14.0];
        contentLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:contentLabel];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)setCommentModel:(AuctionCommentModel *)commentModel{
    if (_commentModel != commentModel) {
        [_commentModel release];
        _commentModel = [commentModel retain];
    }
//    if ([_commentModel.residentSex isEqualToString:@"男"]) {
//        maleImageView.image = [UIImage imageNamed:@"icon_male.png"];
//    }else if ([_commentModel.residentSex isEqualToString:@"女"]){
//        maleImageView.image = [UIImage imageNamed:@"icon_female.png"];
//    }
//    contentLabel.text = _commentModel.remark;
//    timeLabel.text = [Common intervalSinceNow:_commentModel.createTime];
//    titleLabel.text = _commentModel.residentName;
    
}

@end
