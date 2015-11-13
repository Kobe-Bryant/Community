//
//  LiveEncyclopediaCell.m
//  CommunityAPP
//
//  Created by Dream on 14-3-17.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import "LiveEncyclopediaCell.h"
#import "Global.h"
#import "NSObject_extra.h"

@implementation LiveEncyclopediaButton



@end

@implementation LiveEncyclopediaCell
@synthesize titleLable = _titleLable;
@synthesize subTitleLable = _subTitleLable;
@synthesize contentImg = _contentImg;
@synthesize contentTextView = _contentTextView;
@synthesize commentImg = _commentImg;
@synthesize  loveBtn = _loveBtn;
@synthesize commentLable = _commentLable;
@synthesize loveLable = _loveLable;
@synthesize backImg = _backImg;
@synthesize countLable = _countLable;
@synthesize subTitleTypeLable = _subTitleTypeLable;
@synthesize backsBtn = _backsBtn;
@synthesize commentBtn = _commentBtn;


- (void)dealloc
{
    [_titleLable release]; _titleLable = nil;
    [_subTitleTypeLable release]; _subTitleTypeLable = nil;
    [_subTitleLable release]; _subTitleLable = nil;
    [_contentImg release]; _contentImg = nil;
    [_contentTextView release]; _contentTextView = nil;
    [_commentImg release]; _commentImg = nil;
    [_loveBtn release]; _loveBtn = nil;
    [_commentLable release]; _commentLable = nil;
    [_loveLable release]; _loveLable = nil;
    [_backImg release]; _backImg = nil;
    [super dealloc];
}

- (void) layoutSubviews {
    [super layoutSubviews];
    self.backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    self.backgroundView.frame = CGRectMake(0,0, 300.0,300.0);
    self.contentView.frame =CGRectMake(0, 0, 300.0, 300.0);
    self.backgroundView.backgroundColor = [UIColor whiteColor];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        //标题
        _titleLable = [self newLabelWithText:@"掌握几个时段规律护肤效果最好" frame:CGRectMake(10,12, 300, 19) font:[UIFont systemFontOfSize:15] textColor:RGB(51, 51, 51)];
        _titleLable.backgroundColor = [UIColor clearColor];
        [self addSubview:_titleLable];
        
        //副标题
        _subTitleTypeLable = [self newLabelWithText:@"美容" frame:CGRectMake(10,_titleLable.frame.size.height+_titleLable.frame.origin.y+1, 35, 17) font:[UIFont systemFontOfSize:12] textColor:RGB(153, 153, 153)];
        _subTitleLable.backgroundColor = [UIColor clearColor];
        [self addSubview:_subTitleTypeLable];
    
        _subTitleLable = [self newLabelWithText:@"2014-02-04 06：30" frame:CGRectMake(_subTitleTypeLable.frame.size.width +_subTitleTypeLable.frame.origin.x ,_titleLable.frame.size.height+_titleLable.frame.origin.y+1, 300, 17) font:[UIFont systemFontOfSize:12] textColor:RGB(153, 153, 153)];
        _subTitleLable.backgroundColor = [UIColor clearColor];
        [self addSubview:_subTitleLable];
        
        // 内容图片
        UIImage *headImage = [UIImage imageNamed:@"bg_sample_3.png"];
        _contentImg = [self newImageViewWithImage:headImage frame:CGRectMake(10, _subTitleLable.frame.size.height+_subTitleLable.frame.origin.y+8, 280, 160)];
        [self addSubview:_contentImg];
        
        //内容详情
        _contentTextView = [[UILabel alloc]initWithFrame:CGRectMake(10, _contentImg.frame.size.height+_contentImg.frame.origin.y-2, 290, 50)];
        _contentTextView.textColor = RGB(90, 90, 90);
        _contentTextView.font = [UIFont systemFontOfSize:13.0];
        _contentTextView.numberOfLines = 2;
        _contentTextView.text = @"详情字段";
        [self addSubview:_contentTextView];
        
        //底部横条
       UIImage *backImage = [UIImage imageNamed:@"bounds.life.png"];
        _backsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _backsBtn.frame = CGRectMake(0,300-backImage.size.height, backImage.size.width, backImage.size.height);
        [_backsBtn setImage:nil forState:UIControlStateDisabled];
        [_backsBtn setBackgroundColor:RGB(241, 241, 241)];
        [self addSubview:_backsBtn];
        
        //评论图片
        UIImage *commentImage = [UIImage imageNamed:@"icon_life_message.png"];
        _commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _commentBtn.frame = CGRectMake(8,7, commentImage.size.width, commentImage.size.height);
        [_commentBtn setImage:commentImage forState:UIControlStateNormal];
        [_commentBtn addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
        [_backsBtn addSubview:_commentBtn];
        
        //评论
        _commentLable = [self newLabelWithText:@"1793" frame:CGRectMake(_commentBtn.frame.size.width+_commentBtn.frame.origin.x+1,8, 50, 20) font:[UIFont systemFontOfSize:12] textColor:RGB(153, 153, 153)];
        _commentLable.backgroundColor = [UIColor clearColor];
        [_backsBtn addSubview:_commentLable];
        
        //点赞图片
        //UIImage *loveImage = [UIImage imageNamed:@"icon_life_like.png"];
        UIImage *normalImage = [UIImage imageNamed:@"icon_life_like_normal.png"];
        UIImage *selectedImage = [UIImage imageNamed:@"icon_life_like_click.png"];
        _loveBtn = [LiveEncyclopediaButton buttonWithType:UIButtonTypeCustom];
        _loveBtn.frame = CGRectMake(70,7, normalImage.size.width, normalImage.size.height);
        [_loveBtn setImage:normalImage forState:UIControlStateNormal];
        [_loveBtn setImage:selectedImage forState:UIControlStateSelected];
        [_backsBtn addSubview:_loveBtn];
        
        //点赞
        _loveLable = [[UILabel alloc]initWithFrame:CGRectMake(_loveBtn.frame.size.width+_loveBtn.frame.origin.x+5,8, 50, 20)];
        _loveLable.text = @"0";
        _loveLable.font = [UIFont systemFontOfSize:12];
        _loveLable.textColor = RGB(153, 153, 153);
        _loveLable.backgroundColor = [UIColor clearColor];
        [_backsBtn addSubview:_loveLable];

    }
    return self;
}

- (void)setLiveModel:(LiveEncyclopediaModel *)liveModel{
    if (liveModel == _liveModel) {
        [_liveModel release];
        _liveModel = [liveModel retain];
    }
    self.loveBtn.liveModel = _liveModel;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
