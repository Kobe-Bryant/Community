//
//  EditMyInfoViewController.m
//  CommunityAPP
//
//  Created by Stone on 14-4-3.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import "EditMyInfoViewController.h"
#import "Global.h"
#import "NSObject_extra.h"
#import "ASIFormDataRequest.h"
#import "UserModel.h"
#import "NSFileManager+Community.h"
#import "UIImage+extra.h"
#include <ImageIO/ImageIO.h>
#import "MBProgressHUD.h"
#import "UIImageView+WebCache.h"
#import "Common.h"
#import "CommunityHttpRequest.h"
#import "ASIWebServer.h"
#import "NSString+MD5.h"
#import "LoginViewController.h"
#import "UIViewController+NavigationBar.h"
#import "MobClick.h"

@interface EditMyInfoViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,WebServiceHelperDelegate,UITextViewDelegate,UITextViewDelegate>{
    UIButton *btnMale;
    UIButton *btnFemale;
}

@property (nonatomic, retain) UIButton *btnAddPhotos;
@property (nonatomic, retain) UIImagePickerController *imagePicker;
@property (nonatomic, retain) NSMutableArray *imageArr;//拍照图片集合
@property (nonatomic, retain) CommunityHttpRequest *modifyMyInfoRequest;

@end

@implementation EditMyInfoViewController

@synthesize imageArr = _imageArr;
@synthesize btnAddPhotos = _btnAddPhotos;
@synthesize imagePicker = _imagePicker;
@synthesize personalInfo = _personalInfo;
@synthesize modifyMyInfoRequest = _modifyMyInfoRequest;

- (void)dealloc{
    [_modifyMyInfoRequest cancelDelegate:self];
    _imagePicker.delegate = nil;    _imagePicker = nil;
    myTableView.dataSource = nil;   myTableView.delegate = nil;
    [myTableView release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
         _imageArr = [[NSMutableArray alloc]initWithCapacity:0];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
    [MobClick beginLogPageView:@"EditMyInfoPage"]; // 友盟统计
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
    [MobClick endLogPageView:@"EditMyInfoPage"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController setNavigationBarHidden:NO];
    [self.view setBackgroundColor:RGB(244, 244, 244)];
    
    //自适应iOS的导航栏、状态栏
    [self adjustiOS7NaviagtionBar];
    [self setNavigationTitle:@"编辑资料"];
    //自定义返回按钮
    UIButton *backButton = [self setBackBarButton];
    [backButton addTarget:self action:@selector(leftBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self setBackBarButtonItem:backButton];

    
    //    右边按钮
    UIImage *rightImage = [UIImage imageNamed:@"icon_phone_add_save.png"];
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setImage:rightImage forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    rightBtn.frame = CGRectMake(0,0,44,44);
    [self setRightBarButtonItem:rightBtn];
    
    //uitableview列表
    myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, /*contentScrollView.frame.size.height+contentScrollView.frame.origin.y+20*/CGRectGetMaxY(navImageView.frame), ScreenWidth, ScreenHeight) style:UITableViewStylePlain];
    myTableView.backgroundColor = RGB(244, 244, 244);
    myTableView.delegate = self;
    myTableView.dataSource = self;
    myTableView.tableFooterView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
    myTableView.tableHeaderView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
    [self.view addSubview:myTableView];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ---Action
- (void)leftBtnAction:(UIButton *)sender{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"确认放弃本次编辑吗?" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    alert.tag = 11;
    [alert show];
    [alert release];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 11) {
        if (buttonIndex == 0) {
            [self popViewController];
        }else{
            NSLog(@"不想退出编辑");
        }
    }
    
}

- (void)popViewController{
    if ([tfNikeName resignFirstResponder] || [tvDescription resignFirstResponder]) {
        [tfNikeName resignFirstResponder];
        [tvDescription resignFirstResponder];
    }
    [self.navigationController popViewControllerAnimated:YES];

}

