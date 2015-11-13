//
//  RealRegisterViewController.m
//  CommunityAPP
//
//  Created by Dream on 14-3-19.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import "RealRegisterViewController.h"
#import "Global.h"
#import "NSObject_extra.h"
#import "EndRegisterViewController.h"
#import "UserModel.h"
#import "UIViewController+NavigationBar.h"
#import "AppConfig.h"
#import "ZJSwitch.h"
#import "MobClick.h"

@interface RealRegisterViewController ()

@end

@implementation RealRegisterViewController
@synthesize codeDictionary;
@synthesize inviteCodeString;

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
    timer = nil;
    [request cancelDelegate:self];
    [super dealloc];
}
- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
    [MobClick beginLogPageView:@"RealRegisterPage"];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
    [MobClick endLogPageView:@"RealRegisterPage"];
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
    //右按钮
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [rightBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:15.0]];
    [rightBtn addTarget:self action:@selector(rightBtnAction) forControlEvents:UIControlEventTouchUpInside];
    rightBtn.frame = CGRectMake(280,0,70,44);
    [self setRightBarButtonItem:rightBtn];

    
    //输入手机号
    phoneField = [[UITextField alloc]initWithFrame:CGRectMake(10, 25,ScreenWidth-20 , 40)];
    phoneField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;//字体垂直居中对齐
    phoneField.font = [UIFont systemFontOfSize:16.0];
    phoneField.placeholder = @"请输入你的手机号";
    phoneField.borderStyle = UITextBorderStyleNone;
    phoneField.background = APP_imageStrench;
    phoneField.delegate = self;
    phoneField.keyboardType = UIKeyboardTypeNumberPad;
    //设置光标坐标
    UIView *phoneView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 11, 0)];
    phoneField.leftView = phoneView;
    phoneField.leftViewMode = UITextFieldViewModeAlways;
    [phoneView release];
    [self.view addSubview:phoneField];
    [phoneField release];

    //输入密码
    UIView *backPasswordView = [[UIView alloc]initWithFrame:CGRectMake(10,84,ScreenWidth-20 , 40)];
    backPasswordView.layer.borderWidth = 0.5f;
    backPasswordView.layer.borderColor = RGB(222, 222, 222).CGColor;
    backPasswordView.layer.cornerRadius = 5.0;
    backPasswordView.layer.masksToBounds = YES;
    [self.view addSubview:backPasswordView];
    [backPasswordView release]; //add vincent 内存释放
    
    passField = [[UITextField alloc]initWithFrame:CGRectMake(10, 84,ScreenWidth-80, 40)];
    passField.secureTextEntry = YES;
    passField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;//字体垂直居中对齐
    passField.font = [UIFont systemFontOfSize:16.0];
    passField.placeholder = @"请设置登录密码";
    passField.borderStyle = UITextBorderStyleNone;
//    passField.background = APP_imageStrench;
    passField.delegate = self;
    passField.keyboardType = UIKeyboardTypeEmailAddress;
    passField.returnKeyType = UIReturnKeyNext;
    testField.clearButtonMode = UITextFieldViewModeWhileEditing;
    //设置光标坐标
    UIView *passView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 11, 0)];
    passField.leftView = passView;
    passField.leftViewMode = UITextFieldViewModeAlways;
    [passView release];
    [self.view addSubview:passField];
    [passField release];
    
    // Example of a bigger switch with images
