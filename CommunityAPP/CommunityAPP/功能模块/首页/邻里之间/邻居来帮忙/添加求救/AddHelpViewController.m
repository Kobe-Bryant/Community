//
//  AddHelpViewController.m
//  CommunityAPP
//
//  Created by Dream on 14-3-10.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import "AddHelpViewController.h"
#import "Global.h"
#import "NSObject_extra.h"
#import "UIViewController+NavigationBar.h"

@interface AddHelpViewController ()

@end

@implementation AddHelpViewController
@synthesize imageArr = _imageArr;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _imageArr = [[NSMutableArray alloc]initWithCapacity:0];
    }
    return self;
}

- (void)dealloc
{
    [helpField release]; helpField = nil;
    [addField release]; addField = nil;
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.view setBackgroundColor:RGB(244, 244, 244)];
    
    //自适应iOS的导航栏、状态栏
    [self adjustiOS7NaviagtionBar];
    [self setNavigationTitle:@"添加求助"];

    
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
    UIButton *addPicBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addPicBtn.frame = CGRectMake(10,5, 65, 65);
    [addPicBtn setImage:[UIImage imageNamed:@"icon_car_add.png"] forState:UIControlStateNormal];
    [addPicBtn addTarget:self action:@selector(addPicBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [contentScrollView addSubview:addPicBtn];
    
    //uitableview列表
    addHelpTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, contentScrollView.frame.size.height+contentScrollView.frame.origin.y+20, ScreenWidth, 500) style:UITableViewStyleGrouped];
    addHelpTableView.backgroundColor = RGB(244, 244, 244);
    addHelpTableView.delegate = self;
    addHelpTableView.dataSource = self;
    addHelpTableView.backgroundView = nil;
    addHelpTableView.tableHeaderView.backgroundColor = [UIColor clearColor];
    addHelpTableView.tableHeaderView = contentScrollView;
    addHelpTableView.tableFooterView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
    [self.view addSubview:addHelpTableView];

}

#pragma mark -- uitableviewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier]autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    
    if (indexPath.row ==0) {
        helpField = [[UITextField alloc]initWithFrame:CGRectMake(15, 0, 320, 40)];
        helpField.delegate=self;
        helpField.borderStyle = UITextBorderStyleNone;
        helpField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;//字体垂直居中对齐
        helpField.font = [UIFont systemFontOfSize:15.0];
        helpField.placeholder = @"求助类型";
        [cell.contentView addSubview:helpField];
    }
    if (indexPath.row == 1) {
        addField = [[UITextField alloc]initWithFrame:CGRectMake(15, 0, 320, 40)];
        addField.delegate=self;
        addField.borderStyle = UITextBorderStyleNone;
        addField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;//字体垂直居中对齐
        addField.font = [UIFont systemFontOfSize:15.0];
        addField.placeholder = @"补充说明，写文案换灯泡修电脑找工作...";
        [cell.contentView addSubview:addField];
    }
    
    
    return cell;
}
#pragma mark -- uitableviewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.0;
}
#pragma mark -
#pragma uitextFIeldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [addField resignFirstResponder];
    [helpField resignFirstResponder];
    return YES;
}
//导航栏左右按钮
-(void)backBtnAction
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)rightBtnAction
{
    
}
//添加图片按钮
-(void)addPicBtnAction
{
    UIActionSheet* mySheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消"destructiveButtonTitle:@"拍照" otherButtonTitles:@"从相册选择", nil];
    [mySheet showInView:[UIApplication sharedApplication].keyWindow];
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
        picker.delegate = self;
        [self presentViewController:picker animated:YES completion:NULL];
    }
    
}
#pragma mark --UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    BOOL iscamera = [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
    if (!iscamera) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"没有相机" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
        [alert show];
        [alert release];
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
        [imgView release];
    }
    contentScrollView.contentSize = CGSizeMake([self.imageArr count]*75+85,75);
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
