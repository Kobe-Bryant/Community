//
//  RuleRegulationManager.h
//  CommunityAPP
//
//  Created by liuzhituo on 14-3-8.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol RuleRegulationDelegate;
@interface RuleRegulationManager : NSObject

@property (nonatomic, assign) id<RuleRegulationDelegate> delegate;

@property (nonatomic, retain, readonly) NSMutableArray *rules;

+ (instancetype)shareInstance;

- (void)getRuleRegulation;



@end


@protocol RuleRegulationDelegate <NSObject>

- (void)shareRuleRegulationSucceed:(id)response;

- (void)shareRuleRegulationFailed:(id)response;

@end