//
//  AddPhoneViewController.m
//  CommunityAPP
//
//  Created by yunlai on 14-3-5.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import "AddPhoneViewController.h"
#import "Global.h"
#import "NSObject_extra.h"
#import "DetailPhoneNumViewController.h"
#import "CommunityHttpRequest.h"
#import "UserModel.h"
#import "PhoneBookViewController.h"
#import "ContactModel.h"
#import "DataBaseManager.h"
#import "UIViewController+NavigationBar.h"
#import "MobClick.h"

@interface AddPhoneViewController ()<UIAlertViewDelegate,UITextViewDelegate>{
    
    UIView *backView;
}

@property (nonatomic, retain) CommunityHttpRequest *addContactsRequest;
@property (nonatomic, retain) DataBaseManager *dbManager;

@end

@implementation AddPhoneViewController

@synthesize addContactsRequest = _addContactsRequest;
@synthesize prviewController = _prviewController;
@synthesize dbManager = _dbManager;

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
    [_addContactsRequest cancelDelegate:self];
    [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
    [MobClick beginLogPageView:@"AddPhonePage"];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
    [MobClick endLogPageView:@"AddPhonePage"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    //自适应iOS的导航栏、状态栏
    [self adjustiOS7NaviagtionBar];
    [self setNavigationTitle:@"添加电话"];
    //自定义返回按钮
    UIButton *backButton = [self setBackBarButton];
    [backButton addTarget:self action:@selector(backBtnAlert:) forControlEvents:UIControlEventTouchUpInside];
    [self setBackBarButtonItem:backButton];
    
    //    右边按钮
    UIImage *rightImage = [UIImage imageNamed:@"icon_phone_add_save.png"];
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setImage:rightImage forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightBtnAction) forControlEvents:UIControlEventTouchUpInside];
    rightBtn.frame = CGRectMake(275,0,44,44);
    [self setRightBarButtonItem:rightBtn];
    
    //设置页面背景颜色
    self.view.backgroundColor = RGB(246, 246, 246);
    
    //UIView添加电话详情
    backView = [[UIView alloc]initWithFrame:CGRectMake(0,35, ScreenWidth, 122)];
    backView.backgroundColor = [UIColor whiteColor];
    backView.layer.borderWidth = 1.0;
    backView.layer.borderColor = RGB(231, 231, 231).CGColor;
    
    UIView *lineView1 = [[UIView alloc]initWithFrame:CGRectMake(20, 41, 300, 1)];
    lineView1.backgroundColor = RGB(231, 231, 231);
    UIView *lineView2 = [[UIView alloc]initWithFrame:CGRectMake(20, 81, 300, 1)];
    lineView2.backgroundColor = RGB(231, 231, 231);
    //名称Lab
    UILabel *nameLab = [[UILabel alloc]initWithFrame:CGRectMake(20, 12, 42, 21)];
    nameLab.font = [UIFont systemFontOfSize:16.0];
    nameLab.textColor = RGB(190, 190, 190);
    nameLab.text = @"名称";
    //电话Lab
    UILabel *numLab = [[UILabel alloc]initWithFrame:CGRectMake(20, 52, 42, 21)];
    numLab.font = [UIFont systemFontOfSize:16.0];
    numLab.textColor = RGB(190, 190, 190);
    numLab.text = @"电话";
    //描述Lab
    UILabel *describeLab = [[UILabel alloc]initWithFrame:CGRectMake(20, 92, 42, 21)];
    describeLab.font = [UIFont systemFontOfSize:16.0];
    describeLab.textColor = RGB(190, 190, 190);
    describeLab.text = @"描述";
    //名称field
    nameField = [[UITextField alloc]initWithFrame:CGRectMake(70, 1, 245, 40)];
    nameField.borderStyle = UITextBorderStyleNone;
    nameField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;//字体垂直居中对齐
    nameField.font = [UIFont systemFontOfSize:14.0];
    nameField.returnKeyType = UIReturnKeyNext;
    nameField.delegate = self;

    //电话field
    numField = [[UITextField alloc]initWithFrame:CGRectMake(70, 41, 245, 40)];
    numField.borderStyle = UITextBorderStyleNone;
    numField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;//字体垂直居中对齐
    numField.font = [UIFont systemFontOfSize:14.0];
    numField.delegate = self;
    numField.keyboardType = UIKeyboardTypeNumberPad;
   
    //描述field
    tvDescribe = [[UITextView alloc]initWithFrame:CGRectMake(70, 83, 245, 37)];
    tvDescribe.font = [UIFont systemFontOfSize:14.0];
    tvDescribe.delegate = self;
    
    [self.view addSubview:backView];
    [backView addSubview:lineView1];
    [backView addSubview:lineView2];
    [backView addSubview:nameLab];
    [backView addSubview:numLab];
    [backView addSubview:describeLab];
    [backView addSubview:nameField];
    [backView addSubview:numField];
    [backView addSubview:tvDescribe];
    [lineView1 release];
    [lineView2 release];
    [backView release];
    [nameLab release];
    [numLab release];
    [describeLab release];
    [nameField release];
    [numField release];
    [tvDescribe release];
    
    //添加退出键盘手势
    UITapGestureRecognizer *tapBack = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backfield)];
    [self.view addGestureRecognizer:tapBack];
    [tapBack release];
}

