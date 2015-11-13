//
//  GroupUserListModel.m
//  CommunityAPP
//
//  Created by yunlai on 14-6-20.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import "GroupUserListModel.h"

@implementation GroupUserListModel
@synthesize groupIdString;
@synthesize groupNameString;
@synthesize orderIndexString;

-(void)dealloc{
    [groupIdString release];
    [groupNameString release];
    [orderIndexString  release];
    [super dealloc];
}
@end
