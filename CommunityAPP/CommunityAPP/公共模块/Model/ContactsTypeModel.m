//
//  ContactsTypeModel.m
//  CommunityAPP
//
//  Created by Stone on 14-3-11.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import "ContactsTypeModel.h"

@implementation ContactsTypeModel

@synthesize isRequestSucceed = _isRequestSucceed;
@synthesize typeId = _typeId;
@synthesize typeName = _typeName;
@synthesize updateTime = _updateTime;

@synthesize isRecently = _isRecently;

- (void)dealloc{
    [super dealloc];
}

- (id)init{
    self = [super init];
    if (self) {
        _isRequestSucceed = NO;
        _updateTime = @"";
        _isRecently = NO;
    }
    
    return self;
}

- (void)setIsRecently:(BOOL)isRecently{
    _isRecently = isRecently;
}

@end