- (void)backBtnAlert:(UIButton *)sender{
    if (nameField.text.length || numField.text.length || tvDescribe.text.length) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"取消添加电话?" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
        [alert show];
        [alert release];
    }else{
        [self backBtnAction];
    }

}

//返回
-(void)backBtnAction{
    [self backfield];
    
    if (_prviewController) {
        [_prviewController showMyConatcts:YES];
    }
    [self.navigationController popViewControllerAnimated:YES];
    
}

//右边按钮
-(void)rightBtnAction
{
    NSString *regex = @"[\\s\\S]{3,12}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if (nameField.text.length ==0 && [nameField.text isEqualToString:@""]) {
        [self alertWithFistButton:@"确定" SencodButton:nil Message:@"名称不能为空"];
         [nameField becomeFirstResponder];
    }else if (numField.text.length == 0 && [numField.text isEqualToString:@""]){
        [self alertWithFistButton:@"确定" SencodButton:nil Message:@"电话号码不能为空"];
         [numField becomeFirstResponder];
    } else if(![pred evaluateWithObject:numField.text]){
        [self alertWithFistButton:@"确定" SencodButton:nil Message:@"电话号码格式不正确!"];
        [numField becomeFirstResponder];
    }else{
      [self requestAddContacts];
    }
}

//点击next跳到下一个textfield
#pragma mark -- uitextfieldDelegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{//限制字符在20个以内  add by Devin
    if ([string isEqualToString:@"\n"]){
        return YES;
    }
    NSString * aString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (textField == nameField)
    {
        if ([aString length] > 15) {
            return NO;
        }
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField;
{
    [numField becomeFirstResponder];
    return YES;
}

//键盘退出
-(void)backfield
{
    [nameField resignFirstResponder];
    [numField resignFirstResponder];
    [tvDescribe resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ---UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
            
            break;
        case 1:
            [self backBtnAction];
            break;
        default:
            break;
    }
}

#pragma mark ---network
- (void)requestAddContacts{
    
    ContactModel *model = [[[ContactModel alloc] init] autorelease];
    model.type = MY_PRIVATE_CONTACTS_TYPE_ID;
    model.contactName = nameField.text;
    model.phoneNumber = numField.text;
    model.contactDescription = tvDescribe.text;
    model.typeName = @"我";
    model.contactId = 9999;
//    _dbManager = [DataBaseManager shareDBManeger];
//    [_dbManager insertContact:model];
    
    UserModel *userModel = [UserModel shareUser];
    NSString *parameters = [NSString stringWithFormat:@"?%@=%@&%@=%@&%@=%@&%@=%@&%@=%@&%@=%@&%@=%@",UPDATE_TIME,DEF_UPDATE_TIME,USER_ID,userModel.userId,COMMUNITY_ID,userModel.communityId,PROPERTY_ID,userModel.propertyId,CONTACT,nameField.text,PHONE_NUMBER,numField.text,DESCRIPTION,tvDescribe.text];
    
    if (_addContactsRequest == nil) {
        _addContactsRequest = [CommunityHttpRequest shareInstance];
    }
    [_addContactsRequest addContact:self parameters:parameters];
}

-(void) callBackWith: (WInterface) interface status: (NSString*) status data:(id) data{
    if (interface == COMMUNITY_PRIVATE_CONTACTS_ADD) {
        
        if ([status isEqualToString:NETWORK_RETURN_CODE_S_OK]) {
            [Global hideProgressViewForType:failed message:@"添加成功" afterDelay:1.0f];
            [self backBtnAction];
            
        }else{
            //异常处理
            //23[self alertWithFistButton:@"确定" SencodButton:nil Message:@"添加失败"];
            NSString *message = [data objectForKey:@"errorMsg"];
            if (message.length == 0) {
                message = @"添加失败";
            }
            [Global hideProgressViewForType:failed message:message afterDelay:1.0f];
        }
    }
}

- (void)textViewDidChange:(UITextView *)textView{
    CGSize newSize = [textView.text
                      sizeWithFont:[UIFont fontWithName:@"Helvetica" size:14]
                      constrainedToSize:CGSizeMake(245-20,9999)
                      lineBreakMode:NSLineBreakByCharWrapping];
    NSLog(@"%@",NSStringFromCGSize(tvDescribe.contentSize));

    if (newSize.height <= 38) {
        tvDescribe.frame = CGRectMake(70, 83, 245, 38);
        CGRect rect = CGRectMake(CGRectGetMinX(backView.frame), CGRectGetMinY(backView.frame), CGRectGetWidth(backView.frame),83+38);
        backView.frame = rect;
    }else{
        tvDescribe.frame = CGRectMake(70, 83, 245, tvDescribe.contentSize.height);
        CGRect rect = CGRectMake(CGRectGetMinX(backView.frame), CGRectGetMinY(backView.frame), CGRectGetWidth(backView.frame),83+tvDescribe.contentSize.height);
        backView.frame = rect;
    }
    
    
}

@end
