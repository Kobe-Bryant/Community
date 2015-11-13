//
//  DataBaseManager.m
//  CommunityAPP
//
//  Created by Stone on 14-3-11.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import "DataBaseManager.h"
#import "FMDatabaseQueue.h"
#import "NSFileManager+Community.h"
#import "ContactsTypeModel.h"
#import "ContactModel.h"
#import "UpdateTimeModel.h"
#import "XmppMessageListModel.h"
#import "FriendListDetailInfromation.h"
#import "GroupUserListModel.h"
#import "NeighboorHoodFriendList.h"

@interface DataBaseManager (){
    NSString  *dbVersion;
}

@property (nonatomic, retain) FMDatabase *fmdb;
@property (nonatomic, retain) FMDatabasePool *fmdbPool;
@property (nonatomic, retain) FMDatabaseQueue *fmdbQueue;
@property (nonatomic, copy) NSString *dbFilePath; //数据库文件路径
@property (nonatomic, copy) NSString *dbFileConfig; //数据库配置信息的路径
@property (nonatomic, retain)  NSMutableArray *dbData; //存放读取数据
@property (nonatomic, copy) NSString *dbName; //数据库名字

@end

@implementation DataBaseManager

@synthesize fmdb = _fmdb;
@synthesize fmdbPool = _fmdbPool;
@synthesize fmdbQueue = _fmdbQueue;
@synthesize dbFilePath = _dbFilePath;

 static DataBaseManager *_instance = nil;
+(id) shareDBManeger{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[DataBaseManager alloc] init];
    });
    return _instance;
}
- (id)init{
    self = [super init];
    if (self) {
    }
    return self;
}

//打开数据库
-(void) openDatabase{
   
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *dirPath = [fileManager applicationLibraryDirectory];

    self.dbFilePath = [NSString stringWithFormat:@"%@/%@",dirPath,@"community.sqlite"];
    
    NSLog(@"数据库位置:%@",self.dbFilePath);
    //数据库存在就打开，不存在就创建打开
    self.fmdb = [FMDatabase databaseWithPath:self.dbFilePath];
    if (![_fmdb open]) {
        NSLog(@"数据库打开失败");
    }else {
        [self createTablePool];
    }
    [_fmdb close];
    return;
}

- (void)deleteDataBase{
    NSFileManager *fileManager = [NSFileManager defaultManager];
   BOOL flag = [fileManager removeItemAtPath:self.dbFilePath error:nil];
    if (flag) {
        //创建新的数据库
        [self openDatabase];
    }
}

//关闭数据库
-(void) closeDatabase{
    [_fmdb close];
}
#pragma mark ----
- (void)createTablePool{
    self.fmdbQueue = [FMDatabaseQueue databaseQueueWithPath:self.dbFilePath];
    dbVersion = @"1.00";
    [self.fmdbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        //创建电话本类型
        NSString *createContactTypeTable = @"create table if not exists t_contacts_type (type_id int primary key,type_name text,update_time text,extra text)" ;
        BOOL result = [db executeUpdate:createContactTypeTable];
        //创建电话本列表
        NSString *createContactTable = @"create table if not exists t_contacts(contact_id int primary key,contact_name text,contact_type text,contact_type_name text,contact_call text,contact_description text,last_call_time text,call_count integer,extra text)";
        result &= [db executeUpdate:createContactTable];
        
        //创建更新时间的表
        NSString *createUpdateTimeTable = @"create table if not exists t_update_time(type text primary key,date text,extra text)";
        result &= [db executeUpdate:createUpdateTimeTable];
        
        //创建通知表
         NSString * creatNoticeTable = @"create table if not exists t_notification(id int primary key,notic_id integer,content_label text,author text,time text,isUrl text,extra text)";
         result &= [db executeUpdate:creatNoticeTable];
        
        //创建规章制度表
        NSString *creatRulesRegulationTable = @"create table if not exists t_rulesregulation(rulesregulation_id int primary key ,title text,contentLabel text,content text,icon text,isUrl text,extra text)";
        result &= [db executeUpdate:creatRulesRegulationTable];
        
        //添加createtime字段
        //NSString *
        
        //创建账单类型表
        NSString *createBillTypeTable = @"create table if not exists t_bill_type(bill_type_id text primary key,bill_type_label text,bill_total text,extra text)";
        result &= [db executeUpdate:createBillTypeTable];
        
        //创建账单表
        NSString *createBillTable = @"create table if not exists t_bill(bill_id text,bill_title text,bill_icon text,bill_total text,bill_statue text,bill_type text,bill_value text,bill_start_end_time text,bill_const text,bill_price text,bill_old_arrears text,bill_damages text,bill_type_id text,extra text)";
        result &= [db executeUpdate:createBillTable];
        
        //创建个人资料表
        NSString *createPersonalInfoTable = @"create table if not exists t_personal_info(nick_name text,sex text,signature text,imgs text,community_name text,identify text,icon text,extra text)";
        result &= [db executeUpdate:createPersonalInfoTable];
        
        //创建电话本列表
        NSString *createMadePhoneCallTable = @"create table if not exists t_made_call(contact_id integer,contact_name text,contact_type text,contact_type_name text,contact_call text,contact_description text,last_call_time text,call_count integer,extra text)";
        result &= [db executeUpdate:createMadePhoneCallTable];
        
//        创建消息列表和消息记录
        NSString *createMessageListTable = @"create table if not exists t_message_list(message_nickname text,message_signing text,message_sex text,message_icon text,message_body text,message_fromjid text,message_tojid text,message_time text,message_text text)";
        result &= [db executeUpdate:createMessageListTable];

//        创建好友列表
        NSString *createFriendListTable = @"create table if not exists t_friend_list(friend_jid text,friend_name text,friend_subscription text,friend_group text,friend_from text,friend_given text,friend_residentid text,friend_fn text,friend_sex text,friend_nickname text,friend_binval text,friend_commmunity text,friend_address text,friend_home text,friend_extra text)";
        result &= [db executeUpdate:createFriendListTable];
        
        //创建群组列表
        NSString *createGroupListTable = @"create table if not exists t_group_list(groupid text,groupName text,orderIndex text)";
        result &= [db executeUpdate:createGroupListTable];
        
//        创建邻居好友列表
        NSString *createNeighboorhoodFriendListTable = @"create table if not exists t_neighboorhoodfriend_list(friend_userId text,friend_username text,friend_nickname text,friend_avatar text,friend_gender text,friend_ts text,friend_groupId text,friend_userType text,friend_updateTime text,friend_enabled text,friend_status text,friend_isDel text,friend_signature)";
        result &= [db executeUpdate:createNeighboorhoodFriendListTable];

        if (!result) {
            *rollback = YES;
            return;
        }

    }];

}
#pragma mark ---通知表
//插入数据
-(BOOL)inserNoticeModel:(NOticeModel *)model{
    if (model == nil) {
        NSLog(@"通知model插入为空");
       
        return NO;
    }
    BOOL flag = NO;
    [self deleteNoticeWithId:model.noticeId];
    if ([_fmdb open]) {
        flag = [_fmdb executeUpdate:@"insert into t_notification(notic_id,content_label,author,time,isUrl,extra) values(?,?,?,?,?,?)",[NSNumber numberWithInteger:model.noticeId],model.noticeContent,model.noticeTitle,model.noticeCreateTime,model.noticeIsUrl,model.extra];
    }
    [self closeDatabase];
    return flag;
}
//删除表数据
- (void) deleteNoticeWithId:(NSInteger) notic_id {
    if ([_fmdb open]) {
        NSString * query = [NSString stringWithFormat:@"DELETE FROM t_notification WHERE notic_id = '%d'",notic_id];
        NSLog(@"删除一条数据");
        [_fmdb executeUpdate:query];
    }
   
     [self closeDatabase];
}
//查询表
-(NSMutableArray *)selectNoticeModel
{
    NSMutableArray *mutableArry = [[[NSMutableArray alloc]init] autorelease];
    if ([_fmdb open]) {
        NSString * sql = @"select * from t_notification ORDER BY time DESC ";
        FMResultSet * notice = [_fmdb executeQuery:sql];
        while ([notice next]) {
            NOticeModel *model = [[[NOticeModel alloc]init] autorelease];
            model.noticeId = [notice intForColumn:@"notic_id"];
            model.noticeTitle = [notice stringForColumn:@"author"];
            model.noticeCreateTime = [notice stringForColumn:@"time"];
            model.noticeContent = [notice stringForColumn:@"content_label"];
            model.noticeIsUrl = [notice stringForColumn:@"isUrl"];
            model.extra = [notice stringForColumn:@"extra"];
            [mutableArry addObject:model];
//            [model release]; //add Vincent 内存释放
        }
    }
     [self closeDatabase];
    return mutableArry;
}

