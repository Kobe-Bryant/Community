//
//  NeighboorHoodFriendList.h
//  CommunityAPP
//
//  Created by yunlai on 14-6-20.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NeighboorHoodFriendList : NSObject
@property(nonatomic,retain)NSString *userIdString;
@property(nonatomic,retain)NSString *usernameString;
@property(nonatomic,retain)NSString *nicknameString;
@property(nonatomic,retain)NSString *avatarString;
@property(nonatomic,retain)NSString *genderString;
@property(nonatomic,retain)NSString *tsString;
@property(nonatomic,retain)NSString *groupIdString;
@property(nonatomic,retain)NSString *userTypeString;
@property(nonatomic,retain)NSString *updateTimeString;
@property(nonatomic,retain)NSString *enabledString;
@property(nonatomic,retain)NSString *statusString;
@property(nonatomic,retain)NSString *isDelString;
@property(nonatomic,retain)NSString *signatureString;

@property(nonatomic,retain)NSString *pageSizeString;
@property(nonatomic,retain)NSString *totalCountString;
@property(nonatomic,retain)NSString *pagesString;
@property(nonatomic,retain)NSString *prevPageString;
@property(nonatomic,retain)NSString *nextPageString;
@property(nonatomic,retain)NSString *timeStamp;
@end
