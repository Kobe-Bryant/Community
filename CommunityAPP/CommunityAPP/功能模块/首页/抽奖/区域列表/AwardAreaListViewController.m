//
//  AwardAreaListViewController.m
//  CommunityAPP
//
//  Created by yunlai on 14-5-14.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import "AwardAreaListViewController.h"
#import "Global.h"
#import "UIViewController+NavigationBar.h"
#import "UserModel.h"
#import "DataLocitionModel.h"
#import "CityListViewController.h"
#import "AppDelegate.h"
#import "MobClick.h"

@interface AwardAreaListViewController ()

@end

@implementation AwardAreaListViewController
@synthesize provincesArray;

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
    [MobClick beginLogPageView:@"AwardAreaListPage"];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
    [MobClick endLogPageView:@"AwardAreaListPage"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //自适应iOS的导航栏、状态栏
    [self adjustiOS7NaviagtionBar];
    [self setNavigationTitle:@"区域选择"];
    //自定义返回按钮
    UIButton *backButton = [self setBackBarButton];
    [backButton addTarget:self action:@selector(leftBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self setBackBarButtonItem:backButton];
    
    [self loardTableView];
    
     [self requestAreasList];
}

-(void)leftBtnAction{
    [self.navigationController popViewControllerAnimated:YES];
}

//请求区域地址
-(void)requestAreasList{
    [self hideHudView];
    hudView = [Global showMBProgressHud:self SuperView:self.view Msg:@"请稍候..."];
    
    // 网络请求ß®
    if (request == nil) {
        request = [CommunityHttpRequest shareInstance];
    }
    UserModel *userModel = [UserModel shareUser];
    NSString *string = [NSString stringWithFormat:@"?userId=%@&communityId=%@&propertyId=%@&parentId=%@",userModel.userId,userModel.communityId,userModel.propertyId,@"0"];//参数
    [request requestDataLocation:self parameters:string];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)loardTableView{
    recordTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, MainHeight) style:UITableViewStylePlain];
    recordTableView.backgroundColor = RGB(244, 244, 244);
    recordTableView.delegate = self;
    recordTableView.dataSource = self;
    recordTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    recordTableView.tableFooterView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
    [self.view addSubview:recordTableView];
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.provincesArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NoticeTableView"];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:
                 UITableViewCellStyleSubtitle reuseIdentifier:@"NoticeTableView"] autorelease];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    
    DataLocitionModel  *model = [self.provincesArray objectAtIndex:indexPath.row];
    cell.textLabel.text = model.nameString;
    
    return cell;
}
#pragma mark UITableViewDelegate implementation
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DataLocitionModel  *model = [self.provincesArray objectAtIndex:indexPath.row];
    
    CityListViewController *listVc = [[CityListViewController alloc] init];
    listVc.model = model;
    
    AppDelegate *appDelegate = [AppDelegate instance];
    appDelegate.areaString = model.nameString;

    [self.navigationController pushViewController:listVc animated:YES];
    [listVc release];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
- (void) hideHudView
{
    if (hudView) {
        [hudView hide:YES];
    }
}
#pragma mark
-(void) callBackWith: (WInterface) interface status: (NSString*) status data:(id) data{
    [self hideHudView];
    if (interface == COMMUNITY_DATA_LOCATION){
 
        NSArray *callBackArray = [data objectForKey:@"dataList"];
        NSMutableArray *object_Arr = [[NSMutableArray alloc] init];
        for (NSDictionary *dic in callBackArray) {
            DataLocitionModel  *model = [[DataLocitionModel alloc] init];
            model.idString = [dic objectForKey:@"id"];
            model.nameString = [dic objectForKey:@"name"];
            model.parentIdString = [dic objectForKey:@"parentId"];
            [object_Arr addObject:model];
            [model release];
        }
        self.provincesArray = object_Arr;
        [recordTableView reloadData];
        [object_Arr release]; //add Vincent 内存释放
    }else{
        
    }
}

@end
