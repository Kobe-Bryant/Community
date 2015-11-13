//
//  FriendAndGroupListModel.m
//  ;
//
//  Created by yunlai on 14-5-12.
//  Copyright (c) 2014年 Dawn_wdf. All rights reserved.
//

#import "FriendAndGroupListModel.h"

@implementation FriendAndGroupListModel
@synthesize jidString;
@synthesize nameString;
@synthesize groupString;
@synthesize userInformation;

-(void)dealloc{
    [jidString release];
    [nameString release];
    [groupString release];
    [userInformation release];
    [super dealloc];
}
@end
