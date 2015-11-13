//
//  UpdateTimeModel.m
//  CommunityAPP
//
//  Created by Stone on 14-3-12.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import "UpdateTimeModel.h"

@implementation UpdateTimeModel

@synthesize type = _type;
@synthesize date = _date;

- (void)dealloc{
    _type = nil;
    _date = nil;
    [super dealloc];
}

- (id)init{
    self = [super init];
    if (self) {
        _type = @"-1";
        _date = @"";
    }
    
    return self;
}

@end
