//
//  AddCarPoolingViewController.m
//  CommunityAPP
//
//  Created by Dream on 14-3-7.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import "AddCarPoolingViewController.h"
#import "Global.h"
#import "NSObject_extra.h"
@interface AddCarPoolingViewController ()

@end

@implementation AddCarPoolingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.imageArr = [[NSMutableArray alloc]initWithCapacity:0];
    }
    return self;
}
- (void)dealloc
{
    [addCarTableView release];addCarTableView = nil;
    [taxiBtn release]; taxiBtn = nil;
    [carBtn release]; carBtn = nil;
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.view setBackgroundColor:RGB(244, 244, 244)];
    //    导航
    UIImage *navImage = [UIImage imageNamed:@"top_bar_home.png"];
    UIImageView *navImageView = [[UIImageView alloc] init];
    navImageView.image = navImage;
    navImageView.frame = CGRectMake(0,[Global judgementIOS7:0], ScreenWidth, navImage.size.height);
    navImageView.userInteractionEnabled = YES;
    [self.view addSubview:navImageView];
    [navImageView release];
    
    //    title
    UILabel *titleLabel = [self newLabelWithText:@"添加拼车" frame:CGRectMake(0, 0, 320, navImageView.frame.size.height) font:[UIFont systemFontOfSize:22] textColor:[UIColor whiteColor]];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [navImageView addSubview:titleLabel];
    [titleLabel release];
    
    //   返回
    UIImage *backImage = [UIImage imageNamed:@"icon_back.png"];
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setBackgroundImage:backImage forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnAction) forControlEvents:UIControlEventTouchUpInside];
    backBtn.frame = CGRectMake(5,(navImageView.frame.size.height-backImage.size.height)/2,backImage.size.width,backImage.size.height);
    [navImageView addSubview:backBtn];
    
    //    右边按钮
    UIImage *rightImage = [UIImage imageNamed:@"icon_phone_add_save.png"];
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setImage:rightImage forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightBtnAction) forControlEvents:UIControlEventTouchUpInside];
    rightBtn.frame = CGRectMake(275,0,44,44);
    [navImageView addSubview:rightBtn];
    
    //滚动视图
    contentScrollView =[[UIScrollView alloc]initWithFrame:CGRectMake(0,0, ScreenWidth, 75)] ;
    contentScrollView.layer.borderWidth = 1.0f;
    contentScrollView.layer.borderColor = RGB(229, 229, 229).CGColor;
    contentScrollView.pagingEnabled = YES;
    contentScrollView.showsHorizontalScrollIndicator = NO;
    contentScrollView.showsVerticalScrollIndicator = NO;
    contentScrollView.scrollsToTop = NO;
    [contentScrollView setBackgroundColor:[UIColor whiteColor]];
    //添加照片button
    UIButton *addPicBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addPicBtn.frame = CGRectMake(10,5, 65, 65);
    [addPicBtn setImage:[UIImage imageNamed:@"icon_car_add.png"] forState:UIControlStateNormal];
    [addPicBtn addTarget:self action:@selector(addPicBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [contentScrollView addSubview:addPicBtn];
    
    //uitableview列表
    addCarTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, contentScrollView.frame.size.height+contentScrollView.frame.origin.y+20, ScreenWidth, 500) style:UITableViewStyleGrouped];
    addCarTableView.backgroundColor = RGB(244, 244, 244);
    addCarTableView.delegate = self;
    addCarTableView.dataSource = self;
    addCarTableView.sectionHeaderHeight = 5.0;
    addCarTableView.sectionFooterHeight = 5.0;
    addCarTableView.tableHeaderView.backgroundColor = [UIColor redColor];
    addCarTableView.tableHeaderView = contentScrollView;
    [self.view addSubview:addCarTableView];
}
#pragma mark -- uitableviewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 6;
    }
    if (section == 1) {
        return 1;
    }
    return section;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{    NSInteger section = indexPath.section;
     NSInteger row = indexPath.row;
    
    static NSString *identifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier]autorelease];
        cell.textLabel.font = [UIFont systemFontOfSize:15.0];
        cell.textLabel.textColor = RGB(205, 205, 205);
    }
    
    switch (section) {
        case 0:
            if (row == 0) {
                //设置cell点击背景为无色
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                //拼的士
                UIView *taxiView = [[UIView alloc]initWithFrame:CGRectMake(15, 1, 60, 38)];
                taxiView.backgroundColor = [UIColor whiteColor];
                taxiBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 15, 12, 12)];
                [taxiBtn setBackgroundImage:[UIImage imageNamed:@"icon_box_selected.png"] forState:UIControlStateNormal];
                UILabel *taxiLab = [[UILabel alloc]initWithFrame:CGRectMake(14, 10, 45,20)];
                taxiLab.text = @"拼的士";
                taxiLab.font = [UIFont systemFontOfSize:15.0];
                //给taxiView添加一个点击事件
                UITapGestureRecognizer *taxiTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(taxiTap)];
                [taxiView addGestureRecognizer:taxiTap];
                [taxiView addSubview:taxiBtn];
                [taxiView addSubview:taxiLab];
                [cell.contentView addSubview:taxiView];
               
                [taxiLab release];
                [taxiView release];
                
                //我有车
                UIView *carView = [[UIView alloc]initWithFrame:CGRectMake(95, 1, 55, 38)];
                carView.backgroundColor = [UIColor whiteColor];
                carBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 15, 12, 12)];
                [carBtn setBackgroundImage:[UIImage imageNamed:@"icon_box.png"] forState:UIControlStateNormal];
                UILabel *carLab = [[UILabel alloc]initWithFrame:CGRectMake(14, 10, 45,20)];
                carLab.text = @"我有车";
                carLab.font = [UIFont systemFontOfSize:15.0];
                //给carView添加一个点击事件
                UITapGestureRecognizer *carTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(carTap)];
                [carView addGestureRecognizer:carTap];
                [carView addSubview:carBtn];
                [carView addSubview:carLab];
                [cell.contentView addSubview:carView];
                [carLab release];
                [carView release];
            }
            if (row == 1) {
                UITextField *arriveField = [[UITextField alloc]initWithFrame:CGRectMake(15, 0, 320, 40)];
                arriveField.delegate=self;
                arriveField.returnKeyType = UIReturnKeyNext;
                arriveField.tag=1;
                arriveField.borderStyle = UITextBorderStyleNone;
                arriveField.font = [UIFont systemFontOfSize:15.0];
                arriveField.placeholder = @"出发地点";
                [cell.contentView addSubview:arriveField];
                [arriveField release];
            }
            if (row == 2) {
                UITextField *nameField = [[UITextField alloc]initWithFrame:CGRectMake(15, 0, 320, 40)];
                nameField.delegate=self;
                nameField.returnKeyType = UIReturnKeyNext;
                nameField.tag=2;
                nameField.borderStyle = UITextBorderStyleNone;
                nameField.font = [UIFont systemFontOfSize:15.0];
                nameField.placeholder = @"比如大厦名称，路名";
                [cell.contentView addSubview:nameField];
                [nameField release];
            }
             if (row == 3) {
                 UITextField *timeField = [[UITextField alloc]initWithFrame:CGRectMake(15, 0, 320, 40)];
                 timeField.delegate=self;
                 timeField.returnKeyType = UIReturnKeyNext;
                 timeField.tag=3;
                 timeField.borderStyle = UITextBorderStyleNone;
                 timeField.font = [UIFont systemFontOfSize:15.0];
                 timeField.placeholder = @"出发时间";
                 [cell.contentView addSubview:timeField];
                 [timeField release];
            }
            if (row == 4) {
                UITextField *offworkField = [[UITextField alloc]initWithFrame:CGRectMake(15, 0, 320, 40)];
                offworkField.delegate=self;
                offworkField.returnKeyType = UIReturnKeyNext;
                offworkField.tag=4;
                offworkField.borderStyle = UITextBorderStyleNone;
                offworkField.font = [UIFont systemFontOfSize:15.0];
                offworkField.placeholder = @"下班时间";
                [cell.contentView addSubview:offworkField];
                [offworkField release];
            }
            
            if (row == 5) {
                UITextField *phoneField = [[UITextField alloc]initWithFrame:CGRectMake(15, 0, 320, 40)];
                phoneField.returnKeyType = UIReturnKeyNext;
                phoneField.delegate=self;
                phoneField.tag=5;
                phoneField.borderStyle = UITextBorderStyleNone;
                phoneField.font = [UIFont systemFontOfSize:15.0];
                phoneField.placeholder = @"联系手机";
                [cell.contentView addSubview:phoneField];
                [phoneField release];
            }
            break;
        case 1:
            if (row == 0) {
                addField = [[UITextField alloc]initWithFrame:CGRectMake(15, 0, 320, 40)];
                addField.delegate=self;
                addField.tag=6;
                addField.borderStyle = UITextBorderStyleNone;
                addField.font = [UIFont systemFontOfSize:15.0];
                addField.placeholder = @"补充说明，比如车辆款式，驾龄等。";
                [cell.contentView addSubview:addField];
                [addField release];
            }
            break;
            
        default:
            break;
    }
    return cell;
}

