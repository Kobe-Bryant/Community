//
//  SubCollectionCellView.m
//  CommunityAPP
//
//  Created by yunlai on 14-4-20.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//
#import "SubCollectionCellView.h"
#import "Global.h"

@implementation SubCollectionCellView

@synthesize iconImageView;
@synthesize titleNameLabel;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubCollectionCellView];
    }
    return self;
}

-(void) initSubCollectionCellView
{
    self.userInteractionEnabled = YES;
    self.backgroundColor = [UIColor clearColor];
    iconImageView = [[UIImageView alloc] init];
    iconImageView.image = [UIImage imageNamed:@"bg_sample_5.png"];
    [iconImageView setFrame:CGRectMake(0, 0, 160, 110)];
    [self addSubview:iconImageView];
    
        //名称
    titleNameLabel = [[UILabel alloc ]initWithFrame:
                          CGRectMake(0, iconImageView.frame.size.height
                                     +iconImageView.frame.origin.y+10, 160, 22)];
    titleNameLabel.text = @"iphone6";
    titleNameLabel.textAlignment = NSTextAlignmentCenter;
    titleNameLabel.textColor = RGB(53, 53, 53);
    titleNameLabel.backgroundColor = [UIColor clearColor];
    titleNameLabel.font=[UIFont systemFontOfSize:14];
    [self addSubview:titleNameLabel];
}


- (void)dealloc
{
    [iconImageView release];
    [titleNameLabel release];
    [super dealloc];
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
