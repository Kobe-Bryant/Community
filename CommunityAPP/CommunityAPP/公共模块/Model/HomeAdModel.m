//
//  HomeAdModel.m
//  CommunityAPP
//
//  Created by Dream on 14-4-26.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import "HomeAdModel.h"

@implementation HomeAdModel
@synthesize adId = _adId;
@synthesize adResUrl = _adResUrl;
@synthesize adShowType = _adShowType;
@synthesize adActionType = _adActionType;
@synthesize adActionValue = _adActionValue;

- (void)dealloc
{
    [_adId release]; _adId = nil;
    [_adResUrl release]; _adResUrl = nil;
    [_adShowType release]; _adShowType = nil;
    [_adActionType release]; _adActionType = nil;
    [_adActionValue release]; _adActionValue = nil;
    [super dealloc];
}

@end
