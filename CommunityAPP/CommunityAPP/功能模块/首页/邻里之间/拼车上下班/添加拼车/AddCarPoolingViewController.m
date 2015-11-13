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
#import "UserModel.h"
#import "ASIFormDataRequest.h"
#import "UIImage+extra.h"
#include <ImageIO/ImageIO.h>
#import "UIViewController+NavigationBar.h"
#import "JSONKit.h"
#import "AppDelegate.h"
#import "MobClick.h"

#define NAVIGATIONBAR_HEIGHT    64.0f

@interface AddCarPoolingViewController ()<UIImagePickerControllerDelegate,UITextViewDelegate>
{
    NSInteger typeInteger;//判断车的类型 2_的士,3_轿车,4_卡车
}

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
- (void)dealloc{
    [nameField release]; nameField = nil;
    [phoneField release]; phoneField = nil;
    [arriveField release];  arriveField = nil;
    [taxiBtn release]; taxiBtn = nil;
    [carBtn release]; carBtn = nil;
    [offworkField release]; offworkField = nil;
    [timeField release]; timeField = nil;
    [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
    [MobClick beginLogPageView:@"AddCarPoolingPage"];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
    [MobClick endLogPageView:@"AddCarPoolingPage"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.view setBackgroundColor:RGB(244, 244, 244)];
    
    //自适应iOS的导航栏、状态栏
    [self adjustiOS7NaviagtionBar];
    [self setNavigationTitle:@"添加拼车"];
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
    
    
    backScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0,0, ScreenWidth, MainHeight)];
    backScroll.contentSize = CGSizeMake(ScreenWidth, 650);
    backScroll.backgroundColor = RGB(240, 240, 240);
    backScroll.bounces = YES;
    backScroll.showsHorizontalScrollIndicator = NO;
    backScroll.showsVerticalScrollIndicator = NO;
    [self.view addSubview:backScroll];
    
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
    addPicBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addPicBtn.frame = CGRectMake(10,5, 65, 65);
    [addPicBtn setImage:[UIImage imageNamed:@"icon_car_add.png"] forState:UIControlStateNormal];
    [addPicBtn addTarget:self action:@selector(addPicBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [contentScrollView addSubview:addPicBtn];
    
    //uitableview列表
    addCarTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, MainHeight+80) style:UITableViewStylePlain];
    addCarTableView.backgroundColor = RGB(244, 244, 244);
    addCarTableView.delegate = self;
    addCarTableView.dataSource = self;
    addCarTableView.sectionFooterHeight =44.0;
    addCarTableView.tableHeaderView.backgroundColor = [UIColor redColor];
    addCarTableView.tableHeaderView = contentScrollView;
    addCarTableView.scrollEnabled = NO;
    addCarTableView.tableFooterView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
    addCarTableView.backgroundView = nil;
    addCarTableView.backgroundColor = [UIColor clearColor];
    [backScroll addSubview:addCarTableView];
    [addCarTableView release];
    
//  当前默认的是车的类型 2_的士,3_轿车,4_卡车
    typeInteger = 2;
    
    //上下班时间选择器  add by devin
    toolbar = [[UIToolbar alloc] init];
    [toolbar setBarStyle:UIBarStyleBlackTranslucent];
    [toolbar sizeToFit];
    UIBarButtonItem *buttonflexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *buttonDone = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneClicked:)];
    [toolbar setItems:[NSArray arrayWithObjects:buttonflexible,buttonDone, nil]];
}
//取消键盘
-(void)resignKeyboard{
    [arriveField resignFirstResponder];
    [nameField resignFirstResponder];
    [phoneField resignFirstResponder];
    [txDescription resignFirstResponder];
}

