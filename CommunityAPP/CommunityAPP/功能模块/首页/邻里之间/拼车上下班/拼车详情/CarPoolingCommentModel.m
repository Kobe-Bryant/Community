//
//  CarPoolingCommentModel.m
//  CommunityAPP
//
//  Created by yunlai on 14-3-24.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import "CarPoolingCommentModel.h"

@implementation CarPoolingCommentModel
@synthesize idString;
@synthesize residentIdString;
@synthesize residentNameString;
@synthesize residentSexString;
@synthesize residentIconString;
//@synthesize communityIdString;
//@synthesize moduleTypeIdString;
//@synthesize commentIdString;
@synthesize remarkString;
@synthesize createTimeString;
@synthesize replyIdString;
@synthesize replyIconString;
@synthesize replyNickNameString;
-(void)dealloc{
    [idString release];  idString= nil;
    [residentIdString release]; residentIdString= nil;
    [residentNameString release]; residentNameString = nil;
    [residentSexString release]; residentSexString = nil;
    [residentIconString release]; residentIconString = nil;
//    [communityIdString release];  communityIdString = nil;
//    [moduleTypeIdString release];  moduleTypeIdString= nil;
//    [commentIdString release];  commentIdString = nil;
    [remarkString release];  remarkString= nil;
    [createTimeString release];  createTimeString= nil;
    [replyIdString release];  replyIdString= nil;
    [replyIconString release];  replyIconString= nil;
    [replyNickNameString release];  replyNickNameString= nil;
    [super dealloc];
}
@end
