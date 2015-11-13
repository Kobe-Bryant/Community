//
//  ContactsTypeModel.h
//  CommunityAPP
//
//  Created by Stone on 14-3-11.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ContactsTypeModel : NSObject

@property (nonatomic,assign) NSInteger typeId;      //类型Id
@property (nonatomic, retain) NSString *typeName;   //电话本类型名
@property (nonatomic, retain) NSString *updateTime; //更新时间


@property (nonatomic, assign) BOOL  isRequestSucceed;   //是否已请求成功,不存入数据库
@property (nonatomic, assign) BOOL  isRecently;         //是否最近
@property (nonatomic, assign) BOOL isMine;              //是否是我的电话本

@end