//    SevenSwitch *mySwitch2 = [[SevenSwitch alloc] initWithFrame:CGRectMake(240, 7
//                                                                           , 56, 26)];
//    [mySwitch2 addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
//    mySwitch2.offImage = [UIImage imageNamed:@"offImage.png"];
//    mySwitch2.onImage = [UIImage imageNamed:@"ouImage1.png"];
//    mySwitch2.onColor = RGB(87, 182, 16);//[UIColor colorWithHue:0.08f saturation:0.74f brightness:1.00f alpha:1.00f];
//    mySwitch2.isRounded = YES;
//    [mySwitch2 setOn:YES animated:YES];
    ZJSwitch *mySwitch2 = [[ZJSwitch alloc] initWithFrame:CGRectMake(240, 7, 58, 26)];
    mySwitch2.backgroundColor = [UIColor clearColor];
    mySwitch2.tintColor = [UIColor colorWithWhite:0.9 alpha:0.4];
    [mySwitch2 addTarget:self action:@selector(handleSwitchEvent:) forControlEvents:UIControlEventValueChanged];
    mySwitch2.onText = @"abc";
    mySwitch2.offText = @"●●●";
    mySwitch2.on = YES;
    [backPasswordView addSubview:mySwitch2];
    
    //输入验证码
    testField = [[UITextField alloc]initWithFrame:CGRectMake(10, 140,165 , 40)];
    testField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;//字体垂直居中对齐
    testField.font = [UIFont systemFontOfSize:16.0];
    testField.placeholder = @"输入验证码";
    testField.borderStyle = UIReturnKeyNext;
    testField.background = APP_imageStrench;
    testField.delegate = self;
    testField.clearButtonMode = UITextFieldViewModeWhileEditing;
    testField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    testField.returnKeyType = UIReturnKeyNext;
    
    //设置光标坐标
    UIView *testView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 11, 0)];
    testField.leftView = testView;
    testField.leftViewMode = UITextFieldViewModeAlways;
    [testView release];
    [self.view addSubview:testField];
    [testField release];
    
    //验证码
    UIImage *testImg = [UIImage imageNamed:@"get_pass1.png"];
    testBtn = [self newButtonWithImage:testImg highlightedImage:nil frame:CGRectMake(ScreenWidth-testImg.size.width-10, 140, testImg.size.width, testImg.size.height) title:@"获取验证码" titleColor:[UIColor whiteColor] titleShadowColor:nil font:[UIFont systemFontOfSize:16.0] target:self action:@selector(testBtnAction)];
    [self.view addSubview:testBtn];
    [testBtn release];
    
    indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicatorView.frame = CGRectMake(0, 0, testImg.size.width, testImg.size.height);
    [testBtn addSubview:indicatorView];
    
    //点击退出键盘
    UITapGestureRecognizer *closeTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeKeyBoard)];
    [self.view addGestureRecognizer:closeTap];
    [closeTap release];
}

