//
//  MyCommentModel.h
//  CommunityAPP
//
//  Created by Dream on 14-4-12.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyCommentModel : NSObject
@property (nonatomic,assign) NSInteger mycommentId;
@property (nonatomic,retain) NSString *mycommentResidentId;
@property (nonatomic,retain) NSString *mycommentResidentIcon;
@property (nonatomic,retain) NSString *mycommentResidentName;
@property (nonatomic,retain) NSString *mycommentCommentId;
@property (nonatomic,assign) NSInteger mycommentModuleTypeId;
@property (nonatomic,retain) NSString *mycommentRemark;
@property (nonatomic,retain) NSString *mycommentCreateTime;
@end
