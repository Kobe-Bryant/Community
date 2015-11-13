//
//  LoginViewController.h
//  CommunityAPP
//
//  Created by Dream on 14-3-19.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

typedef NS_ENUM(NSInteger, LOGINTYPE){
        LOGIN_NORMAL,       //正常登陆模式
        LOGIN_MODAL,        //模态登陆
};

@interface LoginViewController : UIViewController<UITextFieldDelegate>
{
    UITextField *phoneField;//手机号输入
    UITextField *passwordField;//密码输入
    
    MBProgressHUD *hudView;
}

@property (nonatomic, assign) LOGINTYPE loginType;


@end
