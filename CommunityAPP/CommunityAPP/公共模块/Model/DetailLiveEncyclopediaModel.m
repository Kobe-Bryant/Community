//
//  DetailLiveEncyclopediaModel.m
//  CommunityAPP
//
//  Created by Dream on 14-3-21.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import "DetailLiveEncyclopediaModel.h"

@implementation DetailLiveEncyclopediaModel
@synthesize detailLiveId;
@synthesize detailLiveTitle = _detailLiveTitle;
@synthesize detailLiveFavour;
@synthesize detailLiveFavourId;
@synthesize detailLiveCreateTime = _detailLiveCreateTime;
@synthesize detailLiveContent = _detailLiveContent;
@synthesize detailLiveContentImg = _detailLiveContentImg;
@synthesize detailLiveCommentCount;
@synthesize detailLiveTypeLable = _detailLiveTypeLable;
@synthesize detailIsUrl = _detailIsUrl;
@synthesize detailCollectId;

//评论
@synthesize commentId;
@synthesize commentresidentId;
@synthesize commentcommunityId;
@synthesize commentmoduleTypeId;
@synthesize commentcommentId;
@synthesize commentresidentName = _commentresidentName;
@synthesize commentresidentSex = _commentresidentSex;
@synthesize commentresidentIcon = _commentresidentIcon;
@synthesize commentremark = _commentremark;
@synthesize commentcreateTime = _commentcreateTime;
@synthesize commentSum = commentSum;
@synthesize replyId;
@synthesize replyNickName = _replyNickName;
@synthesize replyIcon = _replyIcon;
@synthesize remark = _remark;
@end
