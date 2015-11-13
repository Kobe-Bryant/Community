//
//  UIImage+MyInfo.h
//  CommunityAPP
//
//  Created by Stone on 14-4-9.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger, YLPhotoComeFrom){
    YLPhotoFromServer       = 0,
    YLPhotoFromLibrary      = 1,
    YLPhotoFromCamera       = 2,
};

@interface UIImage (MyInfo)

@property (nonatomic, retain) NSString *urlStr;

@property (nonatomic, assign) YLPhotoComeFrom photoComeFrom;

//@property (nonatomic, assign)


@end
