//
//  UploadManager.h
//  CommunityAPP
//
//  Created by Stone on 14-4-9.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "ASINetworkQueue.h"

@interface UploadManager : NSObject{
    ASINetworkQueue*  _networkQueue;
}

- (id)shareInstance;

@end
