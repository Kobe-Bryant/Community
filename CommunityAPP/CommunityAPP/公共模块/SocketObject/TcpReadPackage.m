//
//  TcpReadPackage.m
//  ql
//
//  Created by yunlai on 14-5-3.
//  Copyright (c) 2014年 LuoHui. All rights reserved.
//

#import "TcpReadPackage.h"

@implementation TcpReadPackage


- (int)appendData:(NSData *)data {
    //包头的长度
    int lengthOfHead = 32;
    
    ///如果当前所拼接的数据小于包头，则。。。
    int resultLength = data.length + _data.length;
    
    int readLength = 0;
    
    
    //补齐包头
    if (_data.length < lengthOfHead) {
        
        if (resultLength <= lengthOfHead) {
            
            [_data appendData:data];
            readLength += data.length;
            
        }else {
            
            int chaLength = lengthOfHead - _data.length;
            [_data appendData:[data subdataWithRange:NSMakeRange(_data.length, chaLength)]];
            readLength += chaLength;
            
            ///表示还有剩下的数据
            data = [data subdataWithRange:NSMakeRange(_data.length-1, lengthOfHead-_data.length+1)];
        }
    }
    
    //判断包头是否补满了
    if (data.length==lengthOfHead && _allLength==0) {
        //获取包总共的大小
        _allLength=100;
    }
    
    if (data.length>0 && _allLength>0) {
        
        int canReadDataCount = [self readDataFromData:data withLength:_allLength - lengthOfHead];
        readLength+=canReadDataCount;
    
    }
    if (_data.length == _allLength && _allLength>0) {
        _isReadFinish = YES;
    }
    
    return readLength;
    
}


///从data读取长度为length的数据  ，如果data的总长度小于length 则全部读取 返回实际读取的数量， 如果只需要读一部分，就读一部分，并返回实际读取的数据长度
- (int)readDataFromData:(NSData *)data withLength:(int)length {
    
    if (data.length<=length) {
        
        [_data appendData:data];
        return _data.length;
        
    }
    else {
        
        [_data appendData:[data subdataWithRange:NSMakeRange(0, length)]];
        return length;
    
    }
    
    
    return 0;
}

@end
