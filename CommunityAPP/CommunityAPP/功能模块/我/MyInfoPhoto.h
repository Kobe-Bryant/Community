//
//  MyInfoPhoto.h
//  CommunityAPP
//
//  Created by Stone on 14-4-9.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIImage+extra.h"
#import "UIImage+MyInfo.h"

typedef NS_ENUM(NSInteger, PhotoState){
    YLStateNormal           =       0,
    YLStateUploading        =       1,
    YLStateDownloading      =       2,
    YLStateUploadFailed     =       3,
    YLStateDownloadFailed   =       4,
};


typedef NS_ENUM(NSInteger, PhotoDeatilType){
    YLPHotoADD              =       0,
    YLPhotoUpdate           =       1,
    YLPhotoDelete           =       2,
};

@interface MyInfoPhoto : NSObject

@property (nonatomic, retain) UIImage *image;

@property (nonatomic, assign) YLPhotoComeFrom photoComeFrom;

@property (nonatomic, retain) NSString *strUrl;

@property (nonatomic, assign) PhotoState photoState;

@property (nonatomic, assign) NSInteger photoIndex;

@property (nonatomic, retain) NSString *fileName;

@property (nonatomic, assign) BOOL isIcon;

@property (nonatomic, retain) NSString *imageId;

@property (nonatomic, assign) PhotoDeatilType detailType;

@end
