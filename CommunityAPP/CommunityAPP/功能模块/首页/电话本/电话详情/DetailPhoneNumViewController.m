//
//  DetailPhoneNumViewController.m
//  CommunityAPP
//
//  Created by Dream on 14-3-6.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import "DetailPhoneNumViewController.h"
#import "Global.h"
#import "NSObject_extra.h"
#import "ContactModel.h"
#import "UserModel.h"
#import "CommunityHttpRequest.h"
#import "DataBaseManager.h"
#import "MakePhoneCall.h"
#import "NSObject+Time.h"
#import "ModifyContactViewController.h"
#import "UIViewController+NavigationBar.h"
#import "PhoneBookViewController.h"
#import "MobClick.h"

@interface DetailContactTableViewCell : UITableViewCell

@property (nonatomic, retain) UITextField *textField;       //default


@end

@implementation DetailContactTableViewCell

@synthesize textField = _textField;

- (void)dealloc{
    [_textField release];   _textField = nil;
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.textLabel.textColor = RGB(190, 190, 190);
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(70, 0, 248, 43.5)];  //15
        _textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;//字体垂直居中对齐
        _textField.enabled = NO;
        [self addSubview:_textField];
        
    }
    return self;
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated{
    [super setEditing:editing animated:animated];
    if (editing) {
        _textField.enabled = YES;
        _textField.borderStyle = UITextBorderStyleNone;
        
    }else{
        _textField.enabled = NO;
        _textField.borderStyle = UITextBorderStyleNone;
    }
}

@end

@interface DetailPhoneNumViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    UITableView *detailTableView;
    UIButton *editBtn;
    UIButton *dialBtn;
    
    UITextField *contactNameFiled;
    UITextField *phoneNumField;
    UITextField *descriptionField;
    
}

@property (nonatomic, retain) CommunityHttpRequest *updateContactRequest;
@property (nonatomic, retain) DataBaseManager *dbManager;
@property(copy,nonatomic) void (^AlertView)(NSString * title,NSString * message);//显示提示框
@property (nonatomic, retain) UIWebView *phoneCallWebView;

@end

@implementation DetailPhoneNumViewController

@synthesize updateContactRequest = _updateContactRequest;
@synthesize contactModel = _contactModel;
@synthesize dbManager = _dbManager;
@synthesize AlertView=_AlertView;
@synthesize phoneCallWebView = _phoneCallWebView;

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
    [_updateContactRequest cancelDelegate:self];
    [detailTableView release]; detailTableView = nil;
    [super dealloc];
}
- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
    [detailTableView reloadData];
    [MobClick beginLogPageView:@"DetailPhoneNumPage"];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
    [MobClick endLogPageView:@"DetailPhoneNumPage"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    //自适应iOS的导航栏、状态栏
    [self adjustiOS7NaviagtionBar];
    [self setNavigationTitle:_contactModel.typeName];
    
    //自定义返回按钮
    UIButton *backButton = [self setBackBarButton];
    [backButton addTarget:self action:@selector(backBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self setBackBarButtonItem:backButton];
    

    //    右边按钮
//    UIImage *rightImage = [UIImage imageNamed:@"icon_phone_add_save.png"];
//    editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [editBtn setImage:rightImage forState:UIControlStateNormal];
//    [editBtn addTarget:self action:@selector(editContact:) forControlEvents:UIControlEventTouchUpInside];
//    editBtn.frame = CGRectMake(275,0,44,44);
//    [navImageView addSubview:editBtn];
    
    //设置页面背景颜色
    self.view.backgroundColor = RGB(246, 246, 246);
    
    //uitableview视图显示电话详情
    detailTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 400) style:UITableViewStylePlain];
    detailTableView.backgroundColor = RGB(246, 246, 246);
    detailTableView.scrollEnabled = NO;
    detailTableView.delegate = self;
    detailTableView.dataSource = self;
    [self.view addSubview:detailTableView];
    
    //拨号button
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 105)];
    [detailTableView setTableFooterView:footView];//把uiview设置成uitableview的footview
    
    dialBtn = [[UIButton alloc]initWithFrame:CGRectMake(10,60, 300, 40)];
    [dialBtn setBackgroundColor:[UIColor clearColor]];
    [dialBtn setBackgroundImage:[UIImage imageNamed:@"dial_phone.png"] forState:UIControlStateNormal];
    [dialBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [dialBtn setTitle:@"拨      号" forState:UIControlStateNormal];
    [dialBtn addTarget:self action:@selector(makePhoneCall:) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:dialBtn];
    [dialBtn release];
    [footView release];

    [self setAlertView:^(NSString *title, NSString *msg) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                        message:msg
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
    }];
}

