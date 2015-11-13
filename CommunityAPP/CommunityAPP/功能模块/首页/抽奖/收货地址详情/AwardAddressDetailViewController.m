//
//  AwardAddressDetailViewController.m
//  CommunityAPP
//
//  Created by yunlai on 14-4-22.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import "AwardAddressDetailViewController.h"
#import "NSObject_extra.h"
#import "Global.h"
#import "UserModel.h"
#import "UIViewController+NavigationBar.h"
#import "AwardAreaListViewController.h"
#import "MobClick.h"

@interface AwardAddressDetailViewController ()

@end

@implementation AwardAddressDetailViewController
@synthesize addressModel;

-(void)dealloc{
    [recordTableView release];
    [super dealloc];
}


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
    [recordTableView reloadData];
    [MobClick beginLogPageView:@"AwardAddressDetailPage"];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
    [MobClick endLogPageView:@"AwardAddressDetailPage"];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    appDelegate = [AppDelegate instance];
    appDelegate.areaString = @"";
    appDelegate.areaString = @"";
    [self.view setBackgroundColor:[UIColor whiteColor]];
    //自适应iOS的导航栏、状态栏
    [self adjustiOS7NaviagtionBar];
    [self setNavigationTitle:@"收货地址详情"];
    
    //自定义返回按钮
    UIButton *backButton = [self setBackBarButton];
    [backButton addTarget:self action:@selector(backBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self setBackBarButtonItem:backButton];
    
    //    右边按钮
    UIImage *rightImage = [UIImage imageNamed:@"icon_phone_add_save.png"];
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setImage:rightImage forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightBtnAction) forControlEvents:UIControlEventTouchUpInside];
    rightBtn.frame = CGRectMake(275,0,44,44);
    [self setRightBarButtonItem:rightBtn];
    
    [self initTableView];
}

//返回导航按钮
-(void)backBtnAction
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"是否退出编辑" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    alert.tag = 10000;
    [alert show];
    [alert release];
}

//添加
-(void)rightBtnAction{
    [self hideHudView];
    hudView = [Global showMBProgressHud:self SuperView:self.view Msg:@"请稍候..."];
    
    // 网络请求ß®
    if (request == nil) {
        request = [CommunityHttpRequest shareInstance];
    }
    UserModel *userModel = [UserModel shareUser];
    NSString *userCityIdStirng;
    if ([appDelegate.areaIdString length]!=0) {
        userCityIdStirng = appDelegate.areaIdString;
    }else{
        userCityIdStirng = self.addressModel.cityIdString;
    }
    NSString *string = [NSString stringWithFormat:@"?userId=%@&communityId=%@&propertyId=%@&addId=%@&consignee=%@&phoneNumber=%@&zipCode=%@&addressId=%@&address=%@&isDefault=%@",userModel.userId,userModel.communityId,userModel.propertyId,self.addressModel.idString,self.addressModel.consigneeString,self.addressModel.phoneNumberString,self.addressModel.zipCodeString,userCityIdStirng,self.addressModel.addressString,self.addressModel.isDefaultString];//参数
    [request requestAddressEdit:self parameters:string];
}
- (void)registerForKeyboardNotifications{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShown:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}


// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWillShown:(NSNotification*)aNotification{
    if (!isIPhone5) {
        [UIView animateWithDuration:0.4
                         animations:^{
                             self.view.transform = CGAffineTransformMakeTranslation(0, -28);
                         }];
    }
    
}
- (void)keyboardWillBeHidden:(NSNotification*)aNotification{
    if (!isIPhone5) {
        [UIView animateWithDuration:0.2
                         animations:^{
                             self.view.transform = CGAffineTransformIdentity;
                         }];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    [UIView animateWithDuration:0.1
                     animations:^{
                         self.view.transform = CGAffineTransformIdentity;
                     }];
    return YES;
}
-(void)initTableView{
    recordTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, MainHeight) style:UITableViewStylePlain];
    recordTableView.backgroundView = nil;
    recordTableView.backgroundColor = RGB(244, 244, 244);
    recordTableView.delegate = self;
    recordTableView.dataSource = self;
    recordTableView.tableFooterView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
    [self.view addSubview:recordTableView];
    
    [self registerForKeyboardNotifications];
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

