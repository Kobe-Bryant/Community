//
//  AddGoodsViewController.m
//  CommunityAPP
//
//  Created by Dream on 14-3-17.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import "AddGoodsViewController.h"
#import "Global.h"
#import "NSObject_extra.h"
#import "ASIFormDataRequest.h"
#import "UserModel.h"
#import "NSFileManager+Community.h"
#import "UIImage+extra.h"
#include <ImageIO/ImageIO.h>
#import "MBProgressHUD.h"
#import "UIViewController+NavigationBar.h"
#import "JSONKit.h"
#import "AppDelegate.h"
#import "MobClick.h"

@interface AddGoodsViewController ()<UITextViewDelegate>

@property (nonatomic, retain) UIButton *btnAddPhotos;

@end

@implementation AddGoodsViewController
@synthesize imageArr = _imageArr;
@synthesize btnAddPhotos = _btnAddPhotos;

- (void)dealloc{
     addGoodsTableView = nil;
    [self.imageArr removeAllObjects]; self.imageArr = nil;
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
    [MobClick beginLogPageView:@"AddGoodsPage"];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
    [MobClick endLogPageView:@"AddGoodsPage"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.view setBackgroundColor:RGB(244, 244, 244)];
    [self.navigationController setNavigationBarHidden:NO];
    //自适应iOS的导航栏、状态栏
    [self adjustiOS7NaviagtionBar];
    [self setNavigationTitle:@"添加物品"];
    //自定义返回按钮
    UIButton *backButton = [self setBackBarButton];
    [backButton addTarget:self action:@selector(leftBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self setBackBarButtonItem:backButton];
    
    //    右边按钮
    UIImage *rightImage = [UIImage imageNamed:@"icon_phone_add_save.png"];
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setImage:rightImage forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightBtnAction) forControlEvents:UIControlEventTouchUpInside];
    rightBtn.frame = CGRectMake(275,0,44,44);
    [self setRightBarButtonItem:rightBtn];
    
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
    _btnAddPhotos = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnAddPhotos.frame = CGRectMake(10,5, 65, 65);
    [_btnAddPhotos setImage:[UIImage imageNamed:@"icon_car_add.png"] forState:UIControlStateNormal];
    [_btnAddPhotos addTarget:self action:@selector(addPicBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [contentScrollView addSubview:_btnAddPhotos];

    //uitableview列表
    addGoodsTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 20, ScreenWidth, MainHeight) style:UITableViewStylePlain];
    addGoodsTableView.backgroundColor = RGB(244, 244, 244);
    addGoodsTableView.delegate = self;
    addGoodsTableView.dataSource = self;
    addGoodsTableView.tableHeaderView.backgroundColor = [UIColor clearColor];
    addGoodsTableView.tableHeaderView = contentScrollView;
    addGoodsTableView.backgroundView = nil;
    addGoodsTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:addGoodsTableView];
    [addGoodsTableView release];
    
    [self refreshPickedAssets];
}

