//
//  RealRegisterViewController.h
//  CommunityAPP
//
//  Created by Dream on 14-3-19.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommunityHttpRequest.h"
#import "MBProgressHUD.h"

@interface RealRegisterViewController : UIViewController<UITextFieldDelegate>
{
    UITextField *phoneField;
    UITextField *passField;
    UITextField *testField;
    
    UIButton *testBtn;//验证码button
    
    CommunityHttpRequest *request;
    
    MBProgressHUD *hudView;
    
    UIActivityIndicatorView *indicatorView;
    
    int  second;
    
    NSTimer *timer;
}
@property(nonatomic,retain)NSString *inviteCodeString;
@property(nonatomic,retain)NSDictionary *codeDictionary;
@end
