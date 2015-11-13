//
//  LoginViewController.m
//  CommunityAPP
//
//  Created by Dream on 14-3-19.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import "LoginViewController.h"
#import "Global.h"
#import "NSObject_extra.h"
#import "RegisterViewController.h"
#import "SeekPasswordViewController.h"
#import "AppDelegate.h"
#import "CommunityHttpRequest.h"
#import "ASIWebServer.h"
#import "UserModel.h"
#import "AppConfig.h"
#import "Reachability.h"
#import "MobClick.h"

@interface LoginViewController ()<WebServiceHelperDelegate>

@property (nonatomic, retain) CommunityHttpRequest *request;

@end

@implementation LoginViewController{
    
    NSInteger requestTimes;
}

@synthesize request = _request;

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_request cancelDelegate:self];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _loginType = LOGIN_NORMAL;
        requestTimes = 0;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];

    self.view.backgroundColor = [UIColor whiteColor];
    //title图片 pic_xiaoqubao.png    pic_yishequ.png
     UIImage *logoImg = [UIImage imageNamed:@"pic_xiaoqubao.png"];
    
    if ([APP_NAME isEqualToString:@"小区宝"]) {
        logoImg = [UIImage imageNamed:@"pic_xiaoqubao.png"];
    } else if ([APP_NAME isEqualToString:@"壹社区"]){
        logoImg = [UIImage imageNamed:@"pic_yishequ.png"];
    }else{
        logoImg = [UIImage imageNamed:@"pic_xiaoqubao.png"];
    }
    
    UIImageView *titleImg = [self newImageViewWithImage:logoImg frame:CGRectMake(11, 100, logoImg.size.width, logoImg.size.height)];
    [self.view addSubview:titleImg];
    [titleImg release];

    //手机号输入框
    phoneField = [[UITextField alloc]initWithFrame:CGRectMake(10, 210,ScreenWidth-20 , 40)];
    phoneField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;//字体垂直居中对齐
    phoneField.clearButtonMode = UITextFieldViewModeWhileEditing;
    phoneField.font = [UIFont systemFontOfSize:16.0];
    phoneField.placeholder = @"电话号";
    phoneField.borderStyle = UITextBorderStyleNone;
    phoneField.background = APP_imageStrench;
    phoneField.keyboardType = UIKeyboardTypeNumberPad;
    //设置光标坐标
    UIView *phoneView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 11, 0)];
    phoneField.leftView = phoneView;
    phoneField.leftViewMode = UITextFieldViewModeAlways;
    [phoneView release];
    [self.view addSubview:phoneField];
    [phoneField release];

    //密码输入框
    passwordField = [[UITextField alloc]initWithFrame:CGRectMake(10, 260,ScreenWidth-20 , 40)];
    passwordField.clearButtonMode = UITextFieldViewModeWhileEditing;
    passwordField.font = [UIFont systemFontOfSize:16.0];
    passwordField.placeholder = @"密码";
    passwordField.borderStyle = UITextBorderStyleNone;
    passwordField.delegate = self;
    passwordField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;//字体垂直居中对齐
    passwordField.keyboardType = UIKeyboardTypeDefault;
    passwordField.returnKeyType = UIReturnKeyDone;
    passwordField.background = APP_imageStrench;
    //设置光标坐标
    UIView *passwordView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 11, 0)];
    passwordField.leftView = passwordView;
    passwordField.leftViewMode = UITextFieldViewModeAlways;
    passwordField.secureTextEntry = YES;
    [self.view addSubview:passwordField];
    [passwordView release];
    [passwordField release];
    