//查询表
-(NSInteger)selectUnreadNotice
{
    NSMutableArray *mutableArry = [[NSMutableArray alloc]init];
    if ([_fmdb open]) {
        NSString * sql = @"select * from t_notification where extra = '0'";
        FMResultSet * rs = [_fmdb executeQuery:sql];
        while ([rs next]) {
            NOticeModel *model = [[[NOticeModel alloc]init] autorelease];
            model.noticeId = [rs intForColumn:@"notic_id"];
            model.noticeTitle = [rs stringForColumn:@"author"];
            model.noticeCreateTime = [rs stringForColumn:@"time"];
            model.noticeContent = [rs stringForColumn:@"content_label"];
            model.noticeIsUrl = [rs stringForColumn:@"isUrl"];
            model.extra = [rs stringForColumn:@"extra"];
            [mutableArry addObject:model];
        }
    }
    [self closeDatabase];
    return [mutableArry count];
}

- (BOOL)updateNoticeModel:(NOticeModel *)model{
    BOOL flag = NO;
    if (model == nil) {
    NSLog(@"更新NoticeModel失败, model 为 nil");
        return flag;
     }
    if ([_fmdb open]) {
        NSString *sql = [NSString stringWithFormat:@"UPDATE t_notification set extra = %@ WHERE notic_id = '%@'", model.extra,[NSNumber numberWithInteger:model.noticeId]];
        flag = [_fmdb executeUpdate:sql];
    }
    [_fmdb close];
    return flag;
}

#pragma mark --- 规章制度
//插入数据
-(BOOL)inserRulesRegulationModel:(RulesRegulationModel *)model{
    if (model == nil) {
        NSLog(@"规章制度model插入为空");
        return NO;
    }
    BOOL flag = NO;
    [self deleteRuleRegulationById:model.ruleId];
    if ([_fmdb open]) {
        //先检查数据库中是否有该规章制度，有则先删除，没有直接插入
        flag = [_fmdb executeUpdate:@"insert into t_rulesregulation(rulesregulation_id,title,contentLabel,content,icon,isUrl,extra) values(?,?,?,?,?,?,?)",[NSNumber numberWithInteger:model.ruleId],model.title,model.contentLabel,model.content,model.icon,model.isUrl,[NSNumber numberWithBool:model.isRead]];
    }
    [self closeDatabase];
    return flag;
}

-(NSInteger)selectUnreadRules{
    NSMutableArray *mutableArry = [[[NSMutableArray alloc]init] autorelease];
    if ([_fmdb open]) {
        NSString * sql = @"select * from t_rulesregulation where extra = '0'";
        FMResultSet * rules = [_fmdb executeQuery:sql];
        while ([rules next]) {
            RulesRegulationModel *model = [[[RulesRegulationModel alloc]init] autorelease];
            model.ruleId = [rules intForColumn:@"rulesregulation_id"];
            model.title = [rules stringForColumn:@"title"];
            model.contentLabel = [rules stringForColumn:@"contentLabel"];
            model.content = [rules stringForColumn:@"content"];
            model.icon = [rules stringForColumn:@"icon"];
            model.isUrl = [rules stringForColumn:@"isUrl"];
            model.read = [rules boolForColumn:@"extra"];
            [mutableArry addObject:model];
        }
    }
    [self closeDatabase];
    return [mutableArry count];

}

