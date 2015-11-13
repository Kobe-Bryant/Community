//
//  AwardAddAddressViewController.m
//  CommunityAPP
//
//  Created by yunlai on 14-4-21.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import "AwardAddAddressViewController.h"
#import "NSObject_extra.h"
#import "Global.h"
#import "UserModel.h"
#import "AddressAreaModel.h"
#import "UIViewController+NavigationBar.h"
#import "DataLocitionModel.h"
#import "AwardAreaListViewController.h"
#import "AppDelegate.h"
#import "MobClick.h"

@interface AwardAddAddressViewController ()<UIAlertViewDelegate>
@end

@implementation AwardAddAddressViewController
//@synthesize arearString;
@synthesize addressModel;
//@synthesize provincesArray;

-(void)dealloc{

    [areasView release];  areasView = nil;
    [areasPickView release]; areasPickView= nil;
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.addressModel = [[AddressListModel alloc] init];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
    [recordTableView reloadData];
    [MobClick beginLogPageView:@"AwardAddAddressPage"];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
    [MobClick endLogPageView:@"AwardAddAddressPage"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    appDelegate = [AppDelegate instance];
    appDelegate.areaString = @"";
    appDelegate.areaString = @"";
    
    //自适应iOS的导航栏、状态栏
    [self adjustiOS7NaviagtionBar];
    [self setNavigationTitle:@"添加收货地址"];
    //自定义返回按钮
    UIButton *backButton = [self setBackBarButton];
    [backButton addTarget:self action:@selector(backBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self setBackBarButtonItem:backButton];    
    //    右边按钮
    UIImage *rightImage = [UIImage imageNamed:@"icon_phone_add_save.png"];
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setImage:rightImage forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightBtnAction) forControlEvents:UIControlEventTouchUpInside];
    rightBtn.frame = CGRectMake(265,0,44,44);
    [self setRightBarButtonItem:rightBtn];
    
    [self initTableView];
    
    [self registerForKeyboardNotifications];
    
//    [self requestAreasList];
    
//    cArray = [[NSMutableArray alloc] init];
//    aArray = [[NSMutableArray alloc] init];
}

////请求区域地址
//-(void)requestAreasList{
//    [self hideHudView];
//    hudView = [Global showMBProgressHud:self SuperView:self.view Msg:@"请稍候..."];
//    
//    // 网络请求ß®
//    if (request == nil) {
//        request = [CommunityHttpRequest shareInstance];
//    }
//    UserModel *userModel = [UserModel shareUser];
//    NSString *string = [NSString stringWithFormat:@"?userId=%@&communityId=%@&propertyId=%@&parentId=%@",userModel.userId,userModel.communityId,userModel.propertyId,@"0"];//参数
//    [request requestDataLocation:self parameters:string];
//}

//表单验证
- (BOOL)checkForm {
    if ([self.addressModel.consigneeString isEqualToString:@""]||[self.addressModel.consigneeString isEqualToString:nil]||[self.addressModel.consigneeString length] == 0) {
        [Global showMBProgressHudHint:self SuperView:self.view Msg:@"收货人不能为空！" ShowTime:1.0];
        
        return FALSE;
    }else if (![self isValidTelMobileNumber:self.addressModel.phoneNumberString]) {
        
        [Global showMBProgressHudHint:self SuperView:self.view Msg:@"手机号码或固话不能为空！" ShowTime:1.0];
        
        return FALSE;
    }else if ([self.addressModel.zipCodeString isEqualToString:@""]||[self.addressModel.zipCodeString isEqualToString:nil]||[self.addressModel.zipCodeString length] == 0) {
        
        [Global showMBProgressHudHint:self SuperView:self.view Msg:@"邮编不能为空！" ShowTime:1.0];
        
        return FALSE;
    }else if ([appDelegate.areaString isEqualToString:@""]||[appDelegate.areaString isEqualToString:nil]||[appDelegate.areaString length] == 0) {
        
        [Global showMBProgressHudHint:self SuperView:self.view Msg:@"所在地区不能为空！" ShowTime:1.0];
        
        return FALSE;
    }else if ([self.addressModel.fullAddressString isEqualToString:@""]||[self.addressModel.fullAddressString isEqualToString:nil]||[self.addressModel.fullAddressString length] == 0) {
        
        [Global showMBProgressHudHint:self SuperView:self.view Msg:@"详细地址不能为空！" ShowTime:1.0];
        
        return FALSE;
    }else {
        return TRUE;
    }
}


