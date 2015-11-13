//
//  NeighboorHoodFriendList.m
//  CommunityAPP
//
//  Created by yunlai on 14-6-20.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import "NeighboorHoodFriendList.h"

@implementation NeighboorHoodFriendList
@synthesize userIdString;
@synthesize usernameString;
@synthesize nicknameString;
@synthesize avatarString;
@synthesize genderString;
@synthesize tsString;
@synthesize groupIdString;
@synthesize pageSizeString;
@synthesize totalCountString;
@synthesize pagesString;
@synthesize prevPageString;
@synthesize nextPageString;
@synthesize isDelString;
@synthesize signatureString;

@synthesize userTypeString;
@synthesize updateTimeString;
@synthesize enabledString;
@synthesize statusString;
@synthesize timeStamp;

-(void)dealloc{
    [signatureString release];
    [userTypeString release];
    [updateTimeString release];
    [enabledString release];
    [statusString release];
    [isDelString release];
    [userIdString release];
    [usernameString release];
    [nicknameString release];
    [avatarString release];
    [genderString release];
    [tsString release];
    [groupIdString release];
    [pageSizeString release];
    [totalCountString release];
    [pagesString release];
    [prevPageString release];
    [nextPageString release];
    [super dealloc];
}

@end
