//
//  AuctionModel.m
//  CommunityAPP
//
//  Created by Stone on 14-3-20.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import "AuctionModel.h"

@implementation AuctionModel

@synthesize auctionId = _auctionId;
@synthesize residentId = _residentId;
@synthesize residentIcon = _residentIcon;
@synthesize communityName = _communityName;
@synthesize auctionUpdateTime = _auctionUpdateTime;
@synthesize title = _title;
@synthesize cost = _cost;
@synthesize commentNumber = _commentNumber;
@synthesize images = _images;

- (void)dealloc{
    [super dealloc];
}

- (id)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}

@end
