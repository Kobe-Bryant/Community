//
//  CarPoolDataModel.h
//  CommunityAPP
//
//  Created by yunlai on 14-3-21.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CarPoolDataModel : NSObject
@property(nonatomic,assign)NSInteger idInteger;
@property(nonatomic,assign)NSInteger residentId;
@property(nonatomic,assign)NSInteger communityId;
@property(nonatomic,retain)NSString *typeString;
@property(nonatomic,retain)NSString *destinationString;
@property(nonatomic,retain)NSString *returnHomeString;
@property(nonatomic,retain)NSString *attendanceTimeString;
@property(nonatomic,retain)NSString *closingTimeString;
@property(nonatomic,retain)NSString *contactUsString;
@property(nonatomic,retain)NSString *remarkString;
@property(nonatomic,retain)NSString *createTimeString;
@property(nonatomic,retain)NSString *publisherIdString;
@property(nonatomic,retain)NSString *publisherNameString;
@property(nonatomic,retain)NSString *iconString;
@property(nonatomic,retain)NSString *sexString;
@property(nonatomic,retain)NSString *commentNumber;
@end