-(NSMutableArray *)selectRulesRegulationModel
{
    NSMutableArray *mutableArry = [[[NSMutableArray alloc]init] autorelease];
    if ([_fmdb open]) {
        NSString * sql = @"select * from t_rulesregulation ORDER BY contentLabel DESC";
        FMResultSet * rules = [_fmdb executeQuery:sql];
        while ([rules next]) {
            RulesRegulationModel *model = [[[RulesRegulationModel alloc]init] autorelease];
            model.ruleId = [rules intForColumn:@"rulesregulation_id"];
            model.title = [rules stringForColumn:@"title"];
            model.contentLabel = [rules stringForColumn:@"contentLabel"];
            model.content = [rules stringForColumn:@"content"];
            model.icon = [rules stringForColumn:@"icon"];
            model.isUrl = [rules stringForColumn:@"isUrl"];
            model.read = [rules boolForColumn:@"extra"];
            [mutableArry addObject:model];
//            [model release]; //add Vincent 内存释放
        }
    }
    [self closeDatabase];
    return mutableArry;
}

- (BOOL)deleteRuleRegulationById:(NSInteger)ruleId{
    BOOL flag = NO;
    
    if ([_fmdb open]) {
         NSString *sql = [NSString stringWithFormat:@"DELETE from t_rulesregulation where rulesregulation_id = '%d'",ruleId];
        flag = [_fmdb executeUpdate:sql];
        
    }
    [_fmdb close];
    return flag;
}

- (BOOL)updateRuleRegulationById:(NSInteger)ruleId state:(BOOL)isRead{
    BOOL flag = NO;
    /*
     UPDATE t_contacts set contact_name = '%@',contact_call= '%@', contact_description = '%@' WHERE contact_id = '%@'
     */
    if ([_fmdb open]) {
        NSString *sql = [NSString stringWithFormat:@"UPDATE t_rulesregulation set extra = '%@' where rulesregulation_id = '%d'",[NSNumber numberWithBool:isRead],ruleId];
        flag = [_fmdb executeUpdate:sql];
        
    }
    [_fmdb close];
    return flag;
}

#pragma mark ---电话本
- (BOOL)insertContactsTypeModel:(ContactsTypeModel *)model{
    if (model == nil) {
        NSLog(@"插入ContactsTypeModel为空");
        return NO;
    }
    BOOL flag = NO;
    if ([_fmdb open]) {
        flag = [_fmdb executeUpdate:@"insert into t_contacts_type (type_id,type_name,update_time) values(?,?,?)",[NSNumber numberWithInteger:model.typeId],model.typeName,model.updateTime];
    }
    
    [self closeDatabase];
    return flag;
}
            
- (BOOL)insertContact:(ContactModel *)model{
    
    if (model == nil) {
        NSLog(@"插入ContactModel为空");
        return NO;
    }
    
    BOOL flag = NO;
    if ([_fmdb open]) {

        flag = [_fmdb executeUpdate:@"insert into t_contacts (contact_id,contact_name,contact_type,contact_type_name,contact_call,contact_description,last_call_time,call_count) values(?,?,?,?,?,?,?,?)"
                ,[NSNumber numberWithInteger:model.contactId]
                ,model.contactName
                ,model.type
                ,model.typeName
                ,model.phoneNumber,
                model.contactDescription,
                model.lastCallTime
                ,[NSNumber numberWithInteger:model.callCount]];
    }
    
    [self closeDatabase];
    
    return flag;
}

- (BOOL)deleteAllContactsByType:(NSInteger)type{

    BOOL flag = NO;
    if ([_fmdb open]) {
        NSString *sql = [NSString stringWithFormat:@"delete from t_contacts where contact_type = %d",type];
       flag = [_fmdb executeUpdate:sql];
    }
    
    [_fmdb close];
    
    return flag;
}

- (BOOL)deleteAllContactsType{
    
    /*
        type_id integer primary key,type_name text,update_time text
     */
    BOOL flag = NO;
    if ([_fmdb open]) {
        NSString *sql = @"delete from t_contacts_type";
         flag = [_fmdb executeUpdate:sql];
    }
    
    [_fmdb close];
    return flag;
}


/*
 FMResultSet *results = [appDelegate.datebase executeQuery:@"select p.personId personId,p.personName personName,d.deptName deptName from person p,dept d where p.deptid=d.deptid"];
 while ([results next])
 */
- (NSArray *)selectAllContactsType                      //查询所有电话本类型
{
    /*
        contacts_type (type_id integer primary key,type_name text,update_time text)
     */
    NSMutableArray *array = [NSMutableArray array];
    if ([_fmdb open]) {
        NSString *sql = [NSString stringWithFormat:@"select * from t_contacts_type"];
        FMResultSet *results = [_fmdb executeQuery:sql];
        while ([results next]) {
            
            ContactsTypeModel *model = [[[ContactsTypeModel alloc] init] autorelease];
            model.typeId = [results intForColumn:@"type_id"];
            model.typeName = [results stringForColumn:@"type_name"];
            model.updateTime = [results stringForColumn:@"update_time"];
            [array addObject:model];
        }
    }
    [_fmdb close];
    return array;
}
- (NSArray *)selectContactsbyType:(NSInteger)type       //查询某一类型的电话记录
{
    /*
        contacts(contact_id integer primary key,contact_name text,contact_type text,contact_type_name text,contact_call text,contact_description text,last_call_time text,call_count integer)     */
    NSMutableArray *array = [NSMutableArray array];
    if ([_fmdb open]) {
        NSString *sql = [NSString stringWithFormat:@"select * from t_contacts where contact_type = %d ORDER BY contact_id DESC",type];
        FMResultSet *results = [_fmdb executeQuery:sql];
        while ([results next]) {
            ContactModel *model = [[[ContactModel alloc] init] autorelease];
            model.contactId = [results intForColumn:@"contact_id"];
            model.contactName = [results stringForColumn:@"contact_name"];
            model.type = [results stringForColumn:@"contact_type"];
            model.typeName = [results stringForColumn:@"contact_type_name"];
            model.phoneNumber = [results stringForColumn:@"contact_call"];
            model.contactDescription = [results stringForColumn:@"contact_description"];
            model.lastCallTime = [results stringForColumn:@"last_call_time"];
            model.callCount = [results intForColumn:@"call_count"];
            
            [array addObject:model];
        }
    }
    [_fmdb close];
    return array;
}

