//
//  DeliveryAddressView.m
//  CommunityAPP
//
//  Created by yunlai on 14-4-20.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import "DeliveryAddressView.h"
#import "Global.h"
#import "LuckDrawViewController.h"
#import "AwardAddressDetailViewController.h"
#import "DeliveryAddressTableViewCell.h"
#import "UserModel.h"
#import "AddressListModel.h"

@implementation DeliveryAddressView
@synthesize listArray;

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame viewController:(id)viewController
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        lastViewController = viewController;
        
        self.listArray = [[NSMutableArray alloc] initWithCapacity:0];
        
        [self initTableView];
        
        [self requestDeliveryAddress];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestDeliveryAddress) name:@"requestDeliveryAddress" object:nil];

    }
    return self;
}

-(void)requestDeliveryAddress{
    [self.listArray removeAllObjects];
    
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
    recordTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, self.frame.size.height) style:UITableViewStylePlain];
    recordTableView.backgroundView = nil;
    recordTableView.backgroundColor = RGB(244, 244, 244);
    recordTableView.delegate = self;
    recordTableView.dataSource = self;
//    recordTableView.sectionFooterHeight = 10;
//    recordTableView.sectionHeaderHeight = 10;
    recordTableView.tableFooterView = [[[UIView alloc] initWithFrame:CGRectZero]  autorelease];
    [self addSubview:recordTableView];
    [recordTableView release];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

//添加默认的地址
-(void)rightBtnAction{
    // 网络请求ß®
    if (request == nil) {
        request = [CommunityHttpRequest shareInstance];
    }
    UserModel *userModel = [UserModel shareUser];
    NSString *addressArearIdString;
    if ([modelData.areaIdString length]!=0) {
        addressArearIdString = modelData.areaIdString;
    }else{
        addressArearIdString = modelData.cityIdString;
    }
    NSString *string = [NSString stringWithFormat:@"?userId=%@&communityId=%@&propertyId=%@&addId=%@&consignee=%@&phoneNumber=%@&zipCode=%@&addressId=%@&address=%@&isDefault=%@",userModel.userId,userModel.communityId,userModel.propertyId,modelData.idString,modelData.consigneeString,modelData.phoneNumberString,modelData.zipCodeString,addressArearIdString,modelData.addressString,@"1"];//参数
    [request requestAddressEdit:self parameters:string];
}

- (void)detailAddress:(id)sender{
    UIButton *addressBtnTag = (UIButton *)sender;
    AddressListModel  *model = [self.listArray objectAtIndex:addressBtnTag.tag];

    [lastViewController addressDetail:model];
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
            cell.backgroundView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
            cell.backgroundView.backgroundColor = [UIColor whiteColor];
            
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
            cell.backgroundView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
            cell.backgroundView.backgroundColor = [UIColor whiteColor];
        }
        int row = [indexPath row];
        AddressListModel  *model = [self.listArray objectAtIndex:row];
        
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
        cell.contentLabel.text = model.fullAddressString;
        return cell;
    }else{
        return nil;
    }
}
#pragma mark UITableViewDelegate implementation
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        [lastViewController addAddress];
    }else if(indexPath.section == 1){
        int row = [indexPath row];
        selectedIndex = row;

        AddressListModel  *model = [self.listArray objectAtIndex:row];
        NSString *defaultString = [NSString stringWithFormat:@"%@",model.isDefaultString];
        if (![defaultString isEqualToString:@"0"]) {
//            选中
            
        }else {
//            未选中
            modelData = [self.listArray objectAtIndex:indexPath.row];
            
            [self rightBtnAction];
            [tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
        }

    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 44;
    }
    return 70;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *__view = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)] autorelease];
    __view.backgroundColor = RGB(244, 244, 244);
    
    return __view;
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
                model.areaIdString = [dic objectForKey:@"areaId"];
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
    }else if (interface == COMMENT_PROFILE_ADRESS_EDIT) {
        if ([status isEqualToString:NETWORK_RETURN_CODE_S_OK]) {
      
            [self requestDeliveryAddress];
        }
    }else if (interface == COMMENT_PROFILE_ADRESS_DELE) {
//        if ([[data objectForKey:@""] isEqualToString:@"0"]) {
            [Global showMBProgressHudHint:self SuperView:lastViewController.view Msg:[data objectForKey:@"errorMsg"] ShowTime:1.0];
//        }else{
//            [Global showMBProgressHudHint:self SuperView:lastViewController.view Msg:[data objectForKey:@"errorMsg"] ShowTime:1.0];
//        }
    }
}

- (BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (NSString *)tableView:(UITableView *)tableVie titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}
// 当点击删除时，删除该条记录
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        AddressListModel  *model = [self.listArray objectAtIndex:indexPath.row];
        [self deleteAddress:model];
        
        [self.listArray removeObjectAtIndex:indexPath.row];
        [recordTableView reloadData];
    }
}


//删除当前的地址
-(void)deleteAddress:(AddressListModel *)model{
    // 网络请求ß®
    if (request == nil) {
        request = [CommunityHttpRequest shareInstance];
    }
    UserModel *userModel = [UserModel shareUser];
    NSString *string = [NSString stringWithFormat:@"?userId=%@&communityId=%@&propertyId=%@&consigneeId=%@",userModel.userId,userModel.communityId,userModel.propertyId,model.idString];//参数
    [request requestDeleteAddress:self parameters:string];
}

- (void) hideHudView
{
    if (hudView) {
        [hudView hide:YES];
    }
}
@end
