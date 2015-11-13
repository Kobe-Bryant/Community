//
//  LiveEncyclopediaViewController.m
//  CommunityAPP
//
//  Created by Dream on 14-3-17.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import "LiveEncyclopediaViewController.h"
#import "Global.h"
#import "NSObject_extra.h"
#import "LiveEncyclopediaCell.h"
#import "IconButton.h"
#import "CommunityHttpRequest.h"
#import "UserModel.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import "MySelfViewController.h"
#import "MJRefresh.h"
#import "NeighborhoodIntroduceViewController.h"
#import "UIViewController+NavigationBar.h"
#import "AppConfig.h"
#import "MobClick.h"

@interface LiveEncyclopediaViewController (){
    MJRefreshFooterView *_footer;
    NSInteger buttonTag;//判断是哪个section的点赞
    NSInteger lastId;
    //LiveEncyclopediaCell *availableCell;
}

@property (nonatomic, retain) CommunityHttpRequest *request;
@property (nonatomic,retain) NSMutableArray *liveEncyclopediaArr;

@end

@implementation LiveEncyclopediaViewController
@synthesize request = _request;
@synthesize liveEncyclopediaArr;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.liveEncyclopediaArr = [[NSMutableArray alloc]initWithCapacity:0];
        lastId = 0;
    }
    return self;
}
- (void)dealloc{
    [_request cancelDelegate:self];
    liveEncyclopediaTableView.delegate = nil;
    liveEncyclopediaTableView.dataSource = nil;
    self.liveEncyclopediaArr = nil;
    [liveEncyclopediaTableView release]; liveEncyclopediaTableView =nil;
    [super dealloc];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //加载网络数据
    [self hideHudView];
    hudView = [Global showMBProgressHud:self SuperView:self.view Msg:@"请稍候..."];//  请求验证是否正确
    [self loadRequestData];
    [MobClick beginLogPageView:@"LiveEncyclopediaPage"]; //友盟统计
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
   [MobClick endLogPageView:@"LiveEncyclopediaPage"];
}

- (void)viewDidLoad{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.navigationController setNavigationBarHidden:NO];
    [self.view setBackgroundColor:RGB(241, 241, 241)];
    
    //自适应iOS的导航栏、状态栏
    [self adjustiOS7NaviagtionBar];
    [self setNavigationTitle:@"生活百科"];
    //自定义返回按钮
    UIButton *backButton = [self setBackBarButton];
    [backButton addTarget:self action:@selector(leftBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self setBackBarButtonItem:backButton];
    
    //列表视图
    liveEncyclopediaTableView = [[UITableView alloc]initWithFrame:CGRectMake(10, 0, ScreenWidth-20, MainHeight) style:UITableViewStyleGrouped];
    liveEncyclopediaTableView.delegate = self;
    liveEncyclopediaTableView.dataSource = self;
    liveEncyclopediaTableView.backgroundView = nil;
    liveEncyclopediaTableView.backgroundColor = [UIColor clearColor];
    liveEncyclopediaTableView.sectionHeaderHeight = 5.0;
    liveEncyclopediaTableView.sectionFooterHeight = 5.0;
    liveEncyclopediaTableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:liveEncyclopediaTableView];
    
    //上拉刷新
    [self addFooter];
}

#pragma mark ---refresh
#pragma mark ---refresh
- (void)addFooter
{
    __unsafe_unretained LiveEncyclopediaViewController *vc = self;
    MJRefreshFooterView *footer = [MJRefreshFooterView footer];
    footer.scrollView = liveEncyclopediaTableView;
    footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        //下拉刷新再次请求评论数据
        NSLog(@"%@",vc);
       [self loadRequestData];
    };
    _footer = footer;
    
}

- (void)doneWithView{
    [_footer endRefreshing];
}

