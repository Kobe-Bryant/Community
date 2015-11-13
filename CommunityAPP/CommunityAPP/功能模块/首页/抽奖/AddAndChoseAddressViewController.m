//
//  AddAndChoseAddressViewController.m
//  CommunityAPP
//
//  Created by yunlai on 14-5-15.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import "AddAndChoseAddressViewController.h"
#import "Global.h"
#import "UserModel.h"
#import "UIViewController+NavigationBar.h"
#import "AddressListModel.h"
#import "AwardAddressDetailViewController.h"
#import "DeliveryAddressTableViewCell.h"
#import "AwardAddAddressViewController.h"
#import "MobClick.h"

@interface AddAndChoseAddressViewController ()

@end

@implementation AddAndChoseAddressViewController

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
    [self requestDeliveryAddress];
    [MobClick beginLogPageView:@"AddAndChoseAddressPage"];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
    [MobClick endLogPageView:@"AddAndChoseAddressPage"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    //自适应iOS的导航栏、状态栏
    [self adjustiOS7NaviagtionBar];
    [self setNavigationTitle:@"选择收货地址"];
    
    //自定义返回按钮
    UIButton *backButton = [self setBackBarButton];
    [backButton addTarget:self action:@selector(backBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self setBackBarButtonItem:backButton];
    
    [self initTableView];
}

//返回导航按钮
-(void)backBtnAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)requestDeliveryAddress{
    self.listArray = [[NSArray alloc] init];;
    //加载网络数据
    [self hideHudView];
    hudView = [Global showMBProgressHud:self SuperView:lastViewController.view Msg:@"请稍候..."];//  请求验证是否正确
    
    // 网络请求ß®
    if (request == nil) {
        request = [CommunityHttpRequest shareInstance];
    }
    UserModel *userModel = [UserModel shareUser];
    NSString *string = [NSString stringWithFormat:@"?userId=%@&communityId=%@&propertyId=%@",userModel.userId,userModel.communityId,userModel.propertyId];//参数
    [request requestAddressInfo:self parameters:string];
}

-(void)initTableView{
    recordTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, MainHeight) style:UITableViewStylePlain];
    recordTableView.backgroundColor = RGB(244, 244, 244);
    recordTableView.delegate = self;
    recordTableView.dataSource = self;
    recordTableView.sectionFooterHeight = 10;
    //    recordTableView.sectionHeaderHeight = 10;
    recordTableView.tableFooterView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
    [self.view addSubview:recordTableView];
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

- (void)detailAddress:(id)sender{
    UIButton *addressBtnTag = (UIButton *)sender;
    AddressListModel  *model = [self.listArray objectAtIndex:addressBtnTag.tag];
    
    AwardAddressDetailViewController *addressDetail = [[AwardAddressDetailViewController alloc] init];
    addressDetail.addressModel = model;
    [self.navigationController pushViewController:addressDetail animated:YES];
    [addressDetail release];
}

//添加默认的地址
-(void)rightBtnAction{
    [self hideHudView];
    hudView = [Global showMBProgressHud:self SuperView:self.view Msg:@"请稍候..."];
    
    // 网络请求ß®
    if (request == nil) {
        request = [CommunityHttpRequest shareInstance];
    }
    UserModel *userModel = [UserModel shareUser];
    NSString *string = [NSString stringWithFormat:@"?userId=%@&communityId=%@&propertyId=%@&addId=%@&consignee=%@&phoneNumber=%@&zipCode=%@&addressId=%@&address=%@&isDefault=%@",userModel.userId,userModel.communityId,userModel.propertyId,modelData.idString,modelData.consigneeString,modelData.phoneNumberString,modelData.zipCodeString,modelData.cityIdString,modelData.fullAddressString,@"1"];//参数
    [request requestAddressEdit:self parameters:string];
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
        return [self.listArray count];
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger indexSection = [indexPath section];
    static NSString *CellIdentifier1 = @"Cell1";
    static NSString *CellIdentifier2 = @"Cell2";
    
    if (indexSection == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:
                     UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier1] autorelease];
            cell.accessoryType= UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            
            UIImage *iconImage = [UIImage imageNamed:@"bg_awardView_addAdress.png"];
            UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, (44-iconImage.size.height)/2, iconImage.size.width, iconImage.size.height)];
            iconImageView.image = iconImage;
            [cell addSubview:iconImageView];
            [iconImageView release];
            
            //名称
            UILabel *nameLabel = [[UILabel alloc ]  initWithFrame:
                                  CGRectMake(iconImageView.frame.size.width+iconImageView.frame.origin.x+10, iconImageView.frame.origin.y, 210, 22)];
            nameLabel.text = @"新增收货地址";
            nameLabel.textColor=RGB(53, 53, 53);
            nameLabel.backgroundColor = [UIColor clearColor];
            nameLabel.font=[UIFont systemFontOfSize:15];
            [cell addSubview:nameLabel];
            [nameLabel release];
        }
        
        return cell;
        
    }else if (indexSection == 1){
        DeliveryAddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier2];
        if (cell == nil) {
            cell = [[[DeliveryAddressTableViewCell alloc] initWithStyle:
                     UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier2] autorelease];
        }
        int row = [indexPath row];
        AddressListModel  *model = [self.listArray objectAtIndex:row];
        