//导航左按钮
-(void)leftBtnAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)closeKeyBoard
{
    [phoneField resignFirstResponder];
    [passField resignFirstResponder];
    [testField resignFirstResponder];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == passField) {
        [testField becomeFirstResponder];
    }else if(textField == testField){
        [self closeKeyBoard];
        [self rightBtnAction];
    }
    return YES;
}
- (BOOL)checkFormTest {
    //判断手机号码是否是11位数(不是就过滤掉)
    NSString *regex = @"[0-9]{11}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if ([phoneField.text isEqualToString:@""]||[phoneField.text isEqualToString:nil]||[phoneField.text length] == 0) {
        
        [self alertWithFistButton:nil SencodButton:@"确定" Message:@"电话号码不能为空！"];
        
        [phoneField becomeFirstResponder];
        
        return FALSE;
    }else if ([passField.text isEqualToString:@""]||[passField.text isEqualToString:nil]||[passField.text length] == 0) {
        [self alertWithFistButton:nil SencodButton:@"确定" Message:@"密码不能为空！"];
        
        [passField becomeFirstResponder];
        return FALSE;
    }  else if(![pred evaluateWithObject:phoneField.text]){
        [self alertWithFistButton:@"确定" SencodButton:nil Message:@"手机号码格式不正确!"];
        [phoneField becomeFirstResponder];
        return FALSE;
    }else if (passField.text.length < 6 ||passField.text.length > 16) {
        [self alertWithFistButton:nil SencodButton:@"确定" Message:@"密码为6~16位！"];
        
        [passField becomeFirstResponder];
        return FALSE;
    }
    else {
        return TRUE;
    }
}
//验证码
-(void)testBtnAction
{
   if ([self checkFormTest]){
        [indicatorView startAnimating];
        
      [testBtn setTitle:@"120" forState:UIControlStateNormal];
      [testBtn setBackgroundImage:[UIImage imageNamed:@"reget1.png"] forState:UIControlStateNormal];
       testBtn.userInteractionEnabled = NO;
        second = 119;

        timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(displayTime) userInfo:nil repeats:YES];

        //加载网络数据
        if (request == nil) {
            request = [CommunityHttpRequest shareInstance];
        }
        NSString *parameters = [NSString stringWithFormat:@"?phoneNumber=%@",phoneField.text];//参数
        NSLog(@"parameters %@",parameters);
        [request requestRegisterMsgcode:self parameters:parameters];
   }

  
}
-(void)displayTime{
    if (second>0) {
        [testBtn setTitle:[NSString stringWithFormat:@"%d",second] forState:UIControlStateNormal];
        testBtn.userInteractionEnabled = NO;
    }
    else
    {
        [testBtn setTitle:@"重新发送验证码" forState:UIControlStateNormal];
        [testBtn setBackgroundImage:[UIImage imageNamed:@"get_pass1.png"] forState:UIControlStateNormal];
        [testBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        testBtn.userInteractionEnabled = YES;
        if ([timer isValid])
            [timer invalidate];
    }
    second --;
}

- (BOOL)checkForm {
    
    if ([phoneField.text isEqualToString:@""]||[phoneField.text isEqualToString:nil]||[phoneField.text length] == 0) {
        
        [self alertWithFistButton:nil SencodButton:@"确定" Message:@"电话号码不能为空！"];
        
        [phoneField becomeFirstResponder];
        
        return FALSE;
    }else if ([passField.text isEqualToString:@""]||[passField.text isEqualToString:nil]||[passField.text length] == 0) {
        [self alertWithFistButton:nil SencodButton:@"确定" Message:@"密码不能为空！"];
        
        [passField becomeFirstResponder];
        return FALSE;
    }  else if ([testField.text isEqualToString:@""]||[testField.text isEqualToString:nil]||[testField.text length] == 0) {
        [self alertWithFistButton:nil SencodButton:@"确定" Message:@"验证码不能为空！"];
        
        [testField becomeFirstResponder];
        return FALSE;
    }
    else {
        return TRUE;
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
    if (interface == COMMUNITY_REGISTER_MSGCODE) {
        [indicatorView stopAnimating];
        indicatorView = nil;
        
        if ([status isEqualToString:NETWORK_RETURN_CODE_S_OK]) {
            NSLog(@"[data retain] %@",[data retain]);
        }else{
            NSLog(@"获取验证码失败");
        }
    }else if (interface == COMMUNITY_REGISTER_STEPONE){
        self.codeDictionary = [data retain];
        if ([status isEqualToString:NETWORK_RETURN_CODE_S_OK]) {
            EndRegisterViewController *endRegisterVc = [[EndRegisterViewController alloc]init];
            endRegisterVc.uuidString = [self.codeDictionary objectForKey:@"uuid"];
            endRegisterVc.phoneFieldString = phoneField.text;
            endRegisterVc.pwsString = passField.text ;
            
            [MobClick event:@"Register_Second"];
            
            [self.navigationController pushViewController:endRegisterVc animated:YES];
            [endRegisterVc release];
        }else{
            testBtn.userInteractionEnabled = YES;
            [testBtn setTitle:@"重新发送验证码" forState:UIControlStateNormal];
            if ([timer isValid])
            [timer invalidate];
            timer= nil;
            
            if ([self.codeDictionary objectForKey:@"errorMsg"]) {
                [self alertWithFistButton:nil SencodButton:@"确定" Message:[self.codeDictionary objectForKey:@"errorMsg"]];
            }
            
        }
    }
}
-(void)rightBtnAction{
    //    验证当前的表单
    if ([self checkForm]) {
        hudView = [Global showMBProgressHud:self SuperView:self.view Msg:@"请稍候..."];//       请求验证验证码是否正确
        
        //加载网络数据
        if (request == nil) {
            request = [CommunityHttpRequest shareInstance];
        }
        NSString *parameters = [NSString stringWithFormat:@"?phoneNumber=%@&password=%@&inviteCode=%@&smsCode=%@",phoneField.text,passField.text,self.inviteCodeString,testField.text];//参数
        NSLog(@"parameters %@",parameters);
        [request requestRegisterOneStep:self parameters:parameters];
    }
}
//- (void)switchChanged:(SevenSwitch *)sender {
//    //    NSLog(@"Changed value to: %@", sender.on ? @"ON" : @"OFF");
//    if (sender.on) {
//        passField.secureTextEntry = NO;
//    }else{
//        passField.secureTextEntry = YES;
//        
//    }
//    //[newPasswordField becomeFirstResponder];
//}
- (void)handleSwitchEvent:(ZJSwitch *)sender
{
    //NSLog(@"%s", __FUNCTION__);
    if (sender.on) {
        passField.secureTextEntry = NO;
    }else{
        passField.secureTextEntry = YES;
    }
}
- (void) hideHudView
{
    if (hudView) {
        [hudView hide:YES];
    }
}
@end
