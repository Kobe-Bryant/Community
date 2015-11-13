//
//  ResignPasswordViewController.h
//  CommunityAPP
//
//  Created by Dream on 14-3-20.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
@interface ResignPasswordViewController : UIViewController<UITextFieldDelegate>
{
    UITextField *passwordField;
    MBProgressHUD *hudView;
}
@property (nonatomic,retain) NSString *passStr1;
@end
