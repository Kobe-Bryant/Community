//
//  ChartMessage.m
//  气泡
//
//  Created by zzy on 14-5-13.
//  Copyright (c) 2014年 zzy. All rights reserved.
//

#import "ChartMessage.h"

@implementation ChartMessage

-(void)setDict:(NSDictionary *)dict
{
    self.dict = dict;
    self.icon = [dict objectForKey:@"icon"];
//  self.time=dict[@"time"];
    self.content = [dict objectForKey:@"content"];
    self.messageType = [[dict objectForKey:@"type"] intValue];
}
@end