- (BOOL)deleteMyContact:(ContactModel *)model          //删除一条我的电话
{
    BOOL flag = NO;
    if (model == nil) {
        NSLog(@"删除ContactModel失败, model 为 nil");
        return flag;
    }
    if ([_fmdb open]) {
        NSString *sql = [NSString stringWithFormat:@"DELETE FROM t_contacts WHERE contact_id = '%@'",[NSNumber numberWithInteger:model.contactId]];
        flag = [_fmdb executeUpdate:sql];
    }
    
    [_fmdb close];
    
    return flag;
}
- (BOOL)updateMyContact:(ContactModel *)model          //修改一条我的电话记录
{
    BOOL flag = NO;
    if (model == nil) {
        NSLog(@"更新ContactModel失败, model 为 nil");
        return flag;
    }
    if ([_fmdb open]) {
        NSString *sql = [NSString stringWithFormat:@"UPDATE t_contacts set contact_name = '%@',contact_call= '%@', contact_description = '%@' WHERE contact_id = '%@'",model.contactName,model.phoneNumber,model.contactDescription,[NSNumber numberWithInteger:model.contactId]];
        flag = [_fmdb executeUpdate:sql];
    }
    
    [_fmdb close];
    
    return flag;
}
#pragma mark ---update time
- (BOOL)insertRequestUpdateTime:(UpdateTimeModel *)model{
     BOOL flag = NO;
    if (model == nil) {
        NSLog(@"updateModel 为 空");
        return flag;
        
    }
    /*
        t_update_time(type text primary key,date text)
     */
    
    if ([self deleteUpdateModel:[model.type integerValue]]) {
        if ([_fmdb open]) {
            flag = [_fmdb executeUpdate:@"insert into t_update_time (type,date) values(?,?)"
                    ,model.type
                    ,model.date];
        }

    }
    
    [_fmdb close];
    return flag;
}

- (UpdateTimeModel *)selectUpdateTimeByInterface:(WInterface)type{
    
    UpdateTimeModel *model = [[[UpdateTimeModel alloc] init] autorelease];
    model.type = [NSString stringWithFormat:@"%d",type];
    if ([_fmdb open]) {
        NSString *sql = [NSString stringWithFormat:@"select * from t_update_time where type = %d",type];
        FMResultSet *results = [_fmdb executeQuery:sql];
        while ([results next]) {
            
            model.type = [results stringForColumn:@"type"];
            model.date = [results stringForColumn:@"date"];
            
            return model;
        }
    }
    [_fmdb close];
    
    return model;
}

- (BOOL)deleteUpdateModel:(WInterface)type{

    BOOL flag = NO;
    if (type) {
        if ([_fmdb open]) {
            NSString *sql = [NSString stringWithFormat:@"delete from t_update_time where type = %d",type];
            flag = [_fmdb executeUpdate:sql];
            
            if (flag) {
                NSLog(@"删除成功");
            }
        }
    }
    
    return flag;
}

#pragma mark ---Made phone call
- (BOOL)insertMadePhoneCall:(ContactModel *)model{
    if (model == nil) {
        NSLog(@"插入ContactModel为空");
        return NO;
    }
    
    BOOL flag = NO;
    if ([_fmdb open]) {
        NSString *delSql = [NSString stringWithFormat:@"DELETE from t_made_call where contact_id = %d",model.contactId];
        
        BOOL result = [_fmdb executeUpdate:delSql];
        
        NSLog(@"result:%d",result);

        flag = [_fmdb executeUpdate:@"insert into t_made_call (contact_id,contact_name,contact_type,contact_type_name,contact_call,contact_description,last_call_time,call_count) values(?,?,?,?,?,?,?,?)"
                ,[NSNumber numberWithInteger:model.contactId]
                ,model.contactName
                ,model.type
                ,model.typeName
                ,model.phoneNumber,
                model.contactDescription,
                model.lastCallTime
                ,[NSNumber numberWithInteger:model.callCount]];
    }
    
    [self closeDatabase];
    
    return flag;
}

- (NSArray *)selectAllMadePhoneCall{
    /*
     contacts(contact_id integer primary key,contact_name text,contact_type text,contact_type_name text,contact_call text,contact_description text,last_call_time text,call_count integer)     */
    NSMutableArray *array = [NSMutableArray array];
    if ([_fmdb open]) {
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM t_made_call ORDER BY last_call_time DESC"];
        FMResultSet *results = [_fmdb executeQuery:sql];
        while ([results next]) {
            ContactModel *model = [[[ContactModel alloc] init] autorelease];
            model.contactId = [results intForColumn:@"contact_id"];
            model.contactName = [results stringForColumn:@"contact_name"];
            model.type = [results stringForColumn:@"contact_type"];
            model.typeName = [results stringForColumn:@"contact_type_name"];
            model.phoneNumber = [results stringForColumn:@"contact_call"];
            model.contactDescription = [results stringForColumn:@"contact_description"];
            model.lastCallTime = [results stringForColumn:@"last_call_time"];
            model.callCount = [results intForColumn:@"call_count"];
            model.isRecently = YES;
            [array addObject:model];
        }
    }
    [_fmdb close];
    return array;
}

