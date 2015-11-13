//
//  AwardRecordingModel.m
//  CommunityAPP
//
//  Created by yunlai on 14-4-29.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import "AwardRecordingModel.h"

@implementation AwardRecordingModel
@synthesize contentString;
@synthesize getTimeString;
@synthesize idString;
@synthesize isUrlString;
@synthesize picUrlString;
@synthesize statusString;
@synthesize titleString;

-(void)dealloc{
    [contentString release];
    [getTimeString release];
    [idString release];
    [isUrlString release];
    [picUrlString release];
    [statusString release];
    [titleString release];
    [super dealloc];
}

@end
