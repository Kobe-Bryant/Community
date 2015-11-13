//
//  MyCommentModel.m
//  CommunityAPP
//
//  Created by Dream on 14-4-12.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import "MyCommentModel.h"

@implementation MyCommentModel
@synthesize mycommentId;
@synthesize mycommentResidentId =_mycommentResidentId ;
@synthesize mycommentResidentIcon = _mycommentResidentIcon;
@synthesize mycommentResidentName = _mycommentResidentName;
@synthesize mycommentCommentId = _mycommentCommentId;
@synthesize mycommentModuleTypeId;
@synthesize mycommentRemark = _mycommentRemark;
@synthesize mycommentCreateTime = _mycommentCreateTime;

- (void)dealloc
{
     [_mycommentResidentId release]; _mycommentResidentId = nil;
     [_mycommentResidentIcon release]; _mycommentResidentIcon = nil;
     [_mycommentResidentName release]; _mycommentResidentName = nil;
     [_mycommentCommentId release]; _mycommentCommentId = nil;
     [_mycommentRemark release]; _mycommentRemark = nil;
     [_mycommentCreateTime release]; _mycommentCreateTime = nil;
    [super dealloc];
}

@end