- (void)rightBtnAction:(UIButton *)sender{
    NSLog(@"%@",sender);
    [self requestModifyMyInfo];
}

- (void)addPicBtnAction:(UIButton *)sender{
    UIActionSheet* mySheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消"destructiveButtonTitle:@"拍照" otherButtonTitles:@"从相册选择", nil];
    [mySheet showInView:[UIApplication sharedApplication].keyWindow];
    [mySheet release];
}

#pragma mark ---network
- (void)requestModifyMyInfo{
    if (tfNikeName.text.length == 0) {
        [Common showMessage:@"昵称不能为空" showInfo:nil WithDelegate:nil];
        return;
    }
    NSString *sex = @"男";
    if (btnMale.selected) {
        sex = @"男";
    }
    else{
        sex = @"女";
    }
    NSString *signature = @"";
    if (/*tvDescription.text.length == 0*/0) {
         [Common showMessage:@"描述不能为空" showInfo:nil WithDelegate:nil];
    }else{
       signature = tvDescription.text;
        UserModel *userModel = [UserModel shareUser];
        NSString *strParameter = [NSString stringWithFormat:@"%@%@%@%@%@%@%@",userModel.userId,userModel.communityId,userModel.propertyId,tfNikeName.text,sex,signature,userModel.token];
        NSString *token = [strParameter md5];
        NSString *parameters = [NSString stringWithFormat:@"?%@=%@&%@=%@&%@=%@&%@=%@&%@=%@&%@=%@&%@=%@",USER_ID,userModel.userId,COMMUNITY_ID,userModel.communityId,PROPERTY_ID,userModel.propertyId,@"nickName",tfNikeName.text,@"sex",sex,@"signature",tvDescription.text,@"token",token];
        
        if (_modifyMyInfoRequest == nil) {
            _modifyMyInfoRequest = [CommunityHttpRequest shareInstance];
        }

        [_modifyMyInfoRequest requestModifyMyInfo:self parameters:parameters];
    }
}

-(void) callBackWith: (WInterface) interface status: (NSString*) status data:(id) data{
    NSLog(@"interface :%d status:%@",interface,status);
    if (interface == COMMUNITY_PROFILE_UPDATE) {
        NSString *code = [data objectForKey:ERROR_CODE];
        if ([code isEqualToString:NETWORK_RETURN_CODE_S_OK]) {
            [self popViewController];

        }else{
            if ([code isEqualToString:NETWORK_RETURN_POWER_AUTH_ERROR]) {
                LoginViewController *loginVc = [[LoginViewController alloc] init];
                loginVc.loginType = LOGIN_MODAL;
                UINavigationController *nav = [[[UINavigationController alloc] initWithRootViewController:loginVc] autorelease];
                [self.navigationController presentViewController:nav animated:YES completion:nil];
                [loginVc release];
            }
        }
        
    }
    else{
        
    }
}

//选择照相，或者照片库
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;
{
    if (buttonIndex == 0) {
        
        BOOL iscamera = [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
        if (!iscamera) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"没有相机" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
            [alert release];
            return;
        }

    }
    if (buttonIndex == 1) {

        
    }
    
}

