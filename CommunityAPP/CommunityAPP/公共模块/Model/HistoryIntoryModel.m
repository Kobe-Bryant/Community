//
//  HistoryIntoryModel.m
//  CommunityAPP
//
//  Created by Dream on 14-4-4.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import "HistoryIntoryModel.h"

@implementation HistoryIntoryModel
@synthesize codeTypeStr;
@synthesize inviteCodeStr;
@synthesize stateStr;
@synthesize createTimeStr;
- (void)dealloc
{
    [codeTypeStr release]; codeTypeStr = nil;
    [inviteCodeStr release]; inviteCodeStr = nil;
    [stateStr release]; stateStr = nil;
    [createTimeStr release]; createTimeStr = nil;
    [super dealloc];
}

@end