- (void)textFieldWithText:(UITextField *)textField
{
    if (textField.tag == 100011) {
        self.addressModel.consigneeString = textField.text;
    }else if (textField.tag == 100012){
        self.addressModel.phoneNumberString = textField.text;
    }else if (textField.tag == 100013){
        self.addressModel.zipCodeString = textField.text;
    }
//    else if (textField.tag == 100014){
//        self.addressModel.provinceIdString = textField.text;
//    }
    else if (textField.tag == 100015){
        self.addressModel.addressString = textField.text;
    }

}

#pragma UITableViewDelegate
#pragma mark UITableViewDataSource implementation
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0) {
        return 1;
    }else{
        return 4;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier1 = @"Cell1";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:
                 UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier1] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.backgroundView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
        cell.backgroundView.backgroundColor = [UIColor whiteColor];
        cell.textLabel.backgroundColor = [UIColor clearColor];
        UITextField *contentField = [[UITextField alloc]initWithFrame:CGRectMake(90, 0, 210, 40)];
        contentField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;//字体垂直居中对齐
        contentField.clearButtonMode = UITextFieldViewModeWhileEditing;
        contentField.tag = 100010;
        contentField.font = [UIFont systemFontOfSize:16];
        [contentField setBackgroundColor:[UIColor clearColor]];
        [cell.contentView addSubview:contentField];
        [contentField release];
    }
    UITextField *contentLabelTag = (UITextField *)[cell viewWithTag:100010];
    [contentLabelTag addTarget:self action:@selector(textFieldWithText:) forControlEvents:UIControlEventEditingChanged];
    NSInteger section = [indexPath section];
    cell.textLabel.textColor = RGB(53, 53, 53);
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    if (section == 0) {
        
        cell.textLabel.text = @"收货人";
        contentLabelTag.text = self.addressModel.consigneeString;
        contentLabelTag.tag = 100011;
        
    }else if(section == 1){
        NSInteger row = [indexPath row];
        switch (row) {
            case 0:
            {
                cell.textLabel.text = @"手机号码";
                contentLabelTag.text = self.addressModel.phoneNumberString;
                contentLabelTag.tag = 100012;
            }
                break;
            case 1:
            {
                cell.textLabel.text = @"邮政编码";
                 contentLabelTag.text = self.addressModel.zipCodeString;
                contentLabelTag.tag = 100013;
            }
                break;
            case 2:
            {
                cell.textLabel.text = @"所在地区";
                cell.accessoryType= UITableViewCellAccessoryDisclosureIndicator;
                NSString *areaString;
                if ([appDelegate.areaString length]!=0) {
                    areaString  = appDelegate.areaString;
                }else{
                    areaString = [self.addressModel.fullAddressString stringByReplacingOccurrencesOfString:self.addressModel.addressString withString:@""];
                }
                contentLabelTag.userInteractionEnabled = NO;
                contentLabelTag.text = areaString;
//                contentLabelTag.tag = 100014;
            }
                break;
            case 3:
            {
                cell.textLabel.text = @"详细地址";
                contentLabelTag.text = self.addressModel.addressString;
                contentLabelTag.tag = 100015;
            }
                break;
            default:
                break;
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 20.0f;
    }
    
    return 10.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *__view = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)] autorelease];
    __view.backgroundColor = RGB(244, 244, 244);
    return __view;
}

#pragma mark UITableViewDelegate implementation
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        
    }else if(indexPath.section == 1){
        if (indexPath.row == 2) {
            AwardAreaListViewController *listViewC = [[AwardAreaListViewController alloc]  init];
            [self.navigationController pushViewController:listViewC animated:YES];
            [listViewC release];
        }
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

#pragma mark
-(void) callBackWith: (WInterface) interface status: (NSString*) status data:(id) data{
    [self hideHudView];
    NSLog(@"interface :%d status:%@",interface,status);
    if (interface == COMMENT_PROFILE_ADRESS_EDIT) {
        if ([status isEqualToString:NETWORK_RETURN_CODE_S_OK]) {
            if ([data objectForKey:@"errorMsg"]) {
                [Global showMBProgressHudHint:self SuperView:self.view Msg:[data objectForKey:@"errorMsg"] ShowTime:1.0];
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:@"requestDeliveryAddress" object:nil];
            
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [Global showMBProgressHudHint:self SuperView:self.view Msg:[data objectForKey:@"errorMsg"] ShowTime:1.0];
        }
    }
}

- (void) hideHudView
{
    if (hudView) {
        [hudView hide:YES];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 10000) {
        if (buttonIndex == 0) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}
@end
