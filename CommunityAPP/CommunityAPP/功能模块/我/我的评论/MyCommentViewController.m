//
//  MyCommentViewController.m
//  CommunityAPP
//
//  Created by Dream on 14-3-13.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import "MyCommentViewController.h"
#import "Global.h"
#import "NSObject_extra.h"
#import "MyCommentCell.h"
#import "CommunityHttpRequest.h"
#import "UserModel.h"
#import "MyCommentModel.h"
#import "UIImageView+WebCache.h"
#import "DetailLiveEncyclopediaViewController.h"
#import "SellingDetailViewController.h"
#import "CarPoolingDetailViewController.h"
#import "TQRichTextView.h"
#import "UIViewController+NavigationBar.h"
#import "MobClick.h"

@interface MyCommentViewController ()
@property (nonatomic, retain) CommunityHttpRequest *request;

@end

@implementation MyCommentViewController
@synthesize request = _request;
@synthesize mycommentArray = _mycommentArray;
@synthesize commentTitleString;
@synthesize commentIdString;
@synthesize hisOrmycomment = _hisOrmycomment;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _mycommentArray = [[NSMutableArray alloc]initWithCapacity:0];
        _hisOrmycomment = MYCOMMENT;  //默认是我的评论
    }
    return self;
}
-(id)initWithUserId:(NSString *)userIdString title:(NSString *)titleString{
    self = [self init];
    if (self) {
        // Custom initialization
        _mycommentArray = [[NSMutableArray alloc]initWithCapacity:0];
        self.commentTitleString = titleString;
        self.commentIdString = userIdString;
    }
    return self;
}
- (void)dealloc
{
    [_request cancelDelegate:self];
    [_mycommentArray release]; _mycommentArray = nil;
    [super dealloc];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    //加载网络数据
    [self hideHudView];
    hudView = [Global showMBProgressHud:self SuperView:self.view Msg:@"请稍候..."];//  请求验证验证码是否正确
    
    //加载网络数据
    if (_request == nil) {
        _request = [CommunityHttpRequest shareInstance];
    }
    UserModel *userModel = [UserModel shareUser];
    NSString *userIdString;
    if ([self.commentIdString length]!=0) {
        userIdString = self.commentIdString;
    }else{
        userIdString = userModel.userId;
    }
    NSString *parameters = [NSString stringWithFormat:@"?%@=%@&%@=%@&%@=%@&lastId=%d",USER_ID,userIdString ,COMMUNITY_ID,userModel.communityId,PROPERTY_ID,userModel.propertyId,0];//参数
    [_request requestMyComment:self parameters:parameters];
    
    [MobClick beginLogPageView:@"MyCommentPage"]; // 友盟统计
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
    [MobClick endLogPageView:@"MyCommentPage"];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.navigationController setNavigationBarHidden:NO];
    [self.view setBackgroundColor:RGB(241, 241, 241)];
    //自适应iOS的导航栏、状态栏
    if (_hisOrmycomment == HISCOMMENT) {
        [self setNavigationTitle:@"ta的评论"];// 判断是从他的评论push过来
    }else{
        [self setNavigationTitle:@"我的评论"];
    }
    [self adjustiOS7NaviagtionBar];
    //自定义返回按钮
    UIButton *backButton = [self setBackBarButton];
    [backButton addTarget:self action:@selector(leftBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self setBackBarButtonItem:backButton];

    
    //列表视图
    myCommentTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0,ScreenWidth, MainHeight) style:UITableViewStylePlain];
    myCommentTableView.delegate = self;
    myCommentTableView.dataSource = self;
    myCommentTableView.tableFooterView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
    myCommentTableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:myCommentTableView];
    
}
#pragma mark -- uitableviewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_mycommentArray count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyCommentCell"];
    if (cell == nil) {
        cell = [[[MyCommentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MyCommentCell"]autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    //网络数据设置
    MyCommentModel *model = [self.mycommentArray objectAtIndex:indexPath.row];
    [cell.headerImg setImageWithURL:[NSURL URLWithString:model.mycommentResidentIcon] placeholderImage:[UIImage imageNamed:@"default_head.png"]];
    cell.nameLable.text = model.mycommentResidentName;
    cell.timeLable.text = model.mycommentCreateTime;
    /* 2生活百科 3美食 4拼车上次班 5随手拍了卖
     */
    if (model.mycommentModuleTypeId == 2) {
        cell.commentTypeImg.image = [UIImage imageNamed:@"small_live_more.png"];
    }else if(model.mycommentModuleTypeId == 3){
        cell.commentTypeImg.image = [UIImage imageNamed:@"default_head.png"];
    }else if(model.mycommentModuleTypeId == 4){
        cell.commentTypeImg.image = [UIImage imageNamed:@"small_neighbor_car_pic.png"];
    }else if(model.mycommentModuleTypeId == 5){
        cell.commentTypeImg.image = [UIImage imageNamed:@"small_neighbor_photo_pic.png"];
    }
    //自适应
    CGFloat textHeight = [TQRichTextView getRechTextViewHeightWithText:model.mycommentRemark viewWidth:250 font:[UIFont systemFontOfSize:14.0] lineSpacing:1.8];
    CGRect rect = cell.contentLable.frame;
    cell.contentLable.frame = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width,MAX(textHeight, 44.0f));
    [cell.contentLable setText:model.mycommentRemark];
    [cell.timeLable setFrame:CGRectMake(195,cell.contentLable.frame.size.height+cell.contentLable.frame.origin.y , 120, 20)];
    UITapGestureRecognizer *labTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(lableTap:)];
    cell.contentLable.tag = indexPath.row;
    [cell.contentLable addGestureRecognizer:labTap];
    [labTap release];
    return cell;
    
}

#pragma mark ---- uitableviewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyCommentModel *model = ([self.mycommentArray  count]>indexPath.row)?[self.mycommentArray objectAtIndex:indexPath.row]:nil;
    
    NSString *strRemark = model.mycommentRemark;
    
    //逻辑判断高度
    CGFloat textHeight = [TQRichTextView getRechTextViewHeightWithText:strRemark viewWidth:250 font:[UIFont systemFontOfSize:14.0] lineSpacing:1.8];
    
    CGFloat height = MAX(textHeight, 44.0f);
    
    return height+70;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    MyCommentModel *model = [self.mycommentArray objectAtIndex:indexPath.row];
    /* 2生活百科 3美食 4拼车上次班 5随手拍了卖
     */
    if (model.mycommentModuleTypeId == 2) {
        DetailLiveEncyclopediaViewController *live = [[DetailLiveEncyclopediaViewController alloc]init];
        live.vcType = MyConrrollerPush;// 选择从我的评论push过去
        if (_hisOrmycomment == HISCOMMENT) {
            live.liveCommentType = IsHisLiveMyComment; // 判断是从他的评论push过来(用来标注“他的评论”或者“我的评论”)
        }else{
            live.liveCommentType = IsLiveMyComment; //判断是从我的评论push过来
        }
        live.flag = TRUE;
        live.comModel = model;
        live.type = CMLIVEPEDIA;//生活百科模块
        live.baseId = [NSString stringWithFormat:@"%@",model.mycommentCommentId];//生活百科帖子id
        [self.navigationController pushViewController:live animated:YES];
        [live release];
        
    }else if(model.mycommentModuleTypeId == 3){
        
    }else if(model.mycommentModuleTypeId == 4){
        CarPoolingDetailViewController *car = [[CarPoolingDetailViewController alloc]init];
        car.carVcType = MyCarConrrollerPush;// 选择从我的评论push过去
        if (_hisOrmycomment == HISCOMMENT) {
            car.carCommentType = IsHisCarMyComment; // 判断是从他的评论push过来
        }else{
           car.carCommentType = IsCarMyComment; //判断是从我的评论push过来
        }
        car.flag = TRUE;
        car.comModel = model;
        car.type = CMSHARECAR;
        car.baseId = [NSString stringWithFormat:@"%@",model.mycommentCommentId];
        [self.navigationController pushViewController:car animated:YES];
        [car release];
    }else if(model.mycommentModuleTypeId == 5){
        SellingDetailViewController *sell = [[SellingDetailViewController alloc]init];
        sell.entryType = CMEntryPush;
        if (_hisOrmycomment == HISCOMMENT) {
            sell.sellCommentType = IsHisSellMyComment; // 判断是从他的评论push过来
        }else{
            sell.sellCommentType = IsSellMyComment;
        }
        sell.flag = TRUE;
        sell.comModel = model;
        sell.type = CMAUCTION;
        sell.baseId = [NSString stringWithFormat:@"%@",model.mycommentCommentId];
        [self.navigationController pushViewController:sell animated:YES];
        [sell release];
    }
}
//导航栏左按钮
-(void)leftBtnAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark ------
-(void) callBackWith: (WInterface) interface status: (NSString*) status data:(id) data{
    [self.mycommentArray removeAllObjects];
    NSString *code = [data objectForKey:ERROR_CODE];
    if ([code isEqualToString:NETWORK_RETURN_CODE_S_OK]){
        [self hideHudView];
        NSArray *array = [data objectForKey:@"commentvo"];
        for (NSDictionary *dic in array) {
            MyCommentModel *model = [[MyCommentModel alloc]init];
            model.mycommentId = [[dic objectForKey:@"id"] integerValue];
            model.mycommentResidentId = [dic objectForKey:@"residentId"];
            model.mycommentResidentIcon = [dic objectForKey:@"residentIcon"];
            model.mycommentResidentName = [dic objectForKey:@"residentName"];
            model.mycommentCommentId = [dic objectForKey:@"commentId"];
            model.mycommentModuleTypeId = [[dic objectForKey:@"moduleTypeId"] integerValue];
            model.mycommentRemark = [dic objectForKey:@"remark"];
            model.mycommentCreateTime = [dic objectForKey:@"createTime"];
            [self.mycommentArray addObject:model];
            [model release];//add vincent
        }
        if ([self.mycommentArray count]==0) {
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
            [myCommentTableView reloadData];
        }
    }else{
        NSLog(@"获取网络数据失败");
     }
}

