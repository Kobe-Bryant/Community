//
//  DataLocitionModel.m
//  CommunityAPP
//
//  Created by yunlai on 14-5-14.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import "DataLocitionModel.h"

@implementation DataLocitionModel
@synthesize idString;
@synthesize nameString;
@synthesize parentIdString;
-(void)dealloc{
    [idString release];
    [nameString release];
    [parentIdString release];
    [super dealloc];
}
@end
