//
//  ModifyPasswordViewController.m
//  CommunityAPP
//
//  Created by Dream on 14-3-21.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import "ModifyPasswordViewController.h"
#import "Global.h"
#import "NSObject_extra.h"
#import "CommunityHttpRequest.h"
#import "UserModel.h"
#import "NSString+MD5.h"
#import "LoginViewController.h"
#import "UIViewController+NavigationBar.h"
#import "ZJSwitch.h"
#import "MobClick.h"

@interface ModifyPasswordViewController ()
@property (nonatomic, retain) CommunityHttpRequest *request;

@end

@implementation ModifyPasswordViewController
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
    [_request cancelDelegate:self];
    [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
    [MobClick beginLogPageView:@"ModifyPasswordPage"]; // 友盟统计
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
    [MobClick endLogPageView:@"ModifyPasswordPage"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.view setBackgroundColor:RGB(255, 255, 255)];
    
    //自适应iOS的导航栏、状态栏
    [self adjustiOS7NaviagtionBar];
    [self setNavigationTitle:@"修改密码"];
    //自定义返回按钮
    UIButton *backButton = [self setBackBarButton];
    [backButton addTarget:self action:@selector(leftBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self setBackBarButtonItem:backButton];
    
    //密码输入框
    UIView *backPasswordView = [[UIView alloc]initWithFrame:CGRectMake(10,24,ScreenWidth-20 , 40)];
    backPasswordView.layer.borderWidth = 0.5f;
    backPasswordView.layer.borderColor = RGB(222, 222, 222).CGColor;
    backPasswordView.layer.cornerRadius = 5.0;
    backPasswordView.layer.masksToBounds = YES;
    [self.view addSubview:backPasswordView];
    [backPasswordView release]; //add vincent 内存释放
    
    //密码输入框
    newPasswordField = [[UITextField alloc]initWithFrame:CGRectMake(10,24,ScreenWidth-90, 40)];
    newPasswordField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;//字体垂直居中
    newPasswordField.placeholder = @"输入新密码";
    newPasswordField.font = [UIFont systemFontOfSize:16.0];
    newPasswordField.borderStyle = UITextBorderStyleNone;
//    newPasswordField.background = APP_imageStrench;
    newPasswordField.delegate = self;
    newPasswordField.keyboardType = UIKeyboardTypeEmailAddress;
    //设置光标坐标
    UIView *newPasswordView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 11, 0)];
    newPasswordField.leftView = newPasswordView;
    newPasswordField.leftViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:newPasswordField];
    [newPasswordView release];
    [newPasswordField release];
    
//    SevenSwitch *mySwitch2 = [[SevenSwitch alloc] initWithFrame:CGRectMake(234, 7
//                                                                           , 56, 26)];
//    [mySwitch2 addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
//    mySwitch2.offImage = [UIImage imageNamed:@"offImage.png"];
//    mySwitch2.onImage = [UIImage imageNamed:@"ouImage1.png"];
//    mySwitch2.onColor = RGB(87, 182, 16); //[UIColor colorWithHue:0.08f saturation:0.74f brightness:1.00f alpha:1.00f];
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
    
    //密码uiswitch
//    UISwitch *passSwitch = [[UISwitch alloc]initWithFrame:CGRectMake(240, 5, 60, 25)];
//    passSwitch.on = YES;
//    [passSwitch addTarget:self action:@selector(secureChange:) forControlEvents:UIControlEventValueChanged];
    //[backPasswordField addSubview:passSwitch];
   // [passSwitch release];
    
    //下一步按钮
    UIImage *loginImg = [UIImage imageNamed:@"login1.png"];
    UIButton *nextBtn = [self newButtonWithImage:loginImg highlightedImage:nil frame:CGRectMake(10, newPasswordField.frame.size.height+newPasswordField.frame.origin.y+64, loginImg.size.width, loginImg.size.height) title:@"提 交" titleColor:[UIColor whiteColor] titleShadowColor:nil font:[UIFont systemFontOfSize:19.0] target:self action:@selector(nextBtn)];
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
    [newPasswordField resignFirstResponder];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [newPasswordField resignFirstResponder];
    return YES;
}

- (BOOL)checkForm {
    if ([newPasswordField.text isEqualToString:@""]||[newPasswordField.text isEqualToString:nil]||[newPasswordField.text length] == 0) {
        
        [self alertWithFistButton:@"确定" SencodButton:nil Message:@"输入新密码不能为空!"];
        [newPasswordField becomeFirstResponder];
        return FALSE;
    }else{
        return TRUE;
    }
}
//提交
-(void)nextBtn
{
    if ([self checkForm]) {
        [self hideHudView];
        hudView = [Global showMBProgressHud:self SuperView:self.view Msg:@"请稍候..."];
        [self requestModify];
    }
}
-(void)requestModify
{
    //Auth 2.0加密
    //    UserModel *userModel = [UserModel shareUser];
    //    NSLog(@"userModel.token = =%@",userModel.token);
    //    NSString *publicKeyStr = [NSString stringWithFormat:@"%@%@%@%@%@%@",DEF_UPDATE_TIME,userModel.propertyId,userModel.communityId,userModel.userId,newPasswordField.text,userModel.token];
    //    NSString *newPublicKeyStr = [publicKeyStr md5];
    
    // 网络请求
    if (_request == nil) {
        _request = [CommunityHttpRequest shareInstance];
    }
    UserModel *userModel = [UserModel shareUser];
    NSString *parameters = [NSString stringWithFormat:@"?updateTime=%@&propertyId=%@&communityId=%@&userId=%@&newPassword=%@",DEF_UPDATE_TIME,userModel.propertyId,userModel.communityId,userModel.userId,newPasswordField.text];//参数
    [_request requestModifyPassword:self parameters:parameters];

}
-(void) callBackWith: (WInterface) interface status: (NSString*) status data:(id) data{
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
#pragma mark ---
//- (void)secureChange:(UISwitch *)sender{
//    if (sender.isOn) {
//        newPasswordField.secureTextEntry = YES;
//    }else{
//        newPasswordField.secureTextEntry = NO;
//    }
//    
//    [newPasswordField becomeFirstResponder];
//}

//- (void)switchChanged:(SevenSwitch *)sender {
//    //    NSLog(@"Changed value to: %@", sender.on ? @"ON" : @"OFF");
//    if (sender.on) {
//        newPasswordField.secureTextEntry = NO;
//    }else{
//        newPasswordField.secureTextEntry = YES;
//    }
//}

- (void)handleSwitchEvent:(ZJSwitch *)sender
{
    //NSLog(@"%s", __FUNCTION__);
    if (sender.on) {
        newPasswordField.secureTextEntry = NO;
    }else{
        newPasswordField.secureTextEntry = YES;
        
    }
    
}

- (void) hideHudView
{
    if (hudView) {
        [hudView hide:YES];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