-(void)loadRequestData{
    //加载网络数据 生活百科列表
    if (_request == nil) {
        _request = [CommunityHttpRequest shareInstance];
    }
    UserModel *userModel = [UserModel shareUser];
    LiveEncyclopediaModel *model = [self.liveEncyclopediaArr lastObject];
    
    if (model == nil) {
        lastId = 0;
    }else{
        lastId =model.liveId;
    }
    NSString *parameters = [NSString stringWithFormat:@"?%@=%@&%@=%@&%@=%@&%@=%@&lastId=%d",UPDATE_TIME,DEF_UPDATE_TIME,USER_ID,userModel.userId,COMMUNITY_ID,userModel.communityId,PROPERTY_ID,userModel.propertyId,lastId];//参数
    [_request requestLiveEncyclopedia:self parameters:parameters];
}

#pragma mark -- uitableviewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.liveEncyclopediaArr count];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identify = @"LiveEncyclopediaCell";
    LiveEncyclopediaCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[[LiveEncyclopediaCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify]autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        //设置边角
        cell.layer.borderWidth = 1.0f;
        cell.layer.borderColor = RGB(225, 225, 225).CGColor;
        cell.layer.cornerRadius = 5.0;
        cell.layer.masksToBounds = YES;
       //点击背景颜色
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    LiveEncyclopediaModel *model = [self.liveEncyclopediaArr objectAtIndex:indexPath.section];
    cell.liveModel = model;
    cell.subTitleTypeLable.text = model.liveType;
    cell.titleLable.text = model.liveTitle;  //标题
    cell.subTitleLable.text = model.liveCreateTime; //时间
    cell.contentTextView.text = model.liveContent; // 内容
    cell.commentLable.text = [NSString stringWithFormat:@"%d",model.liveCommentCount];//评论条数
    
    cell.loveLable.text = [NSString stringWithFormat:@"%d",model.liveFavour];// 点赞个数
    [cell.contentImg setImageWithURL:[NSURL URLWithString:model.liveContentImg] placeholderImage:[UIImage imageNamed:@"bg_sample_3.png"]]; //图片
    
    //点赞button
    cell.loveBtn.tag = indexPath.section;
    [cell.loveBtn addTarget:self action:@selector(loveBtn:) forControlEvents:UIControlEventTouchUpInside];

    //评论button
    cell.commentBtn.tag = indexPath.section;
    [cell.commentBtn addTarget:self action:@selector(commentBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    //评论头像图片
    if (![model.liveIcon isEqualToString:@""]) {
        NSArray *picArray = [model.liveIcon componentsSeparatedByString:@";"];
    for (int i = 0; i<[picArray count]; i++) {
        IconButton *partnersBtn = [IconButton buttonWithType:UIButtonTypeCustom];
        partnersBtn.frame = CGRectMake(10*(i+1)+(54/2)*i+180,5, 54/2, 54/2);
        [partnersBtn setImageWithURL:[NSURL URLWithString:[picArray objectAtIndex:i]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:nil]];
        partnersBtn.layer.cornerRadius = 13.5;
        partnersBtn.layer.masksToBounds = YES;
        [partnersBtn addTarget:self action:@selector(btnDetailAction:idString:) forControlEvents:UIControlEventTouchUpInside];
        partnersBtn.tagIndex = indexPath.section;
        partnersBtn.tagClick = i;
        [cell.backsBtn addSubview:partnersBtn];
        }
    }
    //点赞按钮
    if (model.liveFavourId == 0) {
        cell.loveBtn.selected = NO;
        
    }else{
        cell.loveBtn.selected = YES;
    }

        return cell;
}

#pragma mark --- uitableviewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   DetailLiveEncyclopediaViewController *detailLiveVc =[[DetailLiveEncyclopediaViewController alloc]init];
   LiveEncyclopediaModel *model = [self.liveEncyclopediaArr objectAtIndex:indexPath.section];
   detailLiveVc.type = CMLIVEPEDIA;
   detailLiveVc.liveModel = model;
   detailLiveVc.baseId = [NSString stringWithFormat:@"%d",model.liveId];
   [self.navigationController pushViewController:detailLiveVc animated:YES];
   [detailLiveVc release];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10.0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 300.0;
}

//点赞按钮
-(void)loveBtn:(LiveEncyclopediaButton *)sender{
    LiveEncyclopediaButton *button = (LiveEncyclopediaButton *)sender;
    buttonTag = button.tag;
    LiveEncyclopediaModel *model = [self.liveEncyclopediaArr objectAtIndex:button.tag];
    NSLog(@"model.liveId = %d",model.liveId);
    if (model.liveFavourId == 0) {
        NSLog(@"点赞了");
        //加载网络数据
        if (_request == nil) {
            _request = [CommunityHttpRequest shareInstance];
        }
        UserModel *userModel = [UserModel shareUser];
        NSString *parameters1 = [NSString stringWithFormat:@"?%@=%@&%@=%@&%@=%@&moduleTypeId=%d&detailsId=%d",USER_ID,userModel.userId,COMMUNITY_ID,userModel.communityId,PROPERTY_ID,userModel.propertyId,2,model.liveId];
        [_request requestAddLove:self parameters:parameters1];
    }else{
        NSLog(@"取消点赞了");
        //加载网络数据
        if (_request == nil) {
            _request = [CommunityHttpRequest shareInstance];
        }
        UserModel *userModel = [UserModel shareUser];
        NSString *parameters2 = [NSString stringWithFormat:@"?%@=%@&%@=%@&%@=%@&favourId=%d",USER_ID,userModel.userId,COMMUNITY_ID,userModel.communityId,PROPERTY_ID,userModel.propertyId,model.liveFavourId];
        [_request requestDeleLove:self parameters:parameters2];
    }
}

//评论按钮
-(void)commentBtn:(id)sender{
   UIButton *button = (UIButton *)sender;
   // buttonTag = button.tag;
   DetailLiveEncyclopediaViewController *detailLiveVc =[[DetailLiveEncyclopediaViewController alloc]init];
   LiveEncyclopediaModel *model = [self.liveEncyclopediaArr objectAtIndex:button.tag];
    detailLiveVc.liveModel = model;
   detailLiveVc.passStr = [NSString stringWithFormat:@"%d",model.liveId];
   [self.navigationController pushViewController:detailLiveVc animated:YES];
   [detailLiveVc release];
}

//导航左右按钮
-(void)leftBtnAction{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark ------
-(void) callBackWith: (WInterface) interface status: (NSString*) status data:(id) data{
    if (interface == COMMUNITY_LIVEENCYCLOPEDIA_LIST) {
        if ([status isEqualToString:NETWORK_RETURN_CODE_S_OK]) {
            [self hideHudView];
            NSArray *array = [data objectForKey:@"encyclopedia"];
            NSMutableArray *object_Arr = [[NSMutableArray alloc] init];
            for (NSDictionary *dic in array) {
                LiveEncyclopediaModel *listModel = [[LiveEncyclopediaModel alloc]init];
                listModel.liveId = [[dic objectForKey:@"id"] integerValue];
                listModel.liveTitle = [dic objectForKey:@"title"];
                listModel.liveType = [dic objectForKey:@"type"];
                listModel.liveContent = [dic objectForKey:@"contentLabel"];
                listModel.liveCreateTime = [dic objectForKey:@"createTime"];
                listModel.liveContentImg = [dic objectForKey:@"cover"];
                listModel.liveFavour = [[dic objectForKey:@"favour"] integerValue];
                listModel.liveFavourId = [[dic objectForKey:@"favourId"] integerValue];
                listModel.liveCommentCount = [[dic objectForKey:@"commentCount"] integerValue] ;
                listModel.liveResidentId = [dic objectForKey:@"residentId"];
                listModel.liveIcon = [dic objectForKey:@"icon"];
                listModel.liveContentImg = [dic objectForKey:@"cover"];
                listModel.liveIcon = [dic objectForKey:@"icon"];
                [object_Arr addObject:listModel];
                [listModel release]; //add Vincent 内存释放
            }
            [self.liveEncyclopediaArr addObjectsFromArray:object_Arr];
            [object_Arr release];
            [self doneWithView];
            [liveEncyclopediaTableView reloadData];
        }else{
            [self doneWithView];
            NSLog(@"生活百科数据获取失败");
        }
    }
    //点赞
     else if (interface == COMMUNITY_ADD_LOVE) {
         NSString *code = [data objectForKey:ERROR_CODE];
         if ([code isEqualToString:NETWORK_RETURN_CODE_S_OK]) {
             LiveEncyclopediaModel *model = [self.liveEncyclopediaArr count]>buttonTag?[self.liveEncyclopediaArr objectAtIndex:buttonTag]:nil;
             LiveEncyclopediaCell *cell = nil;
             if (model) {
             cell = (LiveEncyclopediaCell *)[liveEncyclopediaTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:buttonTag]];
             }
             cell.loveBtn.selected = YES;
             model.liveFavourId = [[data objectForKey:@"id"]integerValue];
             NSLog(@"model.liveFavourId = %d",model.liveFavourId);
             model.liveFavour++;
//            [liveEncyclopediaTableView reloadSections:[NSIndexSet indexSetWithIndex:buttonTag] withRowAnimation:UITableViewRowAnimationAutomatic];
             [liveEncyclopediaTableView reloadData];
         }
     }
    
    //取消点赞
     else if(interface == COMMUNITY_DELE_LOVE){
         NSString *code = [data objectForKey:ERROR_CODE];
         if ([code isEqualToString:NETWORK_RETURN_CODE_S_OK]) {
             LiveEncyclopediaModel *model = [self.liveEncyclopediaArr count]>buttonTag?[self.liveEncyclopediaArr objectAtIndex:buttonTag]:nil;
             LiveEncyclopediaCell *cell = nil;
             if (model) {
             cell = (LiveEncyclopediaCell *)[liveEncyclopediaTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:buttonTag]];
             }
             cell.loveBtn.selected = NO;
             model.liveFavourId = 0;
             model.liveFavour--;
            // [liveEncyclopediaTableView reloadSections:[NSIndexSet indexSetWithIndex:buttonTag] withRowAnimation:UITableViewRowAnimationNone];
             [liveEncyclopediaTableView reloadData];
         }

     
     }
}
- (void) hideHudView{
    if (hudView) {
        [hudView hide:YES];
    }
}

