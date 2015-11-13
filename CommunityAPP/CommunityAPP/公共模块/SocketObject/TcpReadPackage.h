//
//  TcpReadPackage.h
//  ql
//
//  Created by yunlai on 14-5-3.
//  Copyright (c) 2014年 LuoHui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TcpReadPackage : NSObject {
    
    NSMutableData *_data;
    
    int _allLength;
}


@property (nonatomic, assign)BOOL isReadFinish; //是否读取完成

///读入data 返回读进去的数量
- (int)appendData:(NSData *)data;

@end
