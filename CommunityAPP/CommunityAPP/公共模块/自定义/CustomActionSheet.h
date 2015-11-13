//
//  CustomActionSheet.h
//  WOW
//
//  Created by jiayi on 13-3-25.
//  Copyright (c) 2013年 贾 朝阳. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CustomButton;

@interface CustomActionSheet : UIActionSheet

@property (nonatomic,retain) CustomButton  *rButton;
@property (nonatomic,retain) NSString      *shareTitle;
@property (nonatomic,retain) UIImage       *shareImage;
@property (nonatomic,retain) NSString      *shareURL;
@end