- (void)setContactModel:(ContactModel *)contactModel{
    if (contactModel != _contactModel) {
        [_contactModel release];
        _contactModel = [contactModel retain];
    }
    
    [self setNavigationTitle:_contactModel.typeName];

}

#pragma mark --- uitableviwDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return 3;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"Cell";
    DetailContactTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell =[[[DetailContactTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier]autorelease];
        cell.textLabel.font = [UIFont systemFontOfSize:15.0];
        cell.textLabel.textColor = RGB(84, 83, 84);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    

    if (indexPath.section == 0) {
        
        if ([_contactModel.type integerValue] == [MY_PRIVATE_CONTACTS_TYPE_ID integerValue]) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
        if (indexPath.row == 0) {
            cell.textLabel.text = @"名称";
            cell.textField.text = _contactModel.contactName;
            contactNameFiled = cell.textField;
            contactNameFiled.font = [UIFont systemFontOfSize:16.0];
            contactNameFiled.textColor = RGB(51, 51, 51);
        }
        if (indexPath.row == 1) {
            cell.textLabel.text = @"电话";
            cell.textField.text = _contactModel.phoneNumber;
            phoneNumField = cell.textField;
            phoneNumField.font = [UIFont systemFontOfSize:16.0];
            phoneNumField.textColor = RGB(51, 51, 51);
        }
        if (indexPath.row == 2) {
            cell.textLabel.text = @"描述";
            cell.textField.text = _contactModel.contactDescription;
            descriptionField = cell.textField;
            descriptionField.font = [UIFont systemFontOfSize:16.0];
            descriptionField.textColor = RGB(51, 51, 51);
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
     [tableView deselectRowAtIndexPath:indexPath animated:YES];
    /*
    
     ContactModel *model = ([self.contacts count] > indexPath.row) ? [self.contacts objectAtIndex:indexPath.row] : nil;
     DetailPhoneNumViewController *detailPhoneVC = [[DetailPhoneNumViewController alloc] initWithNibName:nil bundle:nil];
     detailPhoneVC.contactModel = model;
     [self.navigationController pushViewController:detailPhoneVC animated:YES];
     [detailPhoneVC release];
     */
    if (indexPath.section == 0) {
        if ([_contactModel.type integerValue] == [MY_PRIVATE_CONTACTS_TYPE_ID integerValue])
        {
            ModifyContactViewController *vc = [[ModifyContactViewController alloc] initWithNibName:nil bundle:nil];
            vc.contactModel = _contactModel;
            if (indexPath.row == 0) {
                vc.modifyType = CONTACT_NAME;
            }else if (indexPath.row == 1){
                vc.modifyType = CONTACT_PHONENUM;
            }else if (indexPath.row == 2){
                vc.modifyType = CONTACT_DESCRIPTION;
            }
        
        [self.navigationController pushViewController:vc animated:YES];
            [vc release];
        }
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return NO;
    }
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleNone;
}





//返回上一级页面
-(void)backBtnAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateDBContact{
    _dbManager = [DataBaseManager shareDBManeger];
    _contactModel.contactName = contactNameFiled.text;
    _contactModel.phoneNumber = phoneNumField.text;
    _contactModel.contactDescription = descriptionField.text;
    if ([_dbManager updateMyContact:_contactModel]) {
        NSLog(@"更新数据库成功");
    }
}

#pragma mark ---Action
- (void)makePhoneCall:(UIButton *)sender{
    NSLog(@"%@",NSStringFromSelector(_cmd));
    NSLog(@"%d",sender.tag);
    if (_contactModel == nil) {
        return;
    }
    NSString *msg;
    BOOL call_ok = [self makeCall:_contactModel.phoneNumber];
    
    if (call_ok) {
        ContactModel *model = [_contactModel copy];
        
        model.typeName = @"最近";
        model.type = @"最近";
        model.lastCallTime = [NSObject getCurrentTime];
        _dbManager = [DataBaseManager shareDBManeger];
        
        BOOL flag = [_dbManager insertMadePhoneCall:model];
        if (flag) {
            NSLog(@"插入拨打电话记录成功");
        }else{
            NSLog(@"插入拨打电话记录失败");
        }
    }else{
        msg=@"设备不支持电话功能";
        [self alertWithTitle:nil msg:msg];
    }
}

- (BOOL) makeCall:(NSString *)phoneNumber
{
    if (phoneNumber==nil ||[phoneNumber isEqualToString:@""])
    {
        return NO;
    }
    BOOL call_ok = false;
    NSString *numberAfterClear = [[phoneNumber componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789-+()"] invertedSet]] componentsJoinedByString:@""];
    NSURL *phoneNumberURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", numberAfterClear]];
    NSLog(@"make call, URL=%@", phoneNumberURL);
    
    call_ok = [[UIApplication sharedApplication] canOpenURL:phoneNumberURL];
    
    if (call_ok) {
        if ( !_phoneCallWebView ) {
            _phoneCallWebView = [[UIWebView alloc]initWithFrame:CGRectZero];// 这个webView只是一个后台的容易 不需要add到页面上来 效果跟方法二一样 但是这个方法是合法的
        }
        [_phoneCallWebView loadRequest:[NSURLRequest requestWithURL:phoneNumberURL]];
        [self.view addSubview:_phoneCallWebView];
    }
    return call_ok;
}

- (void) alertWithTitle: (NSString *)title msg: (NSString *)msg
{
    if (self.AlertView) {
        self.AlertView(title,msg);
    }
}


- (void)editContact:(UIButton *)sender{
    NSLog(@"编辑");
    if (sender) {
        [sender addTarget:self action:@selector(cancelEditing:) forControlEvents:UIControlEventTouchUpInside];
        [detailTableView setEditing:YES animated:YES];
    }
}

- (void)cancelEditing:(UIButton *)sender{
    NSLog(@"取消编辑");
    if (sender) {
        
        [self requestEditContact];
        [detailTableView setEditing:NO animated:YES];
    }

}

- (void)requestEditContact{
    UserModel *userModel = [UserModel shareUser];
    NSString *parameters = [NSString stringWithFormat:@"?%@=%@&%@=%@&%@=%@&%@=%@&id=%d&%@=%@&%@=%@&%@=%@",UPDATE_TIME,DEF_UPDATE_TIME,USER_ID,userModel.userId,COMMUNITY_ID,userModel.communityId,PROPERTY_ID,userModel.propertyId,_contactModel.contactId,CONTACT,contactNameFiled.text,PHONE_NUMBER,phoneNumField.text,DESCRIPTION,descriptionField.text];
    
    if (_updateContactRequest == nil) {
        _updateContactRequest = [CommunityHttpRequest shareInstance];
    }
    [_updateContactRequest editContact:self parameters:parameters];
}

-(void) callBackWith: (WInterface) interface status: (NSString*) status data:(id) data{
    if (interface == COMMUNITY_PRIVATE_CONTACTS_UPDATE) {
        if ([status isEqualToString:NETWORK_RETURN_CODE_S_OK]) {
            [self updateDBContact];
            [self backBtnAction];
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 10000) {
        if (buttonIndex == 0) {
            if ([_contactModel.type isEqualToString:MY_PRIVATE_CONTACTS_TYPE_ID]) {
                [_prviewController showMyConatcts:YES];
            }
            
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}
@end
