//
//  SellingDetailViewController.m
//  CommunityAPP
//
//  Created by Stone on 14-3-18.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import "SellingDetailViewController.h"
#import "Global.h"
#import "NSObject_extra.h"
#import "SellingCommentCell.h"
#import "CarPoolDetailSectionHeaderView.h"
#import "CommunityHttpRequest.h"
#import "UserModel.h"
#import "ASIWebServer.h"
#import "AuctionDetailModel.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
#import "UIButton+WebCache.h"
#import "Common.h"
#import "AuctionCommentCell.h"
#import "AuctionCommentModel.h"
#import "Common.h"
#import "NSObject+Time.h"
#import "MJPhoto.h"
#import "MJPhotoBrowser.h"
#import "MJRefresh.h"
#import "CommunitySendTextAndImageView.h"
#import "CommonDefine.h"
#import "NeighborhoodIntroduceViewController.h"
#import "UIViewController+NavigationBar.h"
#import "MobClick.h"

@interface SellingDetailViewController ()<UITableViewDataSource,UITableViewDelegate,CommunitySendTextAndImageViewDelegate,WebServiceHelperDelegate,UIActionSheetDelegate>
{
    MJRefreshFooterView *_footer;
    NSInteger isCollected; // 判断是否收藏 0没收藏 非0收藏 add by devin
    NSInteger selectedId; //选中某人的评论 add by devin
    NSInteger delegateId; //删除评论 add by devin
    NSInteger clickIndexPathRow; //判断点了哪一个cell
   CommunitySendTextAndImageView *sendTextView;
}
@property (nonatomic, retain) NSString *auctionId;
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) UIScrollView *goodsPrviewScrollView;
@property (nonatomic, retain) UILabel *goodsTitle;
@property (nonatomic, retain) NSMutableArray *goodsPrviewsList;
@property (nonatomic, retain) CommunityHttpRequest *request;
@property (nonatomic, retain) AuctionDetailModel *auctionDetailModel;
@property (nonatomic, retain) NSString *lastCommentId;
@property (nonatomic, assign) NSInteger countString;
@property (nonatomic, retain) NSMutableArray *auctionComments;
@property (nonatomic, assign) GetCemmetnType getCommentType;
@property (nonatomic,retain) UIButton *commentButton;
@end

@implementation SellingDetailViewController

@synthesize tableView = _tableView;
@synthesize goodsPrviewScrollView = _goodsPrviewScrollView;
@synthesize goodsTitle = _goodsTitle;
@synthesize goodsPrviewsList = _goodsPrviewsList;
@synthesize auctionId = _auctionId;
@synthesize request = _request;
@synthesize lastCommentId = _lastCommentId;
@synthesize countString = _countString;
@synthesize auctionComments = _auctionComments;
@synthesize getCommentType = _getCommentType;
@synthesize entryType = _entryType;
@synthesize sellPublishType = _sellPublishType;
@synthesize sellCommentType = _sellCommentType;
@synthesize commentButton = _commentButton;
@synthesize publishModel = _publishModel;
@synthesize comModel = _comModel;
@synthesize flag = _flag;

- (void)dealloc{
    _tableView.delegate = nil;
    _tableView.dataSource = nil;
    
    
    [_request cancelDelegate:self];

    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _goodsPrviewsList = [[NSMutableArray alloc] init];
        _auctionDetailModel = [[AuctionDetailModel alloc] init];
        _lastCommentId = @"0";
        _auctionComments = [[NSMutableArray alloc] init];
        _getCommentType = GET_PAST_COMMENT;
        self.entryType = CMEntryPresent;
        self.sellCommentType = IsNotSellMyComment;
        self.sellPublishType = IsNotSellMyPublish;
        _flag = FALSE;
        _countString = 0;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
    [MobClick beginLogPageView:@"SellingDetailPage"];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
    [MobClick endLogPageView:@"SellingDetailPage"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.navigationController setNavigationBarHidden:NO];
    self.view.backgroundColor = [UIColor whiteColor];
    
    //自适应iOS的导航栏、状态栏
    [self adjustiOS7NaviagtionBar];
    [self setNavigationTitle:@"随手拍了卖"];
    //自定义返回按钮
    UIButton *backButton = [self setBackBarButton];
    [backButton addTarget:self action:@selector(leftBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self setBackBarButtonItem:backButton];
    
    //    右边按钮 add by devin
    if (self.entryType == CMEntryPush&&self.sellPublishType == IsSellMyPublish) {
        rightImage = [UIImage imageNamed:@"icon_notice_delete.png"];
        rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [rightBtn setImage:rightImage forState:UIControlStateNormal];
        [rightBtn addTarget:self action:@selector(MySellConrrollerPushRightBtn) forControlEvents:UIControlEventTouchUpInside];
        rightBtn.frame = CGRectMake(275,0,44,44);
        [self setRightBarButtonItem:rightBtn];
    
    }else{
        rightImage = [UIImage imageNamed:@"icon_collection.png"];
        rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [rightBtn setImage:rightImage forState:UIControlStateNormal];
        [rightBtn addTarget:self action:@selector(rightBtnAction) forControlEvents:UIControlEventTouchUpInside];
        rightBtn.frame = CGRectMake(275,0,44,44);
        [self setRightBarButtonItem:rightBtn];
    
    }
    //列表视图
    //CGRectMake(0, 0, ScreenWidth, MainHeight-CommunitySendBackHeight)

    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth,MainHeight-CommunitySendBackHeight) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableHeaderView = [self goodsHeadView];
    _tableView.backgroundView = nil;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.tableFooterView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.view addSubview:_tableView];
    [_tableView release];
    
    //    发送面板
    sendTextView = [[CommunitySendTextAndImageView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height-CommunitySendBackHeight, ScreenHeight, CommunitySendBackHeight) superView:self.view];
    sendTextView.delegate = self;
    [self.view addSubview:sendTextView];
    [sendTextView release];
    
     [self requestAuctionDetail];
    //上拉加载更多
    [self addFooter];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setBaseId:(NSString *)baseId{
    [super setBaseId:baseId];
    if (_auctionId != baseId) {
        [_auctionId release];
         _auctionId = [baseId retain];
        
    }
}

