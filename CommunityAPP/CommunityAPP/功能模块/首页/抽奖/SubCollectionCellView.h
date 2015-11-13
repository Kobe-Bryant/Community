//
//  SubCollectionCellView.m
//  CommunityAPP
//
//  Created by yunlai on 14-4-20.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface SubCollectionCellView : UIView
{
    UIImageView *iconImageView;
    UILabel *titleNameLabel;
}

@property(retain,nonatomic) UIImageView *iconImageView;
@property(retain,nonatomic) UILabel *titleNameLabel;

-(void)initSubCollectionCellView;

@end
