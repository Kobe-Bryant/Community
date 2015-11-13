//
//  DataBaseManager.h
//  CommunityAPP
//
//  Created by Stone on 14-3-11.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "Global.h"
#import "NOticeModel.h"
#import "RulesRegulationModel.h"
#import "CommunityIntroduceModel.h"
#import "XmppMessageListModel.h"

@class ContactsTypeModel;
@class ContactModel;
@class UpdateTimeModel;
@class FriendListDetailInfromation;
@class GroupUserListModel;
@class NeighboorHoodFriendList;

@interface DataBaseManager : NSObject


+(id) shareDBManeger;

//打开数据库
-(void) openDatabase;

- (void) deleteDataBase;

//关闭数据库
-(void) closeDatabase;


//add devin 插入通知的数据
-(BOOL)inserNoticeModel:(NOticeModel *)model;
- (void) deleteNoticeWithId:(NSInteger) uid;
-(NSMutableArray *)selectNoticeModel;
-(NSInteger)selectUnreadNotice;
- (BOOL)updateNoticeModel:(NOticeModel *)model;

//add devin 插入规章制度数据
-(BOOL)inserRulesRegulationModel:(RulesRegulationModel *)model;
-(NSMutableArray *)selectRulesRegulationModel;
-(NSInteger)selectUnreadRules;

- (BOOL)updateRuleRegulationById:(NSInteger)ruleId state:(BOOL)isRead;

//------------------------------电话本
- (BOOL)insertContactsTypeModel:(ContactsTypeModel *)model; //插入电话本类型

- (BOOL)insertContact:(ContactModel *)model;                //插入电话记录


- (BOOL)deleteAllContactsByType:(NSInteger)type;    //删除某一类型所有的电话


- (BOOL)deleteAllContactsType;                      //删除所有的电话本类型

- (NSArray *)selectAllContactsType ;                      //查询所有电话本类型

- (NSArray *)selectContactsbyType:(NSInteger)type;       //查询某一类型的电话记录

- (BOOL)deleteMyContact:(ContactModel *)model;          //删除一条我的电话

- (BOOL)updateMyContact:(ContactModel *)model;          //修改一条我的电话记录

#pragma mark ---update time
- (BOOL)insertRequestUpdateTime:(UpdateTimeModel *)model;    //请求的更新时间

- (UpdateTimeModel *)selectUpdateTimeByInterface:(WInterface)type;     //获取

#pragma mark ---Made phone call
- (BOOL)insertMadePhoneCall:(ContactModel *)model;                //插入电话记录

- (NSArray *)selectAllMadePhoneCall;                              //选取所有拨打过的电话

- (BOOL)deleteMadePhoneCall:(NSInteger)contactId;                  //删除打过电话记录

//插入消息列表
- (BOOL)insertMessageList:(XmppMessageListModel *)model;
//删除消息列表
- (BOOL)deleteMessageList:(XmppMessageListModel *)model;
//查询消息列表
-(NSMutableArray *)selectMessageList;
//查询消息中未读的数据
-(NSInteger)selectUnReadMessageList;
//更新消息列表
- (BOOL)updateMessageList:(XmppMessageListModel *)model;

- (BOOL)insertFriendList:(FriendListDetailInfromation *)model;
//删除消息列表
- (BOOL)deleteFriendList:(FriendListDetailInfromation *)model;
//查询消息列表
-(NSMutableArray *)selectFriendList;
//更新消息列表
- (BOOL)updateFriendList:(FriendListDetailInfromation *)model;
//根据group进行搜素当前的数组
-(NSMutableArray *)selectGroupList:(NSString *)modelString;
//查询当前的id是否在数据库中
//- (BOOL)selectJidYesOrNo:(NSString *)jidString;
-(NSMutableArray *)selectJidYesOrNo:(NSString *)jidString;

//群主列表的数据操作
- (BOOL)insertGroupList:(GroupUserListModel *)model;
//删除消群主
- (BOOL)deleteGroupList:(GroupUserListModel *)model;
//更新群主列表
- (BOOL)updateGroupList:(GroupUserListModel *)model;
//查询群主列表
-(NSMutableArray *)selectGroupList;

//插入邻居好友数据
- (BOOL)insertNeighboorHoodFriendList:(NeighboorHoodFriendList *)model;
//删除好友
- (BOOL)deleteNeighBoorHoodFriendList:(NeighboorHoodFriendList *)model;
//根据groupId进行搜素当前的数组
-(NSMutableArray *)selectNeighboorHoodFriendList:(NSString *)modelString;
//根据单个的jid请求当前用户的信息
-(NSMutableArray *)selectNeighborHoodFriend:(NSString *)jidString;
//查询全部
-(NSMutableArray *)selectNeighboorHoodList;
//更好友信息列表
- (BOOL)updateNeighboorHoodFriendList:(NeighboorHoodFriendList *)model;
@end
