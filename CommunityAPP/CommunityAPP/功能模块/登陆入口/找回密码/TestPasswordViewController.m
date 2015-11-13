//
//  TestPasswordViewController.m
//  CommunityAPP
//
//  Created by Dream on 14-3-20.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import "TestPasswordViewController.h"
#import "Global.h"
#import "NSObject_extra.h"
#import "ResignPasswordViewController.h"
#import "CommunityHttpRequest.h"
#import "UIViewController+NavigationBar.h"
#import "AppConfig.h"
#import "MobClick.h"

@interface TestPasswordViewController ()
@property (nonatomic, retain) CommunityHttpRequest *request;
@end

@implementation TestPasswordViewController
@synthesize request = _request;
@synthesize passStr = _passStr;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        count = 60;
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
    [MobClick beginLogPageView:@"TestPasswordPage"];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
    [MobClick endLogPageView:@"TestPasswordPage"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.view setBackgroundColor:RGB(255, 255, 255)];
    
    //自适应iOS的导航栏、状态栏
    [self adjustiOS7NaviagtionBar];
    [self setNavigationTitle:@"填写验证码"];
    //自定义返回按钮
    UIButton *backButton = [self setBackBarButton];
    [backButton addTarget:self action:@selector(leftBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self setBackBarButtonItem:backButton];
    
    //输入验证码
    testField = [[UITextField alloc]initWithFrame:CGRectMake(10, 25,165 , 40)];
    testField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;//字体垂直居中对齐
    testField.clearButtonMode = UITextFieldViewModeWhileEditing;
    testField.placeholder = @"输入验证码";
    testField.font = [UIFont systemFontOfSize:16.0];
    testField.borderStyle = UITextBorderStyleNone;
    testField.background = APP_imageStrench;
    testField.delegate = self;
    testField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    //设置光标坐标
    UIView *testView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 11, 0)];
    testField.leftView = testView;
    testField.leftViewMode = UITextFieldViewModeAlways;
    [testView release];
    [self.view addSubview:testField];
    [testField release];
    
    //验证码
    UIImage *testImg = [UIImage imageNamed:@"get_pass1.png"];
    testBtn = [self newButtonWithImage:testImg highlightedImage:nil frame:CGRectMake(ScreenWidth-130 ,25, testImg.size.width, testImg.size.height) title:@"获取验证码" titleColor:[UIColor whiteColor] titleShadowColor:nil font:[UIFont systemFontOfSize:16.0] target:self action:@selector(testBtn)];
    testBtn.userInteractionEnabled = YES;
    [self.view addSubview:testBtn];
    [testBtn release];
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
//定时器
-(void)timeLoop
{
    //60秒后重新获取验证码
    myTimer = [NSTimer  timerWithTimeInterval:1.0 target:self selector:@selector(timerFired)userInfo:nil repeats:YES];
    [[NSRunLoop  currentRunLoop] addTimer:myTimer forMode:NSDefaultRunLoopMode];
}

-(void)timerFired
{   //让按钮变成绿色可编辑状态
     NSString *str = [NSString stringWithFormat:@"%i",--count];
    [testBtn setBackgroundImage:[UIImage imageNamed:@"reget1.png"] forState:UIControlStateNormal];
    testBtn.userInteractionEnabled = NO;
    [testBtn setTitle:[NSString stringWithFormat:@"%@后重新获取",str] forState:UIControlStateNormal];
    
    if ([str isEqualToString:@"0"]) {
         [myTimer setFireDate:[NSDate distantFuture]];//关闭定时器
        [testBtn setBackgroundImage:[UIImage imageNamed:@"get_pass1.png"] forState:UIControlStateNormal];
        testBtn.userInteractionEnabled = YES;
        [testBtn setTitle:@"重新获取验证码" forState:UIControlStateNormal];
        [testBtn addTarget:self action:@selector(testBtn) forControlEvents:UIControlEventTouchUpInside];
    }
}
//验证码按钮
-(void)testBtn
{
    //60秒后重新获取验证码
    [self timeLoop];
    [myTimer setFireDate:[NSDate distantPast]];//开启
    count = 60;
   
    // 网络请求
    if (_request == nil) {
      _request = [CommunityHttpRequest shareInstance];
    }
    NSString *string = [NSString stringWithFormat:@"?phoneNumber=%@",self.passStr];//参数
    [_request requestSeekPasswordTestStep:self parameters:string];
    
}

//导航栏左按钮
-(void)leftBtnAction
{
    [self.navigationController popViewControllerAnimated:YES];
}
//关闭键盘
-(void)closeKeyBoard
{
    [testField resignFirstResponder];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [testField resignFirstResponder];
    return YES;
}

- (BOOL)checkForm {
    if ([testField.text isEqualToString:@""]||[testField.text isEqualToString:nil]||[testField.text length] == 0) {
        
        [self alertWithFistButton:@"确定" SencodButton:nil Message:@"输入验证码不能为空!"];
        [testField becomeFirstResponder];
        return FALSE;
    }else{
        return TRUE;
    }
}
//下一步
-(void)nextBtn
{
     //[myTimer setFireDate:[NSDate distantFuture]];//关闭定时器
    if ([self checkForm]) {
        [self hideHudView];
        hudView = [Global showMBProgressHud:self SuperView:self.view Msg:@"请稍候..."];
        [self requestTest];
    }
}
-(void)requestTest
{
    // 网络请求
    if (_request == nil) {
        _request = [CommunityHttpRequest shareInstance];
    }
    NSString *string = [NSString stringWithFormat:@"?securityCode=%@&phoneNumber=%@",testField.text,self.passStr];//参数
    [_request requestSeekPasswordTwoStep:self parameters:string];
}



-(void) callBackWith: (WInterface) interface status: (NSString*) status data:(id) data
{
     [self hideHudView];
    if (interface == COMMUNITY_SEEKPASSWORD_TWO) {
        if ([status isEqualToString:NETWORK_RETURN_CODE_S_OK]) {
            ResignPasswordViewController *resignPasswordVc = [[ResignPasswordViewController alloc]init];
            resignPasswordVc.passStr1 = [data objectForKey:@"phoneNumber"];
            [self.navigationController pushViewController:resignPasswordVc animated:YES];
            [resignPasswordVc release];
            
        }else{
            if ([data objectForKey:@"errorMsg"]) {
                [self alertWithFistButton:nil SencodButton:@"确定" Message:[data objectForKey:@"errorMsg"]];
            }
            
            return;
        }
    }
   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) hideHudView
{
    if (hudView) {
        [hudView hide:YES];
    }
}

@end
