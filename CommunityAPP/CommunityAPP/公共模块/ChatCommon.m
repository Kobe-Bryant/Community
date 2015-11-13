//
//  ChatComment.m
//  CommunityAPP
//
//  Created by yunlai on 14-7-21.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import "ChatCommon.h"

@implementation ChatCommon
static id sharedGlobal = nil;

@synthesize userModel; 

+ (void)initialize
{
    if (self == [ChatCommon class])
    {
        sharedGlobal = [[self alloc] init];
    }
}

+ (ChatCommon *)sharedGlobal
{
    return sharedGlobal;
}
@end
