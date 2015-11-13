//
//  TcpOperation.h
//  ql
//
//  Created by yunlai on 14-5-3.
//  Copyright (c) 2014年 LuoHui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TcpReadPackage.h"

//tcp操作类
@interface TcpOperation : NSObject {
    NSMutableArray *_operationQueue;
    
    TcpReadPackage *_currentPackage;
    
    dispatch_queue_t _serialQueue;
    
    BOOL *_isParser;
}
// 单列
+ (TcpOperation *)shareTcpOperation;

// 操作接收的数据
- (void)addAPackage:(TcpReadPackage *)package commandType:(int)type packageData:(NSData *)data;

@end
