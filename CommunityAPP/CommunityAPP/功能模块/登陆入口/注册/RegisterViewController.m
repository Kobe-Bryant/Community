//
//  RegisterViewController.m
//  CommunityAPP
//
//  Created by Dream on 14-3-19.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import "RegisterViewController.h"
#import "Global.h"
#import "NSObject_extra.h"
#import "RealRegisterViewController.h"
#import "UIViewController+NavigationBar.h"
#import "AppConfig.h"
#import "IssueViewController.h"
#import "MobClick.h"

@interface RegisterViewController ()

@end

@implementation RegisterViewController
//@synthesize codeDictionary;

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
    hudView = nil;
    [request cancelDelegate:self];
    [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
    [MobClick beginLogPageView:@"RegisterPage"];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
    [MobClick endLogPageView:@"RegisterPage"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.view setBackgroundColor:RGB(255, 255, 255)];
    
    [self.navigationController setNavigationBarHidden:NO];
    //自适应iOS的导航栏、状态栏
    [self adjustiOS7NaviagtionBar];
    [self setNavigationTitle:@"注册"];
    //自定义返回按钮
    UIButton *backButton = [self setBackBarButton];
    [backButton addTarget:self action:@selector(leftBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self setBackBarButtonItem:backButton];
    
    //右按钮
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [rightBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:15.0]];
    [rightBtn addTarget:self action:@selector(rightBtnAction) forControlEvents:UIControlEventTouchUpInside];
    rightBtn.frame = CGRectMake(280,0,70,44);
    [self setRightBarButtonItem:rightBtn];
    
    //提示文字
    UILabel *alertLable = [self newLabelWithText:@"请输入邀请码" frame:CGRectMake(22, 56,150 , 20) font:[UIFont systemFontOfSize:16.0] textColor:RGB(51, 51, 51)];
    [self.view addSubview:alertLable];
    [alertLable release];

    //邀请码
    registerField = [[UITextField alloc]initWithFrame:CGRectMake(10, 88,ScreenWidth-20 , 40)];
    registerField.font = [UIFont systemFontOfSize:16.0];
    registerField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;//字体垂直居中对齐
    registerField.placeholder = @"邀请码";
    registerField.borderStyle = UITextBorderStyleNone;
    registerField.background = APP_imageStrench;
    registerField.delegate = self;
    registerField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    registerField.returnKeyType = UIReturnKeyNext;
    //设置光标坐标
    UIView *registerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 11, 0)];
    registerField.leftView = registerView;
    registerField.leftViewMode = UITextFieldViewModeAlways;
    [registerView release];
    [self.view addSubview:registerField];
    [registerField release];
    
    //找回密码按钮
    UIButton *seekPassBtn = [self newButtonWithImage:nil highlightedImage:nil frame:CGRectMake(175, registerField.frame.size.height+registerField.frame.origin.y+7, 150, 20) title:@"怎样获取邀请码?" titleColor:RGB(102, 102, 102) titleShadowColor:nil font:[UIFont systemFontOfSize:14.0] target:self action:@selector(seekPassBtn)];
    [self.view addSubview:seekPassBtn];
    [seekPassBtn release];

    //点击退出键盘
    UITapGestureRecognizer *closeTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeKeyBoard)];
    [self.view addGestureRecognizer:closeTap];
    [closeTap release];
}
//关闭键盘
-(void)closeKeyBoard
{
    [registerField resignFirstResponder];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [registerField resignFirstResponder];
    [self rightBtnAction];
    return YES;
}

//导航栏左按钮
-(void)leftBtnAction
{
    if ([registerField becomeFirstResponder]) {
         [registerField resignFirstResponder];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

//验证邀请码
-(void)verificationAction{
    //加载网络数据
    if (request == nil) {
        request = [CommunityHttpRequest shareInstance];
    }
    NSString *parameters = [NSString stringWithFormat:@"?inviteCode=%@",registerField.text];//参数
    NSLog(@"parameters %@",parameters);
    [request requestVerificationAction:self parameters:parameters];
}

-(void)rightBtnAction{
    if ([registerField.text length]!=0) {
        [self hideHudView];
        hudView = [Global showMBProgressHud:self SuperView:self.view Msg:@"请稍候..."];//       请求验证验证码是否正确
        [self verificationAction];
    }else{
        [self alertWithFistButton:@"确定" SencodButton:nil Message:@"邀请码不能为空！"];
        [registerField becomeFirstResponder];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark ------
-(void) callBackWith: (WInterface) interface status: (NSString*) status data:(id) data{
    [self hideHudView];
    if ([status isEqualToString:NETWORK_RETURN_CODE_S_OK]) {
        RealRegisterViewController *realRegisterVc = [[RealRegisterViewController alloc]init];
        realRegisterVc.inviteCodeString = registerField.text;
        
        [MobClick event:@"Register_First"];
        
        [self.navigationController pushViewController:realRegisterVc animated:YES];
        [realRegisterVc release];
    }else{
        if ([data objectForKey:@"errorMsg"]) {
            [self alertWithFistButton:nil SencodButton:@"确定" Message:[data objectForKey:@"errorMsg"]];
        }
        
        return;
    }
}

-(void)seekPassBtn{
    IssueViewController *issueVc = [[IssueViewController alloc]init];
    [self.navigationController pushViewController:issueVc animated:YES];
    [issueVc release];
}

- (void) hideHudView
{
    if (hudView) {
        [hudView hide:YES];
    }
}
@end