//        if (row == selectedIndex) {     // selected
//            UIImage *imageSelected = [UIImage imageNamed:@"bg_awardView_selectedAdress.png"];
//            cell.iconImageView.image = imageSelected;
//        }
//        else {
//            cell.iconImageView.image = nil;
//        }
        NSString *defaultString = [NSString stringWithFormat:@"%@",model.isDefaultString];
        if (![defaultString isEqualToString:@"0"]) {
            UIImage *imageSelected = [UIImage imageNamed:@"bg_awardView_selectedAdress.png"];
            cell.iconImageView.image = imageSelected;
        }else {
            cell.iconImageView.image = nil;
        }
        
        cell.detailbtn.tag = row;
        [cell.detailbtn addTarget:self action:@selector(detailAddress:) forControlEvents:UIControlEventTouchUpInside];
        cell.nameLabel.text = model.consigneeString;
        cell.contentLabel.text = model.addressString;
        return cell;
    }else{
        return nil;
    }
}
#pragma mark UITableViewDelegate implementation
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        AwardAddAddressViewController *addressVc = [[AwardAddAddressViewController alloc] init];
        [self.navigationController pushViewController:addressVc animated:YES];
        [addressVc release];
    }else if(indexPath.section == 1){
        int row = [indexPath row];
        selectedIndex = row;
        modelData = [self.listArray objectAtIndex:row];
        
        [self rightBtnAction];
        
//        [tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 44;
    }
    return 70;
}
#pragma mark
-(void) callBackWith: (WInterface) interface status: (NSString*) status data:(id) data{
    NSLog(@"interface :%d status:%@",interface,status);
    [self hideHudView];
    
    if (interface == COMMENT_PROFILE_ADRESS_INFO) {
        if ([status isEqualToString:NETWORK_RETURN_CODE_S_OK]) {
            NSArray *array = [data objectForKey:@"addressList"];
            NSMutableArray *object_Arr = [[NSMutableArray alloc] init];
            for (NSDictionary *dic in array) {
                AddressListModel  *model = [[AddressListModel alloc] init];
                model.idString = [dic objectForKey:@"id"];
                model.consigneeString = [dic objectForKey:@"consignee"];
                model.phoneNumberString = [dic objectForKey:@"phoneNumber"];
                model.zipCodeString = [dic objectForKey:@"zipCode"];
                model.provinceIdString = [dic objectForKey:@"provinceId"];
                model.cityIdString = [dic objectForKey:@"cityId"];
                model.addressString = [dic objectForKey:@"address"];
                model.fullAddressString = [dic objectForKey:@"fullAddress"];
                model.isDefaultString = [dic objectForKey:@"isDefault"];
                [object_Arr addObject:model];
                [model release];
            }
            self.listArray = object_Arr;
            [object_Arr release]; //add Vincent 内存释放
            
            //            if ([self.listArray count]==0) {
            //                [Global showMBProgressHudHint:self SuperView:lastViewController.view Msg:@"当前没有数据" ShowTime:1.0];
            //            }else {
            [recordTableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
            //            }
        }
    }
    if (interface == COMMENT_PROFILE_ADRESS_EDIT) {
        if ([status isEqualToString:NETWORK_RETURN_CODE_S_OK]) {
//            if ([data objectForKey:@"errorMsg"]) {
//                [Global showMBProgressHudHint:self SuperView:self.view Msg:[data objectForKey:@"errorMsg"] ShowTime:1.0];
//            }else{
                [self requestDeliveryAddress];
                [self backBtnAction];
//            }
        }
    }
}

- (void) hideHudView
{
    if (hudView) {
        [hudView hide:YES];
    }
}
@end
