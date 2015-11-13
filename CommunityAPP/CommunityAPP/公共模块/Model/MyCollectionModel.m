//
//  MyCollectionModel.m
//  CommunityAPP
//
//  Created by Dream on 14-4-12.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import "MyCollectionModel.h"

@implementation MyCollectionModel
@synthesize mycollectionId;
@synthesize mycollectionDetailsId;
@synthesize mycollectionPublisherId = _mycollectionPublisherId;
@synthesize mycollectionPublisherIcon = _mycollectionPublisherIcon;
@synthesize mycollectionPublisherNickName = _mycollectionPublisherNickName;
@synthesize mycollectionModuleId = _mycollectionModuleId;
@synthesize mycollectionModuleType = _mycollectionModuleType;
@synthesize mycollectionTitle = _mycollectionTitle;
@synthesize mycollectionCreateTime = _mycollectionCreateTime;

- (void)dealloc
{
    [_mycollectionPublisherId release]; _mycollectionPublisherId = nil;
    [_mycollectionPublisherIcon release]; _mycollectionPublisherIcon = nil;
    [_mycollectionPublisherNickName release]; _mycollectionPublisherNickName = nil;
    [_mycollectionModuleId release]; _mycollectionModuleId = nil;
    [_mycollectionModuleType release]; _mycollectionModuleType = nil;
    [_mycollectionTitle release]; _mycollectionTitle = nil;
    [_mycollectionCreateTime release]; _mycollectionCreateTime = nil;
    [super dealloc];
}

@end
