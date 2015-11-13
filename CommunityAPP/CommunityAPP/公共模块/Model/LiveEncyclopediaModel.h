//
//  LiveEncyclopediaModel.h
//  CommunityAPP
//
//  Created by Dream on 14-3-21.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LiveEncyclopediaModel : NSObject
@property (nonatomic,assign) NSInteger liveId;
@property (nonatomic,retain) NSString *liveTitle;
@property (nonatomic,retain) NSString *liveType;
@property (nonatomic,retain) NSString *liveContent;
@property (nonatomic,retain) NSString *liveCreateTime;
@property (nonatomic,retain) NSString *liveContentImg;
@property (nonatomic,assign) NSInteger liveFavour;
@property (nonatomic,assign) NSInteger liveFavourId;
@property (nonatomic,assign) NSInteger liveCommentCount;
@property (nonatomic,retain) NSString *liveResidentId;
@property (nonatomic,retain) NSString *liveIcon;
@property (nonatomic,assign) BOOL isFavor;

@end
