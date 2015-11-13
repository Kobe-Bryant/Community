//
//  RuleRegulationManager.m
//  CommunityAPP
//
//  Created by liuzhituo on 14-3-8.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import "RuleRegulationManager.h"

#import "Global.h"
#import "ASIWebServer.h"
#import "UserModel.h"
#import "DataBaseManager.h"
#import "UpdateTimeModel.h"

@interface RuleRegulationManager ()<WebServiceHelperDelegate>

@property (nonatomic, assign) WInterface interface;

@property (nonatomic, retain) DataBaseManager *dbManager;

@end

@implementation RuleRegulationManager

@synthesize interface = _interface;

+ (RuleRegulationManager *)shareInstance{
    static RuleRegulationManager *instance = nil;
    if (instance == nil) {
        instance = [[RuleRegulationManager alloc] init];
    }
    
    return instance;
    
}

- (void)dealloc{
    [super dealloc];
}

- (id)init{
    self = [super init];
    
    if (self) {

    }
    
    return self;
}
- (NSString *)getUrl{
    return HTTPURLPREFIX;//域名
}

- (NSString *)getUrlParameter{
    DataBaseManager *dbManager = [DataBaseManager shareDBManeger];
    UpdateTimeModel *model = [dbManager selectUpdateTimeByInterface:COMMUNITY_RULES_LIST];
    NSLog(@"%@",model.date);
    UserModel *userModel = [UserModel shareUser];
    NSString *string = [NSString stringWithFormat:@"?userId=%@&communityId=%@&propertyId=%@&updateTime=%@",userModel.userId,userModel.communityId,userModel.propertyId,model.date];//参数
    
    return string;
}

- (NSString *)getMethodName{
    return RULES_LIST_URL;//url
}
- (void)getRuleRegulation{
    NSString *url = [self getUrl];
    NSString *urlPara = [self getUrlParameter];
    NSString *methodName = [self getMethodName];
    _interface = COMMUNITY_RULES_LIST;
    
    ASIWebServer *webServer = [ASIWebServer shareController];
    [webServer sendRequestWithEnvironment:url bodyUrlString:urlPara byMethodName:methodName byInterface:_interface byCallBackDelegate:self showLoad:NO];
}
-(void) callBackWith: (WInterface) interface status: (NSString*) status data:(id) data{
    
    if (interface == _interface) {
        if ([status isEqualToString:NETWORK_RETURN_CODE_S_OK]) {   //请求数据成功
            if ([self.delegate respondsToSelector:@selector(shareRuleRegulationSucceed:)]) {
                NSString *code = [data objectForKey:ERROR_CODE];
                if ([code isEqualToString:NETWORK_RETURN_CODE_S_OK]) {
                    UpdateTimeModel *updateModel = [[UpdateTimeModel alloc] init];
                    updateModel.type = [NSString stringWithFormat:@"%d",COMMUNITY_RULES_LIST];
                    updateModel.date = [data objectForKey:@"updateTime"];
                    _dbManager = [DataBaseManager shareDBManeger];
                    BOOL flag = [_dbManager insertRequestUpdateTime:updateModel];
                    if (flag) {
                        NSLog(@"插入更新时间成功");
                    }
                    [updateModel release];
                    
                    NSArray *array = [data objectForKey:@"rules"];
                    for (NSDictionary *dic in array) {
                        RulesRegulationModel  *model = [[[RulesRegulationModel alloc]init] autorelease];
                        model.ruleId = [[dic objectForKey:@"id"] integerValue];
                        model.title = [dic objectForKey:@"title"];
                        model.contentLabel = [dic objectForKey:@"createTime"];
                        model.content = [dic objectForKey:@"content"];
                        model.icon = [dic objectForKey:@"icon"];
                        model.isUrl = [dic objectForKey:@"isUrl"];
                        model.read = NO;
                        //插入数据
                        BOOL flag = [_dbManager inserRulesRegulationModel:model];
                        if (flag) {
                            NSLog(@"插入成功");
                        }
                    }
                    
                }
                [self.delegate shareRuleRegulationSucceed:data];
                
            }
        }
        else{   //请求数据失败
            if ([self.delegate respondsToSelector:@selector(shareRuleRegulationFailed:)]) {
                [self.delegate shareRuleRegulationFailed:data];
            }
        }
    }
}
@end
