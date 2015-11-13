//
//  MyPublishModel.m
//  CommunityAPP
//
//  Created by Dream on 14-4-16.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import "MyPublishModel.h"

@implementation MyPublishModel
@synthesize mypublishId = _mypublishId;
@synthesize mypublishModuleId = _mypublishModuleId;
@synthesize mypublishModuleTypeId = _mypublishModuleTypeId;
@synthesize mypublishTitle = _mypublishTitle;
@synthesize mypublishCreateTime = _mypublishCreateTime;

- (void)dealloc
{
    [_mypublishId release]; _mypublishId = nil;
    [_mypublishModuleId release]; _mypublishModuleId = nil;
    [_mypublishModuleTypeId release]; _mypublishModuleTypeId = nil;
    [_mypublishTitle release]; _mypublishTitle = nil;
    [_mypublishCreateTime release]; _mypublishCreateTime = nil;
    [super dealloc];
}

@end
