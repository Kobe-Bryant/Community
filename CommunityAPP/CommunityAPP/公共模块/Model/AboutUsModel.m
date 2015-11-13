//
//  AboutUsModel.m
//  CommunityAPP
//
//  Created by Dream on 14-5-24.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import "AboutUsModel.h"

@implementation AboutUsModel
@synthesize titleString = _titleString;
@synthesize contentString = _contentString;
@synthesize updateTimeString = _updateTimeString;
@synthesize isUrlInt;
-(void)dealloc{
    [_titleString release];
    [_contentString release];
    [_updateTimeString release];
    [super dealloc];
}
@end