- (BOOL)deleteMadePhoneCall:(NSInteger)contactId{
    BOOL flag = NO;
    if ([_fmdb open]) {
        NSString *sql = [NSString stringWithFormat:@"DELETE from t_made_call where contact_id = %d",contactId];
        flag = [_fmdb executeUpdate:sql];
    }
    
    return flag;
}


//插入消息列表
- (BOOL)insertMessageList:(XmppMessageListModel *)model{
    if (model == nil) {
        NSLog(@"插入XmppMessageListModel为空");
        return NO;
    }
    NSLog(@"insert: body :%@ text:%@",model.bodyString,model.isRead);
    BOOL flag = NO;
    if ([_fmdb open]) {
        flag = [_fmdb executeUpdate:@"insert into t_message_list (message_nickname,message_signing,message_sex,message_icon,message_body,message_fromjid,message_tojid,message_time,message_text) values(?,?,?,?,?,?,?,?,?)"
                ,model.nickNameString
                ,model.signString
                ,model.sexString
                ,model.iconString
                ,model.bodyString
                ,model.fromJidString,
                model.toJidString,
                model.timeString,
                model.isRead
                ];
    }
    
    [self closeDatabase];
    
    return flag;
}
//删除消息列表
- (BOOL)deleteMessageList:(XmppMessageListModel *)model
{
    BOOL flag = NO;
    if (model == nil) {
        NSLog(@"删除XmppMessageListModel失败, model 为 nil");
        return flag;
    }
    //有问题，不能这样写
    if ([_fmdb open]) {
        NSArray *sepJids = [model.fromJidString componentsSeparatedByString:@"/"];
        if ([sepJids count] > 0) {
            NSString *jidString = [sepJids objectAtIndex:0];
            NSString *sql = [NSString stringWithFormat:@"DELETE FROM t_message_list WHERE message_fromjid like '%@%%'",jidString];
            flag = [_fmdb executeUpdate:sql];
        }

    }
    
    [_fmdb close];
    
    return flag;
}
//查询消息列表
-(NSMutableArray *)selectMessageList
{
    NSMutableArray *mutableArry = [[NSMutableArray alloc]init];
    if ([_fmdb open]) {
        NSString * sql = @"select * from t_message_list";
        FMResultSet * message = [_fmdb executeQuery:sql];
        while ([message next]) {
            XmppMessageListModel *model = [[XmppMessageListModel alloc]init];
            model.toJidString = [message stringForColumn:@"message_tojid"];
            model.fromJidString = [message stringForColumn:@"message_fromjid"];
            model.bodyString = [message stringForColumn:@"message_body"];
            model.iconString = [message stringForColumn:@"message_icon"];
            model.sexString = [message stringForColumn:@"message_sex"];
            model.nickNameString = [message stringForColumn:@"message_nickname"];
            model.signString = [message stringForColumn:@"message_signing"];
            model.timeString = [message stringForColumn:@"message_time"];
            model.isRead = [message stringForColumn:@"message_text"];
            [mutableArry addObject:model];
            [model release]; //add Vincent 内存释放
        }
    }
    [self closeDatabase];
    return mutableArry;
}