#pragma mark -- uitableviewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 6;
    }
    if (section == 1) {
        return 1;
    }
    return section;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    static NSString *identifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier]autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
        cell.backgroundView.backgroundColor = [UIColor whiteColor];
    }
    UserModel *userModel = [UserModel shareUser];
    switch (section) {
        case 0:
            if (row == 0) {
                //设置cell点击背景为无色
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                //拼的士
                UIView *taxiView = [[UIView alloc]initWithFrame:CGRectMake(15, 1, 60, 38)];
                taxiView.backgroundColor = [UIColor clearColor];
                taxiBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 15, 12, 12)];
                [taxiBtn setBackgroundImage:[UIImage imageNamed:@"icon_box_selected.png"] forState:UIControlStateNormal];
                UILabel *taxiLab = [[UILabel alloc]initWithFrame:CGRectMake(14, 10, 45,20)];
                taxiLab.backgroundColor = [UIColor clearColor];
                taxiLab.text = @"拼的士";
                taxiLab.font = [UIFont systemFontOfSize:15.0];
                //给taxiView添加一个点击事件
                UITapGestureRecognizer *taxiTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(taxiTap)];
                [taxiView addGestureRecognizer:taxiTap];
                [taxiView addSubview:taxiBtn];
                [taxiView addSubview:taxiLab];
                [cell.contentView addSubview:taxiView];
                [taxiTap release];
                [taxiLab release];
                [taxiView release];
                
                //我有车
                UIView *carView = [[UIView alloc]initWithFrame:CGRectMake(95, 1, 55, 38)];
                carView.backgroundColor = [UIColor clearColor];
                carBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 15, 12, 12)];
                [carBtn setBackgroundImage:[UIImage imageNamed:@"icon_box.png"] forState:UIControlStateNormal];
                UILabel *carLab = [[UILabel alloc]initWithFrame:CGRectMake(14, 10, 45,20)];
                carLab.backgroundColor = [UIColor clearColor];
                carLab.text = @"我有车";
                carLab.font = [UIFont systemFontOfSize:15.0];
                //给carView添加一个点击事件
                UITapGestureRecognizer *carTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(carTap)];
                [carView addGestureRecognizer:carTap];
                [carView addSubview:carBtn];
                [carView addSubview:carLab];
                [cell.contentView addSubview:carView];
                [carTap release];
                [carLab release];
                [carView release];
            }
            if (row == 1) {
                arriveField = [[UITextField alloc]initWithFrame:CGRectMake(15, 0, 320, 40)];
                arriveField.delegate=self;
                arriveField.tag=row;
                arriveField.borderStyle = UITextBorderStyleNone;
                arriveField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;//字体垂直居中对齐
                arriveField.font = [UIFont systemFontOfSize:15.0];
                arriveField.placeholder = @"出发地点";
                arriveField.text = userModel.communityName;
                [cell.contentView addSubview:arriveField];
            }
            if (row == 2) {
                nameField = [[UITextField alloc]initWithFrame:CGRectMake(15, 0, 320, 40)];
                nameField.delegate=self;
                nameField.tag=row;
                nameField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;//字体垂直居中对齐
                nameField.borderStyle = UITextBorderStyleNone;
                nameField.font = [UIFont systemFontOfSize:15.0];
                nameField.placeholder = @"目的地点";
                [cell.contentView addSubview:nameField];
            }
             if (row == 3) {
                 timeField = [[DatePickField alloc]initWithFrame:CGRectMake(15, 0, 320, 40)];
                 [timeField addTarget:self action:@selector(timeFieldDone:) forControlEvents:UIControlEventEditingDidBegin];
                 timeField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;//字体垂直居中对齐
                 timeField.tag = row;
                 timeField.placeholder = @"出发时间";
                 timeField.font = [UIFont systemFontOfSize:15.0];
                 timeField.borderStyle = UITextBorderStyleNone;
                 [cell.contentView addSubview:timeField];
                 timeField.inputAccessoryView = toolbar;
                 
                 
             }
            if (row == 4) {
                offworkField = [[DatePickField alloc]initWithFrame:CGRectMake(15, 0, 320, 40)];
                [offworkField addTarget:self action:@selector(offworkFieldDone:) forControlEvents:UIControlEventEditingDidBegin];
                offworkField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;//字体垂直居中对齐
                offworkField.placeholder = @"下班时间";
                offworkField.tag = row;
                offworkField.font = [UIFont systemFontOfSize:15.0];
                offworkField.borderStyle = UITextBorderStyleNone;
                [cell.contentView addSubview:offworkField];
                offworkField.inputAccessoryView = toolbar;
            }
            if (row == 5) {
                phoneField = [[UITextField alloc]initWithFrame:CGRectMake(15, 0, 320, 40)];
                phoneField.delegate=self;
                phoneField.tag=row;
                phoneField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;//字体垂直居中对齐
                phoneField.borderStyle = UITextBorderStyleNone;
                phoneField.keyboardType = UIKeyboardTypeNumberPad;
                phoneField.font = [UIFont systemFontOfSize:15.0];
                phoneField.placeholder = @"联系手机(选填)";
                [cell.contentView addSubview:phoneField];
            }
            break;
        case 1:
            if (row == 0) {
                txDescription = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, 320, 80)];
                txDescription.delegate = self;
                txDescription.font = [UIFont systemFontOfSize:15.0f];
                txDescription.returnKeyType = UIReturnKeyDone;
                [cell.contentView addSubview:txDescription];
                [txDescription release];
            }
            break;
            
        default:
            break;
    }
    return cell;
}

