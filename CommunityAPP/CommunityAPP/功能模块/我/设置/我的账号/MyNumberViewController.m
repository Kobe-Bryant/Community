//
//  MyNumberViewController.m
//  CommunityAPP
//
//  Created by Dream on 14-5-21.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import "MyNumberViewController.h"
#import "UIViewController+NavigationBar.h"
#import "Global.h"
#import "NSObject_extra.h"
#import "MobClick.h"

@interface MyNumberViewController ()

@end

@implementation MyNumberViewController

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
    [MobClick beginLogPageView:@"MyNumberPage"]; // 友盟统计
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
    [MobClick endLogPageView:@"MyNumberPage"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:RGB(244, 244, 244)];
    
    //自适应iOS的导航栏、状态栏
    [self adjustiOS7NaviagtionBar];
    [self setNavigationTitle:@"我的账号"];
    //自定义返回按钮
    UIButton *backButton = [self setBackBarButton];
    [backButton addTarget:self action:@selector(backBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self setBackBarButtonItem:backButton];
    
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 30, ScreenWidth, 40)];
    backView.layer.borderWidth = 0.5f;
    backView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    backView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backView];
    [backView release];
    
    // 手机号title
    UILabel *logoLable = [self newLabelWithText:@"你的手机号：" frame:CGRectMake(20, 10,90, 18) font:[UIFont systemFontOfSize:15.0] textColor:RGB(51, 51, 51)];
    logoLable.backgroundColor = [UIColor clearColor];
    [backView addSubview:logoLable];
    [logoLable release];
    
    //手机号输入框
    numberField = [[UITextField alloc]initWithFrame:CGRectMake(110,0,210 , 40)];
    numberField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;//字体垂直居中对齐
    numberField.borderStyle = UITextBorderStyleNone;
    numberField.keyboardType = UIKeyboardTypeNumberPad;
    [backView addSubview:numberField];
    [numberField release];
    
    //下一步按钮
    UIImage *loginImg = [UIImage imageNamed:@"login1.png"];
    UIButton *nextBtn = [self newButtonWithImage:loginImg highlightedImage:nil frame:CGRectMake(10, 130
                                                                                                                                   , loginImg.size.width, loginImg.size.height) title:@"更换手机号码" titleColor:[UIColor whiteColor] titleShadowColor:nil font:[UIFont systemFontOfSize:19.0] target:self action:@selector(nextBtn)];
    [self.view addSubview:nextBtn];
    [nextBtn release];
    
    //提示lable
    UILabel *sendLable = [self newLabelWithText:@"更换手机号后，下次登录可使用新手机号登录" frame:CGRectMake(10, nextBtn.frame.size.height+nextBtn.frame.origin.y, ScreenWidth, 30) font:[UIFont systemFontOfSize:14.0] textColor:RGB(102 , 102, 102)];
    [self.view addSubview:sendLable];
    [sendLable release];

    
    //点击退出键盘
    UITapGestureRecognizer *closeTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeKeyBoard)];
    [self.view addGestureRecognizer:closeTap];
    [closeTap release];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//关闭键盘
-(void)closeKeyBoard
{
    [numberField resignFirstResponder];
}

//返回导航按钮
-(void)backBtnAction
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)nextBtn{

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
