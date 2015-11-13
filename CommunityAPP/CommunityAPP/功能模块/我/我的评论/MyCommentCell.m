//
//  MyCommentCell.m
//  CommunityAPP
//
//  Created by Dream on 14-3-18.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import "MyCommentCell.h"
#import "Global.h"
#import "NSObject_extra.h"
@implementation MyCommentCell
@synthesize headerImg = _headerImg;
@synthesize nameLable = _nameLable;
@synthesize timeLable = _timeLable;
@synthesize contentLable = _contentLable;
@synthesize commentTypeImg = _commentTypeImg;

- (void)dealloc
{
    [_headerImg release]; _headerImg = nil;
    [_nameLable release]; _nameLable = nil;
    [_timeLable release]; _timeLable = nil;
    [_contentLable release]; _contentLable = nil;
    [_commentTypeImg release]; _commentTypeImg = nil;
    [super dealloc];
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        // 头像 图片
        UIImage *headImage = [UIImage imageNamed:@"diqiu.png"];
        _headerImg = [self newImageViewWithImage:headImage frame:CGRectMake(15, 7, headImage.size.width, headImage.size.height)];
        
        _headerImg.layer.cornerRadius = 17.0;
        _headerImg.layer.masksToBounds = YES;
        [self addSubview:_headerImg];

        // 昵称title
        _nameLable = [self newLabelWithText:@"District 7" frame:CGRectMake(_headerImg.frame.origin.x+_headerImg.frame.size.width+7,15, 100, 20) font:[UIFont systemFontOfSize:15] textColor:RGB(42, 42, 42)];
        _nameLable.backgroundColor = [UIColor clearColor];
        [self addSubview:_nameLable];
        
        //评论类型图片
        UIImage *commentTypeImage = [UIImage imageNamed:@"small_neighbor_car_pic.png"];
        _commentTypeImg = [self newImageViewWithImage:commentTypeImage frame:CGRectMake(285, 18, commentTypeImage.size.width, commentTypeImage.size.height)];
        [self addSubview:_commentTypeImg];
        
        // 内容title
        _contentLable= [[TQRichTextView alloc]initWithFrame:CGRectMake(17,_headerImg.frame.origin.y+_headerImg.frame.size.height+5, 300, 20)];
        _contentLable.font = [UIFont systemFontOfSize:15.0];
        _contentLable.backgroundColor = [UIColor clearColor];
        _contentLable.lineSpacing = 2.0f;
        [self addSubview:_contentLable];

        // 时间title
        _timeLable = [self newLabelWithText:@"2014-12-20 06:30" frame:CGRectMake(100, 70,120, 20) font:[UIFont systemFontOfSize:12] textColor:RGB(144, 144, 144)];
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
