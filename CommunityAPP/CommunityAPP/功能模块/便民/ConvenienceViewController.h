//
//  ConvenienceViewController.h
//  CommunityAPP
//
//  Created by yunlai on 14-3-4.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "DPRequest.h"

@interface ConvenienceViewController : UIViewController<DPRequestDelegate>
{
    UIScrollView *contentScrollView;
    MBProgressHUD *hudView;
    
//    NSString *currentString;
}
@property(nonatomic,retain)NSMutableDictionary *listDictionary;
@end