-(NSInteger)selectUnReadMessageList{
    NSMutableArray *mutableArry = [[[NSMutableArray alloc]init] autorelease];
    if ([_fmdb open]) {
        NSString * sql = @"select * from t_message_list where message_text = '0'";
        FMResultSet *message = [_fmdb executeQuery:sql];
        while ([message next]) {
            XmppMessageListModel *model = [[[XmppMessageListModel alloc]init] autorelease];
            model.toJidString = [message stringForColumn:@"message_tojid"];
            model.fromJidString = [message stringForColumn:@"message_fromjid"];
            model.bodyString = [message stringForColumn:@"message_body"];
            model.iconString = [message stringForColumn:@"message_icon"];
            model.sexString = [message stringForColumn:@"message_sex"];
            model.nickNameString = [message stringForColumn:@"message_nickname"];
            model.signString = [message stringForColumn:@"message_signing"];
            model.timeString = [message stringForColumn:@"message_time"];
            model.isRead = [message stringForColumn:@"message_text"];
            [mutableArry addObject:model];
        }
    }
    [self closeDatabase];
    return [mutableArry count];
    
}
//更新消息列表
- (BOOL)updateMessageList:(XmppMessageListModel *)model
{
    BOOL flag = NO;
    if (model == nil) {
        NSLog(@"更新XmppMessageListModel失败, model 为 nil");
        return flag;
    }
    if ([_fmdb open]) {
        //NSString *sql = [NSString stringWithFormat:@"UPDATE t_message_list set message_nickname = '%@', message_signing = '%@', message_sex = '%@', message_icon = '%@', message_body = '%@', message_time = '%@', message_tojid = '%@', message_text = '%@' WHERE message_fromjid = '%@'",model.nickNameString,model.signString,model.sexString,model.iconString,model.bodyString,model.timeString,model.toJidString,model.isRead,model.fromJidString];
        flag = [_fmdb executeUpdate:@"UPDATE t_message_list set message_nickname = ?, message_signing = ?, message_sex = ?, message_icon = ?, message_body = ?, message_time = ?, message_tojid = ?, message_text = ? WHERE message_fromjid = ?",model.nickNameString,model.signString,model.sexString,model.iconString,model.bodyString,model.timeString,model.toJidString,model.isRead,model.fromJidString];
    }
    
    [_fmdb close];
    
    return flag;
}
//add vincent
//插入好友信息
- (BOOL)insertFriendList:(FriendListDetailInfromation *)model{
    if (model == nil) {
        NSLog(@"插入FriendListDetailInfromation为空");
        return NO;
    }
    BOOL flag = NO;
    if ([_fmdb open]) {
        flag = [_fmdb executeUpdate:@"insert into t_friend_list (friend_jid,friend_name,friend_subscription,friend_group,friend_from,friend_given,friend_residentid,friend_fn,friend_sex,friend_nickname,friend_binval,friend_commmunity,friend_address,friend_home,friend_extra) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"
                ,model.friendJidString
                ,model.friendNameString
                ,model.friendSubscriptionString
                ,model.friendGruopString
                ,model.friendFromString
                ,model.friendGivenString,
                model.friendResidentidString,
                model.friendFnString,
                model.friendSexString,
                model.friendNickNameString,
                model.friendBinvalString,
                model.friendCommunityString,
                model.friendAddressString,
                model.friendHomeString,
                model.friendExtraString
                ];
    }
    
    [self closeDatabase];
    
    return flag;
}
//删除消息列表
- (BOOL)deleteFriendList:(FriendListDetailInfromation *)model
{
    BOOL flag = NO;
    if (model == nil) {
        NSLog(@"删除FriendListDetailInfromation失败, model 为 nil");
        return flag;
    }
    if ([_fmdb open]) {
        NSString *sql = [NSString stringWithFormat:@"DELETE FROM t_friend_list WHERE friend_jid = '%@'",model.friendJidString];
        flag = [_fmdb executeUpdate:sql];
    }
    
    [_fmdb close];
    
    return flag;
}
//根据group进行搜素当前的数组
-(NSMutableArray *)selectGroupList:(NSString *)modelString
{
    NSMutableArray *mutableArry = [[NSMutableArray alloc]init];
    if ([_fmdb open]) {
        NSString * sql = [NSString stringWithFormat:@"select * from t_friend_list where friend_group = '%@'",modelString];
        FMResultSet * message = [_fmdb executeQuery:sql];
        while ([message next]) {
            FriendListDetailInfromation *model = [[FriendListDetailInfromation alloc]init];
            model.friendJidString = [message stringForColumn:@"friend_jid"];
            model.friendNameString = [message stringForColumn:@"friend_name"];
            model.friendSubscriptionString = [message stringForColumn:@"friend_subscription"];
            model.friendGruopString = [message stringForColumn:@"friend_group"];
            model.friendFromString = [message stringForColumn:@"friend_from"];
            model.friendGivenString = [message stringForColumn:@"friend_given"];
            model.friendResidentidString = [message stringForColumn:@"friend_residentid"];
            model.friendFnString = [message stringForColumn:@"friend_fn"];
            model.friendSexString = [message stringForColumn:@"friend_sex"];
            model.friendNickNameString = [message stringForColumn:@"friend_nickname"];
            model.friendBinvalString = [message stringForColumn:@"friend_binval"];
            model.friendCommunityString = [message stringForColumn:@"friend_commmunity"];
            model.friendAddressString = [message stringForColumn:@"friend_address"];
            model.friendHomeString = [message stringForColumn:@"friend_home"];
            model.friendExtraString = [message stringForColumn:@"friend_extra"];
            [mutableArry addObject:model];
            [model release]; //add Vincent 内存释放
        }
    }
    [self closeDatabase];
    return mutableArry;
}
-(NSMutableArray *)selectFriendList
{
    NSMutableArray *mutableArry = [[NSMutableArray alloc]init];
    if ([_fmdb open]) {
        NSString * sql = @"select * from t_friend_list";
        FMResultSet * message = [_fmdb executeQuery:sql];
        while ([message next]) {
            FriendListDetailInfromation *model = [[FriendListDetailInfromation alloc]init];
            model.friendJidString = [message stringForColumn:@"friend_jid"];
            model.friendNameString = [message stringForColumn:@"friend_name"];
            model.friendSubscriptionString = [message stringForColumn:@"friend_subscription"];
            model.friendGruopString = [message stringForColumn:@"friend_group"];
            model.friendFromString = [message stringForColumn:@"friend_from"];
            model.friendGivenString = [message stringForColumn:@"friend_given"];
            model.friendResidentidString = [message stringForColumn:@"friend_residentid"];
            model.friendFnString = [message stringForColumn:@"friend_fn"];
            model.friendSexString = [message stringForColumn:@"friend_sex"];
            model.friendNickNameString = [message stringForColumn:@"friend_nickname"];
            model.friendBinvalString = [message stringForColumn:@"friend_binval"];
            model.friendCommunityString = [message stringForColumn:@"friend_commmunity"];
            model.friendAddressString = [message stringForColumn:@"friend_address"];
            model.friendHomeString = [message stringForColumn:@"friend_home"];
            model.friendExtraString = [message stringForColumn:@"friend_extra"];
            [mutableArry addObject:model];
            [model release]; //add Vincent 内存释放
        }
    }
    [self closeDatabase];
    return mutableArry;
}
//更好友信息列表
- (BOOL)updateFriendList:(FriendListDetailInfromation *)model
{
    BOOL flag = NO;
    if (model == nil) {
        NSLog(@"更新FriendListDetailInfromation失败, model 为 nil");
        return flag;
    }
    if ([_fmdb open]) {
        NSString *sql = [NSString stringWithFormat:@"UPDATE t_friend_list set friend_from = '%@', friend_given = '%@', friend_residentid = '%@', friend_fn = '%@', friend_sex = '%@', friend_nickname = '%@', friend_binval = '%@', friend_commmunity = '%@', friend_address = '%@' , friend_home = '%@' , friend_extra = '%@' WHERE friend_jid = '%@'",model.friendFromString,model.friendGivenString,model.friendResidentidString,model.friendFnString,model.friendSexString,model.friendNickNameString,model.friendBinvalString,model.friendCommunityString,model.friendAddressString,model.friendHomeString,model.friendExtraString,model.friendJidString];
        flag = [_fmdb executeUpdate:sql];
    }
    
    [_fmdb close];
    
    return flag;
}
-(NSMutableArray *)selectJidYesOrNo:(NSString *)jidString
{
    NSMutableArray *mutableArry = [[NSMutableArray alloc]init];
    if ([_fmdb open]) {
        NSString * sql = [NSString stringWithFormat:@"select * from t_friend_list where friend_jid = '%@'",jidString];
        FMResultSet * message = [_fmdb executeQuery:sql];
        while ([message next]) {
            FriendListDetailInfromation *model = [[FriendListDetailInfromation alloc]init];
            model.friendJidString = [message stringForColumn:@"friend_jid"];
            model.friendNameString = [message stringForColumn:@"friend_name"];
            model.friendSubscriptionString = [message stringForColumn:@"friend_subscription"];
            model.friendGruopString = [message stringForColumn:@"friend_group"];
            model.friendFromString = [message stringForColumn:@"friend_from"];
            model.friendGivenString = [message stringForColumn:@"friend_given"];
            model.friendResidentidString = [message stringForColumn:@"friend_residentid"];
            model.friendFnString = [message stringForColumn:@"friend_fn"];
            model.friendSexString = [message stringForColumn:@"friend_sex"];
            model.friendNickNameString = [message stringForColumn:@"friend_nickname"];
            model.friendBinvalString = [message stringForColumn:@"friend_binval"];
            model.friendCommunityString = [message stringForColumn:@"friend_commmunity"];
            model.friendAddressString = [message stringForColumn:@"friend_address"];
            model.friendHomeString = [message stringForColumn:@"friend_home"];
            model.friendExtraString = [message stringForColumn:@"friend_extra"];
            [mutableArry addObject:model];
            [model release]; //add Vincent 内存释放
        }
    }
    [self closeDatabase];
    return mutableArry;
}

