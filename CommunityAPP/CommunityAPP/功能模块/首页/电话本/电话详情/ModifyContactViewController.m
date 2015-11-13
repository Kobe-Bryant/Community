//
//  ModifyContactViewController.m
//  CommunityAPP
//
//  Created by Stone on 14-3-26.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import "ModifyContactViewController.h"
#import "Global.h"
#import "NSObject_extra.h"
#import "ContactModel.h"
#import "UserModel.h"
#import "CommunityHttpRequest.h"
#import "DataBaseManager.h"
#import "MakePhoneCall.h"
#import "NSObject+Time.h"
#import "ASIWebServer.h"
#import "UIViewController+NavigationBar.h"
#import "MobClick.h"

@interface ModifyContactViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,WebServiceHelperDelegate,UITextViewDelegate>{
    UITableView     *_tableView;
    UIButton        *btnSave;
    UITextView     *editField;
    UIView *bgView;
}

@property (nonatomic, retain) CommunityHttpRequest *request;
@property (nonatomic, retain) DataBaseManager *dbManager;

@end

@implementation ModifyContactViewController

@synthesize request = _request;
@synthesize contactModel = _contactModel;
@synthesize modifyType = _modifyType;
@synthesize dbManager = _dbManager;

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
    [MobClick beginLogPageView:@"ModifyContactPage"];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
    [MobClick endLogPageView:@"ModifyContactPage"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    //自适应iOS的导航栏、状态栏
    [self adjustiOS7NaviagtionBar];
    [self setNavigationTitle:@"电话"];
    //自定义返回按钮
    UIButton *backButton = [self setBackBarButton];
    [backButton addTarget:self action:@selector(leftBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self setBackBarButtonItem:backButton];
    //    右边按钮
    UIImage *rightImage = [UIImage imageNamed:@"icon_phone_add_save.png"];
    UIButton *editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [editBtn setImage:rightImage forState:UIControlStateNormal];
    [editBtn addTarget:self action:@selector(rightBtnAction) forControlEvents:UIControlEventTouchUpInside];
    editBtn.frame = CGRectMake(275,0,44,44);
    [self setRightBarButtonItem:editBtn];
    
    //设置页面背景颜色
    self.view.backgroundColor = RGB(246, 246, 246);
    
    
    //UIView添加电话详情
    bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 44)];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.layer.borderWidth = 1.0;
    bgView.layer.borderColor = RGB(231, 231, 231).CGColor;
    [self.view addSubview:bgView];
    [bgView release];
    
    editField = [[UITextView alloc] initWithFrame:CGRectMake(8, 0, 280, 44)];
    editField.font = [UIFont systemFontOfSize:20.0f];
 
    editField.delegate = self;
    [bgView addSubview:editField];
    [editField release];
    
    [self updateTextField];
    
    [self adjustView:editField];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ---action
- (void)leftBtnAction{
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"是否放弃编辑" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    alert.tag = 10000;
    [alert show];
    [alert release];
}

- (void)rightBtnAction{
    NSLog(@"save");
    //requestEditContact
    //((\d{11})|^((\d{7,8})|(\d{4}|\d{3})-(\d{7,8})|(\d{4}|\d{3})-(\d{7,8})-(\d{4}|\d{3}|\d{2}|\d{1})|(\d{7,8})-(\d{4}|\d{3}|\d{2}|\d{1}))$)
    
    if (_modifyType == CONTACT_PHONENUM) {
        NSString * regex = @"[\\s\\S]{3,12}";//@"(\\(\\d{3,4}\\)|\\d{3,4}-|\\s)?\\d{7,14}";//((/d{11})|^((/d{7,8})|(/d{4}|/d{3})-(/d{7,8})|(/d{4}|/d{3})-(/d{7,8})-(/d{4}|/d{3}|/d{2}|/d{1})|(/d{7,8})-(/d{4}|/d{3}|/d{2}|/d{1}))$)
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
        BOOL isMatch = [pred evaluateWithObject:editField.text];
        if (!isMatch) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"电话号码格式不正确" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            [alert release];
            return;
        }
        [self updateContactModel];
        [self requestEditContact];
    }else{
        [self updateContactModel];
        [self requestEditContact];
    }


}

