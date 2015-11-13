//
//  EndRegisterViewController.m
//  CommunityAPP
//
//  Created by Dream on 14-3-19.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import "EndRegisterViewController.h"
#import "Global.h"
#import "NSObject_extra.h"
#import "ASIFormDataRequest.h"
#import "AppDelegate.h"
#import "UserModel.h"
#import "UIViewController+NavigationBar.h"
#import "AppConfig.h"
#import "JSONKit.h"
#import "MobClick.h"

@interface EndRegisterViewController ()

@end

@implementation EndRegisterViewController
@synthesize uuidString;
@synthesize phoneFieldString;
@synthesize imageData;
@synthesize pwsString;

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
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [httpRequest cancelDelegate:self];
    [super dealloc];
}
- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
    [MobClick beginLogPageView:@"EndRegisterPage"];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
    [MobClick endLogPageView:@"EndRegisterPage"];
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
    [rightBtn setTitle:@"完成" forState:UIControlStateNormal];
    [rightBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:15.0]];
    [rightBtn addTarget:self action:@selector(rightBtnAction) forControlEvents:UIControlEventTouchUpInside];
    rightBtn.frame = CGRectMake(280,0,60,44);
    [self setRightBarButtonItem:rightBtn];

    
    //头像图像
    headerImg = [UIImage imageNamed:@"girl_header1.png"];
    headerImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    headerImageBtn.layer.cornerRadius = 47.7;
    headerImageBtn.layer.masksToBounds = YES;
    headerImageBtn.frame = CGRectMake((ScreenWidth-headerImg.size.width)/2, 45, headerImg.size.width, headerImg.size.height);
    [headerImageBtn setBackgroundImage:headerImg forState:UIControlStateNormal];
    [headerImageBtn addTarget:self action:@selector(headerImageBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:headerImageBtn];
    
    //性别按钮
     UIImage *boyImg = [UIImage imageNamed:@"sex-boy1.png"];
    boyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    boyBtn.frame = CGRectMake(85, 175, boyImg.size.width, boyImg.size.height);
    [boyBtn setBackgroundImage:boyImg forState:UIControlStateNormal];
    [boyBtn addTarget:self action:@selector(boyBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:boyBtn];
    
    
    UIImage *girlImg = [UIImage imageNamed:@"sex-selected-girl1.png"];
    girlBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    girlBtn.frame = CGRectMake(195, 175, girlImg.size.width, girlImg.size.height);
    [girlBtn setBackgroundImage:girlImg forState:UIControlStateNormal];
    [girlBtn addTarget:self action:@selector(girlBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:girlBtn];
    
    //输入密码
    nameField = [[UITextField alloc]initWithFrame:CGRectMake(10, 195+boyImg.size.height,ScreenWidth-20 , 40)];
    nameField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;//字体垂直居中对齐
    nameField.font = [UIFont systemFontOfSize:16.0];
    nameField.placeholder = @"昵称";
    nameField.borderStyle = UITextBorderStyleNone;
    nameField.background = APP_imageStrench;
    nameField.delegate = self;
    nameField.keyboardType = UIKeyboardTypeDefault;
    nameField.returnKeyType = UIReturnKeyDone;
    //设置光标坐标
    UIView *nameView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 11, 0)];
    nameField.leftView = nameView;
    nameField.leftViewMode = UITextFieldViewModeAlways;
    [nameView release];
    [self.view addSubview:nameField];
    [nameField release];

    [self registerForKeyboardNotifications];
    
    //点击退出键盘
    UITapGestureRecognizer *closeTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeKeyBoard)];
    [self.view addGestureRecognizer:closeTap];
    [closeTap release];
    
//性别默认为男
    userSex = CMUserFemale;
}
//导航栏左按钮
-(void)leftBtnAction
{
    [self.navigationController popViewControllerAnimated:YES];
}
//关闭键盘
-(void)closeKeyBoard
{
    [nameField resignFirstResponder];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [nameField resignFirstResponder];
    return YES;
}
//更换性别按钮
-(void)boyBtn
{
    userSex = CMUserMale;
    UIImage *boyHeader = [UIImage imageNamed:@"boy_header1.png"];
    [headerImageBtn setBackgroundImage:boyHeader forState:UIControlStateNormal];
    [boyBtn setBackgroundImage:[UIImage imageNamed:@"sex-selected-boy1.png"] forState:UIControlStateNormal];
    [girlBtn setBackgroundImage:[UIImage imageNamed:@"sex-girl1.png"] forState:UIControlStateNormal];
}
-(void)girlBtn
{
    userSex = CMUserFemale;
    UIImage *girlHeader = [UIImage imageNamed:@"girl_header1.png"];
     [headerImageBtn setBackgroundImage:girlHeader forState:UIControlStateNormal];
    [boyBtn setBackgroundImage:[UIImage imageNamed:@"sex-boy1.png"] forState:UIControlStateNormal];
    [girlBtn setBackgroundImage:[UIImage imageNamed:@"sex-selected-girl1.png"] forState:UIControlStateNormal];
}

//从相册获取头像
-(void)headerImageBtn
{
    [nameField resignFirstResponder];
    UIActionSheet* mySheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消"destructiveButtonTitle:@"拍照" otherButtonTitles:@"从相册选择", nil];
    [mySheet showInView:[UIApplication sharedApplication].keyWindow];
    [mySheet release];
}
//选择照相，或者照片库
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;
{
    if (buttonIndex == 0) {
        
        BOOL iscamera = [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
        if (!iscamera) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"没有相机" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
            [alert show];
            [alert release];
            return;
        }
        UIImagePickerController *pick = [[UIImagePickerController alloc]init];
        pick.delegate = self;
        pick.sourceType = UIImagePickerControllerSourceTypeCamera;
        pick.allowsEditing = YES;
        [self presentViewController:pick animated:YES completion:NULL];
        [pick release];
    }
    if (buttonIndex == 1) {
        UIImagePickerController *pick  =[[UIImagePickerController alloc] init];
        pick.allowsEditing = YES;
        //设置委托
        pick.delegate=self;
        pick.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:pick animated:YES completion:NULL];
        [pick release];
    }
}