- (void)addCommentViewController{
    
}

- (void)addFooter
{
    __unsafe_unretained SellingDetailViewController *vc = self;
    MJRefreshFooterView *footer = [MJRefreshFooterView footer];
    footer.scrollView = self.tableView;
    footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        NSLog(@"%@",vc);
        if (_flag == TRUE) {
            [self requestAuctionComments:GET_PAST_COMMENT searchType:@"3"];
        }else{
             [self requestAuctionComments:GET_PAST_COMMENT searchType:@"2"];//全部评论
        }
    };
    footer.endStateChangeBlock = ^(MJRefreshBaseView *refreshView){
        
    };
    _footer = footer;
}

- (void)doneWithView//:(MJRefreshBaseView *)refreshView
{
    [self.tableView reloadData];
    //[self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
    // 刷新表格
    [_footer endRefreshing];
}



#pragma mark ---draw
- (UIView *)goodsHeadView{
    UIView *view = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 240)] autorelease];
    view.backgroundColor = [UIColor clearColor];
    _goodsPrviewScrollView = [[UIScrollView alloc] initWithFrame:view.bounds];
    _goodsPrviewScrollView.bounces = NO;
    _goodsPrviewScrollView.pagingEnabled = YES;
    _goodsPrviewScrollView.contentSize = CGSizeMake(view.bounds.size.width*2, view.bounds.size.height);
    [view addSubview:_goodsPrviewScrollView];
    [_goodsPrviewScrollView release];
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(view.bounds)-44, view.frame.size.width, 44)];
    titleView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
    [view addSubview:titleView];
    [titleView release];
    
    _goodsTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, titleView.frame.size.width, 44)];
    _goodsTitle.backgroundColor = [UIColor clearColor];
    _goodsTitle.textAlignment = NSTextAlignmentLeft;
    _goodsTitle.textColor = [UIColor whiteColor];
    [titleView addSubview:_goodsTitle];
    [_goodsTitle release];
    
    [self refreshHeadView];
    
    return view;
}

- (void)refreshHeadView{
    NSArray *array = [_auctionDetailModel.images componentsSeparatedByString:@";"];
    [_goodsPrviewsList removeAllObjects];
    [_goodsPrviewsList addObjectsFromArray:array];
    
    for (int i = 0; i < [_goodsPrviewsList count]; i++) {
        CGRect rect = CGRectMake(CGRectGetWidth(_goodsPrviewScrollView.bounds)*i,0, CGRectGetWidth(_goodsPrviewScrollView.bounds), CGRectGetHeight(_goodsPrviewScrollView.bounds));
        NSURL *url = [NSURL URLWithString:[_goodsPrviewsList objectAtIndex:i]];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:rect];
        [imageView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"bg_sample_2.png"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        imageView.userInteractionEnabled = YES;
        imageView.tag = i;
        [_goodsPrviewScrollView addSubview:imageView];
        [imageView release];
        
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgTap:)];
        [imageView addGestureRecognizer:gesture];
        [gesture release];
    }
    _goodsPrviewScrollView.contentSize = CGSizeMake(CGRectGetWidth(_goodsPrviewScrollView.bounds)*[_goodsPrviewsList count], CGRectGetHeight(_goodsPrviewScrollView.bounds));
    
    _goodsTitle.text = _auctionDetailModel.title;
}