- (void)updateContactModel{
    if (editField.text.length == 0) {
        [self alertWithFistButton:nil SencodButton:@"确定" Message:@"不能为空"];
        return;
    }
    switch (_modifyType) {
        case CONTACT_NAME:
            _contactModel.contactName = editField.text;
            break;
        case CONTACT_PHONENUM:
            _contactModel.phoneNumber = editField.text;
            
            break;
        case CONTACT_DESCRIPTION:
            _contactModel.contactDescription = editField.text;
            break;
        default:
            break;
    }
    _dbManager = [DataBaseManager shareDBManeger];
    BOOL flag = [_dbManager updateMyContact:_contactModel];
    if (flag) {
        NSLog(@"成功");
    }
    //UPDATE t_contacts set contact_name = abcdf,contact_call= 1232134546465, contact_description = dsfsdfsd, WHERE contact_id = '82'
}

- (void)updateTextField{
    switch (_modifyType) {
        case CONTACT_NAME:
            editField.text = _contactModel.contactName;
            break;
        case CONTACT_PHONENUM:
            editField.text = _contactModel.phoneNumber;
            editField.keyboardType = UIKeyboardTypeNumberPad;
            break;
        case CONTACT_DESCRIPTION:
            editField.text = _contactModel.contactDescription;
            break;
        default:
            break;
    }
}

- (void)requestEditContact{
    UserModel *userModel = [UserModel shareUser];
    NSString *parameters = [NSString stringWithFormat:@"?%@=%@&%@=%@&%@=%@&%@=%@&id=%d&%@=%@&%@=%@&%@=%@",UPDATE_TIME,DEF_UPDATE_TIME,USER_ID,userModel.userId,COMMUNITY_ID,userModel.communityId,PROPERTY_ID,userModel.propertyId,_contactModel.contactId,CONTACT,_contactModel.contactName,PHONE_NUMBER,_contactModel.phoneNumber,DESCRIPTION,_contactModel.contactDescription];
    
    if (_request == nil) {
        _request = [CommunityHttpRequest shareInstance];
    }
    [_request editContact:self parameters:parameters];
}

#pragma mark ---UITableViewDatasorce
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identify = @"identify";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    if (indexPath.row == 0) {

        [cell.contentView addSubview:editField];
        [editField becomeFirstResponder];

    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

#pragma mark ---UITableViewDelegate
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark --- UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField{

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    return YES;
}

-(void) callBackWith: (WInterface) interface status: (NSString*) status data:(id) data{
    if (interface == COMMUNITY_PRIVATE_CONTACTS_UPDATE) {
        if ([status isEqualToString:NETWORK_RETURN_CODE_S_OK]) {
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [self alertWithFistButton:nil SencodButton:@"确定" Message:@"修改电话失败"];

        }
    }
}

- (void)textViewDidChange:(UITextView *)textView{
    [self adjustView:textView];
}

- (void)adjustView:(UITextView *)textView{
    CGSize newSize = [textView.text
                      sizeWithFont:[UIFont fontWithName:@"Helvetica" size:20]
                      constrainedToSize:CGSizeMake(280-20,9999)
                      lineBreakMode:NSLineBreakByCharWrapping];
    editField.frame = CGRectMake(8, 0, 280, newSize.height * 1.3);
    
    CGRect rect = CGRectMake(CGRectGetMinX(bgView.frame), CGRectGetMinY(bgView.frame), CGRectGetWidth(bgView.frame),newSize.height * 1.3+10);
    if (newSize.height*1.3+5 <= 44) {
        rect = CGRectMake(CGRectGetMinX(bgView.frame), CGRectGetMinY(bgView.frame), CGRectGetWidth(bgView.frame),44);
    }
    
    bgView.frame = rect;

//    if (newSize.height <= 44) {
//        editField.frame = CGRectMake(8, 0, 280, 44);
//        CGRect rect = CGRectMake(CGRectGetMinX(bgView.frame), CGRectGetMinY(bgView.frame), CGRectGetWidth(bgView.frame),44);
//        bgView.frame = rect;
//    }else{
//        editField.frame = CGRectMake(8, 0, 280, editField.contentSize.height);
//        CGRect rect = CGRectMake(CGRectGetMinX(bgView.frame), CGRectGetMinY(bgView.frame), CGRectGetWidth(bgView.frame),editField.contentSize.height);
//        bgView.frame = rect;
//        
//    }
    
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 10000) {
        if (buttonIndex == 0) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}
@end
