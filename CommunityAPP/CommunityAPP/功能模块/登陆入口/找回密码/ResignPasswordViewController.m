//
//  ResignPasswordViewController.m
//  CommunityAPP
//
//  Created by Dream on 14-3-20.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import "ResignPasswordViewController.h"
#import "Global.h"
#import "NSObject_extra.h"
#import "LoginViewController.h"
#import "CommunityHttpRequest.h"
#import "UIViewController+NavigationBar.h"
#import "AppConfig.h"
#import "MobClick.h"

@interface ResignPasswordViewController ()
@property (nonatomic, retain) CommunityHttpRequest *request;

@end

@implementation ResignPasswordViewController
@synthesize request = _request;
@synthesize passStr1 = _passStr1;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [_request cancelDelegate:self];
    [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
    [MobClick beginLogPageView:@"ResignPasswordPage"];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
    [MobClick endLogPageView:@"ResignPasswordPage"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.view setBackgroundColor:RGB(255, 255, 255)];
    
    //自适应iOS的导航栏、状态栏
    [self adjustiOS7NaviagtionBar];
    [self setNavigationTitle:@"设置新密码"];
    //自定义返回按钮
    UIButton *backButton = [self setBackBarButton];
    [backButton addTarget:self action:@selector(leftBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self setBackBarButtonItem:backButton];

    
    //密码输入框
//    UIView *backPasswordField = [[UIView alloc]initWithFrame:CGRectMake(10,25,ScreenWidth-20 , 40)];
//    backPasswordField.layer.borderWidth = 1.0f;
//    backPasswordField.layer.borderColor = RGB(195, 195, 195).CGColor;
//    backPasswordField.layer.cornerRadius = 5.0;
//    backPasswordField.layer.masksToBounds = YES;
//    [self.view addSubview:backPasswordField];
//    [backPasswordField release]; //add Vincent 内存释放
    
    //密码输入框
    passwordField = [[UITextField alloc]initWithFrame:CGRectMake(10,25,ScreenWidth-20 , 40)];
    passwordField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;//字体垂直居中对齐
    passwordField.clearButtonMode = UITextFieldViewModeWhileEditing;
    passwordField.placeholder = @"密码";
    passwordField.font = [UIFont systemFontOfSize:16.0];
    passwordField.borderStyle = UITextBorderStyleNone;
    passwordField.secureTextEntry = YES;
    passwordField.background = APP_imageStrench;
    passwordField.delegate = self;
    passwordField.keyboardType = UIKeyboardTypeEmailAddress;
    //设置光标坐标
    UIView *passwordView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 11, 0)];
    passwordField.leftView = passwordView;
    passwordField.leftViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:passwordField];
    [passwordView release];
    [passwordField release];
    
    //密码uiswitch
    UISwitch *passSwitch = [[UISwitch alloc]initWithFrame:CGRectMake(240, 5, 60, 25)];
    passSwitch.on = YES;
    [passSwitch addTarget:self action:@selector(secureChange:) forControlEvents:UIControlEventValueChanged];
    //[backPasswordField addSubview:passSwitch];
    [passSwitch release];
    
    //下一步按钮
    UIImage *loginImg = [UIImage imageNamed:@"login1.png"];
    UIButton *nextBtn = [self newButtonWithImage:loginImg highlightedImage:nil frame:CGRectMake(10,130, loginImg.size.width, loginImg.size.height) title:@"提 交" titleColor:[UIColor whiteColor] titleShadowColor:nil font:[UIFont systemFontOfSize:19.0] target:self action:@selector(nextBtn)];
    [self.view addSubview:nextBtn];
    [nextBtn release];
    
    //点击退出键盘
    UITapGestureRecognizer *closeTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeKeyBoard)];
    [self.view addGestureRecognizer:closeTap];
    [closeTap release];
}

//导航栏左按钮
-(void)leftBtnAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

//关闭键盘
-(void)closeKeyBoard
{
    [passwordField resignFirstResponder];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [passwordField resignFirstResponder];
    return YES;
}

- (BOOL)checkForm {
    if ([passwordField.text isEqualToString:@""]||[passwordField.text isEqualToString:nil]||[passwordField.text length] == 0) {
        
        [self alertWithFistButton:@"确定" SencodButton:nil Message:@"输入密码不能为空!"];
        [passwordField becomeFirstResponder];
        return FALSE;
    }else if(passwordField.text.length < 6 || passwordField.text.length > 16){
        [self alertWithFistButton:@"确定" SencodButton:nil Message:@"密码在6～16位之间!"];
        [passwordField becomeFirstResponder];
        return FALSE;
    }
    else{
        return TRUE;
    }

}

//提交
-(void)nextBtn
{
    if ([self checkForm]) {
        [self hideHudView];
        hudView = [Global showMBProgressHud:self SuperView:self.view Msg:@"请稍候..."];
        [self requestResign];
    }
}
-(void)requestResign
{
    // 网络请求
    if (_request == nil) {
        _request = [CommunityHttpRequest shareInstance];
    }
    NSString *string = [NSString stringWithFormat:@"?newPassword=%@&phoneNumber=%@",passwordField.text,self.passStr1];//参数
    [_request requestSeekPasswordThreeStep:self parameters:string];
   
}

-(void) callBackWith: (WInterface) interface status: (NSString*) status data:(id) data
{
     [self hideHudView];
    if ([status isEqualToString:NETWORK_RETURN_CODE_S_OK]) {
        LoginViewController *loginVc = [[LoginViewController alloc]init];
        [self.navigationController pushViewController:loginVc animated:YES];
        [loginVc release];
        
    }else{
        if ([data objectForKey:@"errorMsg"]) {
            [self alertWithFistButton:nil SencodButton:@"确定" Message:[data objectForKey:@"errorMsg"]];
        }
        
        return;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark ---
- (void)secureChange:(UISwitch *)sender{
    if (sender.isOn) {
        passwordField.secureTextEntry = YES;
    }else{
        passwordField.secureTextEntry = NO;
    }
    [passwordField becomeFirstResponder];
}
- (void) hideHudView
{
    if (hudView) {
        [hudView hide:YES];
    }
}

@end