// 导航左右按钮
-(void)leftBtnAction{
    if (self.entryType == CMEntryPush) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self dismissViewControllerAnimated:YES completion:^{
        
        }];
    }
}

-(void)MySellConrrollerPushRightBtn{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"是否删除" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    [alert show];
    [alert release];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        //加载网络数据
        [self hideHudView];
        hudView = [Global showMBProgressHud:self SuperView:self.view Msg:@"请稍候..."];//  请求验证验证码是否正确
        
        //加载网络数据
        if (_request == nil) {
            _request = [CommunityHttpRequest shareInstance];
        }
        NSString *parameters = nil;
        UserModel *userModel = [UserModel shareUser];
        if ([_auctionDetailModel.residentId isEqualToString:userModel.userId]&& _sellCommentType == IsNotSellMyComment){
        parameters = [NSString stringWithFormat:@"?%@=%@&%@=%@&%@=%@&id=%@&moduleTypeId=%d&moduleId=%@",USER_ID,userModel.userId ,COMMUNITY_ID,userModel.communityId,PROPERTY_ID,userModel.propertyId,_auctionDetailModel.residentId,5,_auctionDetailModel.auctionId];//参数
        }else{
         parameters = [NSString stringWithFormat:@"?%@=%@&%@=%@&%@=%@&id=%@&moduleTypeId=%@&moduleId=%@",USER_ID,userModel.userId ,COMMUNITY_ID,userModel.communityId,PROPERTY_ID,userModel.propertyId,_publishModel.mypublishId,_publishModel.mypublishModuleTypeId,_publishModel.mypublishModuleId];//参数
        }
        [_request requestDelegateMyPublish:self parameters:parameters];
        NSLog(@"删除我的发布");
    }else{
        NSLog(@"取消发布");
    }
}
//收藏  add by devin
-(void)rightBtnAction{
    if (isCollected == 0) {
        NSLog(@"加入收藏");
        if (_request == nil) {
            _request = [CommunityHttpRequest shareInstance];
        }
        UserModel *userModel = [UserModel shareUser];
        /*publisherId = 0 ,代表生活百科发布人（其实是没有发布人）
         */
        NSString *parameters = [NSString stringWithFormat:@"?%@=%@&%@=%@&%@=%@&moduleTypeId=%d&detailsId=%@&publisherId=%@",USER_ID,userModel.userId ,COMMUNITY_ID,userModel.communityId,PROPERTY_ID,userModel.propertyId,5,_auctionDetailModel.auctionId,_auctionDetailModel.residentId];//参数
        [_request requestAddCollect:self parameters:parameters];
        
    }else{
        NSLog(@"取消收藏");
        if (_request == nil) {
            _request = [CommunityHttpRequest shareInstance];
        }
        UserModel *userModel = [UserModel shareUser];
        /*publisherId = 0 ,代表生活百科发布人（其实是没有发布人）
         */
        NSString *parameters = [NSString stringWithFormat:@"?collectId=%d&%@=%@&%@=%@&%@=%@",isCollected,USER_ID,userModel.userId ,COMMUNITY_ID,userModel.communityId,PROPERTY_ID,userModel.propertyId];//参数
        [_request requestCancelCollect:self parameters:parameters];
        
    }
}
#pragma mark ---network
//请求拍卖品详情
- (void)requestAuctionDetail{
    UserModel *userModel = [UserModel shareUser];
    // 网络请求
    if (_request == nil) {
        _request = [CommunityHttpRequest shareInstance];
    }
    NSString *string = [NSString stringWithFormat:@"?userId=%@&communityId=%@&propertyId=%@&auctionId=%@",userModel.userId,userModel.communityId,userModel.propertyId,_auctionId];//参数
    [_request requestAuctionInfo:self parameters:string];
    
}

- (void)requestAuctionComments:(GetCemmetnType)type searchType:(NSString *)searchType {
    UserModel *userModel = [UserModel shareUser];
    // 网络请求
    if (_request == nil) {
        _request = [CommunityHttpRequest shareInstance];
    }
    AuctionCommentModel *model = [self.auctionComments lastObject];
    if (model == nil) {
        _lastCommentId = @"0";
    }else{
        self.lastCommentId = model.commentId;
    }
    self.getCommentType = type;
    if (type == GET_PAST_COMMENT) {
        //不做处理
    }else{
        self.lastCommentId = @"0";
    }
    NSString *string = nil;
    if (self.sellCommentType == IsHisSellMyComment&&self.entryType == CMEntryPush) {
    string = [NSString stringWithFormat:@"?userId=%@&communityId=%@&propertyId=%@&moduleTypeId=%@&commentId=%@&lastId=%@&searchType=%@",_comModel.mycommentResidentId,userModel.communityId,userModel.propertyId,@"5",_auctionId,_lastCommentId,searchType];//参数
    }else{
    string = [NSString stringWithFormat:@"?userId=%@&communityId=%@&propertyId=%@&moduleTypeId=%@&commentId=%@&lastId=%@&searchType=%@",userModel.userId,userModel.communityId,userModel.propertyId,@"5",_auctionId,_lastCommentId,searchType];//参数
    }
    [_request requestComments:self parameters:string];

}