////确定
//-(void)sureBtn
//{
//    if ([nameField.text length]!=0) {
//        hudView = [Global showMBProgressHud:self SuperView:self.view Msg:@"请稍候..."];//       请求验证验证码是否正确
//        [self requestAddAuction];
//    }else{
//        [self alertWithFistButton:@"确定" SencodButton:nil Message:@"昵称不能为空"];
//        [nameField becomeFirstResponder];
//    }
//}

#pragma mark ---network
- (void)requestAddAuction{
    
    NSString *str = HTTPURLPREFIX;
    NSString *urlString = [str stringByAppendingString:REGISTER_STEPTWO];
    NSString *maleString;
    if (userSex == 0) {
        maleString = @"男";
    }else{
         maleString = @"女";
    }
    ASIFormDataRequest *uploadImageRequest= [ ASIFormDataRequest requestWithURL : [NSURL URLWithString:[urlString   stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    [uploadImageRequest setStringEncoding:NSUTF8StringEncoding];
    [uploadImageRequest setRequestMethod:@"POST"];
    [uploadImageRequest addPostValue:nameField.text forKey:@"nickName"];
    [uploadImageRequest addPostValue:maleString forKey:@"sex"];
    //[uploadImageRequest addPostValue:[NSString stringWithFormat:@"%@%@",self.phoneFieldString,self.uuidString] forKey:@"uuid"];
    [uploadImageRequest addPostValue:[NSString stringWithFormat:@"%@",self.uuidString] forKey:@"uuid"];
    [uploadImageRequest addData:self.imageData withFileName:@"register.png" andContentType:nil forKey:@"userIcon"];
    [uploadImageRequest setPostFormat:ASIMultipartFormDataPostFormat];
    [uploadImageRequest setDelegate : self ];
    [uploadImageRequest setDidFinishSelector : @selector (responseComplete:)];
    [uploadImageRequest setDidFailSelector : @selector (responseFailed:)];
    [uploadImageRequest startAsynchronous];
}

- (void)responseComplete:(ASIFormDataRequest *)request{
    
    NSString* response = [request responseString];
    NSLog(@"response %@",response);
    
    NSDictionary *dictionary = [response objectFromJSONString];
    NSString *status = [dictionary objectForKey:@"errorCode"];
    if ([status isEqualToString:NETWORK_RETURN_CODE_S_OK]) {

        UserModel *userModel = [UserModel shareUser];
        userModel.userId = [dictionary objectForKey:@"userId"];
        userModel.userName = [dictionary objectForKey:@"userName"];
        userModel.propertyId = [dictionary objectForKey:@"propertyId"];
        userModel.communityId = [dictionary objectForKey:@"communityId"];
        userModel.token = [dictionary objectForKey:@"token"];
        userModel.userName = [dictionary objectForKey:@"userName"];
        userModel.communityName = [dictionary objectForKey:@"communityName"];
        [userModel saveUserInfo];

        [MobClick event:@"Register_Third_Complete"];
        
        [self hideHudView];

        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        //        请求邻居和分组列表
        [delegate requestGruopList];
        [delegate requestFriendList];
        
        if( [delegate respondsToSelector:@selector(loadAnimationEndedCallback:)] )
        {
            [delegate loadAnimationEndedCallback:nil];
        }
    }
}

- (void)responseFailed:(ASIFormDataRequest *)request{
     [self hideHudView];
    
    NSString* response = [request responseString];
    NSLog(@"response %@",response);
    
    NSDictionary *dictionary = [response objectFromJSONString];
    NSString *status = [dictionary objectForKey:@"errorCode"];
    if (![status isEqualToString:NETWORK_RETURN_CODE_S_OK]) {
        NSLog(@"上传失败");
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -- uitextfieldDelegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{//限制字符在20个以内  add by Devin
    if ([string isEqualToString:@"\n"]){
        return YES;
    }
    NSString * aString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (textField == nameField)
    {
        if ([aString length] > 11) {
            return NO;
        }
    }
    return YES;
}
#pragma mark --UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    self.imageData = UIImagePNGRepresentation(image);
    [headerImageBtn setImage:image forState:UIControlStateNormal];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShown:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWillShown:(NSNotification*)aNotification
{
    
    if (!isIPhone5) {
        [UIView animateWithDuration:0.4
                         animations:^{
                             self.view.transform = CGAffineTransformMakeTranslation(0, -70);
                         }];
    }
}
// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    [UIView animateWithDuration:0.4
                     animations:^{
                         self.view.transform = CGAffineTransformIdentity;
                     }];
}


-(void)rightBtnAction{
    if ([nameField.text length]!=0) {
        hudView = [Global showMBProgressHud:self SuperView:self.view Msg:@"请稍候..."];//       请求验证验证码是否正确
        [self requestAddAuction];
    }else{
        [self alertWithFistButton:@"确定" SencodButton:nil Message:@"昵称不能为空"];
        [nameField becomeFirstResponder];
    }
}

- (void) hideHudView
{
    if (hudView) {
        [hudView hide:YES];
    }
}
@end
