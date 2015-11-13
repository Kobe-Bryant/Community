//
//  AuctionCommentModel.h
//  CommunityAPP
//
//  Created by Stone on 14-3-24.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AuctionCommentModel : NSObject

@property (nonatomic, retain) NSString* commentId;      //评论Id
@property (nonatomic, retain) NSString* residentId;     //评论人Id
@property (nonatomic, retain) NSString* residentName;   //评论人名字
@property (nonatomic, retain) NSString* residentSex;    //评论人性别
@property (nonatomic, retain) NSString* residentIcon;   //评论人头像
@property (nonatomic, retain) NSString* createTime;     //创建时间
@property (nonatomic, retain) NSString* remark;         //评论内容

// add by devin
@property (nonatomic, retain) NSString* replyId;         //回复评论人id
@property (nonatomic, retain) NSString* replyNickName;   //回复人昵称
@property (nonatomic, retain) NSString* replyIcon;       //回复人头像URL
@end
