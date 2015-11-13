//
//  MyPublishViewController.m
//  CommunityAPP
//
//  Created by Dream on 14-3-13.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import "MyPublishViewController.h"
#import "Global.h"
#import "NSObject_extra.h"
#import "MyPublishCell.h"
#import "UserModel.h"
#import "CommunityHttpRequest.h"
#import "UIImageView+WebCache.h"
#import "MyPublishModel.h"
#import "DetailLiveEncyclopediaViewController.h"
#import "SellingDetailViewController.h"
#import "CarPoolingDetailViewController.h"
#import "UIViewController+NavigationBar.h"
#import "MobClick.h"

@interface MyPublishViewController ()
@property (nonatomic, retain) CommunityHttpRequest *request;
@end

@implementation MyPublishViewController
@synthesize mypublishArray = _mypublishArray;
@synthesize sigleArray = _sigleArray;
@synthesize publishTitleString;
@synthesize publishIdString;
@synthesize isWhoPublish = _isWhoPublish;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
//        _mypublishArray = [[NSMutableArray alloc]initWithCapacity:0];
//        _sigleArray = [[NSMutableArray alloc]initWithCapacity:0];
        _isWhoPublish = IsMyPublish; //默认是我的发布
    }
    return self;
}

-(id)initWithUserId:(NSString *)userIdString title:(NSString *)titleString{
    self = [self init];
    if (self) {
        // Custom initialization
        _mypublishArray = [[NSMutableArray alloc]initWithCapacity:0];
        _sigleArray = [[NSMutableArray alloc]initWithCapacity:0];
        
        self.publishTitleString = titleString;
        self.publishIdString = userIdString;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
    //加载网络数据
    [self hideHudView];
    hudView = [Global showMBProgressHud:self SuperView:self.view Msg:@"请稍候..."];//  请求验证验证码是否正确
    [self requestMyPublishData];
    [MobClick beginLogPageView:@"MyPublishPage"]; // 友盟统计
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
    [MobClick endLogPageView:@"MyPublishPage"];
}

- (void)dealloc
{
    [_request cancelDelegate:self];
    [_mypublishArray release]; _mypublishArray = nil;
    [MyPublishTableView release]; MyPublishTableView = nil;
    [hudView release]; hudView = nil;
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.navigationController setNavigationBarHidden:NO];
    [self.view setBackgroundColor:RGB(241, 241, 241)];
    
    //自适应iOS的导航栏、状态栏
    [self adjustiOS7NaviagtionBar];
    if (_isWhoPublish == IsHisPublish) {
        [self setNavigationTitle:@"ta的发布"];//如果是从他的发布push过来，则标志起来（没有删除评论按钮）
    }else{
        [self setNavigationTitle:@"我的发布"];//（有删除评论按钮）
    }
    
    //自定义返回按钮
    UIButton *backButton = [self setBackBarButton];
    [backButton addTarget:self action:@selector(leftBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self setBackBarButtonItem:backButton];
    
    
    //列表视图
    MyPublishTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0,ScreenWidth, MainHeight) style:UITableViewStylePlain];
    MyPublishTableView.delegate = self;
    MyPublishTableView.dataSource = self;
    MyPublishTableView.tableFooterView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
    MyPublishTableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:MyPublishTableView];
    

}

-(void)requestMyPublishData{
    //加载网络数据
    if (_request == nil) {
        _request = [CommunityHttpRequest shareInstance];
    }
    UserModel *userModel = [UserModel shareUser];
    NSString *userIdString;
    if ([self.publishIdString length]!=0) {
        userIdString = self.publishIdString;
    }else{
        userIdString = userModel.userId;
    }
    NSString *parameters = [NSString stringWithFormat:@"?%@=%@&%@=%@&%@=%@&lastId=%d",USER_ID,userIdString ,COMMUNITY_ID,userModel.communityId,PROPERTY_ID,userModel.propertyId,0];//参数
    [_request requestMyPublish:self parameters:parameters];

}

