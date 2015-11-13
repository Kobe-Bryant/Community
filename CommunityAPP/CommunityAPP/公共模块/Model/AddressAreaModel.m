//
//  AddressAreaModel.m
//  CommunityAPP
//
//  Created by yunlai on 14-5-5.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import "AddressAreaModel.h"

@implementation AddressAreaModel
@synthesize idString;
@synthesize nameString;
@synthesize parentIdString;

-(void)dealloc{
    [idString release]; idString = nil;
    [nameString release]; nameString = nil;
    [parentIdString release];parentIdString = nil;
    [super dealloc];
}

@end
