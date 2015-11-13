//
//  MyCollectionModel.h
//  CommunityAPP
//
//  Created by Dream on 14-4-12.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyCollectionModel : NSObject
@property (nonatomic,assign) NSInteger mycollectionId;
@property (nonatomic,assign) NSInteger mycollectionDetailsId;
@property (nonatomic,retain) NSString *mycollectionPublisherId;
@property (nonatomic,retain) NSString *mycollectionPublisherIcon;
@property (nonatomic,retain) NSString *mycollectionPublisherNickName;
@property (nonatomic,retain) NSString *mycollectionModuleId;
@property (nonatomic,retain) NSString *mycollectionModuleType;
@property (nonatomic,retain) NSString *mycollectionTitle;
@property (nonatomic,retain) NSString *mycollectionCreateTime;
@end