//add vincent
//群主列表的数据操作
- (BOOL)insertGroupList:(GroupUserListModel *)model{
    if (model == nil) {
        NSLog(@"插入GroupUserListModel为空");
        return NO;
    }
    BOOL flag = NO;
    if ([_fmdb open]) {
        flag = [_fmdb executeUpdate:@"insert into t_group_list (groupid,groupName,orderIndex) values(?,?,?)"
                ,model.groupIdString
                ,model.groupNameString
                ,model.orderIndexString
                ];
    }
    
    [self closeDatabase];
    
    return flag;
}

//删除消群主
- (BOOL)deleteGroupList:(GroupUserListModel *)model
{
    BOOL flag = NO;
    if (model == nil) {
        NSLog(@"删除GroupUserListModel失败, model 为 nil");
        return flag;
    }
    if ([_fmdb open]) {
        NSString *sql = [NSString stringWithFormat:@"DELETE FROM t_group_list WHERE friend_jid = '%@'",model.groupIdString];
        flag = [_fmdb executeUpdate:sql];
    }
    
    [_fmdb close];
    
    return flag;
}

//更新群主列表
- (BOOL)updateGroupList:(GroupUserListModel *)model
{
    BOOL flag = NO;
    if (model == nil) {
        NSLog(@"更新GroupUserListModel失败, model 为 nil");
        return flag;
    }
    if ([_fmdb open]) {
        NSString *sql = [NSString stringWithFormat:@"UPDATE t_group_list set groupid = '%@', groupName = '%@', orderIndex = '%@'",model.groupIdString,model.groupNameString,model.orderIndexString];
        flag = [_fmdb executeUpdate:sql];
    }
    
    [_fmdb close];
    
    return flag;
}
//查询群主列表
-(NSMutableArray *)selectGroupList
{
    NSMutableArray *mutableArry = [[NSMutableArray alloc]init];
    if ([_fmdb open]) {
        NSString * sql = @"select * from t_group_list";
        FMResultSet * message = [_fmdb executeQuery:sql];
        while ([message next]) {
            GroupUserListModel *model = [[GroupUserListModel alloc]init];
            model.groupIdString = [message stringForColumn:@"groupid"];
            model.groupNameString = [message stringForColumn:@"groupName"];
            model.orderIndexString = [message stringForColumn:@"orderIndex"];
            [mutableArry addObject:model];
            [model release]; //add Vincent 内存释放
        }
    }
    [self closeDatabase];
    return mutableArry;
}

//插入邻居好友数据
- (BOOL)insertNeighboorHoodFriendList:(NeighboorHoodFriendList *)model{
    if (model == nil) {
        NSLog(@"插入NeighboorHoodFriendList为空");
        return NO;
    }
    BOOL flag = NO;
    if ([_fmdb open]) {
        flag = [_fmdb executeUpdate:@"insert into t_neighboorhoodfriend_list (friend_userId,friend_username,friend_nickname,friend_avatar,friend_gender,friend_ts,friend_groupId,friend_userType,friend_updateTime,friend_enabled,friend_status,friend_isDel,friend_signature) values(?,?,?,?,?,?,?,?,?,?,?,?,?)"
                ,model.userIdString
                ,model.usernameString
                ,model.nicknameString
                ,model.avatarString
                ,model.genderString
                ,model.tsString
                ,model.groupIdString
                ,model.userTypeString
                ,model.updateTimeString
                ,model.enabledString
                ,model.statusString
                ,model.isDelString
                ,model.signatureString
                ];
    }
    
    [self closeDatabase];
    
    return flag;
}
//删除好友
- (BOOL)deleteNeighBoorHoodFriendList:(NeighboorHoodFriendList *)model
{
    BOOL flag = NO;
    if (model == nil) {
        NSLog(@"删除NeighboorHoodFriendList失败, model 为 nil");
        return flag;
    }
    if ([_fmdb open]) {
        NSString *sql = [NSString stringWithFormat:@"DELETE FROM t_neighboorhoodfriend_list WHERE friend_userId = '%@'",model.userIdString];
        flag = [_fmdb executeUpdate:sql];
    }
    
    [_fmdb close];
    
    return flag;
}

