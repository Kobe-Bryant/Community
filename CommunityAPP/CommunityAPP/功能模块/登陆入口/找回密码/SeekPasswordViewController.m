//
//  SeekPasswordViewController.m
//  CommunityAPP
//
//  Created by Dream on 14-3-20.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import "SeekPasswordViewController.h"
#import "Global.h"
#import "NSObject_extra.h"
#import "TestPasswordViewController.h"
#import "CommunityHttpRequest.h"
#import "UIViewController+NavigationBar.h"
#import "AppConfig.h"
#import "MobClick.h"

@interface SeekPasswordViewController ()
@property (nonatomic, retain) CommunityHttpRequest *request;

@end

@implementation SeekPasswordViewController
@synthesize request = _request;

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
    [_request cancelDelegate:self];
    [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
    [MobClick beginLogPageView:@"SeekPasswordPage"];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
    [MobClick endLogPageView:@"SeekPasswordPage"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.view setBackgroundColor:RGB(255, 255, 255)];
    [self.navigationController setNavigationBarHidden:NO];
    
    //自适应iOS的导航栏、状态栏
    [self adjustiOS7NaviagtionBar];
    [self setNavigationTitle:@"找回密码"];
    //自定义返回按钮
    UIButton *backButton = [self setBackBarButton];
    [backButton addTarget:self action:@selector(leftBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self setBackBarButtonItem:backButton];

    
    //手机号输入框
    numberField = [[UITextField alloc]initWithFrame:CGRectMake(10,25,ScreenWidth-20 , 40)];
    numberField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;//字体垂直居中对齐
    numberField.clearButtonMode = UITextFieldViewModeWhileEditing;
    numberField.placeholder = @"输入电话号码";
    numberField.font = [UIFont systemFontOfSize:16.0];
    numberField.borderStyle = UITextBorderStyleNone;
    numberField.background = APP_imageStrench;
    numberField.keyboardType = UIKeyboardTypeNumberPad;
    //设置光标坐标
    UIView *numberView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 11, 0)];
    numberField.leftView = numberView;
    numberField.leftViewMode = UITextFieldViewModeAlways;
    [numberView release];
    [self.view addSubview:numberField];
    [numberField release];
    //提示lable
    UILabel *sendLable = [self newLabelWithText:@"为了验证你的身份，我们将发送短信验证码" frame:CGRectMake(9, 66, ScreenWidth, 30) font:[UIFont systemFontOfSize:15.0] textColor:RGB(187, 187, 187)];
    [self.view addSubview:sendLable];
    [sendLable release];
    
    //下一步按钮
    UIImage *loginImg = [UIImage imageNamed:@"login1.png"];
    UIButton *nextBtn = [self newButtonWithImage:loginImg highlightedImage:nil frame:CGRectMake(10, 130, loginImg.size.width, loginImg.size.height) title:@"下一步" titleColor:[UIColor whiteColor] titleShadowColor:nil font:[UIFont systemFontOfSize:19.0] target:self action:@selector(nextBtn)];
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
    [numberField resignFirstResponder];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [numberField resignFirstResponder];
    return YES;
}
- (BOOL)checkForm {
    //判断手机号码是否是11位数(不是就过滤掉)
    NSString *regex = @"[0-9]{11}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    if ([numberField.text isEqualToString:@""]||[numberField.text isEqualToString:nil]||[numberField.text length] == 0) {
       
        [self alertWithFistButton:@"确定" SencodButton:nil Message:@"手机号码不能为空!"];
         [numberField becomeFirstResponder];
         return FALSE;
    }else if(![pred evaluateWithObject:numberField.text]){
        [self alertWithFistButton:@"确定" SencodButton:nil Message:@"手机号码格式不正确!"];
        [numberField becomeFirstResponder];
        return FALSE;
    }
    else{
        return TRUE;
    }
}
-(void)nextBtn
{
    if ([self checkForm]) {
        [self hideHudView];
        hudView = [Global showMBProgressHud:self SuperView:self.view Msg:@"请稍候..."];
        [self requestSeek];
    }
}
-(void)requestSeek
{
    // 网络请求
    if (_request == nil) {
        _request = [CommunityHttpRequest shareInstance];
    }
    NSString *string = [NSString stringWithFormat:@"?phoneNumber=%@",numberField.text];//参数
    [_request requestSeekPasswordOneStep:self parameters:string];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void) callBackWith: (WInterface) interface status: (NSString*) status data:(id) data{
    [self hideHudView];
    if ([status isEqualToString:NETWORK_RETURN_CODE_S_OK]) {
        TestPasswordViewController *testPasseordVc =[[TestPasswordViewController alloc]init];
        testPasseordVc.passStr = [data objectForKey:@"phoneNumber"];
        [self.navigationController pushViewController:testPasseordVc animated:YES];
        [testPasseordVc release];
    }else{
        if ([data objectForKey:@"errorMsg"]) {
            [self alertWithFistButton:nil SencodButton:@"确定" Message:[data objectForKey:@"errorMsg"]];
        }
        
        return;
    }
}
- (void) hideHudView
{
    if (hudView) {
        [hudView hide:YES];
    }
}
@end
