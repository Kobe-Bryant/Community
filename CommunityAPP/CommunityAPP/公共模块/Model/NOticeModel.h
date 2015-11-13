//
//  NOticeModel.h
//  CommunityAPP
//
//  Created by Dream on 14-3-11.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NOticeModel : NSObject

@property (nonatomic,assign) NSInteger noticeId;
@property (nonatomic,retain) NSString *noticeTitle;
@property (nonatomic,retain) NSString *noticeContentLabel;
@property (nonatomic,retain) NSString *noticeContent;
@property (nonatomic,retain) NSString *noticeCreateTime;
@property (nonatomic,retain) NSString *noticeIsUrl;
@property (nonatomic,retain) NSString *noticeUpdate_time;
@property (nonatomic,retain) NSString *extra;
@end
