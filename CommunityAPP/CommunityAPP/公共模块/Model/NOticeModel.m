//
//  NOticeModel.m
//  CommunityAPP
//
//  Created by Dream on 14-3-11.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import "NOticeModel.h"

@implementation NOticeModel
@synthesize noticeId,noticeTitle,noticeContentLabel,noticeCreateTime,noticeUpdate_time,noticeIsUrl=_noticeIsUrl,extra;
@synthesize noticeContent;
-(void)dealloc{
    [noticeTitle release];noticeTitle = nil;
    [_noticeIsUrl release];_noticeIsUrl = nil;
    [noticeContentLabel release];noticeContentLabel= nil;
    [noticeCreateTime release];noticeCreateTime= nil;
    [noticeUpdate_time release]; noticeUpdate_time= nil;
    [extra release]; extra = nil;
    [super dealloc];
}
@end