//添加
-(void)rightBtnAction{
    if ([self checkForm]) {
        [self hideHudView];
        hudView = [Global showMBProgressHud:self SuperView:self.view Msg:@"请稍候..."];
        
        // 网络请求ß®
        if (request == nil) {
            request = [CommunityHttpRequest shareInstance];
        }
        UserModel *userModel = [UserModel shareUser];
        NSString *string = [NSString stringWithFormat:@"?userId=%@&communityId=%@&propertyId=%@&addId=%@&consignee=%@&phoneNumber=%@&zipCode=%@&addressId=%@&address=%@&isDefault=%@",userModel.userId,userModel.communityId,userModel.propertyId,@"0",self.addressModel.consigneeString,self.addressModel.phoneNumberString,self.addressModel.zipCodeString,appDelegate.areaIdString,self.addressModel.fullAddressString,@"0"];//参数
        [request requestAddressEdit:self parameters:string];
    }
}

- (void)textFieldWithText:(UITextField *)textField
{
    if (textField.tag == 100008) {
        self.addressModel.consigneeString = textField.text;
    }else if (textField.tag == 100009){
        self.addressModel.phoneNumberString = textField.text;
    }else if (textField.tag == 100010){
        self.addressModel.zipCodeString = textField.text;
    }
//    else if (textField.tag == 100011){
//        self.addressModel.provinceIdString = textField.text;
//    }
    else if (textField.tag == 100012){
        self.addressModel.fullAddressString = textField.text;
    }
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
    recordTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth,MainHeight) style:UITableViewStylePlain];
    recordTableView.backgroundColor = RGB(244, 244, 244);
    recordTableView.delegate = self;
    recordTableView.dataSource = self;
    recordTableView.backgroundView = nil;
    recordTableView.tableFooterView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
    [self.view addSubview:recordTableView];
    [recordTableView release];
}

//返回导航按钮
//-(void)backBtnAction
//{
//    [self.navigationController popViewControllerAnimated:YES];
//}
-(void)backBtnAction
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"是否放弃编辑" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    [alert show];
    [alert release];
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
       
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)cancelEdit
{
//    [UIView animateWithDuration:0.3
//                     animations:^{
//                     }
//                     completion:^(BOOL finished){
                         [self hiddenView];
//                     }];
}

//-(void)dismissKeyBoard
//{
//    [self hiddenView];
//
//    NSInteger provincesRow = [areasPickView selectedRowInComponent:0];
//    NSInteger citiesRow = [areasPickView selectedRowInComponent:1];
//    NSInteger areasRow = [areasPickView selectedRowInComponent:2];
//
//    self.arearString = [NSString stringWithFormat:@"%@ %@ %@",[[provincesArray objectAtIndex:provincesRow] objectForKey:@"state"],[[citiesArray objectAtIndex:citiesRow] objectForKey:@"city"],[areasArray objectAtIndex:areasRow]];
//    
//    NSIndexPath *indexPath =[NSIndexPath indexPathForRow:2 inSection:1];
//    NSArray *indexArray = [NSArray arrayWithObject:indexPath];
//    [recordTableView reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationAutomatic];
//}

