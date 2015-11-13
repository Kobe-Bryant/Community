
//
//  XmppMessageListModel.m
//  CommunityAPP
//
//  Created by yunlai on 14-5-22.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import "XmppMessageListModel.h"
#import "NSObject+Time.h"

@implementation XmppMessageListModel
@synthesize toJidString;
@synthesize fromJidString;
@synthesize bodyString;
@synthesize iconString;
@synthesize sexString;
@synthesize nickNameString;
@synthesize signString;
@synthesize timeString = _timeString;
@synthesize isRead;
@synthesize offlineString;

//-(void)dealloc{
//    [timeString release]; timeString = nil;
//    [toJidString release]; toJidString = nil;
//    [fromJidString release]; fromJidString = nil;
//    [bodyString release]; bodyString = nil;
//    [iconString release];iconString = nil;
//    [sexString release];sexString = nil;
//    [nickNameString release];nickNameString = nil;
//    [signString release];signString = nil;
//    [super dealloc];
//}


- (void)setTimeString:(NSString *)timeString{
    if (timeString == nil) {
        _timeString = [NSObject getCurrentTime];
    }
    _timeString = [timeString retain];
}

@end
