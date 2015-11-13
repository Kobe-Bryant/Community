//
//  ShareContentViewController.h
//  CommunityAPP
//
//  Created by Stone on 14-4-21.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ShareSDK/ShareSDK.h>

@interface ShareContentViewController : UIViewController

@property (nonatomic, assign) ShareType shareType;

- (id) initWithContent:(NSString *)content;


@end