#pragma mark -- uitableviewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 10.0f;
    }else{
        return 44.0f;
    }
    return 0.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
         UIView *__view = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 10)] autorelease];
        __view.backgroundColor = RGB(244, 244, 244);
        
        return __view;
    }else if(section == 1){
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, 320.f, 44.f)];
        footerView.backgroundColor = [UIColor clearColor];
        UILabel *lable = [self newLabelWithText:@"补充说明，比如车辆款式，驾龄等。(可选)" frame:CGRectMake(10,15 ,280, 20) font:[UIFont systemFontOfSize:15.0] textColor:RGB(90, 90, 90)];
        lable.numberOfLines = 0;
        lable.backgroundColor = [UIColor clearColor];
        [footerView addSubview:lable];
        [lable release];
        return [footerView autorelease];
    }
    
    return nil;
   
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 0) {
        UIView *__view = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 10)] autorelease];
        __view.backgroundColor = RGB(244, 244, 244);
        
        return __view;
    }
    return nil;
}
-(CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 10.f;
    }
    
    return 0.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            return 80.0f;
        }
        
    }
    
    return 40.0f;
}
#pragma mark --键盘代理

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    switch (textField.tag) {
        case 1:{
            
            [backScroll setContentOffset:CGPointMake(0, 0) animated:YES];
        }
            break;
        case 2:{
        
            [backScroll setContentOffset:CGPointMake(0, 0+NAVIGATIONBAR_HEIGHT) animated:YES];
        }
            break;
        case 3:{
            NSLog(@"%d",3);
        }
            break;
        case 4:{
            NSLog(@"%d",4);
        }
            break;
        case 5:{
            [backScroll setContentOffset:CGPointMake(0, 120+NAVIGATIONBAR_HEIGHT) animated:YES];
        }
            break;
        case 6:{
            [backScroll setContentOffset:CGPointMake(0, 150+NAVIGATIONBAR_HEIGHT) animated:YES];
        }
            break;
            
        default:
            break;
    }
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    //限制字符在13个以内  add by Devin
    if ([string isEqualToString:@"\n"]){
        return YES;
    }
    NSString * aString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (textField == nameField ||textField == arriveField)
    {
        if ([aString length] > 13) {
            return NO;
        }
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    switch (textField.tag) {
        case 1:
        {
        [backScroll setContentOffset:CGPointMake(0, 0) animated:YES];
         [textField resignFirstResponder];
            return YES;
            
        }break;
        case 2:
        {
        [backScroll setContentOffset:CGPointMake(0, 0) animated:YES];

        [textField resignFirstResponder];
            return YES;
            
        } break;
        case 5:{
            [backScroll setContentOffset:CGPointMake(0, 0) animated:YES];
            [textField resignFirstResponder];
             return YES;
        }
            break;
        case 6:{
            [backScroll setContentOffset:CGPointMake(0, 0) animated:YES];
            [textField resignFirstResponder];
            return YES;
           
        }break;
        default:
            
            break;
    }    return YES;
}


