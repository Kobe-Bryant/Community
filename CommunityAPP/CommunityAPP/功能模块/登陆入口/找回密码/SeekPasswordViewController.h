//
//  SeekPasswordViewController.h
//  CommunityAPP
//
//  Created by Dream on 14-3-20.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
@interface SeekPasswordViewController : UIViewController<UITextFieldDelegate>
{
    UITextField *numberField;
    MBProgressHUD *hudView;
}

@end