-(void) callBackWith: (WInterface) interface status: (NSString*) status data:(id) data{
    if (interface == COMMUNITY_AUCTION_INFO) {
        if ([status isEqualToString:NETWORK_RETURN_CODE_S_OK]) {
            NSDictionary *dic = [data objectForKey:@"auction"];
            _auctionDetailModel.auctionId = [dic objectForKey:@"auctionId"];
            _auctionDetailModel.auctionUpdateTime = [dic objectForKey:@"auctionUpdateTime"];
            _auctionDetailModel.commentNumber = [dic objectForKey:@"commentNumber"];
            _auctionDetailModel.cost = [dic objectForKey:@"cost"];
            _auctionDetailModel.images = [dic objectForKey:@"images"];
            _auctionDetailModel.residentIcon = [dic objectForKey:@"residentIcon"];
            _auctionDetailModel.residentId = [dic objectForKey:@"residentId"];
            _auctionDetailModel.residentName = [dic objectForKey:@"residentName"];
            _auctionDetailModel.residentSex = [dic objectForKey:@"residentSex"];
            _auctionDetailModel.title = [dic objectForKey:@"title"];
            _auctionDetailModel.remark = [dic objectForKey:@"remark"];
            //add by devin
            isCollected = [[dic objectForKey:@"collectId"] integerValue];
            //判断该贴已删除
            if ([data objectForKey:@"auction"] == nil) {
                NSLog(@"该贴已删除");
                UIImage *image = [UIImage imageNamed:@"bg_sample_2.png"];
                UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
                [_goodsPrviewScrollView addSubview:imageView];
                [imageView release];
            }else{
               [self refreshHeadView];
            }
            
            
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
            if (_flag == TRUE) {
                [self requestAuctionComments:GET_LATEST_COMMENT searchType:@"3"];
            }else{
                [self requestAuctionComments:GET_LATEST_COMMENT searchType:@"2"];
            }
            
            /*导航栏右按钮 从随手拍了卖里present过来判断石否收藏标识  如果是从我的评论里push过来，则显示删除按钮  add by devin
             */
            if (self.entryType == CMEntryPush&&self.sellPublishType == IsSellMyPublish){
                    rightImage = [UIImage imageNamed:@"icon_notice_delete.png"];
                    [rightBtn setImage:rightImage forState:UIControlStateNormal];
                    
                }else{
                    //自己的帖子则显示垃圾桶按钮，其他人的就显示收藏按钮
                    UserModel *userModel = [UserModel shareUser];
                    if ([_auctionDetailModel.residentId isEqualToString:userModel.userId]) {
                        rightImage = [UIImage imageNamed:@"icon_notice_delete.png"];
                        rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                        [rightBtn setImage:rightImage forState:UIControlStateNormal];
                        [rightBtn addTarget:self action:@selector(MySellConrrollerPushRightBtn) forControlEvents:UIControlEventTouchUpInside];
                        rightBtn.frame = CGRectMake(275,0,44,44);
                        [self setRightBarButtonItem:rightBtn];
                    }else{

            if (isCollected == 0) {
                    rightImage = [UIImage imageNamed:@"icon_collection.png"];
                    [rightBtn setImage:rightImage forState:UIControlStateNormal];
                }else{
                    rightImage = [UIImage imageNamed:@"icon_already_collection.png"];
                    [rightBtn setImage:rightImage forState:UIControlStateNormal];
                }
               }
              }

              }else{
            NSLog(@"COMMUNITY_AUCTION_INFO failed");
             }
             }else if (interface == COMMUNITY_COMMENT_LIST){
           if ([status isEqualToString:NETWORK_RETURN_CODE_S_OK]){
            
            if (self.getCommentType == GET_LATEST_COMMENT) {
                [self.auctionComments  removeAllObjects];
            }
            NSArray *array = [data objectForKey:@"commentvo"];
            _countString = [[data objectForKey:@"commentSum"] integerValue];
            for (NSDictionary *dic in array) {
                AuctionCommentModel *model = [[AuctionCommentModel alloc] init];
                model.createTime = [dic objectForKey:@"createTime"];
                model.residentId = [dic objectForKey:@"residentId"];
                model.commentId = [dic objectForKey:@"id"];
                model.remark = [dic objectForKey:@"remark"];
                model.residentIcon = [dic objectForKey:@"residentIcon"];
                model.residentName = [dic objectForKey:@"residentName"];
                model.residentSex = [dic objectForKey:@"residentSex"];
                model.replyId = [dic objectForKey:@"replyId"];
                model.replyNickName = [dic objectForKey:@"replyNickName"];
                model.residentIcon = [dic objectForKey:@"residentIcon"];
                [self.auctionComments addObject:model];
                [model release];
            }
            
                [self doneWithView];
            }else{
                [self doneWithView];
        }
    }
    //添加评论 add by devin
    if (interface == COMMUNITY_ADD_COMMENT) {
        NSString *code = [data objectForKey:ERROR_CODE];
        if ([code isEqualToString:NETWORK_RETURN_CODE_S_OK]) {
            NSLog(@"回复评论成功");
            
            [sendTextView hiddenKeyboard];
            if (_flag == TRUE) {
                 [self requestAuctionComments:GET_LATEST_COMMENT searchType:@"3"];
            }else{
                [self requestAuctionComments:GET_LATEST_COMMENT searchType:@"2"];
            }
        }else{
            NSLog(@"网络数据获取失败");
        }
    }
    //删除评论 add by devin
    if (interface == COMMUNITY_DELEGATE_COMMENT) {
        NSString *code = [data objectForKey:ERROR_CODE];
        if ([code isEqualToString:NETWORK_RETURN_CODE_S_OK]) {
            selectedId = 0;
            NSLog(@"删除评论成功");
            _countString--;
            [self hideHudView];

            AuctionCommentModel *model = [self.auctionComments objectAtIndex:clickIndexPathRow];
                    [self.auctionComments removeObject:model];
                    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
            
         }else{
            NSLog(@"网络数据获取失败");
        }
      }
        //添加收藏 add by devin
          if (interface == COMMUNITY_ADD_COLLECTION){
              NSString *code = [data objectForKey:ERROR_CODE];
            if ([code isEqualToString:NETWORK_RETURN_CODE_S_OK]) {
                rightImage = [UIImage imageNamed:@"icon_already_collection.png"];
                [rightBtn setImage:rightImage forState:UIControlStateNormal];
                NSDictionary *dic =[data objectForKey:@"collects"];
                isCollected = [[dic objectForKey:@"id"] integerValue];
                if ([[data objectForKey:@"errorCode"] isEqualToString:@"000"]) {
                    hudView = [Global showMBProgressHudHint:self SuperView:self.view Msg:@"收藏成功" ShowTime:1.0];
                }else{
                    hudView = [Global showMBProgressHudHint:self SuperView:self.view Msg:@"收藏失败" ShowTime:1.0];
                }
            }
        }
        //取消收藏 add by devin
        if (interface == COMMUNITY_CANCEL_COLLECTION){
             NSString *code = [data objectForKey:ERROR_CODE];
            if ([code isEqualToString:NETWORK_RETURN_CODE_S_OK]) {
                rightImage = [UIImage imageNamed:@"icon_collection.png"];
                [rightBtn setImage:rightImage forState:UIControlStateNormal];
                NSDictionary *dic =[data objectForKey:@"collects"];
                isCollected = [[dic objectForKey:@"id"] integerValue];
                if ([[data objectForKey:@"errorCode"] isEqualToString:@"000"]) {
                    hudView = [Global showMBProgressHudHint:self SuperView:self.view Msg:@"取消收藏成功" ShowTime:1.0];
                }else{
                    hudView = [Global showMBProgressHudHint:self SuperView:self.view Msg:@"取消收藏失败" ShowTime:1.0];
                }
            }
        }
         //删除我的发布
        if(interface == COMMUNITY_DELEGATE_MYPUBLISH){
              NSString *code = [[data objectForKey:ERROR_CODE] retain];
            if ([code isEqualToString:NETWORK_RETURN_CODE_S_OK]){
                [self hideHudView];
                 [self.navigationController popViewControllerAnimated:YES];
            }else{
                NSLog(@"网络获取数据失败");
            }
            
        }
}