//    //密码uiswitch
//    UISwitch *passSwitch = [[UISwitch alloc]initWithFrame:CGRectMake(240, 5, 60, 25)];
//    passSwitch.on = NO;
//    [passSwitch addTarget:self action:@selector(secureChange:) forControlEvents:UIControlEventValueChanged];
//    [backPasswordField addSubview:passSwitch];
//    [passSwitch release];
//    if (IOS6_OR_LATER) {
//        passSwitch.frame = CGRectMake(220, 5, 60, 25);
//    }
    
    //[[UISwitch appearance] setOnImage:[UIImage imageNamed:@"tb_switch_thumb.png"]];
    //[[UISwitch appearance] setOffImage:[UIImage imageNamed:@"tb_switch_track.png"]];
    
   // UIImage *resizableImage = [layerNormal resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5)];
    
    // zhuce账号按钮
     UIImage *registerImage = [UIImage imageNamed:@"bg_asign_shouye.png"];
    UIButton *registerBtn = [self newButtonWithImage:registerImage highlightedImage:nil frame:CGRectMake(10, 332, 142, 42) title:@"注 册" titleColor:RGB(102, 102, 102) titleShadowColor:nil font:[UIFont systemFontOfSize:19.0] target:self action:@selector(registerBtn)];
    [self.view addSubview:registerBtn];
    [registerBtn release];
    
    //登陆按钮
     UIImage *loginImage = [UIImage imageNamed:@"bg_logo_shouye.png"];
    UIButton *loginBtn = [self newButtonWithImage:loginImage highlightedImage:nil frame:CGRectMake(168, 332, 142, 42) title:@"登  录" titleColor:[UIColor whiteColor] titleShadowColor:nil font:[UIFont systemFontOfSize:19.0] target:self action:@selector(loginBtn)];
    [self.view addSubview:loginBtn];
    [loginBtn release];
    
    //找回密码按钮
    UIButton *seekPassBtn = [self newButtonWithImage:nil highlightedImage:nil frame:CGRectMake(230, 380, 85, 20) title:@"忘记密码?" titleColor:RGB(102, 102, 102) titleShadowColor:nil font:[UIFont systemFontOfSize:14.0] target:self action:@selector(seekPassBtn)];
    [self.view addSubview:seekPassBtn];
    [seekPassBtn release];
    
    //点击退出键盘
    UITapGestureRecognizer *closeTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeKeyBoard)];
    [self.view addGestureRecognizer:closeTap];
    [closeTap release];
    
    [self registerForKeyboardNotifications];

}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

//关闭键盘
-(void)closeKeyBoard
{
    [phoneField resignFirstResponder];
    [passwordField resignFirstResponder];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [passwordField resignFirstResponder];
    return YES;
}

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShown:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}


// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWillShown:(NSNotification*)aNotification
{
    if (!isIPhone5) {
        [UIView animateWithDuration:0.4
                         animations:^{
                             self.view.transform = CGAffineTransformMakeTranslation(0, -65);
                         }];
    }
   else {
        [UIView animateWithDuration:0.4
                         animations:^{
                             self.view.transform = CGAffineTransformMakeTranslation(0, -28);
                         }];
    }
    
    
//    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
//    scrollView.contentInset = contentInsets;
//    scrollView.scrollIndicatorInsets = contentInsets;
//    
//    // If active text field is hidden by keyboard, scroll it so it's visible
//    // Your application might not need or want this behavior.
//    CGRect aRect = self.view.frame;
//    aRect.size.height -= kbSize.height;
//    if (!CGRectContainsPoint(aRect, activeField.frame.origin) ) {
//        CGPoint scrollPoint = CGPointMake(0.0, activeField.frame.origin.y-kbSize.height);
//        [scrollView setContentOffset:scrollPoint animated:YES];
//    }
}


// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    [UIView animateWithDuration:0.4
                     animations:^{
                         self.view.transform = CGAffineTransformIdentity;
                     }];
//    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
//    scrollView.contentInset = contentInsets;
//    scrollView.scrollIndicatorInsets = contentInsets;
}

//找回密码
-(void)seekPassBtn
{
    SeekPasswordViewController *seekPasswordVc = [[SeekPasswordViewController alloc]init];
    [self.navigationController pushViewController:seekPasswordVc animated:YES];
    [seekPasswordVc release];
}
//注册账号
-(void)registerBtn
{
    RegisterViewController *RegisterVc = [[RegisterViewController alloc]init];
    [self.navigationController pushViewController:RegisterVc animated:YES];
    [RegisterVc release];
}