#pragma mark -- uitableviewDataSource

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, 320.f, 40.f)];
        headerView.backgroundColor = [UIColor clearColor];
        UILabel *lable = [self newLabelWithText:@"补充说明(可选)" frame:CGRectMake(10,15 ,280, 20) font:[UIFont systemFontOfSize:15.0] textColor:RGB(90, 90, 90)];
        lable.numberOfLines = 0;
        lable.backgroundColor = [UIColor clearColor];
        [headerView addSubview:lable];
        [lable release];
        return [headerView autorelease];
    }else{
        UIView *__view = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 10)] autorelease];
        __view.backgroundColor = RGB(244, 244, 244);
        
        return __view;
    }
    
    return nil;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 0) {
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, 320.f, 50.f)];
        footerView.backgroundColor = RGB(244, 244, 244);

        return [footerView autorelease];
    }
    return nil;
}
-(CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return 10.0f;
    }
    return 0.f;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 10.0f;
    }else{
        return 44.0f;
    }
    
    return 0.0;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            return 120.0f;
        }
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
    return section;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    static NSString *identifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier]autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.backgroundView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
        cell.backgroundView.backgroundColor = [UIColor whiteColor];
    }
    
    switch (section) {
        case 0:
            if (row == 0) {
                titleField = [[UITextField alloc]initWithFrame:CGRectMake(15, 0, 320, 40)];
                titleField.delegate=self;
                titleField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;//字体垂直居中对齐
                titleField.borderStyle = UITextBorderStyleNone;
                titleField.returnKeyType = UIReturnKeyDone;
                titleField.font = [UIFont systemFontOfSize:15.0];
                titleField.placeholder = @"标题，可含种类/品牌/颜色/型号等";
                [cell.contentView addSubview:titleField];
                [titleField release];
            }
            if (row == 1) {
                priceField = [[UITextField alloc]initWithFrame:CGRectMake(15, 0, 320, 40)];
                priceField.delegate=self;
                priceField.borderStyle = UITextBorderStyleNone;
                priceField.keyboardType = UIKeyboardTypeNumberPad;
                priceField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;//字体垂直居中对齐
                priceField.font = [UIFont systemFontOfSize:15.0];
                priceField.placeholder = @"价格";
                [cell.contentView addSubview:priceField];
                [priceField release];
            }
            break;
        case 1:
            if (row == 0) {
                txDescription = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, cell.contentView.frame.size.width, 120)];
                txDescription.delegate = self;
                txDescription.font = [UIFont systemFontOfSize:16.0f];
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

#pragma mark --- uitextfieldDelegate
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (!isIPhone5 && textField == priceField) {
        [UIView animateWithDuration:0.4
                         animations:^{
                             self.view.transform = CGAffineTransformMakeTranslation(0, -90);
                         }];
    }
    
    return YES;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [titleField resignFirstResponder];
    [priceField resignFirstResponder];
    //[descriptionField resignFirstResponder];
    return YES;
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{//限制字符在20个以内  add by Devin
    if ([string isEqualToString:@"\n"]){
        return YES;
    }
    NSString * aString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (textField == priceField) {
        if ([aString length] > 6) {
            return NO;
        }
    }
    if (textField == titleField)
    {
        if ([aString length] > 20) {
            return NO;
        }
    }
    /*
    if (textField == descriptionField) {
        
        if ([aString length] > 120) {
            return NO;
        }
    }
     */
    return YES;
}
//-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
//        [UIView animateWithDuration:0.4
//                         animations:^{
//                             self.view.transform = CGAffineTransformMakeTranslation(0, 0);
//                         }];
//    return YES;
//}

//添加图片按钮
-(void)addPicBtnAction
{
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
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"没有相机" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            [alert release];
            return;
        }
        UIImagePickerController *pick = [[UIImagePickerController alloc] init];
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
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    BOOL iscamera = [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
    if (!iscamera) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"没有相机" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
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
        [self refreshPickedAssets];
    }
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;
{
    NSLog(@"%@",contextInfo);
    // Handle the end of the image write process
    if (!error)
        NSLog(@"Image written to photo album");
    else
        NSLog(@"Error writing to photo album: %@",
                  [error localizedDescription]);
}


#pragma mark --CTAssetsPickerControllerDelegate
-(void)assetsPickerController:(CTAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets
{
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
        [self refreshPickedAssets];
    }
}

- (void)refreshPickedAssets{
    for (NSInteger i = 0; i<self.imageArr.count; i++) {
        UIImageView  *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(75*i+10,5, 65, 65)];
        imageView.image = [self.imageArr objectAtIndex:i];
        [contentScrollView addSubview:imageView];
        [imageView release];
    }
    if ([self.imageArr count] >= 5) {
        _btnAddPhotos.hidden = YES;
        contentScrollView.contentSize = CGSizeMake(([self.imageArr count]-1)*75+85,75);
    }else{
        _btnAddPhotos.frame = CGRectMake(75*[self.imageArr count]+10,5, 65, 65);
        contentScrollView.contentSize = CGSizeMake(([self.imageArr count])*75+85,75);
    }
}

