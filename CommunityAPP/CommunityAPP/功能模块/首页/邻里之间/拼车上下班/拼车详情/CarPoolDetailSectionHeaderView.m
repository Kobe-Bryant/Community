//
//  CarPoolDetailHeaderView.m
//  CommunityAPP
//
//  Created by yunlai on 14-3-18.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import "CarPoolDetailSectionHeaderView.h"
#import "Global.h"
#import "NSObject_extra.h"

@implementation CarPoolDetailSectionHeaderView

- (id)initWithFrame:(CGRect)frame section:(NSInteger)Section sectionTitle:(NSString *)titleString
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, frame.size.height)];
        headerView.backgroundColor = [UIColor whiteColor];
        headerView.layer.borderWidth = 0.5f;
        headerView.layer.borderColor = RGB(223, 223, 223).CGColor;
        [self addSubview:headerView];
        [headerView release];
        
//        UIImage *lineImage = [UIImage imageNamed:@"bg_speacter_line.png"];
//        UIImageView *lineImageView = [self newImageViewWithImage:lineImage frame:CGRectMake(0, 0, ScreenWidth, 1)];
//        [self addSubview:lineImageView];
//        [lineImageView release];
        
        UILabel *sectionLabel = [[UILabel alloc] initWithFrame:CGRectMake(15,0,100,frame.size.height)];
        sectionLabel.backgroundColor = [UIColor clearColor];
        sectionLabel.textColor=RGB(132, 132, 132);
        sectionLabel.textAlignment = NSTextAlignmentLeft;
        sectionLabel.font = [UIFont systemFontOfSize:14];
        sectionLabel.text = [NSString stringWithFormat:@"%@ 条评论",titleString];
        [headerView addSubview:sectionLabel];
        [sectionLabel release];
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
