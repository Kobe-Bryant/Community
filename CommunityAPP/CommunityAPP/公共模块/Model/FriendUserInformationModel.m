
//
//  FriendUserInformationModel.m
//  CommunityAPP
//
//  Created by yunlai on 14-5-21.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import "FriendUserInformationModel.h"

@implementation FriendUserInformationModel
@synthesize fromString;
@synthesize communityString;
@synthesize sexString;
@synthesize nickNameString;
@synthesize binvalString;
@synthesize signatureString;
@synthesize imageUrlString;

-(void)dealloc{
    [imageUrlString release];   imageUrlString = nil;
    [signatureString release]; signatureString = nil;
    [fromString release]; fromString = nil;
    [communityString release];communityString = nil;
    [sexString release]; sexString = nil;
    [nickNameString release];nickNameString = nil;
    [binvalString release];binvalString = nil;

    [super dealloc];
}
@end