//导航栏左右按钮
-(void)leftBtnAction
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"确认放弃本次编辑吗?" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    alert.tag = 10;
    [alert show];
    [alert release];

    return;
    if (titleField.text.length ==0 && priceField.text.length == 0) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if (titleField.text.length !=0 || priceField.text.length != 0 ) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"确认放弃本次编辑吗?" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
        alert.tag = 10;
        [alert show];
        [alert release];
    }
    
   
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 10) {
        if (buttonIndex == 0) {
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            
            NSLog(@"不退出编辑");
        }
    }
   
}


- (void)rightBtnAction{
    NSString *regex = @"^[0-9]+(.[0-9]{0,100})?$";//验证有0~100位小数的正实数
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    if (titleField.text.length ==0 && [titleField.text isEqualToString:@""]) {
        [self alertWithFistButton:@"确定" SencodButton:nil Message:@"标题不能为空"];
        [titleField becomeFirstResponder];
    }else if(![pred evaluateWithObject:priceField.text]){
        [self alertWithFistButton:@"确定" SencodButton:nil Message:@"请输入正确的价格"];
        [priceField becomeFirstResponder];
        
    }else{
        [self requestAddAuction];
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ---UITextView Delegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    if (isIPhone5) {
        [UIView animateWithDuration:0.4
                         animations:^{
                             self.view.transform = CGAffineTransformMakeTranslation(0, -90);
                         }];
    }else{
        [UIView animateWithDuration:0.4
                         animations:^{
                             self.view.transform = CGAffineTransformMakeTranslation(0, -130);
                         }];
    }
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    [UIView animateWithDuration:0.4
                     animations:^{
                         self.view.transform = CGAffineTransformIdentity;
                     }];
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
- (void)requestAddAuction{

    [Global showMBProgressHud:self SuperView:self.view Msg:@"请稍候..." ShowTime:10];
    //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *str = HTTPURLPREFIX;  //@"http://192.168.2.46:8080/property";
        NSString *urlString = [str stringByAppendingString:AUCTION_ADD_URL];
        
        UserModel *userModel = [UserModel shareUser];
        
        ASIFormDataRequest *uploadImageRequest= [ ASIFormDataRequest requestWithURL:[NSURL URLWithString:[urlString   stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
        [uploadImageRequest setStringEncoding:NSUTF8StringEncoding];
        [uploadImageRequest setRequestMethod:@"POST"];
        [uploadImageRequest setPostValue:userModel.userId forKey:@"userId"];
        [uploadImageRequest setPostValue:userModel.communityId forKey:@"communityId"];
        [uploadImageRequest setPostValue:userModel.propertyId forKey:@"propertyId"];
        [uploadImageRequest setPostValue:titleField.text forKey:@"title"];
        [uploadImageRequest setPostValue:priceField.text forKey:@"cost"];
        [uploadImageRequest setPostValue:txDescription.text forKey:@"remark"];
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
    NSString* response = [request responseString];
    NSLog(@"response %@",response);
    request.delegate = nil;
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSDictionary *dictionary = [response objectFromJSONString];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if ([[dictionary objectForKey:@"pointContent"] length]!=0) {
        [Global showMBProgressHudHint:self SuperView:appDelegate.window Msg:[dictionary objectForKey:@"pointContent"] ShowTime:0.5];
    }
    NSString *code = [dictionary objectForKey:@"errorCode"];
    if ([code isEqualToString:NETWORK_RETURN_CODE_S_OK]) {
        [Global hideProgressViewForType:success message:@"添加成功" afterDelay:1.0f];
        
        [MobClick event:@"AddGoods_Complete"];
        
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [Global hideProgressViewForType:failed message:@"添加失败" afterDelay:1.0f];
    }
    
}

- (void)responseFailed:(ASIFormDataRequest *)request{
    NSString* response = [request responseString];
    NSLog(@"response %@",response);
    request.delegate = nil;
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSDictionary *dictionary = [response objectFromJSONString];
    NSString *code = [dictionary objectForKey:@"errorCode"];
    if ([code isEqualToString:NETWORK_RETURN_CODE_S_OK]) {
        [Global hideProgressViewForType:success message:@"添加成功" afterDelay:1.0f];
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [Global hideProgressViewForType:failed message:@"添加失败" afterDelay:1.0f];
    }
}

@end
