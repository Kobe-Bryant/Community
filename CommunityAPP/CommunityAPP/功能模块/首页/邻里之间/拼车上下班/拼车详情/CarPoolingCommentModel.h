//
//  CarPoolingCommentModel.h
//  CommunityAPP
//
//  Created by yunlai on 14-3-24.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CarPoolingCommentModel : NSObject
@property(nonatomic,retain)NSString *idString;
@property(nonatomic,retain)NSString *residentIdString;
@property(nonatomic,retain)NSString *residentNameString;
@property(nonatomic,retain)NSString *residentSexString;
@property(nonatomic,retain)NSString *residentIconString;
//@property(nonatomic,retain)NSString *communityIdString;
//@property(nonatomic,retain)NSString *moduleTypeIdString;
//@property(nonatomic,retain)NSString *commentIdString;
@property(nonatomic,retain)NSString *remarkString;
@property(nonatomic,retain)NSString *createTimeString;
//add by devin
@property(nonatomic,retain)NSString *replyIdString;
@property(nonatomic,retain)NSString *replyNickNameString;
@property(nonatomic,retain)NSString *replyIconString;

@end