#pragma mark ---UITableView dataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *section1 = @"section1";
    static NSString *section2 = @"section2";

    if (indexPath.section == 0) {
        UITableViewCell  *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:section1] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.row == 0) {
            NSURL *url = [NSURL URLWithString:_auctionDetailModel.residentIcon];
            UIImage *iconImage = [UIImage imageNamed:@"default_head.png"];
            UIButton *iconImageBtn= [self newButtonWithImage:iconImage highlightedImage:nil frame:CGRectMake(10, 5, 45, 45) title:nil titleColor:nil titleShadowColor:nil font:nil target:self action:@selector(iconImageBtn)];
            iconImageBtn.layer.cornerRadius = 22.0f;
            iconImageBtn.layer.masksToBounds = YES;
            [iconImageBtn setImageWithURL:url forState:UIControlStateNormal placeholderImage:iconImage];
            [cell.contentView addSubview:iconImageBtn];
            [iconImageBtn release];
            
            UIImageView *sex = [[UIImageView alloc] initWithFrame:CGRectMake(70, 13, 12, 12)];
            if ([_auctionDetailModel.residentSex isEqualToString:@"男"]) {
                sex.image = [UIImage imageNamed:@"icon_male1.png"];
            }else if([_auctionDetailModel.residentSex isEqualToString:@"女"]){
                sex.image = [UIImage imageNamed:@"icon_female1.png"];
            }
            [cell.contentView addSubview:sex];
            [sex release];
            
            UILabel *username = [[UILabel alloc] initWithFrame:CGRectMake(70+15, 7, 150, 20)];
            username.backgroundColor = [UIColor clearColor];
            username.textColor = [UIColor blackColor];
            username.font = [UIFont systemFontOfSize:14];
            username.text = _auctionDetailModel.residentName;
            [cell.contentView addSubview:username];
            [username release];
            
            UIImageView *clockImg = [[UIImageView alloc] initWithFrame:CGRectMake(250, 14, 10, 10)];
            clockImg.image = [UIImage imageNamed:@"icon_time.png"];
            [cell.contentView addSubview:clockImg];
            [clockImg release];
            
            NSDate *formateDate = [NSObject fromatterDateFromStr:_auctionDetailModel.auctionUpdateTime];
            NSString *time = [NSObject compareCurrentTime:formateDate];
            UILabel *lbTime = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(clockImg.frame)+2, 10, 50, 16)];
            lbTime.text = time;
            lbTime.font = [UIFont systemFontOfSize:12];
            lbTime.textColor = [UIColor lightGrayColor];
            lbTime.backgroundColor = [UIColor clearColor];
            [cell.contentView addSubview:lbTime];
            [lbTime release];
        }else if (indexPath.row == 1){
            
            cell.textLabel.text = @"价格";
            cell.textLabel.textColor = [UIColor grayColor];
            
            UILabel *lbPrice = [[UILabel alloc] initWithFrame:CGRectMake(52, 0, 100, 40)];
            lbPrice.backgroundColor = [UIColor clearColor];
            lbPrice.font = [UIFont systemFontOfSize:20];
            lbPrice.text = _auctionDetailModel.cost;
            lbPrice.textColor = [UIColor orangeColor];
            [cell.contentView addSubview:lbPrice];
            [lbPrice release];
            
            
        }else if (indexPath.row == 2){
            cell.textLabel.numberOfLines = 0;
            cell.textLabel.text = _auctionDetailModel.remark;
            cell.textLabel.backgroundColor = [UIColor redColor];
            cell.textLabel.font = [UIFont systemFontOfSize:15];
        }
        
        return cell;

    }else if (indexPath.section == 1){
        SellingCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:section2];
        if (cell == nil) {
            cell = [[[SellingCommentCell alloc] initWithStyle:
                     UITableViewCellStyleDefault reuseIdentifier:section2] autorelease];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        AuctionCommentModel *model = ([self.auctionComments count]>indexPath.row)?[self.auctionComments objectAtIndex:indexPath.row]:nil;
        //名字
        cell.titleLabel.text = model.residentName;
        
        //头像
        [cell.iconImageBtn setImageWithURL:[NSURL URLWithString:model.residentIcon] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"notice_icon.png"]];
        cell.iconImageBtn.tag = indexPath.row;
        [cell.iconImageBtn addTarget:self action:@selector(iconViewBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
        //时间
        NSDate *formateDate = [NSObject fromatterDateFromStr:model.createTime];
        NSString *time = [NSObject compareCurrentTime:formateDate];
        cell.timeLabel.text = time;
        
        //自适应
        CGFloat textHeight = [TQRichTextView getRechTextViewHeightWithText:model.remark viewWidth:250 font:[UIFont systemFontOfSize:14.0] lineSpacing:1.8];
        CGRect rect = cell.contentLabel.frame;
        cell.contentLabel.frame = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, textHeight);
        //内容
         if ([model.replyId integerValue] != 0) {
         cell.contentLabel.text = [NSString stringWithFormat:@"回复 %@:%@",model.replyNickName,model.remark];
          }else{
          cell.contentLabel.text = [NSString stringWithFormat:@"%@",model.remark];
          }
        UITapGestureRecognizer *labTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(lableTap:)];
        cell.contentLabel.tag = indexPath.row;
        [cell.contentLabel addGestureRecognizer:labTap];
        [labTap release];
        //性别
        if ([model.residentSex isEqualToString:@"男"]) {
            cell.maleImageView.image = [UIImage imageNamed:@"icon_male1.png"];
            }else{
            cell.maleImageView.image = [UIImage imageNamed:@"icon_female1.png"];
        }

        return cell;
    }
    
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            if (_auctionDetailModel.remark.length == 0) {
                return 2;
            }
            return 3;
            break;
            case 1:
            return [self.auctionComments count];
            break;
        default:
            break;
    }
    
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