//头像点击进去个人资料
//下面类型的进入
-(void)btnDetailAction:(id)sender  idString:(id)sender2{
    IconButton *button = (IconButton *)sender;
    LiveEncyclopediaModel *model = [self.liveEncyclopediaArr objectAtIndex:button.tagIndex];
    NSArray *picArray = [model.liveResidentId componentsSeparatedByString:@";"];
    NSString *idString = [picArray objectAtIndex:button.tagClick];
    UserModel *userModel = [UserModel shareUser];
    if ([userModel.userId isEqualToString:model.liveResidentId]) {
        NSLog(@"如果是自己的话，不需要进入详情资料");
    }else {
    NeighborhoodIntroduceViewController *introduceVc = [[NeighborhoodIntroduceViewController alloc] initWithUserId:idString communityId:nil propertyId:nil name:nil];
    [self.navigationController pushViewController:introduceVc animated:YES];
        [introduceVc release];
    }
}

////局部section刷新
//NSIndexSet * nd=[[NSIndexSet alloc]initWithIndex:1];//刷新第二个section
//[tview reloadSections:nd withRowAnimation:UITableViewRowAnimationAutomatic];
////局部cell刷新  www.2cto.com
//NSIndexPath *te=[NSIndexPath indexPathForRow:2 inSection:0];//刷新第一个section的第二行
//[tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:te,nil] withRowAnimation:UITableViewRowAnimationMiddle];

@end
