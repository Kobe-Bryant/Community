//
//  RegisterViewController.h
//  CommunityAPP
//
//  Created by Dream on 14-3-19.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommunityHttpRequest.h"
#import "MBProgressHUD.h"
#import "IssueViewController.h"

@interface RegisterViewController : UIViewController<UITextFieldDelegate>
{
    UITextField *registerField;
    
    CommunityHttpRequest *request;
    
    MBProgressHUD *hudView;
}

//@property(nonatomic,retain)NSDictionary *codeDictionary;
@end