#pragma mark ---UITableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
            {
                return 56.0f;
            }
                break;
            case 1:
            {
                return 40.0f;
            }
                break;
            case 2:
            {
                //自适应高度
                CGSize titleSize = [_auctionDetailModel.remark sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(ScreenWidth, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
                return MAX(40.0f, titleSize.height+20);
            }
                break;
            default:
                return 0;
                break;
        }

    }else if (indexPath.section == 1){
        AuctionCommentModel *model = ([self.auctionComments  count]>indexPath.row)?[self.auctionComments objectAtIndex:indexPath.row]:nil;
        
        NSString *strRemark = model.remark;
        
        //逻辑判断高度
        CGFloat textHeight = [TQRichTextView getRechTextViewHeightWithText:strRemark viewWidth:250 font:[UIFont systemFontOfSize:14.0] lineSpacing:1.8];
        
        CGFloat height = MAX(textHeight+45.0f, 65.0f);
        
        return height;
    }
    
    return 0;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{

}
// add by devin
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        clickIndexPathRow = indexPath.row;
        AuctionCommentModel *model = [self.auctionComments objectAtIndex:indexPath.row];
        UserModel *userModel = [UserModel shareUser];
        selectedId = [model.residentId integerValue];
        delegateId = [model.commentId integerValue];
        
        if ([userModel.userId isEqualToString:[NSString stringWithFormat:@"%d",selectedId]]) {
            UIActionSheet *deleSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除" otherButtonTitles:nil, nil];
            [deleSheet showInView:[UIApplication sharedApplication].keyWindow];
            [deleSheet release];
        }else {
            sendTextView.textViewInput.placeholder = [NSString stringWithFormat:@"回复%@",model.residentName];
            [sendTextView.textViewInput becomeFirstResponder];
        }
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 30.0f;
    }
    return 0.0f;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        CarPoolDetailSectionHeaderView *headerView =  [[CarPoolDetailSectionHeaderView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(tableView.bounds), 30) section:section sectionTitle:[tableView.dataSource tableView:tableView titleForHeaderInSection:section]];
        [headerView setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
        
        //查看评论按钮，从我的评论push过来  add by devin
        if (self.entryType == CMEntryPush&&(self.sellCommentType == IsSellMyComment||self.sellCommentType == IsHisSellMyComment)) {
            _commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
            _commentButton.frame = CGRectMake(250, 1, 60, 30);
            _commentButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
            [_commentButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [_commentButton addTarget:self action:@selector(comment) forControlEvents:UIControlEventTouchUpInside];
            if (_flag == TRUE) {
                if (self.sellCommentType == IsSellMyComment) {
                    [_commentButton setTitle:@"我的评论" forState:UIControlStateNormal];
                }else{
                    [_commentButton setTitle:@"他的评论" forState:UIControlStateNormal];
                }
            }else{
                [_commentButton setTitle:@"全部评论" forState:UIControlStateNormal];
            }
            [headerView addSubview:_commentButton];
            
        }
        headerView.tag = section;
        return headerView;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 10.0f;
    }
    return 0.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 0) {
        UIView *__view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 10.0f)];
        [__view setBackgroundColor:RGB(236, 236, 236)];
        return __view;
    }
    return nil;
}