#pragma mark -- uitableviewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.0;
}

#pragma mark --键盘代理
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    switch (textField.tag) {
        case 1:
        {  // 把第二个的textfield的tag让其变成第一相应者，，以下以此类推
            UITextField *tempText1=(UITextField*)[self.view viewWithTag:2];
            [tempText1 becomeFirstResponder];
            
        }break;
        case 2:
        {
            UITextField *tempText2=(UITextField*)[self.view viewWithTag:3];
            [tempText2 becomeFirstResponder];
            [UIView animateWithDuration:0.3 animations:^(void){
                [addCarTableView setFrame:CGRectMake(0, addCarTableView.frame.origin.y-30, 320, addCarTableView.frame.size.height)] ;
            }];
            
        } break;
        case 3:
        {
            UITextField *tempText3=(UITextField*)[self.view viewWithTag:4];
            [tempText3 becomeFirstResponder];
            [UIView animateWithDuration:0.3 animations:^(void){
            [addCarTableView setFrame:CGRectMake(0, addCarTableView.frame.origin.y-40, 320, addCarTableView.frame.size.height)] ;
            }];
        } break;
        case 4:{
            UITextField *tempText4=(UITextField*)[self.view viewWithTag:5];
            [tempText4 becomeFirstResponder];
            [UIView animateWithDuration:0.3 animations:^(void){
                [addCarTableView setFrame:CGRectMake(0, addCarTableView.frame.origin.y-70, 320, addCarTableView.frame.size.height)] ;
            }];
        }
            break;
        case 5:{
            UITextField *tempText5=(UITextField*)[self.view viewWithTag:6];
            [tempText5 becomeFirstResponder];
//            if ([tempText5 isFirstResponder]) {
//                NSLog(@" 上移 ");
//            }
        }
            break;
        case 6:{
            [addField resignFirstResponder];
            [UIView animateWithDuration:0.3 animations:^(void){
                [addCarTableView setFrame:CGRectMake(0, contentScrollView.frame.size.height+contentScrollView.frame.origin.y+20, ScreenWidth, 500)];
            }];
            return YES;
           
        }break;
        default:
            
            break;
    }    return YES;
}

