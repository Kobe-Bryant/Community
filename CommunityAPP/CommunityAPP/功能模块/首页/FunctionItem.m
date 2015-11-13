//
//  FunctionItem.m
//  CommunityAPP
//
//  Created by Stone on 14-5-23.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import "FunctionItem.h"
#import "Global.h"
#import "UIView+Badge.h"

@implementation FunctionItem

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        _btnItem = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnItem.frame = CGRectMake(0,0, 67, 67);
        _btnItem.badge.badgeColor = [UIColor redColor];
        _btnItem.badge.transform = CGAffineTransformMakeTranslation(-8.0, 8.0);
        _btnItem.badge.outlineWidth = 0.0;
        _btnItem.badge.outlineColor = [UIColor clearColor];
        //[_item setImage:[UIImage imageNamed:[typeArray objectAtIndex:i]] forState:UIControlStateNormal];
        //[_item addTarget:self action:@selector(btnDetailAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_btnItem];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 67, 67, 20)];
        _titleLabel.font = [UIFont systemFontOfSize:12];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = RGB(102, 102, 102);
        [_titleLabel setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_titleLabel];
        [_titleLabel release];

        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
