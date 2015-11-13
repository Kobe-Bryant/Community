//
//  ModifyPasswordViewController.h
//  CommunityAPP
//
//  Created by Dream on 14-3-21.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface ModifyPasswordViewController : UIViewController<UITextFieldDelegate>
{
    UITextField *newPasswordField;
     MBProgressHUD *hudView;
}
@end