#pragma mark -- uitableviewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.mypublishArray count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyPublishCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyPublishCell"];
    if (cell == nil) {
        cell = [[[MyPublishCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MyPublishCell"]autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    
    MyPublishModel *model = [_mypublishArray objectAtIndex:indexPath.row];
    cell.titleLable.text = model.mypublishTitle;
    cell.timeLable.text = model.mypublishCreateTime;
    /*模块类型Id  2、生活百科，3、美食，4、拼车上下班, 5.随后拍了卖
     */
    if ([model.mypublishModuleTypeId isEqualToString:@"2"]) {
        //cell.iconImage.image = [UIImage imageNamed:@""];
    }else if([model.mypublishModuleTypeId isEqualToString:@"3"]){
    
    }else if([model.mypublishModuleTypeId isEqualToString:@"4"]){
        cell.iconImage.image = [UIImage imageNamed:@"middle_neighbor_car_pic.png"];
    }else if([model.mypublishModuleTypeId isEqualToString:@"5"]){
        cell.iconImage.image = [UIImage imageNamed:@"middle_neighbor_photo_pic.png"];
    }
    
    return cell;

}
#pragma mark ---- uitableviewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    MyPublishModel *model = [self.mypublishArray objectAtIndex:indexPath.row];
    /* 2生活百科 3美食 4拼车上次班 5随手拍了卖
     */
    if ([model.mypublishModuleTypeId integerValue] == 2) {
        DetailLiveEncyclopediaViewController *live = [[DetailLiveEncyclopediaViewController alloc]init];
        live.type = CMLIVEPEDIA;
        live.baseId = [NSString stringWithFormat:@"%@",model.mypublishModuleId];
        [self.navigationController pushViewController:live animated:YES];
        [live release];
        
    }else if([model.mypublishModuleTypeId integerValue] == 3){
        
    }else if([model.mypublishModuleTypeId integerValue] == 4){
        CarPoolingDetailViewController *car = [[CarPoolingDetailViewController alloc]init];
        car.publishModel = model; //传参
        car.carVcType = MyCarConrrollerPush; //标志从哪个controller传过去
        if (_isWhoPublish == IsHisPublish) {
            car.carPublishType = IsHisCarMyPublish; //如果是从他的发布push过来，则标志起来（没有删除评论按钮）
        }else{
             car.carPublishType = IsCarMyPublish;//（有删除评论按钮）
        }
        car.type = CMSHARECAR;
        car.baseId = [NSString stringWithFormat:@"%@",model.mypublishModuleId];
        [self.navigationController pushViewController:car animated:YES];
        [car release];
    }else if([model.mypublishModuleTypeId integerValue] == 5){
        SellingDetailViewController *sell = [[SellingDetailViewController alloc]init];
        sell.publishModel = model; //传参
        sell.entryType = CMEntryPush;//标志从哪个controller传过去
        if (_isWhoPublish == IsHisPublish) {
            sell.sellPublishType = IsHisSellMyPublish;//如果是从他的发布push过来，则标志起来（没有删除评论按钮）
        }else{
           sell.sellPublishType = IsSellMyPublish;//（有删除评论按钮）
        }
        sell.type = CMAUCTION;
        sell.baseId = [NSString stringWithFormat:@"%@",model.mypublishModuleId];
        [self.navigationController pushViewController:sell animated:YES];
        [sell release];
        
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0;
}

//- (BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
//    return YES;
//}
//- (NSString *)tableView:(UITableView *)tableVie titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return @"删除";
//}
/// 当点击删除时，删除该条记录
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        MyPublishModel *model =[self.mypublishArray objectAtIndex:indexPath.row];
//        //加载网络数据
//        [self hideHudView];
//        hudView = [Global showMBProgressHud:self SuperView:self.view Msg:@"请稍候..."];//  请求验证验证码是否正确
//        
//        //加载网络数据
//        if (_request == nil) {
//            _request = [CommunityHttpRequest shareInstance];
//        }
//        UserModel *userModel = [UserModel shareUser];
//        NSString *parameters = [NSString stringWithFormat:@"?%@=%@&%@=%@&%@=%@&id=%@&moduleTypeId=%@&moduleId=%@",USER_ID,userModel.userId ,COMMUNITY_ID,userModel.communityId,PROPERTY_ID,userModel.propertyId,model.mypublishId,model.mypublishModuleTypeId,model.mypublishModuleId];//参数
//        [_request requestDelegateMyPublish:self parameters:parameters];
//        //把数组里的元素也删除
//        [self.mypublishArray removeObjectAtIndex:indexPath.row];
//       
//    }
//}

#pragma mark ------
-(void) callBackWith: (WInterface) interface status: (NSString*) status data:(id) data{
    [self.mypublishArray removeAllObjects];
    _sigleArray = [data retain];
    NSString *code = [data objectForKey:ERROR_CODE];
    if (interface ==COMMUNITY_SEEK_MYPUBLISH) {
        if ([code isEqualToString:NETWORK_RETURN_CODE_S_OK]){
            [self hideHudView];
            NSArray *array = [data objectForKey:@"publishs"];
            for (NSDictionary *dic in array) {
                MyPublishModel *model = [[MyPublishModel alloc]init];
                model.mypublishId = [dic objectForKey:@"id"];
                model.mypublishModuleId = [dic objectForKey:@"moduleId"];
                model.mypublishModuleTypeId = [dic objectForKey:@"moduleTypeId"];
                model.mypublishTitle = [dic objectForKey:@"title"];
                model.mypublishCreateTime = [dic objectForKey:@"createTime"];
                [self.mypublishArray addObject:model];
                [model release];//add vincent
            }
            if ([self.mypublishArray count]==0) {
                UILabel *noDataContentLabel = [[UILabel alloc ]  initWithFrame:
                                      CGRectMake(0, (self.view.frame.size.height-64)/2, MainWidth, 22)];
                noDataContentLabel.text = GlobalCommunityNoDataWarning;
                noDataContentLabel.textColor = RGB(53, 53, 53);
                noDataContentLabel.hidden = NO;
                noDataContentLabel.textAlignment = NSTextAlignmentCenter;;
                noDataContentLabel.backgroundColor = [UIColor clearColor];
                noDataContentLabel.font = [UIFont systemFontOfSize:17];
                [self.view addSubview:noDataContentLabel];
                [noDataContentLabel release];
                //[Global showMBProgressHudHint:self SuperView:self.view Msg:@"当前没有数据" ShowTime:1.0];
            }else{
                [MyPublishTableView reloadData];
            }
            
        }else{
            NSLog(@"网络获取数据失败");
        }
    }
    else if(interface == COMMUNITY_DELEGATE_MYPUBLISH){
        if ([code isEqualToString:NETWORK_RETURN_CODE_S_OK]){
            [self hideHudView];
            
        }else{
           NSLog(@"网络获取数据失败");
        }
    }
      [MyPublishTableView reloadData];
}

//导航栏左按钮
-(void)leftBtnAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) hideHudView
{
    if (hudView) {
        [hudView hide:YES];
    }
}

@end