#pragma mark -- 点击事件
//选择拼的士还是我有车点击时间
-(void)taxiTap{
    typeInteger = 2;
   [taxiBtn setBackgroundImage:[UIImage imageNamed:@"icon_box_selected.png"] forState:UIControlStateNormal];
     [carBtn setBackgroundImage:[UIImage imageNamed:@"icon_box.png"] forState:UIControlStateNormal];
}
-(void)carTap{
    typeInteger = 3;
    [taxiBtn setBackgroundImage:[UIImage imageNamed:@"icon_box.png"] forState:UIControlStateNormal];
    [carBtn setBackgroundImage:[UIImage imageNamed:@"icon_box_selected.png"] forState:UIControlStateNormal];
}

//添加图片按钮
-(void)addPicBtnAction{
    UIActionSheet* mySheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消"destructiveButtonTitle:@"拍照" otherButtonTitles:@"从相册选择", nil];
    [mySheet showInView:[UIApplication sharedApplication].keyWindow];
    [mySheet release];
}

//选择照相，或者照片库
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;{
    if (buttonIndex == 0) {
        BOOL iscamera = [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
        if (!iscamera) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"没有相机" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
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
        CTAssetsPickerController *picker = [[CTAssetsPickerController alloc] init];
        picker.maximumNumberOfSelection = 5 - [self.imageArr count];
        picker.delegate = self;
        [self presentViewController:picker animated:YES completion:NULL];
        [picker release];
    }
    
}
#pragma mark --UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    BOOL iscamera = [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
    if (!iscamera) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"没有相机" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
        [alert show];
        [alert release];
    }else{
        [picker dismissViewControllerAnimated:YES completion:^{}];
        
        UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
        NSString *str = (NSString*)kCGImagePropertyTIFFDictionary;
        NSDictionary *dic = [[info objectForKey:UIImagePickerControllerMediaMetadata] objectForKey:str];
        
        image.fileName = [[dic objectForKey:@"DateTime"] stringByAppendingPathExtension:@"jpg"];
        UIImage *newImage = [UIImage writeImageToSandBox:image name:image.fileName];
        image = nil;
        [self.imageArr addObject:newImage];
        [self refreshAssetsList];
    }
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;{
    NSLog(@"%@",contextInfo);
    // Handle the end of the image write process
    if (!error)
        NSLog(@"Image written to photo album");
    else
        NSLog(@"Error writing to photo album: %@",
              [error localizedDescription]);
}
#pragma mark --CTAssetsPickerControllerDelegate
-(void)assetsPickerController:(CTAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets{
    if ([assets count] > 0) {
        NSMutableArray *array = [[[NSMutableArray alloc] init] autorelease];
        for (ALAsset *asset in assets)
        {
            ALAssetRepresentation *assetRepresentation = [asset defaultRepresentation];
            UIImage *image = [UIImage imageWithCGImage:assetRepresentation.fullScreenImage];
            
            UIImage *compressImage = [UIImage writeImageToSandBox:image name:assetRepresentation.filename];
            [array addObject:compressImage];
            
        }
        [self.imageArr addObjectsFromArray:array];
        [self refreshAssetsList];
    }
}


- (void)refreshAssetsList{
    for (NSInteger i = 0; i<self.imageArr.count; i++) {
        imgView = [[UIImageView alloc]initWithFrame:CGRectMake(75*i+10,5, 65, 65)];
//        ALAsset *asset = [self.imageArr objectAtIndex:i];
        imgView.image = [self.imageArr objectAtIndex:i];//[UIImage imageWithCGImage:asset.thumbnail];
        [contentScrollView addSubview:imgView];
        
    }
    if ([self.imageArr count] >= 5) {
        addPicBtn.hidden = YES;
        contentScrollView.contentSize = CGSizeMake(([self.imageArr count]-1)*75+85,75);
    }else{
        addPicBtn.frame = CGRectMake(75*[self.imageArr count]+10,5, 65, 65);
        contentScrollView.contentSize = CGSizeMake(([self.imageArr count])*75+85,75);
    }
}

//导航左右按钮
-(void)backBtnAction{
    if (arriveField.text.length ==0 && nameField.text.length == 0&&timeField.text.length == 0&&offworkField.text.length == 0&&phoneField.text.length == 0&&txDescription.text.length == 0&&[self.imageArr count]==0) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if (arriveField.text.length !=0 || nameField.text.length != 0 || timeField.text.length != 0 || offworkField.text.length != 0 ||phoneField.text.length != 0 ||txDescription.text.length != 0||[self.imageArr count]!=0) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"是否退出编辑" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
        alert.tag = 10;
        [alert show];
        [alert release];
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 10) {
        if (buttonIndex == 0) {
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            
            NSLog(@"不退出编辑");
        }
    }
    
}
-(void)rightBtnAction{
    if (arriveField.text.length ==0 && [arriveField.text isEqualToString:@""]) {
        [self alertWithFistButton:@"确定" SencodButton:nil Message:@"出发地点不能为空"];
        [arriveField becomeFirstResponder];
    }else if(nameField.text.length ==0 && [nameField.text isEqualToString:@""]){
        [self alertWithFistButton:@"确定" SencodButton:nil Message:@"目的地点不能为空"];
        [nameField becomeFirstResponder];
        
    }else if(timeField.text.length ==0 && [timeField.text isEqualToString:@""]){
        [self alertWithFistButton:@"确定" SencodButton:nil Message:@"出发时间不能为空"];
        [timeField becomeFirstResponder];
        
    }else if(offworkField.text.length ==0 && [offworkField.text isEqualToString:@""]){
        [self alertWithFistButton:@"确定" SencodButton:nil Message:@"下班时间不能为空"];
        [offworkField becomeFirstResponder];
    }else if(phoneField.text.length !=0 && phoneField.text.length !=11){
        [self alertWithFistButton:@"确定" SencodButton:nil Message:@"填写正确的手机号码格式"];
        [phoneField becomeFirstResponder];
        
    }else{
        //    添加拼车
        [self requestAdCarPoolingDetail];
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ---UITextView Delegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    
    [backScroll setContentOffset:CGPointMake(0, 165+NAVIGATIONBAR_HEIGHT) animated:YES];
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    [backScroll setContentOffset:CGPointMake(0, 0) animated:YES];
    return YES;
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    //限制字符在200个以内  add by Devin
    if ([text isEqualToString:@"\n"]){
        [textView resignFirstResponder];
        return NO;
    }
    NSString * aString = [textView.text stringByReplacingCharactersInRange:range withString:text];
    
    if (textView == txDescription)
    {
        if ([aString length] > 200) {
            return NO;
        }
    }
    return YES;
}


#pragma mark ---network
- (void)requestAdCarPoolingDetail{
    [Global showMBProgressHud:self SuperView:self.view Msg:@"请稍候..."];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *str = HTTPURLPREFIX;
        NSString *urlString = [str stringByAppendingString:CARSHARING_ADD_URL];
        UserModel *userModel = [UserModel shareUser];
        ASIFormDataRequest *uploadImageRequest= [ ASIFormDataRequest requestWithURL : [NSURL URLWithString:[urlString  stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
        [uploadImageRequest setStringEncoding:NSUTF8StringEncoding];
        [uploadImageRequest setRequestMethod:@"POST"];
        [uploadImageRequest addPostValue:userModel.userId forKey:@"userId"];
        [uploadImageRequest addPostValue:userModel.communityId forKey:@"communityId"];
        [uploadImageRequest addPostValue:userModel.propertyId forKey:@"propertyId"];
        [uploadImageRequest addPostValue:[NSString stringWithFormat:@"%d",typeInteger] forKey:@"type"];
        [uploadImageRequest addPostValue:arriveField.text forKey:@"destination"];
        [uploadImageRequest addPostValue:nameField.text forKey:@"returnHome"];
        [uploadImageRequest addPostValue:timeField.text forKey:@"attendanceTime"];
        [uploadImageRequest addPostValue:offworkField.text forKey:@"closingTime"];
        [uploadImageRequest addPostValue:phoneField.text forKey:@"contactUs"];
        [uploadImageRequest addPostValue:txDescription.text forKey:@"remark"];
        [uploadImageRequest setPostFormat:ASIMultipartFormDataPostFormat];
        
        for (UIImage *asset in self.imageArr)
        {
            //ALAssetRepresentation *assetRepresentation = [asset defaultRepresentation];
            UIImage *image = asset;//[UIImage imageWithCGImage:assetRepresentation.fullScreenImage];
            if(image == nil){
                
            }
            else{
                NSData *imageData = [NSData dataWithContentsOfFile:image.filePath];
                NSLog(@"%d",[imageData length]);
                if ((imageData == nil) || ([imageData length] <= 0)){
                    
                }else{
                    [uploadImageRequest addData:imageData withFileName:image.fileName andContentType:@"image/jpeg" forKey:@"images"];
                }
            }
        }
        [uploadImageRequest setDelegate : self ];
        [uploadImageRequest setDidFinishSelector : @selector (responseComplete:)];
        [uploadImageRequest setDidFailSelector : @selector (responseFailed:)];
        [uploadImageRequest startAsynchronous];
    });
}

- (void)responseComplete:(ASIFormDataRequest *)request{
     [self hideHudView];
    NSString* response = [request responseString];
    NSLog(@"response %@",response);
    request.delegate = nil;
    NSDictionary *dictionary = [response objectFromJSONString];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if ([[dictionary objectForKey:@"pointContent"] length]!=0) {
        [Global showMBProgressHudHint:self SuperView:appDelegate.window Msg:[dictionary objectForKey:@"pointContent"] ShowTime:0.5];
    }
    NSString *code = [dictionary objectForKey:@"errorCode"];
    if ([code isEqualToString:NETWORK_RETURN_CODE_S_OK]) {
        if ([[dictionary objectForKey:@"pointContent"] length]!=0) {
            [Global showMBProgressHudHint:self SuperView:self.view Msg:[dictionary objectForKey:@"pointContent"] ShowTime:0.5];
        }else{
            if([dictionary objectForKey:@"errorMsg"]){
                [Global hideProgressViewForType:success message:[dictionary objectForKey:@"errorMsg"] afterDelay:1.0f];
            }
        }
        [MobClick event:@"AddCarPooling_Complete"];
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        if ([dictionary objectForKey:@"errorMsg"]) {
            [Global hideProgressViewForType:failed message:[dictionary objectForKey:@"errorMsg"] afterDelay:1.0f];
        }
        
    }    
}

- (void)responseFailed:(ASIFormDataRequest *)request{
     [self hideHudView];
    NSString* response = [request responseString];
    NSLog(@"response %@",response);
    request.delegate = nil;
    NSDictionary *dictionary = [response objectFromJSONString];
    NSString *code = [dictionary objectForKey:@"errorCode"];
    if ([code isEqualToString:NETWORK_RETURN_CODE_S_OK]) {
        [Global hideProgressViewForType:success message:@"添加成功" afterDelay:1.0f];
        [self.navigationController popViewControllerAnimated:YES];
        
    }else{
        [Global hideProgressViewForType:failed message:@"添加失败" afterDelay:1.0f];
    }
}

#pragma mark ---
//点击让pickView消失
-(void)timeFieldDone:(DatePickField *)sender{

    [backScroll setContentOffset:CGPointMake(0, 70+NAVIGATIONBAR_HEIGHT) animated:YES];
}
-(void)offworkFieldDone:(DatePickField *)sender{
    [backScroll setContentOffset:CGPointMake(0, 105+NAVIGATIONBAR_HEIGHT) animated:YES];
}
-(void)doneClicked:(UIBarButtonItem*)button{
    [self.view endEditing:YES];
    [backScroll setContentOffset:CGPointMake(0, 0) animated:YES];
}

- (void) hideHudView
{
    if (hudView) {
        [hudView hide:YES];
    }
}

@end