#pragma mark -- 点击事件
//选择拼的士还是我有车点击时间
-(void)taxiTap
{
   [taxiBtn setBackgroundImage:[UIImage imageNamed:@"icon_box_selected.png"] forState:UIControlStateNormal];
     [carBtn setBackgroundImage:[UIImage imageNamed:@"icon_box.png"] forState:UIControlStateNormal];
}
-(void)carTap
{
    [taxiBtn setBackgroundImage:[UIImage imageNamed:@"icon_box.png"] forState:UIControlStateNormal];
    [carBtn setBackgroundImage:[UIImage imageNamed:@"icon_box_selected.png"] forState:UIControlStateNormal];
}

//添加图片按钮
-(void)addPicBtnAction
{
    UIActionSheet* mySheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消"destructiveButtonTitle:@"拍照" otherButtonTitles:@"从相册选择", nil];
    [mySheet showInView:self.view];
}
//选择照相，或者照片库
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;
{
    if (buttonIndex == 0) {
        UIImagePickerController *pick = [[UIImagePickerController alloc]init];
        pick.delegate = self;
        pick.sourceType = UIImagePickerControllerSourceTypeCamera;
        pick.allowsEditing = YES;
        [self presentViewController:pick animated:YES completion:NULL];
        
    }
    if (buttonIndex == 1) {
        CTAssetsPickerController *picker = [[CTAssetsPickerController alloc] init];
        //picker.maximumNumberOfSelection = 5;
        //picker.assetsFilter = [ALAssetsFilter allAssets];
        picker.delegate = self;
        [self presentViewController:picker animated:YES completion:NULL];    }
    
}
#pragma mark --UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    BOOL iscamera = [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
    if (!iscamera) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"没有相机" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
        [alert show];
    }
}

#pragma mark --CTAssetsPickerControllerDelegate
-(void)assetsPickerController:(CTAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets
{
    [self.imageArr addObjectsFromArray:assets];
    for (NSInteger i = 0; i<self.imageArr.count; i++) {
        imgView = [[UIImageView alloc]initWithFrame:CGRectMake(75*(i+1)+10,5, 65, 65)];
        ALAsset *asset = [self.imageArr objectAtIndex:i];
        imgView.image = [UIImage imageWithCGImage:asset.thumbnail];
        [contentScrollView addSubview:imgView];
        
            }
        contentScrollView.contentSize = CGSizeMake([self.imageArr count]*75+85,75);
}

//导航左右按钮
-(void)backBtnAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)rightBtnAction
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
