//
//  SubwayBuysTableViewSection.m
//  CommunityAPP
//
//  Created by yunlai on 14-3-7.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import "SubwayBuysTableViewSection.h"
#import "NSObject_extra.h"
#import "Global.h"

@implementation SubwayBuysTableViewSection

- (id)initWithFrame:(CGRect)frame section:(NSInteger)Section labelTitle:(NSString *)titleString;
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UILabel *sectionLabel = [[UILabel alloc] initWithFrame:CGRectMake(5,0,90,frame.size.height)];
        sectionLabel.backgroundColor = [UIColor clearColor];
        sectionLabel.textColor= RGB(153, 153, 153);
        sectionLabel.textAlignment = NSTextAlignmentLeft;
        sectionLabel.font = [UIFont systemFontOfSize:13];
        sectionLabel.text = titleString;
        [self addSubview:sectionLabel];
        [sectionLabel release];
        
        UIImage *sectionImage = [UIImage imageNamed:@"bg_buy_line1.png"];
        UIImageView *sectionImageView= [[UIImageView alloc] initWithFrame:CGRectMake(sectionLabel.frame.size.width+sectionLabel.frame.origin.x, 9, sectionImage.size.width,1)];
        sectionImageView.image = sectionImage;
        [self addSubview:sectionImageView];
        [sectionImageView release];
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