- (BOOL)checkForm {
   
    if ([phoneField.text isEqualToString:@""]||[phoneField.text isEqualToString:nil]||[phoneField.text length] == 0) {
        
        [self alertWithFistButton:nil SencodButton:@"确定" Message:@"电话号码不能为空！"];
        
        [phoneField becomeFirstResponder];
        
        return FALSE;
    }else if ([passwordField.text isEqualToString:@""]||[passwordField.text isEqualToString:nil]||[passwordField.text length] == 0) {
        
        [self alertWithFistButton:nil SencodButton:@"确定" Message:@"密码不能为空！"];
        
        [passwordField becomeFirstResponder];
        return FALSE;
    } else{
        return TRUE;
    }
}
//登录
-(void)loginBtn
{
  //  [self enterMainCommunity];

 //   return;
    
    if ([self checkForm]) {
        Reachability *reach = [Reachability reachabilityForInternetConnection];
        if ([reach isReachable]){
            //add vincent
//            [Global showLoadingProgressViewWithText:@"加载中..."];
            [self hideHudView];
            AppDelegate *appDeleagte = [AppDelegate instance];
            hudView = [Global showMBProgressHud:self SuperView:appDeleagte.window Msg:@"请稍候..."];//       请求验证验证码是否正确
            requestTimes = 0;
            [self requestLogin];
        }else{
            [self alertWithFistButton:@"确定" SencodButton:nil Message:@"当前网络不可用,请检查网络设置"];
            
        }

    }

}
- (void)enterMainCommunity{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    if( [delegate respondsToSelector:@selector(loadAnimationEndedCallback:)] )
    {
//        请求邻居和分组列表
        [delegate requestGruopList];
        [delegate requestFriendList];
        
        [delegate loadAnimationEndedCallback:nil];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ---netWork
- (void)requestLogin{
    // 网络请求
    if (_request == nil) {
        _request = [CommunityHttpRequest shareInstance];
    }
    NSString *string = [NSString stringWithFormat:@"?userName=%@&password=%@",phoneField.text,passwordField.text];//参数
    [_request requestLogin:self parameters:string];
}

-(void) callBackWith: (WInterface) interface status: (NSString*) status data:(id) data{
    [self hideHudView]; //add vincent
    if (interface == COMMUNITY_REGISTER_LOGIN) {
        NSString *code = [data objectForKey:ERROR_CODE];
        if ([code isEqualToString:NETWORK_RETURN_CODE_S_OK]) {
            UserModel *userModel = [UserModel shareUser];
            userModel.userId = [data objectForKey:@"userId"];
            userModel.userName = [data objectForKey:@"userName"];
            userModel.propertyId = [data objectForKey:@"propertyId"];
            userModel.communityId = [data objectForKey:@"communityId"];
            userModel.token = [data objectForKey:@"token"];
            userModel.userName = [data objectForKey:@"userName"];
            userModel.communityName = [data objectForKey:@"communityName"];
            [userModel saveUserInfo];
            if (_loginType == LOGIN_NORMAL) {
                [self enterMainCommunity];
            }else{
                if ([passwordField resignFirstResponder]) {
                    [passwordField resignFirstResponder];
                }
            [MobClick event:@"Login"]; //数据统计
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
            }
           
        }else{
            NSString *msg = [data objectForKey:@"errorMsg"];
            if (msg.length == 0) {
                msg = @"网络连接不给力,请稍后再试";
                requestTimes++;
                
                if (requestTimes>=3) {
                    [self alertWithFistButton:@"确定" SencodButton:nil Message:msg];
                }else{
                    //超时之后再次请求
                    [self requestLogin];
                }
            }else{
                [self alertWithFistButton:@"确定" SencodButton:nil Message:msg];
            }
            
        
        }

    }
}

#pragma mark ---
//- (void)secureChange:(UISwitch *)sender{
//    if (sender.isOn) {
//        passwordField.secureTextEntry = NO;
//    }else{
//        passwordField.secureTextEntry = YES;
//    }
//    
//    [passwordField becomeFirstResponder];
//}

- (void) hideHudView
{
    if (hudView) {
        [hudView hide:YES];
    }
}
@end
