//
//  RulesRegulationModel.h
//  CommunityAPP
//
//  Created by Dream on 14-3-12.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RulesRegulationModel : NSObject
@property (nonatomic,assign) NSInteger ruleId;
@property (nonatomic,retain) NSString *title;
@property (nonatomic,retain) NSString *contentLabel;
@property (nonatomic,retain) NSString *content;
@property (nonatomic,retain) NSString *icon;
@property (nonatomic,retain) NSString *isUrl;

@property (nonatomic, assign ,getter = isRead) BOOL read;

@end
