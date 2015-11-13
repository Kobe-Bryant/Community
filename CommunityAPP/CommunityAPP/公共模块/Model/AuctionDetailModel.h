//
//  AuctionDetailModel.h
//  CommunityAPP
//
//  Created by Stone on 14-3-21.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import "AuctionModel.h"

@interface AuctionDetailModel : AuctionModel

@property (nonatomic, retain) NSString *residentName;
@property (nonatomic, retain) NSString *residentSex;
//@property (nonatomic, retain) NSString *auctionUpdateTime;
@property (nonatomic, retain) NSString *updateTime;
@property (nonatomic, retain) NSString *remark;

@end