-(void)hiddenView{
    [arearField resignFirstResponder];
    areasView.hidden = YES;
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
        contentField.clearButtonMode = UITextFieldViewModeWhileEditing;
        contentField.tag = 100007;
        contentField.font = [UIFont systemFontOfSize:16];
        contentField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;//字体垂直居中对齐
        [contentField setBackgroundColor:[UIColor clearColor]];
        [cell.contentView addSubview:contentField];
        [contentField release];
    }
    UITextField *contentFieldTag = (UITextField *)[cell viewWithTag:100007];
    contentFieldTag.delegate = self;
    [contentFieldTag addTarget:self action:@selector(textFieldWithText:) forControlEvents:UIControlEventEditingChanged];

    NSInteger section = [indexPath section];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.textColor = RGB(53, 53, 53);
    if (section == 0) {
        cell.textLabel.text = @"收货人";
         contentFieldTag.keyboardType = UIKeyboardTypeDefault;
        contentFieldTag.placeholder = @"名字";
        contentFieldTag.tag = 100008;

    }else if(section == 1){
        NSInteger row = [indexPath row];
        switch (row) {
            case 0:
            {
                cell.textLabel.text = @"手机号码";
                contentFieldTag.tag = 100009;
                contentFieldTag.keyboardType = UIKeyboardTypeNumberPad;
                contentFieldTag.placeholder = @"手机号码或固话";
            }
                break;
            case 1:
            {
                cell.textLabel.text = @"邮政编码";
                contentFieldTag.tag = 100010;
                contentFieldTag.keyboardType = UIKeyboardTypeNumberPad;
                contentFieldTag.placeholder = @"邮政编码";
            }
                break;
            case 2:
            {
                cell.accessoryType= UITableViewCellAccessoryDisclosureIndicator;
                cell.textLabel.text = @"所在地区";
//                contentFieldTag.tag = 100011;
                contentFieldTag.userInteractionEnabled = NO;
                contentFieldTag.clearButtonMode = UITextFieldViewModeNever;
//                if ([appDelegate.areaString length]==0) {
//                    contentFieldTag.placeholder = @"地区信息";
//                }else{
                contentFieldTag.text =  appDelegate.areaString;
//                }
            }
                break;
            case 3:
            {
                cell.textLabel.text = @"详细地址";
                contentFieldTag.tag = 100012;
                contentFieldTag.placeholder = @"街道门牌信息";
            }
                break;
            default:
                break;
        }
    }
    return cell;
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 30;
    }
    
    return 10.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *__view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
    __view.backgroundColor = RGB(244, 244, 244);
    
    return __view;
}

//#pragma mark - PickerView lifecycle
//
//- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
//{
//    return 3;
//}
//
//- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
//{
//    switch (component) {
//        case 0:
//            return [provincesArray count];
//            break;
//        case 1:
//            return [cArray count];
//            break;
//        case 2:
//            return [aArray count];
//            break;
//        default:
//            return 0;
//            break;
//    }
//}
//- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
//{
//    switch (component) {
//        case 0:
//            return [[provincesArray objectAtIndex:row] objectForKey:@"name"];
//            break;
//        case 1:
//            if ([cArray count]==0) {
//                return @"";
//            }else{
//                return [[cArray objectAtIndex:row] objectForKey:@"name"];
//            }
//            break;
//        case 2:
//            if ([aArray count]==0) {
//                return @"";
//            }else{
//                return [[aArray objectAtIndex:row] objectForKey:@"name"];
//            }
//                break;
//        default:
//            return @"";
//            break;
//    }
//}
//- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
//{
//        switch (component) {
//            case 0:
//            {
//                for (int i = 0; i<[citiesArray count]; i++) {
//                    if ([[citiesArray objectAtIndex:i] objectForKey:@"parentId"]==[[provincesArray objectAtIndex:row] objectForKey:@"id"]) {
//                        [cArray addObject:[citiesArray objectAtIndex:i]];
//                    }
//                }
//                [areasPickView selectRow:0 inComponent:1 animated:YES];
//                [areasPickView reloadComponent:1];
//
//                for (int i = 0; i<[areasArray count]; i++) {
//                    if ([[areasArray objectAtIndex:i] objectForKey:@"parentId"]==[[cArray objectAtIndex:row] objectForKey:@"id"]) {
//                        [aArray addObject:[areasArray objectAtIndex:i]];
//                    }
//                }
//                [areasPickView selectRow:0 inComponent:2 animated:YES];
//                [areasPickView reloadComponent:2];
//            }
//                break;
//            case 1:
//            {
//                aArray = [[NSMutableArray alloc] init];
//                for (int i = 0; i<[areasArray count]; i++) {
//                    if ([[areasArray objectAtIndex:i] objectForKey:@"parentId"]==[[cArray objectAtIndex:row] objectForKey:@"id"]) {
//                        [aArray addObject:[areasArray objectAtIndex:i]];
//                    }
//                }
//                [areasPickView selectRow:0 inComponent:2 animated:YES];
//                [areasPickView reloadComponent:2];
//            }
//                break;
//            case 2:
//            {
//                
//            }
//                break;
//            default:
//                break;
//    }
//}
//
//- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
//    UILabel* pickerLabel = (UILabel*)view;
//    if (!pickerLabel){
//        pickerLabel = [[UILabel alloc] init];
//        pickerLabel.minimumFontSize = 8.;
//        pickerLabel.adjustsFontSizeToFitWidth = YES;
//        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
//        [pickerLabel setBackgroundColor:[UIColor clearColor]];
//        [pickerLabel setFont:[UIFont boldSystemFontOfSize:17]];
//    }
//    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
//    return pickerLabel;
//}

//- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
//    if (textField.tag == 100011) {
////        [self showPickView:textField];
//    }else{
//        [self hiddenView];
//    }
//    return YES;
//}


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
//            [self backBtnAction];
        }else{
            [Global showMBProgressHudHint:self SuperView:self.view Msg:[data objectForKey:@"errorMsg"] ShowTime:1.0];
        }
    }
//    else if (interface == COMMUNITY_DATA_LOCATION){
//        citiesArray = [[NSMutableArray alloc] init];
//        areasArray = [[NSMutableArray alloc] init];

//        NSArray *callBackArray = [data objectForKey:@"dataList"];
//        for (int i = 0; i<[callBackArray count]; i++) {
//            NSString *typePidString = [[callBackArray objectAtIndex:i] objectForKey:@"parentId"];
//            if ([typePidString isEqualToString:@"0"]) {
//                [provincesArray addObject:[callBackArray objectAtIndex:i]];
//                
//                NSString *idString = [[callBackArray objectAtIndex:i] objectForKey:@"id"];
//                for (int i = 0; i<[callBackArray count]; i++) {
//                    NSString *groupIdString = [[callBackArray objectAtIndex:i] objectForKey:@"parentId"];
//                    
//                    if ([groupIdString isEqualToString:idString]) {
//                        [citiesArray addObject:[callBackArray objectAtIndex:i]];
//                        
//                        NSString *nestIdString = [[callBackArray objectAtIndex:i] objectForKey:@"id"];
//
//                        for (int i = 0; i<[callBackArray count]; i++) {
//                            NSString *dataPIdString = [[callBackArray objectAtIndex:i] objectForKey:@"parentId"];
//                            if ([dataPIdString isEqualToString:nestIdString]) {
//                                [areasArray addObject:[callBackArray objectAtIndex:i]];
//                            }
//                        }
//                    }
//                }
//            }
//        }
//        [areasPickView reloadAllComponents];
//        
//        NSArray *callBackArray = [data objectForKey:@"dataList"];
//        NSMutableArray *object_Arr = [[NSMutableArray alloc] init];
//        for (NSDictionary *dic in callBackArray) {
//            DataLocitionModel  *model = [[DataLocitionModel alloc] init];
//            model.idString = [dic objectForKey:@"id"];
//            model.nameString = [dic objectForKey:@"name"];
//            model.parentIdString = [dic objectForKey:@"parentId"];
//            [object_Arr addObject:model];
//            [model release];
//        }
//        self.provincesArray = object_Arr;
//        [object_Arr release]; //add Vincent 内存释放
//    }
}

- (void) hideHudView
{
    if (hudView) {
        [hudView hide:YES];
    }
}


@end
