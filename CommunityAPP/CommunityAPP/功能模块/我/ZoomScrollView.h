//
//  ZoomScrollView.h
//  CommunityAPP
//
//  Created by Stone on 14-4-11.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MyInfoPhoto.h"

@interface ZoomScrollView : UIScrollView

@property (nonatomic, retain) UIImageView *imageView;

@property (nonatomic, retain) MyInfoPhoto *myInfoPhoto;

@end
