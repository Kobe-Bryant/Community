//
//  AvoidTroubleCell.m
//  CommunityAPP
//
//  Created by Stone on 14-6-20.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import "AvoidTroubleCell.h"

@implementation AvoidTroubleCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        UIImage *selectImg = [UIImage imageNamed:@"selected_avoid.png"];
        self.selectedImageView = [[UIImageView alloc]initWithFrame:CGRectMake(280, (44-selectImg.size.height)/2, selectImg.size.width, selectImg.size.height)];
        self.selectedImageView.image = selectImg;
        [self addSubview:self.selectedImageView];
        [self.selectedImageView release];
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
    if (selected) {
        self.selectedImageView.hidden = NO;
    }else{
        self.selectedImageView.hidden = YES;
    }
}

@end