#pragma mark ---UITableView Datasorce
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    static NSString *identifier = @"Cell";
    
    UITableViewCell  *cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier]autorelease];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    switch (section) {
        case 0:
            if (row == 0) {
                tfNikeName = [[UITextField alloc]initWithFrame:CGRectMake(18, 0, 320, 44)];
                tfNikeName.delegate=self;
                tfNikeName.borderStyle = UITextBorderStyleNone;
                //tfNikeName.font = [UIFont systemFontOfSize:15.0];
                tfNikeName.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;//字体垂直居中对齐
                tfNikeName.text = [_personalInfo objectForKey:@"nickName"];
                [cell.contentView addSubview:tfNikeName];
                [tfNikeName release];
            }
            if (row == 1) {
                //[[_personalInfo objectForKey:@"sex"] isEqualToString:@"男"]
                //[_personalInfo objectForKey:@"nickName"];
                btnMale = [UIButton buttonWithType:UIButtonTypeCustom];
                btnMale.frame = CGRectMake(15, 0, 65, 44);
                [btnMale setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [btnMale setTitle:@"男" forState:UIControlStateNormal];
                [btnMale setImage:[UIImage imageNamed:@"icon_box.png"] forState:UIControlStateNormal];
                [btnMale setImage:[UIImage imageNamed:@"icon_box_selected.png"] forState:UIControlStateSelected];
                btnMale.imageEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 0);
                [btnMale addTarget:self action:@selector(clickMale:) forControlEvents:UIControlEventTouchUpInside];
                [cell.contentView addSubview:btnMale];
                
                btnFemale = [UIButton buttonWithType:UIButtonTypeCustom];
                btnFemale.frame = CGRectMake(CGRectGetMaxX(btnMale.frame)+5, 0, 65, 44);
                [btnFemale setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [btnFemale setTitle:@"女" forState:UIControlStateNormal];
                [btnFemale setImage:[UIImage imageNamed:@"icon_box.png"] forState:UIControlStateNormal];
                [btnFemale setImage:[UIImage imageNamed:@"icon_box_selected.png"] forState:UIControlStateSelected];
                btnFemale.imageEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 0);
                [btnFemale addTarget:self action:@selector(clickFemale:) forControlEvents:UIControlEventTouchUpInside];
                [cell.contentView addSubview:btnFemale];
                
                if ([[_personalInfo objectForKey:@"sex"] isEqualToString:@"男"]) {
                    btnMale.selected = YES;
                    btnFemale.selected = NO;
                } else {
                    btnMale.selected = NO;
                    btnFemale.selected = YES;
                }
            }
            break;
        case 1:
            if (row == 0) {
                tvDescription = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, 300, 80)];
                tvDescription.delegate=self;
                //tfDescription.borderStyle = UITextBorderStyleNone;
                tvDescription.font = [UIFont systemFontOfSize:15.0];
                tvDescription.backgroundColor = [UIColor clearColor];
                //tvDescription.placeholder = @"请输入您的签名";
                tvDescription.text = [_personalInfo objectForKey:@"signature"];
                [cell addSubview:tvDescription];
                [tvDescription release];
            }
            break;
        default:
            break;
    }
    return cell;

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }else if (section == 1){
        return 10;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        UIView *view = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 10)] autorelease];
        view.backgroundColor = self.view.backgroundColor;
        return view;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 44.0f;
    }else{
        return 80.0f;
    }
    return 44.0f;
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 2;
    }
    if (section == 1) {
        return 1;
    }
    return 0;
}

#pragma mark ---uitextview Delegate

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    //限制字符在50个以内  add by Devin
    if ([text isEqualToString:@"\n"]){
        [textView resignFirstResponder];
        return NO;
    }
    NSString * aString = [textView.text stringByReplacingCharactersInRange:range withString:text];
        
    if (textView == tvDescription)
    {
        if ([aString length] > 50) {
            return NO;
        }
    }
    return YES;
}



#pragma mark ---uitextfield Delegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{//限制字符在12个以内  add by Devin
    if ([string isEqualToString:@"\n"]){
        return YES;
    }
    NSString * aString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (textField == tfNikeName)
    {
        if ([aString length] > 12 && range.length == 0) {
            return NO;
        }
    }
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{

    [tfNikeName resignFirstResponder];
    return YES;
}


#pragma mark ---UIAction
- (void)clickMale:(UIButton *)sender{
    btnMale.selected = YES;
    btnFemale.selected = NO;
}

- (void)clickFemale:(UIButton *)sender{
    btnMale.selected = NO;
    btnFemale.selected = YES;
}

@end
