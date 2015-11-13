//
//  DetailLiveEncyclopediaModel.h
//  CommunityAPP
//
//  Created by Dream on 14-3-21.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DetailLiveEncyclopediaModel : NSObject
@property (nonatomic,assign) NSInteger detailLiveId;
@property (nonatomic,assign) NSInteger detailLiveCommentCount;
@property (nonatomic,retain) NSString *detailLiveTitle;
@property (nonatomic,retain) NSString *detailLiveTypeLable;
@property (nonatomic,assign) NSInteger detailLiveFavour;
@property (nonatomic,assign) NSInteger detailLiveFavourId;
@property (nonatomic,retain) NSString *detailLiveCreateTime;
@property (nonatomic,retain) NSString *detailLiveContent;
@property (nonatomic,retain) NSString *detailLiveContentImg;
@property (nonatomic,retain) NSString *detailIsUrl;
@property (nonatomic,assign) NSInteger detailCollectId;

//评论
@property (nonatomic,assign) NSInteger commentId;
@property (nonatomic,assign) NSInteger commentresidentId;
@property (nonatomic,retain) NSString *commentresidentName;
@property (nonatomic,retain) NSString *commentresidentSex;
@property (nonatomic,retain) NSString *commentresidentIcon;
@property (nonatomic,assign) NSInteger commentcommunityId;
@property (nonatomic,assign) NSInteger commentmoduleTypeId;
@property (nonatomic,assign) NSInteger commentcommentId;
@property (nonatomic,retain) NSString *commentremark;
@property (nonatomic,retain) NSString *commentcreateTime;
@property (nonatomic,retain) NSString *commentSum;
@property (nonatomic,assign) NSInteger replyId;
@property (nonatomic,retain) NSString *replyNickName;
@property (nonatomic,retain) NSString *replyIcon;
@property (nonatomic,retain) NSString *remark;

@end
