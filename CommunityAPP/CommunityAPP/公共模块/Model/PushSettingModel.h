//
//  PushSettingModel.h
//  CommunityAPP
//
//  Created by Stone on 14-6-20.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PushSettingModel : NSObject


@property (nonatomic, assign) NSInteger seetingId;
@property (nonatomic, assign) NSInteger pushUserId;
@property (nonatomic, retain) NSString *field;
@property (nonatomic, assign) NSInteger val;
@property (nonatomic, retain) NSString *createTime;
@property (nonatomic, retain) NSString *updateTime;

@end
