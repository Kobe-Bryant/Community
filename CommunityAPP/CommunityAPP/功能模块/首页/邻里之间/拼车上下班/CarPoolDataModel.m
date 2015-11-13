//
//  CarPoolDataModel.m
//  CommunityAPP
//
//  Created by yunlai on 14-3-21.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import "CarPoolDataModel.h"

@implementation CarPoolDataModel
@synthesize idInteger;
@synthesize residentId;
@synthesize communityId;
@synthesize typeString;
@synthesize destinationString;
@synthesize returnHomeString;
@synthesize attendanceTimeString;
@synthesize closingTimeString;
@synthesize contactUsString;
@synthesize remarkString;
@synthesize createTimeString;
@synthesize publisherIdString;
@synthesize publisherNameString;
@synthesize iconString;
@synthesize sexString;
@synthesize commentNumber;

-(void)dealloc{
    [typeString release]; typeString = nil;
    [destinationString release]; destinationString= nil;
    [returnHomeString release]; returnHomeString= nil;
    [attendanceTimeString release]; attendanceTimeString= nil;
    [closingTimeString release];closingTimeString= nil;
    [contactUsString release]; contactUsString = nil;
    [remarkString release];  remarkString= nil;
    [createTimeString release]; createTimeString= nil;
    [publisherIdString release]; publisherIdString= nil;
    [publisherNameString release]; publisherNameString = nil;
    [iconString release]; iconString= nil;
    [sexString release]; sexString= nil;
    [commentNumber release]; commentNumber = nil;
    [super dealloc];
}
@end
