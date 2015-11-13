//
//  CMBPNotification.m
//  CommunityAPP
//
//  Created by Stone on 14-5-27.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import "CMBPNotification.h"
#import "CommunityHttpRequest.h"
#import "UpdateTimeModel.h"
#import "UserModel.h"
#import "DataBaseManager.h"
#import "ASIWebServer.h"
#import "MyCommentModel.h"
#import "RuleRegulationManager.h"

@interface CMBPNotification ()<WebServiceHelperDelegate>

@property (nonatomic, retain) CommunityHttpRequest *request;
@property (nonatomic, retain) DataBaseManager *dbManager;

@end

@implementation CMBPNotification

+ (CMBPNotification *)shareInstance{
    static CMBPNotification *instance = nil;
    if (instance == nil) {
        instance = [[CMBPNotification alloc] init];
    }
    return instance;
}

- (void)dealloc{
    [_request cancelDelegate:self];
    [super dealloc];
}

- (id)init{
    self = [super init];
    if (self) {
        _noticesArray = [[NSMutableArray alloc] init];
        _myComments = [[NSMutableArray alloc] init];
        self.isCommentRead = YES;
        self.isBillRead = YES;
    }
    return self;
}

- (void)applicationLaunchNotification{
    if ([UserModel isLogin]) {
        [[CMBPNotification shareInstance] requestCommunityNotification];
        //[[CMBPNotification shareInstance] requestMyComments];

    }
}


#pragma mark ---network
- (void)requestCommunityNotification{
    // 网络请求ß®
    if (_request == nil) {
        _request = [CommunityHttpRequest shareInstance];
    }
    _dbManager = [DataBaseManager shareDBManeger];
    UpdateTimeModel *model = [_dbManager selectUpdateTimeByInterface:COMMUNITY_NOTICE_INFO];
    UserModel *userModel = [UserModel shareUser];
    NSString *parameters = [NSString stringWithFormat:@"?%@=%@&%@=%@&%@=%@&%@=%@",UPDATE_TIME,model.date,USER_ID,userModel.userId,COMMUNITY_ID,userModel.communityId,PROPERTY_ID,userModel.propertyId];//参数
    NSLog(@"parameters %@",parameters);
    [_request requestNotice:self parameters:parameters];
}

- (void)requestMyBills{
    if (_request == nil) {
        _request = [CommunityHttpRequest shareInstance];
    }
    UserModel *userModel = [UserModel shareUser];
    NSString *string = [NSString stringWithFormat:@"?updateTime=%@&userId=%@&communityId=%@&propertyId=%@&lastTimeLabel=%@",DEF_UPDATE_TIME,userModel.userId,userModel.communityId,userModel.propertyId,@""];//参数
    [_request requestBillList:self parameters:string];
}

- (void)requestMyPublish{
    RuleRegulationManager *manager = [RuleRegulationManager shareInstance];
    [manager getRuleRegulation];
}

- (void)requestMyComments{
    //加载网络数据
    if (_request == nil) {
        _request = [CommunityHttpRequest shareInstance];
    }
    UserModel *userModel = [UserModel shareUser];
    NSString *userIdString = userModel.userId;
    NSString *parameters = [NSString stringWithFormat:@"?%@=%@&%@=%@&%@=%@&lastId=%d",USER_ID,userIdString ,COMMUNITY_ID,userModel.communityId,PROPERTY_ID,userModel.propertyId,0];//参数
    [_request requestMyComment:self parameters:parameters];
}

- (void)requestRuleRegulations{
    
}


-(void) callBackWith: (WInterface) interface status: (NSString*) status data:(id) data{
    if (interface == COMMUNITY_NOTICE_INFO) {
        if ([data isKindOfClass:[NSDictionary class]]) {
            NSString *code = [data objectForKey:ERROR_CODE];
            if ([code isEqualToString:NETWORK_RETURN_CODE_S_OK]) {
                UpdateTimeModel *updateModel = [[UpdateTimeModel alloc] init];
                updateModel.type = [NSString stringWithFormat:@"%d",COMMUNITY_NOTICE_INFO];
                updateModel.date = [data objectForKey:@"updateTime"];
                _dbManager = [DataBaseManager shareDBManeger];
                BOOL flag = [_dbManager insertRequestUpdateTime:updateModel];
                if (flag) {
                    NSLog(@"插入更新时间成功");
                }
                [updateModel release];
                
                NSArray *array = [data objectForKey:@"attentions"];
                for (NSDictionary *dic in array) {
                    NOticeModel  *model = [[[NOticeModel alloc]init] autorelease];
                    model.noticeId = [[dic objectForKey:@"id"] integerValue];
                    model.noticeTitle = [dic objectForKey:@"title"];
                    model.noticeContentLabel = [dic objectForKey:@"contentLabel"];
                    model.noticeCreateTime = [dic objectForKey:@"createTime"];
                    model.noticeIsUrl = [dic objectForKey:@"isUrl"];
                    model.noticeContent = [dic objectForKey:@"content"];
                    model.extra = [NSString stringWithFormat:@"0"];
                    
                    //0代表未读  1代表已读
                    //插入数据
                    BOOL flag = [_dbManager inserNoticeModel:model];
                    if (flag) {
                        NSLog(@"插入成功");
                    }
                    [self.noticesArray addObject:model];
                }
                
                [[NSNotificationCenter defaultCenter] postNotificationName:kCMBPNotice object:nil];
            }
            

        }else{
            NSLog(@"获取通知失败");
        }
        
    }else if (interface == COMMUNITY_SEEK_MYCOMMENT){   //我的评论
        
        NSString *code = [data objectForKey:ERROR_CODE];
        if ([code isEqualToString:NETWORK_RETURN_CODE_S_OK]){
            
            NSArray *array = [data objectForKey:@"commentvo"];
            for (NSDictionary *dic in array) {
                MyCommentModel *model = [[MyCommentModel alloc]init];
                model.mycommentId = [[dic objectForKey:@"id"] integerValue];
                model.mycommentResidentId = [dic objectForKey:@"residentId"];
                model.mycommentResidentIcon = [dic objectForKey:@"residentIcon"];
                model.mycommentResidentName = [dic objectForKey:@"residentName"];
                model.mycommentCommentId = [dic objectForKey:@"commentId"];
                model.mycommentModuleTypeId = [[dic objectForKey:@"moduleTypeId"] integerValue];
                model.mycommentRemark = [dic objectForKey:@"remark"];
                model.mycommentCreateTime = [dic objectForKey:@"createTime"];
                [self.myComments addObject:model];
                [model release];//add vincent
            }
            self.isCommentRead = NO;
            [[NSNotificationCenter defaultCenter] postNotificationName:kCMBPMyComments object:nil];
        }else{
            NSLog(@"评论请求失败");
        }
        
        
        
        
    }else if (interface == COMMUNITY_BILL_LIST_URL){     //我的账单列表
        NSString *code = [data objectForKey:ERROR_CODE];
        if ([code isEqualToString:NETWORK_RETURN_CODE_S_OK]){
            
            self.isBillRead = NO;
            [[NSNotificationCenter defaultCenter] postNotificationName:kCMBPMyBills object:nil];
        }else{
            NSLog(@"账单通知请求失败");
        }

    }
}


@end
