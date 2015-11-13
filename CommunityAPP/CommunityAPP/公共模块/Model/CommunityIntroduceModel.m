//
//  CommunityIntroduceModel.m
//  CommunityAPP
//
//  Created by Dream on 14-3-17.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import "CommunityIntroduceModel.h"

@implementation CommunityIntroduceModel
@synthesize headImage = _headImage;
@synthesize nameStr = _nameStr;
@synthesize adressStr = _adressStr;
@synthesize timeStr = _timeStr;
@synthesize developStr = _developStr;
@synthesize communityStr = _communityStr;
@synthesize countStr = _countStr;
@synthesize stopStr = _stopStr;
@synthesize greenStr = _greenStr;
@synthesize volumeStr = _volumeStr;

- (void)dealloc
{
    [_headImage release]; _headImage = nil;
    [_nameStr release]; _nameStr = nil;
    [_adressStr release]; _adressStr = nil;
    [_timeStr release]; _timeStr = nil;
    [_developStr release]; _developStr = nil;
    [_communityStr release]; _communityStr = nil;
    [_countStr release]; _countStr = nil;
    [_stopStr release]; _stopStr = nil;
    [_greenStr release]; _greenStr = nil;
    [_volumeStr release]; _volumeStr = nil;
    [super dealloc];
}
@end
