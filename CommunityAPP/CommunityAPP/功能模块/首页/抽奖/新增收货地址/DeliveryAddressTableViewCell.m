//
//  DeliveryAddressTableViewCell.m
//  CommunityAPP
//
//  Created by yunlai on 14-4-22.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import "DeliveryAddressTableViewCell.h"
#import "Global.h"

@implementation DeliveryAddressTableViewCell
@synthesize iconImageView;
@synthesize nameLabel;
@synthesize contentLabel;
@synthesize detailbtn;

-(void)dealloc{
    [contentLabel release];
    [nameLabel release];
    [iconImageView release];
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        UIImage *iconImage = [UIImage imageNamed:@"bg_awardView_selectedAdress.png"];
        iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, (70-iconImage.size.height)/2, iconImage.size.width, iconImage.size.height)];
        iconImageView.image = iconImage;
        [self addSubview:iconImageView];
        
        //名称
        nameLabel = [[UILabel alloc ]  initWithFrame:
                              CGRectMake(iconImageView.frame.size.width+iconImageView.frame.origin.x+10, 5, 210, 22)];
        nameLabel.text = @"旺财";
        nameLabel.textColor = RGB(53, 53, 53);
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.font=[UIFont systemFontOfSize:15.0];
        [self addSubview:nameLabel];
        
        //      时间
        contentLabel = [[UILabel alloc ]  initWithFrame:
                                 CGRectMake(nameLabel.frame.origin.x, nameLabel.frame.size.height+nameLabel.frame.origin.y+2, 230, 36)];
        contentLabel.text = @"这是一条测试数据，这是一条测试数据，这是一条测试数据，这是一条测试数据，这是一条测试数据，这是一条测试数据，这是一条测试数据，这是一条测试数据，";
        contentLabel.numberOfLines = 2;
        contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
        contentLabel.textColor = [UIColor grayColor];
        contentLabel.backgroundColor = [UIColor clearColor];
        contentLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:contentLabel];
        
        UIImage *detailImage = [UIImage imageNamed:@"bg_awardView_detail.png"];
        detailbtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [detailbtn setImage:detailImage forState:UIControlStateNormal];
//        [detailbtn addTarget:self action:@selector(backBtnAction) forControlEvents:UIControlEventTouchUpInside];
        detailbtn.frame = CGRectMake(289, (70-detailImage.size.height)/2, detailImage.size.width, detailImage.size.height);
        [self addSubview:detailbtn];
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