//全部评论和个人评论 add by devin
-(void)comment
{
    if (_flag == TRUE) {
        
        [_commentButton setTitle:@"全部评论" forState:UIControlStateNormal];
        [self requestAuctionComments:GET_LATEST_COMMENT searchType:@"2"];
        _flag =  FALSE;
    }else if(_flag == FALSE){
        if (self.sellCommentType == IsSellMyComment) {
            [_commentButton setTitle:@"我的评论" forState:UIControlStateNormal];
        }else{
            [_commentButton setTitle:@"他的评论" forState:UIControlStateNormal];
        }
        [self requestAuctionComments:GET_LATEST_COMMENT searchType:@"3"];
        _flag = TRUE;
        
    }
}

//#pragma mark UITableViewDelegate implementation
-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return @"";
        case 1:
            return [NSString stringWithFormat:@"%d",_countString];
        default:
            return nil;
    }
}
// add by devin
#pragma mark -- uiactionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        NSLog(@"删除");
        //网络请求
        [self hideHudView];
        hudView = [Global showMBProgressHud:self SuperView:self.view Msg:@"请稍候..."];//  请求验证验证码是否正确
        [self requestDelete];
    }
}

-(void)requestDelete{
    //加载网络数据  删除自己的评论
    if (_request == nil) {
        _request = [CommunityHttpRequest shareInstance];
    }
    UserModel *userModel = [UserModel shareUser];
    NSString *parameters = [NSString stringWithFormat:@"?%@=%@&%@=%@&%@=%@&id=%d",USER_ID,userModel.userId ,COMMUNITY_ID,userModel.communityId,PROPERTY_ID,userModel.propertyId,delegateId];//参数
    [_request requestDelegateComment:self parameters:parameters];
}

