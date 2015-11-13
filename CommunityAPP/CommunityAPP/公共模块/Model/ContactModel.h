//
//  ContactModel.h
//  CommunityAPP
//
//  Created by Stone on 14-3-11.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ContactModel : NSObject<NSCopying>

@property (nonatomic, assign) NSInteger contactId;       //电话Id
@property (nonatomic, retain) NSString *contactName;    //联系人姓名
@property (nonatomic, retain) NSString *type;           //电话类型
@property (nonatomic, retain) NSString *phoneNumber;           //电话号码
@property (nonatomic, retain) NSString *contactDescription;    //描述
@property (nonatomic, retain) NSString *typeName;       //类型名

@property (nonatomic,retain) NSString *lastCallTime;    //最后一次呼叫的时间
@property (nonatomic,assign) NSInteger callCount;       //呼叫的次数

@property (nonatomic, assign) BOOL isRecently;      //是否是最近
@property (nonatomic, assign) BOOL isCommit;        //是否提交

@end
