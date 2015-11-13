//
//  AuctionModel.h
//  CommunityAPP
//
//  Created by Stone on 14-3-20.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AuctionModel : NSObject

@property (nonatomic, retain) NSString* auctionId;
@property (nonatomic, retain) NSString* residentId;
@property (nonatomic, retain) NSString* residentIcon;
@property (nonatomic, retain) NSString* communityName;
@property (nonatomic, retain) NSString* auctionUpdateTime;
@property (nonatomic, retain) NSString* title;
@property (nonatomic, retain) NSString* cost;
@property (nonatomic, retain) NSString* commentNumber;
@property (nonatomic, retain) NSString* images;
@property (nonatomic, retain) NSString* sharedContent;

@end