//进入详情的个人资料 add by Devin
-(void)iconImageBtn{
    NeighborhoodIntroduceViewController *introduceVc = [[NeighborhoodIntroduceViewController alloc] initWithUserId:_auctionDetailModel.residentId communityId:nil propertyId:nil name:_auctionDetailModel.residentName];
    [self.navigationController pushViewController:introduceVc animated:YES];
    [introduceVc release];
}

-(void)iconViewBtnAction:(id)sender{
    UIButton *headbtn = (UIButton *)sender;
    AuctionCommentModel *model = [self.auctionComments objectAtIndex:headbtn.tag];
    UserModel *userModel = [UserModel shareUser];
    if ([userModel.userId isEqualToString:model.residentId]) {
        NSLog(@"如果是自己的话，不需要进入详情资料");
    }else {
        NeighborhoodIntroduceViewController *introduceVc = [[NeighborhoodIntroduceViewController alloc] initWithUserId:model.residentId communityId:nil propertyId:nil name:model.residentName];
        [self.navigationController pushViewController:introduceVc animated:YES];
        [introduceVc release];
    }
    
}

//add by Devin
#pragma CommunitySendTextAndImageViewDelegate
-(void)sendTextAction:(NSString *)inputText{

    //加载网络数据  添加评论
    if (_request == nil) {
        _request = [CommunityHttpRequest shareInstance];
    }
    UserModel *userModel = [UserModel shareUser];
    NSString *parameter2 = [NSString stringWithFormat:@"?userId=%@&communityId=%@&propertyId=%@&replyId=%d&moduleTypeId=%d&commentId=%@&remark=%@&receiveId=%@",userModel.userId,userModel.communityId,userModel.propertyId,selectedId,5,_auctionDetailModel.auctionId,inputText,_auctionDetailModel.residentId];
    [_request requestAddComment:self parameters:parameter2];
    //[_tableView reloadData];
    selectedId = 0;
}


-(void)imgTap:(UITapGestureRecognizer *)tap
{
    //NSArray *imgArr = [_auctionDetailModel.images componentsSeparatedByString:@";"];
    //小区图片
    NSArray *imgArr = [_auctionDetailModel.images componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@";"]];
    // 1.封装图片数据
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:imgArr.count];
    for (int i = 0; i<imgArr.count; i++) {
        NSURL *url = [NSURL URLWithString:[_goodsPrviewsList objectAtIndex:i]];
        MJPhoto *photo = [[MJPhoto alloc] init];
        photo.url = url; // 图片路径
        photo.srcImageView = _goodsPrviewScrollView.subviews[i]; // 来源于哪个UIImageView
        [photos addObject:photo];
        [photo release];
    }
    
    // 2.显示相册
    MJPhotoBrowser *browser = [[[MJPhotoBrowser alloc] init] autorelease];
    browser.currentPhotoIndex = tap.view.tag; // 弹出相册时显示的第一张图片是？
    browser.photos = photos; // 设置所有的图片
    [browser show];
}

-(void)lableTap:(UITapGestureRecognizer *)sender{
    NSLog(@"sender = %d",sender.view.tag);
    AuctionCommentModel *model = [self.auctionComments objectAtIndex:sender.view.tag];
    UserModel *userModel = [UserModel shareUser];
    selectedId = [model.residentId integerValue];
    delegateId = [model.commentId integerValue];
    if ([userModel.userId isEqualToString:[NSString stringWithFormat:@"%d",selectedId]]) {
        clickIndexPathRow = sender.view.tag;
        UIActionSheet *deleSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除" otherButtonTitles:nil, nil];
        [deleSheet showInView:[UIApplication sharedApplication].keyWindow];
        [deleSheet release];
    }else {
        sendTextView.textViewInput.placeholder = [NSString stringWithFormat:@"回复%@",model.residentName];
        [sendTextView.textViewInput becomeFirstResponder];
    }

}

- (void) hideHudView
{
    if (hudView) {
        [hudView hide:YES];
    }
}


@end
