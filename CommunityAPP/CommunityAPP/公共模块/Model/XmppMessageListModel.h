//
//  XmppMessageListModel.h
//  CommunityAPP
//
//  Created by yunlai on 14-5-22.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XmppMessageListModel : NSObject
@property(nonatomic,retain)NSString *toJidString;
@property(nonatomic,retain)NSString *fromJidString;
@property(nonatomic,retain)NSString *bodyString;
@property(nonatomic,retain)NSString *iconString;
@property(nonatomic,retain)NSString *sexString;
@property(nonatomic,retain)NSString *nickNameString;
@property(nonatomic,retain)NSString *signString;
@property(nonatomic,retain)NSString *timeString;
@property(nonatomic,retain)NSString *isRead;
@property(nonatomic,retain)NSString *offlineString;
@end