-(void)lableTap:(UITapGestureRecognizer *)sender{
    NSLog(@"sender = %d",sender.view.tag);
    MyCommentModel *model = [self.mycommentArray objectAtIndex:sender.view.tag];
    /* 2生活百科 3美食 4拼车上次班 5随手拍了卖
     */
    if (model.mycommentModuleTypeId == 2) {
        DetailLiveEncyclopediaViewController *live = [[DetailLiveEncyclopediaViewController alloc]init];
        live.vcType = MyConrrollerPush;// 选择从我的评论push过去
        if (_hisOrmycomment == HISCOMMENT) {
            live.liveCommentType = IsHisLiveMyComment; // 判断是从他的评论push过来(用来标注“他的评论”或者“我的评论”)
        }else{
            live.liveCommentType = IsLiveMyComment; //判断是从我的评论push过来
        }
        live.flag = TRUE;
        live.comModel = model;
        live.type = CMLIVEPEDIA;//生活百科模块
        live.baseId = [NSString stringWithFormat:@"%@",model.mycommentCommentId];//生活百科帖子id
        [self.navigationController pushViewController:live animated:YES];
        [live release];
        
    }else if(model.mycommentModuleTypeId == 3){
        
    }else if(model.mycommentModuleTypeId == 4){
        CarPoolingDetailViewController *car = [[CarPoolingDetailViewController alloc]init];
        car.carVcType = MyCarConrrollerPush;// 选择从我的评论push过去
        if (_hisOrmycomment == HISCOMMENT) {
            car.carCommentType = IsHisCarMyComment; // 判断是从他的评论push过来
        }else{
            car.carCommentType = IsCarMyComment; //判断是从我的评论push过来
        }
        car.flag = TRUE;
        car.comModel = model;
        car.type = CMSHARECAR;
        car.baseId = [NSString stringWithFormat:@"%@",model.mycommentCommentId];
        [self.navigationController pushViewController:car animated:YES];
        [car release];
    }else if(model.mycommentModuleTypeId == 5){
        SellingDetailViewController *sell = [[SellingDetailViewController alloc]init];
        sell.entryType = CMEntryPush;
        if (_hisOrmycomment == HISCOMMENT) {
            sell.sellCommentType = IsHisSellMyComment; // 判断是从他的评论push过来
        }else{
            sell.sellCommentType = IsSellMyComment;
        }
        sell.flag = TRUE;
        sell.comModel = model;
        sell.type = CMAUCTION;
        sell.baseId = [NSString stringWithFormat:@"%@",model.mycommentCommentId];
        [self.navigationController pushViewController:sell animated:YES];
        [sell release];
    }
}


- (void) hideHudView
{
    if (hudView) {
        [hudView hide:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
