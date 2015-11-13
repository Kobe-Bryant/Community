//
//  MyBillListBean.h
//  CommunityAPP
//
//  Created by yunlai on 14-3-12.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyBillListBean : NSObject
@property(nonatomic,retain)NSString *amountString;
@property(nonatomic,retain)NSString *countString;
@property(nonatomic,retain)NSString *damagesString;
@property(nonatomic,retain)NSString *endTimeString;
@property(nonatomic,retain)NSString *idString;
@property(nonatomic,retain)NSString *readingsString;
@property(nonatomic,retain)NSString *priceString;
@property(nonatomic,retain)NSString *startTimeString;
@property(nonatomic,retain)NSString *statusString;
@property(nonatomic,retain)NSString *titleString;
@property(nonatomic,retain)NSString *totalString;
@property(nonatomic,retain)NSString *typeString;
@property(nonatomic,retain)NSString *unitString;
@property(nonatomic,retain)NSString *timeLabelString;
@property(nonatomic,retain)NSString *oldArrearsString;
@property(nonatomic,retain)NSString * descriptionString;    //add by Stone 其它类型的详情


@property (nonatomic, retain) NSString *yearTime;
@property (nonatomic,retain) NSString *yearTotal;

@end