-(NSMutableArray *)selectNeighborHoodFriend:(NSString *)jidString
{
    NSMutableArray *mutableArry = [[NSMutableArray alloc]init];
    if ([_fmdb open]) {
        NSString * sql = [NSString stringWithFormat:@"select * from t_neighboorhoodfriend_list where friend_username = '%@'",jidString];
        FMResultSet * message = [_fmdb executeQuery:sql];
        while ([message next]) {
            NeighboorHoodFriendList *model = [[NeighboorHoodFriendList alloc]init];
            model.userIdString = [message stringForColumn:@"friend_userId"];
            model.usernameString = [message stringForColumn:@"friend_username"];
            model.nicknameString = [message stringForColumn:@"friend_nickname"];
            model.avatarString = [message stringForColumn:@"friend_avatar"];
            model.genderString = [message stringForColumn:@"friend_gender"];
            model.tsString = [message stringForColumn:@"friend_ts"];
            model.groupIdString = [message stringForColumn:@"friend_groupId"];
            model.userTypeString = [message stringForColumn:@"friend_userType"];
            model.updateTimeString = [message stringForColumn:@"friend_updateTime"];
            model.enabledString = [message stringForColumn:@"friend_enabled"];
            model.statusString = [message stringForColumn:@"friend_status"];
            model.isDelString = [message stringForColumn:@"friend_isDel"];
            model.signatureString = [message stringForColumn:@"friend_signature"];
            [mutableArry addObject:model];
            [model release]; //add Vincent 内存释放
        }
    }
    [self closeDatabase];
    return mutableArry;
}


//根据groupId进行搜素当前的数组
-(NSMutableArray *)selectNeighboorHoodFriendList:(NSString *)modelString
{
    NSMutableArray *mutableArry = [[NSMutableArray alloc]init];
    if ([_fmdb open]) {
        NSString * sql = [NSString stringWithFormat:@"select * from t_neighboorhoodfriend_list where friend_groupId = '%@'",modelString];
        FMResultSet * message = [_fmdb executeQuery:sql];
        while ([message next]) {
            NeighboorHoodFriendList *model = [[NeighboorHoodFriendList alloc]init];
            model.userIdString = [message stringForColumn:@"friend_userId"];
            model.usernameString = [message stringForColumn:@"friend_username"];
            model.nicknameString = [message stringForColumn:@"friend_nickname"];
            model.avatarString = [message stringForColumn:@"friend_avatar"];
            model.genderString = [message stringForColumn:@"friend_gender"];
            model.tsString = [message stringForColumn:@"friend_ts"];
            model.groupIdString = [message stringForColumn:@"friend_groupId"];
            model.userTypeString = [message stringForColumn:@"friend_userType"];
            model.updateTimeString = [message stringForColumn:@"friend_updateTime"];
            model.enabledString = [message stringForColumn:@"friend_enabled"];
            model.statusString = [message stringForColumn:@"friend_status"];
            model.isDelString = [message stringForColumn:@"friend_isDel"];
            model.signatureString = [message stringForColumn:@"friend_signature"];
            [mutableArry addObject:model];
            [model release]; //add Vincent 内存释放
        }
    }
    [self closeDatabase];
    return mutableArry;
}
-(NSMutableArray *)selectNeighboorHoodList
{
    NSMutableArray *mutableArry = [[NSMutableArray alloc]init];
    if ([_fmdb open]) {
        NSString * sql = @"select * from t_neighboorhoodfriend_list";
        FMResultSet * message = [_fmdb executeQuery:sql];
        while ([message next]) {
            NeighboorHoodFriendList *model = [[NeighboorHoodFriendList alloc]init];
            model.userIdString = [message stringForColumn:@"friend_userId"];
            model.usernameString = [message stringForColumn:@"friend_username"];
            model.nicknameString = [message stringForColumn:@"friend_nickname"];
            model.avatarString = [message stringForColumn:@"friend_avatar"];
            model.genderString = [message stringForColumn:@"friend_gender"];
            model.tsString = [message stringForColumn:@"friend_ts"];
            model.groupIdString = [message stringForColumn:@"friend_groupId"];
            model.userTypeString = [message stringForColumn:@"friend_userType"];
            model.updateTimeString = [message stringForColumn:@"friend_updateTime"];
            model.enabledString = [message stringForColumn:@"friend_enabled"];
            model.statusString = [message stringForColumn:@"friend_status"];
            model.isDelString = [message stringForColumn:@"friend_isDel"];
            model.signatureString = [message stringForColumn:@"friend_signature"];
            [mutableArry addObject:model];
            [model release]; //add Vincent 内存释放
        }
    }
    [self closeDatabase];
    return mutableArry;
}
//更好友信息列表
- (BOOL)updateNeighboorHoodFriendList:(NeighboorHoodFriendList *)model
{
    BOOL flag = NO;
    if (model == nil) {
        NSLog(@"更新updateNeighboorHoodFriendList失败, model 为 nil");
        return flag;
    }
    if ([_fmdb open]) {
        NSString *sql = [NSString stringWithFormat:@"UPDATE t_neighboorhoodfriend_list set friend_userId = '%@', friend_username = '%@', friend_nickname = '%@', friend_avatar = '%@', friend_gender = '%@', friend_ts = '%@', friend_groupId = '%@', friend_userType = '%@', friend_updateTime = '%@' , friend_enabled = '%@' , friend_status = '%@' , friend_isDel = '%@' ,friend_signature = '%@' , WHERE friend_userId = '%@'",model.userIdString,model.usernameString,model.nicknameString,model.avatarString,model.genderString,model.tsString,model.groupIdString,model.userTypeString,model.updateTimeString,model.enabledString,model.statusString,model.isDelString,model.signatureString,model.userIdString];
        flag = [_fmdb executeUpdate:sql];
    }
    
    [_fmdb close];
    
    return flag;
}

@end
