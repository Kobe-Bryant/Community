//
//  MyBillUITableViewCell.m
//  CommunityAPP
//
//  Created by yunlai on 14-3-12.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import "MyBillUITableViewCell.h"
#import "Global.h"

@implementation MyBillUITableViewCell
@synthesize electricMoneyLab;
@synthesize electricStateLab;
@synthesize billTitleLab;
@synthesize iconImage;

-(void)dealloc{
    [electricMoneyLab release]; electricMoneyLab = nil;
    [electricStateLab release]; electricStateLab = nil;
    [billTitleLab release]; billTitleLab = nil;
    [iconImage release]; iconImage = nil;
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        UIImage *iconImg = [UIImage imageNamed:@"icon_water.png"];
        iconImage = [[UIImageView alloc]initWithFrame:CGRectMake(15, (self.frame.size.height - iconImg.size.height)/2, iconImg.size.width, iconImg.size.height)];
        iconImage.image = iconImg;
        [self addSubview:iconImage];
        
        //图片与费用之间的竖线
        UIImage *lineImage = [UIImage imageNamed:@"bg_home_line.png"];
        UIImageView *lineImageView = [[UIImageView alloc]initWithFrame:CGRectMake(55, 5, 1, 34)];
        lineImageView.image = lineImage;
        [self addSubview:lineImageView];
        [lineImageView release];
        
        billTitleLab = [[UILabel alloc] initWithFrame:CGRectMake(lineImageView.frame.origin.x+5, 13, 150, 20)];
        billTitleLab.font = [UIFont systemFontOfSize:15.0];
        billTitleLab.backgroundColor = [UIColor clearColor];
        billTitleLab.textColor = RGB(98, 98, 98);
        billTitleLab.text = @"水费";
        [self addSubview:billTitleLab];
        
        electricMoneyLab = [[UILabel alloc] initWithFrame:CGRectMake(210, 13, 80, 20)];
        electricMoneyLab.font = [UIFont systemFontOfSize:13.0];
        electricMoneyLab.backgroundColor = [UIColor clearColor];
        electricMoneyLab.textColor = RGB(98, 98, 98);
        electricMoneyLab.text = @"¥214";
        [self addSubview:electricMoneyLab];
        
        electricStateLab = [[UILabel alloc] initWithFrame:CGRectMake(275, 13, 80, 20)];
        electricStateLab.font = [UIFont systemFontOfSize:13.0];
        electricStateLab.backgroundColor = [UIColor clearColor];
        electricStateLab.textColor = RGB(98, 98, 98);
        electricStateLab.text = @"已缴";;
        [self addSubview:electricStateLab];
 
        }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
