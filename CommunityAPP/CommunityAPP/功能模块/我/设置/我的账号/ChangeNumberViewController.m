//
//  ChangeNumberViewController.m
//  CommunityAPP
//
//  Created by Dream on 14-5-21.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import "ChangeNumberViewController.h"
#import "Global.h"
#import "NSObject_extra.h"
#import "UIViewController+NavigationBar.h"
#import "MyNumberViewController.h"
#import "MobClick.h"

@interface ChangeNumberViewController ()

@end

@implementation ChangeNumberViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
    [MobClick beginLogPageView:@"ChangeNumberPage"]; // 友盟统计
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
    [MobClick endLogPageView:@"ChangeNumberPage"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:RGB(255, 255, 255)];
    [self.navigationController setNavigationBarHidden:NO];
    
    //自适应iOS的导航栏、状态栏
    [self adjustiOS7NaviagtionBar];
    [self setNavigationTitle:@"更换手机号"];
    //自定义返回按钮
    UIButton *backButton = [self setBackBarButton];
    [backButton addTarget:self action:@selector(leftBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self setBackBarButtonItem:backButton];
    
    
    //手机号输入框
    numberField = [[UITextField alloc]initWithFrame:CGRectMake(10,25,ScreenWidth-20 , 40)];
    numberField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;//字体垂直居中对齐
    numberField.placeholder = @"手机号";
    numberField.font = [UIFont systemFontOfSize:15.0];
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
    UILabel *sendLable = [self newLabelWithText:@"为了验证你的身份，我们将发送短信验证码" frame:CGRectMake(8, 66, ScreenWidth, 30) font:[UIFont systemFontOfSize:15.0] textColor:RGB(166, 166, 166)];
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
-(void)nextBtn
{
    MyNumberViewController *myNumberVc = [[MyNumberViewController alloc]init];
    [self.navigationController pushViewController:myNumberVc animated:YES];
    [myNumberVc release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
