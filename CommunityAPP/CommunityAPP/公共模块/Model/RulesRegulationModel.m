//
//  RulesRegulationModel.m
//  CommunityAPP
//
//  Created by Dream on 14-3-12.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import "RulesRegulationModel.h"

@implementation RulesRegulationModel
@synthesize title,contentLabel,content,icon,isUrl;
@synthesize read;

- (void)dealloc
{
    [title release]; title = nil;
    [contentLabel release]; contentLabel = nil;
    [content release]; content = nil;
    [icon release]; icon = nil;
    [isUrl release]; isUrl = nil;
    [super dealloc];
}

- (id)init{
    
    self = [super init];
    if (self) {
        read = NO;
    }
    return self;
}

@end
