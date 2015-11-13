//
//  ContactModel.m
//  CommunityAPP
//
//  Created by Stone on 14-3-11.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import "ContactModel.h"

@implementation ContactModel

@synthesize contactId = _contactId;       //电话Id
@synthesize contactName = _contactName;    //联系人姓名
@synthesize type = _type;           //电话类型
@synthesize phoneNumber = _phoneNumber;           //电话号码
@synthesize contactDescription = _contactDescription;    //描述
@synthesize typeName = _typeName;       //类型名

@synthesize lastCallTime = _lastCallTime;    //最后一次呼叫的时间
@synthesize callCount = _callCount;       //呼叫的次数

@synthesize isRecently = _isRecently;

- (id)init{
    self = [super init];
    if (self) {
        _isRecently = NO;
    }
    return self;
}

-(id)copyWithZone:(NSZone *)zone{
    ContactModel *contact = [[[self class] allocWithZone:zone]init];
    contact.contactId = _contactId;
    contact.contactName = [_contactName copy];
    contact.type = [_type copy];
    contact.phoneNumber = [_phoneNumber copy];
    contact.contactDescription = [_contactDescription copy];
    contact.typeName = [_typeName copy];
    contact.lastCallTime = [_lastCallTime copy];
    contact.callCount = _callCount;
    
    return contact;
    
}

@end
