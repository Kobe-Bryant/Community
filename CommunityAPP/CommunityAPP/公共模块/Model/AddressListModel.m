//
//  AddressListModel.m
//  CommunityAPP
//
//  Created by yunlai on 14-4-30.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import "AddressListModel.h"

@implementation AddressListModel
@synthesize idString;
@synthesize consigneeString;
@synthesize phoneNumberString;
@synthesize zipCodeString;
@synthesize provinceIdString;
@synthesize cityIdString;
@synthesize addressString;
@synthesize fullAddressString;
@synthesize isDefaultString;
@synthesize areaIdString;

-(void)dealloc{
    [areaIdString release];
    [idString release];
    [consigneeString release];
    [phoneNumberString release];
    [zipCodeString release];
    [provinceIdString release];
    [cityIdString release];
    [addressString release];
    [fullAddressString release];
    [isDefaultString release];
    [super dealloc];
}

@end
