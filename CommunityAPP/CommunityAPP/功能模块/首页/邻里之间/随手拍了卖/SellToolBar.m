//
//  SellToolBar.m
//  CommunityAPP
//
//  Created by Stone on 14-3-17.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import "SellToolBar.h"

@implementation SellToolBar

@synthesize btnComment = _btnComment;
@synthesize btnTakePhotos = _btnTakePhotos;
@synthesize btnShare = _btnShare;

- (void)dealloc{
    
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        CGFloat offset = 90.0;
        
        _btnComment = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnComment.frame = CGRectMake(40, 10, 50, 40);
        [_btnComment setImage:[UIImage imageNamed:@"comments_icon.png"] forState:UIControlStateNormal];
        [self addSubview:_btnComment];
        
        _btnTakePhotos = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnTakePhotos.frame = CGRectMake(40+offset, 0, 60, 60);
        [_btnTakePhotos setImage:[UIImage imageNamed:@"pictures_icon.png"] forState:UIControlStateNormal];
        [self addSubview:_btnTakePhotos];
        
        _btnShare = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnShare.frame = CGRectMake(50+offset*2, 10, 50, 40);
        [_btnShare setImage:[UIImage imageNamed:@"share_icon.png"] forState:UIControlStateNormal];
        [self addSubview:_btnShare];
        
    }
    return self;
}



@end
