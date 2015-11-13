//
//  CarPoolingDetailViewController.m
//  CommunityAPP
//
//  Created by yunlai on 14-3-17.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import "CarPoolingDetailViewController.h"
#import "NSObject_extra.h"
#import "Global.h"
#import "CarPoolingDetailCell.h"
#import "CarPoolingDetailTableHeaderView.h"
#import "CarPoolDetailSectionHeaderView.h"
#import "UserModel.h"
#import "UIButton+WebCache.h"
#import "AppConfig.h"
#import "AuctionModel.h"
#import "CarPoolingCommentModel.h"
#import "UIButton+WebCache.h"
#import "NSObject+Time.h"
#import "CommonDefine.h"
#import "MJRefresh.h"
#import "NeighborhoodIntroduceViewController.h"
#import "MySelfViewController.h"
#import "UIViewController+NavigationBar.h"
#import "UserModel.h"
#import "MobClick.h"

@interface CarPoolingDetailViewController (){
    MJRefreshFooterView *_footer;
    NSInteger isCollected; // 判断是否收藏 0没收藏 非0收藏 add by devin
    NSInteger selectedId; //选中某人的评论 add by devin
    NSInteger delegateId; //删除评论 add by devin
    NSInteger lastCommentId; //lastId
    NSInteger clickIndexPathRow; //判断点了哪一个cell
    
     CarPoolingDetailTableHeaderView *detaileTableView;
}
@property (nonatomic,assign) GetCemmetnType getCommentType;
@property (nonatomic,retain) UIButton *commentButton;
@property (nonatomic,assign) NSInteger countString;
@end

@implementation CarPoolingDetailViewController
@synthesize poolModelStr = _poolModelStr;
@synthesize poolingDetailDictionary;
@synthesize conmmentListDictionary;
@synthesize commentListArray;
@synthesize carVcType = _carVcType;
@synthesize carPublishType = _carPublishType;
@synthesize carCommentType = _carCommentType;
@synthesize commentButton = _commentButton;
@synthesize publishModel = _publishModel;
@synthesize comModel = _comModel;
@synthesize numberAndAdress = _numberAndAdress;
@synthesize flag = _flag;
@synthesize countString = _countString;

-(void)dealloc{
     [request cancelDelegate:self];

    [carPoolTableView release]; carPoolTableView = nil;
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.commentListArray = [[NSMutableArray alloc] init];
        lastCommentId = 0;
        _getCommentType = GET_PAST_COMMENT;
        _carVcType = CarControllerPush; // 默认从拼车上下班push过来
        self.carCommentType = IsCarMyComment;
        _carPublishType = IsNotCarMyPublish;
        _carCommentType = IsNotCarMyComment;
        _flag = FALSE;
        _countString = 0;
        detaileTableView = [[CarPoolingDetailTableHeaderView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 398/2) imageString:@"bg_sample_2.png"];
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
    [MobClick beginLogPageView:@"CarPoolingDetailPage"];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
    [MobClick endLogPageView:@"CarPoolingDetailPage"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.view setBackgroundColor:RGB(244, 244, 244)];
    
    //自适应iOS的导航栏、状态栏
    [self adjustiOS7NaviagtionBar];
    [self setNavigationTitle:@"拼车详情"];
    //自定义返回按钮
    UIButton *backButton = [self setBackBarButton];
    [backButton addTarget:self action:@selector(backBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self setBackBarButtonItem:backButton];
    
    //  请求当前的详情数据
    [self hideHudView];
    hudView = [Global showMBProgressHud:self SuperView:self.view Msg:@"请稍候..."];//  请求验证验证码是否正确
    [self requestCarPoolDetail];
    
    //    右边按钮 add by devin
       if (self.carVcType == MyCarConrrollerPush&&self.carPublishType == IsCarMyPublish) {
        rightImage = [UIImage imageNamed:@"icon_notice_delete.png"];
        rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [rightBtn setImage:rightImage forState:UIControlStateNormal];
        [rightBtn addTarget:self action:@selector(MySellConrrollerPushRightBtn) forControlEvents:UIControlEventTouchUpInside];
        rightBtn.frame = CGRectMake(275,0,44,44);
        [self setRightBarButtonItem:rightBtn];
        
    }else{
//        UserModel *userModel = [UserModel shareUser];
//        if ([[self.poolingDetailDictionary objectForKey:@"publisherId"] isEqualToString:userModel.userId]) {
//            rightImage = [UIImage imageNamed:@"icon_notice_delete.png"];
//            rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//            [rightBtn setImage:rightImage forState:UIControlStateNormal];
//            [rightBtn addTarget:self action:@selector(MySellConrrollerPushRightBtn) forControlEvents:UIControlEventTouchUpInside];
//            rightBtn.frame = CGRectMake(275,0,44,44);
//            [self setRightBarButtonItem:rightBtn];
//        }else{
            //    右边按钮
            rightImage = [UIImage imageNamed:@"icon_collection.png"];
            rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [rightBtn setImage:rightImage forState:UIControlStateNormal];
            [rightBtn addTarget:self action:@selector(rightBtnAction) forControlEvents:UIControlEventTouchUpInside];
            rightBtn.frame = CGRectMake(275,0,44,44);
            [self setRightBarButtonItem:rightBtn];
       // }
    }
    //    列表
    carPoolTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth,MainHeight-CommunitySendBackHeight) style:UITableViewStylePlain];
    carPoolTableView.delegate = self;
    carPoolTableView.dataSource = self;
    carPoolTableView.sectionFooterHeight = 20;
    carPoolTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    carPoolTableView.backgroundView = nil;
    carPoolTableView.backgroundColor = [UIColor clearColor];
    carPoolTableView.backgroundView.backgroundColor = RGB(244, 244, 244);
    carPoolTableView.tableHeaderView = detaileTableView;
    carPoolTableView.tableFooterView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
    [self.view addSubview:carPoolTableView];
    
    [self addFooter]; // 上拉刷新
    
    //    发送面板
   sendTextView = [[CommunitySendTextAndImageView alloc] initWithFrame:CGRectMake(0,ScreenHeight-CommunitySendBackHeight, ScreenWidth, CommunitySendBackHeight) superView:self.view];
    sendTextView.delegate = self;
    [self.view addSubview:sendTextView];
    [sendTextView release];
}

- (void)setBaseId:(NSString *)baseId{
    [super setBaseId:baseId];
    if (_poolModelStr != baseId) {
        [_poolModelStr release];
        _poolModelStr = [baseId retain];
        
    }
}

//刷新标头的数据
-(void)refreshHeadView{
    detaileTableView = [[CarPoolingDetailTableHeaderView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 398/2) imageString:[self.poolingDetailDictionary objectForKey:@"imsg"]];
    carPoolTableView.tableHeaderView = detaileTableView;
    [detaileTableView release];
}

-(void)requestCarPoolDetail{
    // 网络请求
    if (request == nil) {
        request = [CommunityHttpRequest shareInstance];
    }
    UserModel *userModel = [UserModel shareUser];
    NSString *parameters = [NSString stringWithFormat:@"?%@=%@&%@=%@&%@=%@&%@=%@",USER_ID,userModel.userId,COMMUNITY_ID,userModel.communityId,PROPERTY_ID,userModel.propertyId,@"id",_poolModelStr];//参数
    NSLog(@"parameters %@",parameters);
    [request requestCarPoolDetailAdd:self parameters:parameters];
}

- (void)requestAuctionComments:(GetCemmetnType)type searchType:(NSString *)searchType{
    UserModel *userModel = [UserModel shareUser];
    // 网络请求
    if (request == nil) {
        request = [CommunityHttpRequest shareInstance];
    }
//    模块类型Id  2、生活百科，3、美食，4、拼车上下班
//    模块类型Id  2、生活百科，3、美食
//    [NSString stringWithFormat:@"%d",poolModel.idInteger]
    CarPoolingCommentModel *commentModel = [self.commentListArray lastObject];
    if (commentModel == nil) {
        lastCommentId = 0;
    }else{
        lastCommentId = [commentModel.idString integerValue];
    }
    self.getCommentType = type;
    if (type == GET_PAST_COMMENT) {
        //不做处理
    }else{
        lastCommentId = 0;
    }
    NSString *string = nil;
    if (self.carCommentType == IsHisCarMyComment) {
        string = [NSString stringWithFormat:@"?userId=%@&communityId=%@&propertyId=%@&moduleTypeId=%@&commentId=%@&lastId=%d&searchType=%@",_comModel.mycommentResidentId,userModel.communityId,userModel.propertyId,@"4",_poolModelStr,lastCommentId,searchType];//参数
    }else{
        string = [NSString stringWithFormat:@"?userId=%@&communityId=%@&propertyId=%@&moduleTypeId=%@&commentId=%@&lastId=%d&searchType=%@",userModel.userId,userModel.communityId,userModel.propertyId,@"4",_poolModelStr,lastCommentId,searchType];//参数
    }
    
    [request requestComments:self parameters:string];
    
}
#pragma mark ---refresh
- (void)addFooter
{  __unsafe_unretained CarPoolingDetailViewController *vc = self;
    MJRefreshFooterView *footer = [MJRefreshFooterView footer];
    footer.scrollView = carPoolTableView;
    footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        //下拉刷新再次请求评论数据
        NSLog(@"%@",vc);
        if (_flag == TRUE) {
             [self requestAuctionComments:GET_PAST_COMMENT searchType:@"3"];//我的
        }else{
            [self requestAuctionComments:GET_PAST_COMMENT searchType:@"2"];//全部
        }
       
    };
    _footer = footer;
    
}
- (void)doneWithView//:(MJRefreshBaseView *)refreshView
{
    // 刷新表格
    [carPoolTableView reloadData];
    // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
    [_footer endRefreshing];
}

//导航栏左边按钮
-(void)backBtnAction
{
    [self.navigationController popViewControllerAnimated:YES];
}
//右边删除按钮  add by devin
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
        if (request == nil) {
            request = [CommunityHttpRequest shareInstance];
        }
        NSString *parameters = nil;
        UserModel *userModel = [UserModel shareUser];
        if ([[self.poolingDetailDictionary objectForKey:@"publisherId"] isEqualToString:userModel.userId]&&self.carVcType == CarControllerPush) {
         parameters = [NSString stringWithFormat:@"?%@=%@&%@=%@&%@=%@&id=%@&moduleTypeId=%d&moduleId=%@",USER_ID,userModel.userId ,COMMUNITY_ID,userModel.communityId,PROPERTY_ID,userModel.propertyId,[self.poolingDetailDictionary objectForKey:@"publisherId"],4,[self.poolingDetailDictionary objectForKey:@"id"]];//参数
        }else{
         parameters = [NSString stringWithFormat:@"?%@=%@&%@=%@&%@=%@&id=%@&moduleTypeId=%@&moduleId=%@",USER_ID,userModel.userId ,COMMUNITY_ID,userModel.communityId,PROPERTY_ID,userModel.propertyId,_publishModel.mypublishId,_publishModel.mypublishModuleTypeId,_publishModel.mypublishModuleId];//参数
        }
        [request requestDelegateMyPublish:self parameters:parameters];
        NSLog(@"删除我的发布");
    }else{
        NSLog(@"取消发布");
    }
    
}
//右边收藏按钮  add by devin
-(void)rightBtnAction{
    if (isCollected == 0) {
        NSLog(@"加入收藏");
        if (request == nil) {
            request = [CommunityHttpRequest shareInstance];
        }
        UserModel *userModel = [UserModel shareUser];
        /*publisherId = 0 ,代表生活百科发布人（其实是没有发布人）
         */
        NSString *parameters = [NSString stringWithFormat:@"?%@=%@&%@=%@&%@=%@&moduleTypeId=%d&detailsId=%@&publisherId=%@",USER_ID,userModel.userId ,COMMUNITY_ID,userModel.communityId,PROPERTY_ID,userModel.propertyId,4,[self.poolingDetailDictionary objectForKey:@"id"],[self.poolingDetailDictionary objectForKey:@"publisherId"]];//参数
        [request requestAddCollect:self parameters:parameters];
        
    }else{
        NSLog(@"取消收藏");
        if (request == nil) {
            request = [CommunityHttpRequest shareInstance];
        }
        UserModel *userModel = [UserModel shareUser];
        /*publisherId = 0 ,代表生活百科发布人（其实是没有发布人）
         */
        NSString *parameters = [NSString stringWithFormat:@"?collectId=%d&%@=%@&%@=%@&%@=%@",isCollected,USER_ID,userModel.userId ,COMMUNITY_ID,userModel.communityId,PROPERTY_ID,userModel.propertyId];//参数
        [request requestCancelCollect:self parameters:parameters];
        
    }
}

//add vincent 点击头像进入
-(void)iconImageBtn{
        NeighborhoodIntroduceViewController *introduceVc = [[NeighborhoodIntroduceViewController alloc] initWithUserId:[self.poolingDetailDictionary objectForKey:@"publisherId"] communityId:nil propertyId:nil name:[self.poolingDetailDictionary objectForKey:@"publisherName"]];
        [self.navigationController pushViewController:introduceVc animated:YES];
        [introduceVc release];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma UITableViewDelegate
#pragma mark UITableViewDataSource implementation
#pragma mark Table View Data Source Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
//        int i = 2;
//        NSString *contactUs = [self.poolingDetailDictionary objectForKey:@"contactUs"];
//        if (contactUs.length > 0) {
//            ++i;
//        }
//        NSString *strRemark = [self.poolingDetailDictionary objectForKey:@"remark"];
//        if (strRemark.length > 0) {
//            ++i;
//        }
//        return i;
        if (_numberAndAdress == OnlyAdress || _numberAndAdress == OnlyNumber) {
            return 3;
        }
        if (_numberAndAdress == AllNumberAdress) {
            return 4;
        }
        if (_numberAndAdress == NoneNumberAdress) {
            return 2;
        }
        return section;
        
    }else{
        return [self.commentListArray  count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier1 = @"Cell1";
    static NSString *CellIdentifier2 = @"Cell2";
    
    NSInteger indexSection = [indexPath section];
    if (indexSection == 0) {
        UITableViewCell  *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier1] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundView = [[[UIView alloc]initWithFrame:cell.bounds]autorelease];
        cell.backgroundView.backgroundColor = [UIColor whiteColor];
        NSInteger row = [indexPath row];
        switch (row) {
            case 0:
            {
//                图片icon
                UIImage *iconImage = [UIImage imageNamed:@"notice_icon.png"];
                UIButton *iconImageBtn= [self newButtonWithImage:iconImage highlightedImage:nil frame:CGRectMake(12, 6, iconImage.size.width, iconImage.size.height) title:nil titleColor:nil titleShadowColor:nil font:nil target:self action:@selector(iconImageBtn)];
                iconImageBtn.layer.cornerRadius = 22.5f;
                iconImageBtn.layer.masksToBounds = YES;
                [iconImageBtn setImageWithURL:[NSURL URLWithString:[self.poolingDetailDictionary objectForKey:@"icon"]] forState:UIControlStateNormal placeholderImage:iconImage];
                [cell addSubview:iconImageBtn];
                
//                性别男女
                NSString *maleString = [self.poolingDetailDictionary objectForKey:@"sex"];
                UIImage *maleImage = [UIImage imageNamed:@"icon_male1.png"];
                UIImageView *maleImageView = [self newImageViewWithImage:maleImage frame:CGRectMake(iconImageBtn.frame.size.width+iconImageBtn.frame.origin.x+14, iconImageBtn.frame.origin.y+7, maleImage.size.width, maleImage.size.height)];
                if ([maleString isEqualToString:@"男"]) {
                    maleImageView.image = maleImage;
                }else{
                    maleImageView.image = [UIImage imageNamed:@"icon_female1.png"];;
                }
                [cell addSubview:maleImageView];
                [maleImageView release];
                
//                名称
                UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(maleImageView.frame.size.width+maleImageView.frame.origin.x+4, iconImageBtn.frame.origin.y+4, 140, maleImageView.frame.size.height+6)];
                titleLabel.text = [self.poolingDetailDictionary objectForKey:@"publisherName"];
                titleLabel.textAlignment = NSTextAlignmentLeft;
                titleLabel.backgroundColor = [UIColor clearColor];
                titleLabel.font = [UIFont systemFontOfSize:18];
                titleLabel.textColor = RGB(84, 84, 84);
                [cell addSubview:titleLabel];
                [titleLabel release];
                
//                车型号
                NSString *carTypeString = [self.poolingDetailDictionary objectForKey:@"type"];
                UIImage *carImage = [UIImage imageNamed:@"TAXI1.png"];
                UIImageView *carImageView = [self newImageViewWithImage:carImage frame:CGRectMake(maleImageView.frame.origin.x, titleLabel.frame.origin.y+titleLabel.frame.size.height+6, carImage.size.width, carImage.size.height)];
                // add by devin
                if ([carTypeString integerValue]==2) {
                    carImageView.image = [UIImage imageNamed:@"TAXI1.png"];
                }else{
                    carImageView.image = [UIImage imageNamed:@"IHAVECAR1.png"];
                }
                [cell addSubview:carImageView];
                [carImageView release];
//                 时间
                UIImage *timeImage = [UIImage imageNamed:@"icon_time.png"];
                UIImageView *timeImageView = [self newImageViewWithImage:timeImage frame:CGRectMake(250, titleLabel.frame.origin.y+2, timeImage.size.width, timeImage.size.height)];
                [cell addSubview:timeImageView];
                [timeImageView release];
                
                NSDate *formateDate = [NSObject fromatterDateFromStr:[self.poolingDetailDictionary objectForKey:@"createTime"]];
                NSString *time = [NSObject compareCurrentTime:formateDate];
                // 拼车
                UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(timeImageView.frame.size.width+timeImageView.frame.origin.x+4, timeImageView.frame.origin.y-2, 140, timeImage.size.height+4)];
                timeLabel.text = time;
                timeLabel.textColor = RGB(132, 132, 132);
                timeLabel.textAlignment = NSTextAlignmentLeft;
                timeLabel.backgroundColor = [UIColor clearColor];
                timeLabel.font = [UIFont systemFontOfSize:11];
                [cell addSubview:timeLabel];
                [timeLabel release];
            }
                break;
            case 1:
            {
                // 上班
                UILabel *goWorkLabel = [[UILabel alloc] initWithFrame:CGRectMake(15,4, 290, 20)];
                if ([self.poolingDetailDictionary objectForKey:@"attendanceTime"] || [self.poolingDetailDictionary objectForKey:@"destination"]) {
                     goWorkLabel.text = [NSString stringWithFormat:@"上班：%@    到：%@",[self.poolingDetailDictionary objectForKey:@"attendanceTime"],[self.poolingDetailDictionary objectForKey:@"destination"]];
                }else{
                    goWorkLabel.text = [NSString stringWithFormat:@"上班：     到： "];
                }
               
//                @"上班：08:20    到：黄冈商务中心 附近";
                goWorkLabel.textAlignment = NSTextAlignmentLeft;
                goWorkLabel.textColor = RGB(102, 102, 102);
                goWorkLabel.backgroundColor = [UIColor clearColor];
                goWorkLabel.font = [UIFont systemFontOfSize:15];
                [cell addSubview:goWorkLabel];
                [goWorkLabel release];
                
                // 下班
                UILabel *goOutWorkLabel = [[UILabel alloc] initWithFrame:CGRectMake(15,goWorkLabel.frame.size.height+goWorkLabel.frame.origin.y+8, 290, 20)];
                
                if ([self.poolingDetailDictionary objectForKey:@"closingTime"] || [self.poolingDetailDictionary objectForKey:@"returnHome"]) {
                     goOutWorkLabel.text = [NSString stringWithFormat:@"下班：%@    到：%@",[self.poolingDetailDictionary objectForKey:@"closingTime"],[self.poolingDetailDictionary objectForKey:@"returnHome"]];
                }else{
                 goOutWorkLabel.text = [NSString stringWithFormat:@"下班：     到： "];
                }
               
//                @"下班：18:20    到：诺德国际小区 东门";
                goOutWorkLabel.textAlignment = NSTextAlignmentLeft;
                goOutWorkLabel.backgroundColor = [UIColor clearColor];
                goOutWorkLabel.textColor = RGB(102, 102, 102);
                goOutWorkLabel.font = [UIFont systemFontOfSize:15];
                [cell addSubview:goOutWorkLabel];
                [goOutWorkLabel release];
            }
                break;
            case 2:
            {
                NSString *str = [self.poolingDetailDictionary objectForKey:@"contactUs"];
                if (str.length == 0) {
                    str = [self.poolingDetailDictionary objectForKey:@"remark"];
                }
                cell.textLabel.numberOfLines = 0;
                cell.textLabel.font = [UIFont systemFontOfSize:15.0];
                cell.textLabel.textColor = RGB(102, 102, 102);
                cell.textLabel.text = str;
            }
                break;
            case 3:
                cell.textLabel.text = [self.poolingDetailDictionary objectForKey:@"remark"];
                cell.textLabel.font = [UIFont systemFontOfSize:15.0];
                cell.textLabel.textColor = RGB(102, 102, 102);
                cell.textLabel.numberOfLines = 0;
                break;
            default:
                break;
        }
        return cell;
        
    }
    else if (indexSection == 1){
//        CarPoolingDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier2];
        CarPoolingDetailCell  *cell = [[[CarPoolingDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier2] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundView = [[[UIView alloc]initWithFrame:cell.bounds]autorelease];
        cell.backgroundView.backgroundColor = [UIColor whiteColor];

        CarPoolingCommentModel *commentModel = [self.commentListArray objectAtIndex:[indexPath row]];
        [cell.iconImageBtn setImageWithURL:[NSURL URLWithString:commentModel.residentIconString] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"notice_icon.png"]];
        cell.iconImageBtn.tag = indexPath.row;
        [cell.iconImageBtn addTarget:self action:@selector(iconViewBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        if ([commentModel.residentSexString isEqualToString:@"男"]) {
            cell.maleImageView.image = [UIImage imageNamed:@"icon_male1.png"];
        }else{
            cell.maleImageView.image = [UIImage imageNamed:@"icon_female1.png"];
        }
        cell.titleLabel.text =  commentModel.residentNameString;
        
        NSDate *formateDate = [NSObject fromatterDateFromStr:commentModel.createTimeString];
        NSString *time = [NSObject compareCurrentTime:formateDate];
        cell.timeLabel.text = time;
    
        CGFloat textHeight = [TQRichTextView getRechTextViewHeightWithText:commentModel.remarkString viewWidth:250 font:[UIFont systemFontOfSize:14.0] lineSpacing:1.8];
        CGRect rect = cell.contentLabel.frame;
        cell.contentLabel.frame = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, textHeight);
        if ([commentModel.replyIdString integerValue] != 0) {
            cell.contentLabel.text = [NSString stringWithFormat:@"回复 %@:%@",commentModel.replyNickNameString,commentModel.remarkString];
        }else{
           cell.contentLabel.text = commentModel.remarkString;
        }
        UITapGestureRecognizer *labTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(lableTap:)];
        cell.contentLabel.tag = indexPath.row;
        [cell.contentLabel addGestureRecognizer:labTap];
        [labTap release];
        
        return cell;
    }
     return nil;
}
#pragma mark -
#pragma mark Table Delegate Methods
//行的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *str = [self.poolingDetailDictionary objectForKey:@"remark"];
    //自适应高度
    CGSize titleSize = [str sizeWithFont:[UIFont systemFontOfSize:15.0] constrainedToSize:CGSizeMake(ScreenWidth, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    int result = 0;
    switch (indexPath.section) {
        case 0:
            if (_numberAndAdress == NoneNumberAdress){
                if (indexPath.row == 0) {
                    result = 60;
                }else{
                    result = 56;
                }
            }
            if ( _numberAndAdress == OnlyNumber || _numberAndAdress == OnlyAdress){
                if (indexPath.row == 0) {
                    result = 60;
                }else if(indexPath.row == 1){
                    result = 56;
                }else{
                   result = MAX(40.0f, titleSize.height+30);
                }
            }
            if (_numberAndAdress == AllNumberAdress){
                if (indexPath.row == 0) {
                    result = 60;
                }else if(indexPath.row == 1){
                    result = 56;
                }else if(indexPath.row == 2){
                    result = 40;
                }else{
                    result = MAX(40.0f, titleSize.height+20);
                }
            }
            break;
        case 1:{
            
            CarPoolingCommentModel *model = ([self.commentListArray  count]>indexPath.row)?[self.commentListArray objectAtIndex:indexPath.row]:nil;
            NSString *strRemark = model.remarkString;
            //逻辑判断高度
            CGFloat textHeight = [TQRichTextView getRechTextViewHeightWithText:strRemark viewWidth:250 font:[UIFont systemFontOfSize:14.0] lineSpacing:1.8];
            CGFloat height = MAX(textHeight+45.0f, 65.0f);
            return height;
        }
            break;
            default:
            break;
    }
    return result;
}
//add by devin
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        clickIndexPathRow = indexPath.row;
        CarPoolingCommentModel *model = [self.commentListArray objectAtIndex:indexPath.row];
        UserModel *userModel = [UserModel shareUser];
        selectedId = [model.residentIdString integerValue] ;
        delegateId = [model.idString integerValue] ;
        
        if ([userModel.userId isEqualToString:[NSString stringWithFormat:@"%d",selectedId]]) {
            UIActionSheet *deleSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除" otherButtonTitles:nil, nil];
            [deleSheet showInView:[UIApplication sharedApplication].keyWindow];
            [deleSheet release];
        }else {
            sendTextView.textViewInput.placeholder = [NSString stringWithFormat:@"回复%@",model.residentNameString];
            [sendTextView.textViewInput becomeFirstResponder];
        }
    }

}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 0;
    }else{
        return 30;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 10;
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

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        CarPoolDetailSectionHeaderView *headerView =  [[CarPoolDetailSectionHeaderView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(tableView.bounds), 30) section:section sectionTitle:[tableView.dataSource tableView:tableView titleForHeaderInSection:section]];
        [headerView setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
        
        //查看评论按钮，从我的评论push过来  add by devin
        if (self.carVcType == MyCarConrrollerPush&&(self.carCommentType == IsCarMyComment||self.carCommentType == IsHisCarMyComment)) {
            _commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
            _commentButton.frame = CGRectMake(250, 1, 60, 30);
            [_commentButton addTarget:self action:@selector(comment) forControlEvents:UIControlEventTouchUpInside];
            _commentButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
            [_commentButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
            if (_flag == TRUE) {
                if (self.carCommentType == IsHisCarMyComment) {
                    [_commentButton setTitle:@"他的评论" forState:UIControlStateNormal];
                }
                if (self.carCommentType == IsCarMyComment) {
                    [_commentButton setTitle:@"我的评论" forState:UIControlStateNormal];
                }
            }else{
                [_commentButton setTitle:@"全部评论" forState:UIControlStateNormal];
            }
            [headerView addSubview:_commentButton];
        }
        return headerView;
    }
    return nil;
}
//全部评论和个人评论
-(void)comment
{
    if (_flag == TRUE) {
        [_commentButton setTitle:@"全部评论" forState:UIControlStateNormal];
        [self requestAuctionComments:GET_LATEST_COMMENT searchType:@"2"];//2代表所有评论
        _flag = FALSE;
    }else if(_flag == FALSE){
        if (self.carCommentType == IsHisCarMyComment) {
            [_commentButton setTitle:@"他的评论" forState:UIControlStateNormal];
        }
        if (self.carCommentType == IsCarMyComment) {
            [_commentButton setTitle:@"我的评论" forState:UIControlStateNormal];
        }
        [self requestAuctionComments:GET_LATEST_COMMENT searchType:@"3"]; //3 代表我的评论
        _flag =  TRUE;
        
    }
}

//add by devin
#pragma mark -- uiactionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        NSLog(@"删除");
        //网络请求
        [self hideHudView];
        hudView = [Global showMBProgressHud:self SuperView:self.view Msg:@"请稍候..."];//请求验证验证码是否正确
        //加载网络数据  删除自己的评论
        if (request == nil) {
            request = [CommunityHttpRequest shareInstance];
        }
        UserModel *userModel = [UserModel shareUser];
        NSString *parameters = [NSString stringWithFormat:@"?%@=%@&%@=%@&%@=%@&id=%d",USER_ID,userModel.userId ,COMMUNITY_ID,userModel.communityId,PROPERTY_ID,userModel.propertyId,delegateId];//参数
        [request requestDelegateComment:self parameters:parameters];
    }
}
#pragma mark UITableViewDelegate implementation
-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return @"";
        case 1:{
            //[self.conmmentListDictionary objectForKey:@"commentSum"];
            return [NSString stringWithFormat:@"%d",_countString];
        }
        default:
            return nil;
    }
}
//add by devin
#pragma CommunitySendTextAndImageViewDelegate
-(void)sendTextAction:(NSString *)inputText{
    //加载网络数据  添加评论
    if (request == nil) {
        request = [CommunityHttpRequest shareInstance];
    }
    UserModel *userModel = [UserModel shareUser];
    NSString *parameter2 = [NSString stringWithFormat:@"?userId=%@&communityId=%@&propertyId=%@&replyId=%d&moduleTypeId=%d&commentId=%@&remark=%@",userModel.userId,userModel.communityId,userModel.propertyId,selectedId,4,[self.poolingDetailDictionary objectForKey:@"id"],inputText];
    [request requestAddComment:self parameters:parameter2];
    //[carPoolTableView reloadData];
    selectedId = 0;
}

#pragma mark
-(void) callBackWith: (WInterface) interface status: (NSString*) status data:(id) data{
    NSLog(@"interface :%d status:%@",interface,status);
    if (interface == COMMUNITY_CARSHARING_INFO) {
        if ([status isEqualToString:NETWORK_RETURN_CODE_S_OK]) {
            self.poolingDetailDictionary = [[data retain] objectForKey:@"sharing"];
            NSString *contactUs = [self.poolingDetailDictionary objectForKey:@"contactUs"];
            NSString *strRemark = [self.poolingDetailDictionary objectForKey:@"remark"];
            
            //判断删除该帖子
            if ([data objectForKey:@"sharing"] == nil) {
                NSLog(@"该贴已删除");
                detaileTableView = [[CarPoolingDetailTableHeaderView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 398/2) imageString:@"bg_sample_2.png"];
                carPoolTableView.tableHeaderView = detaileTableView;
                [detaileTableView release];
                
            }else{
                //刷新当前的数据
                [self refreshHeadView];
            }

            //是否有电话号或地址
            if (contactUs.length>0&&strRemark.length ==0) {
                _numberAndAdress = OnlyNumber;
            }
            if (contactUs.length == 0&&strRemark.length>0){
                _numberAndAdress = OnlyAdress;
            }
            if (contactUs.length > 0&&strRemark.length>0){
                _numberAndAdress = AllNumberAdress;
            }
            if (contactUs.length == 0&&strRemark.length == 0){
                _numberAndAdress = NoneNumberAdress;
            }
            isCollected = [[self.poolingDetailDictionary objectForKey:@"collectId"] integerValue]; //add by devin
            
            //add by devin 2表示自己评论 3表示全部评论
            if (_flag == TRUE) {
                [self requestAuctionComments:GET_LATEST_COMMENT searchType:@"3"];
            }else{
                 [self requestAuctionComments:GET_LATEST_COMMENT searchType:@"2"];
            }
            
            // 导航栏右按钮 每次进来判断一次是否收藏标识 add by devin
            if (self.carVcType == MyCarConrrollerPush&&self.carPublishType == IsCarMyPublish){
                rightImage = [UIImage imageNamed:@"icon_notice_delete.png"];
                [rightBtn setImage:rightImage forState:UIControlStateNormal];
                
            }else{
                //自己的帖子则显示垃圾桶按钮，其他人的就显示收藏按钮
                UserModel *userModel = [UserModel shareUser];
                if ([[self.poolingDetailDictionary objectForKey:@"publisherId"] isEqualToString:userModel.userId]) {
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
                }}
                }
            [carPoolTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
        }else{
            [self hideHudView];
//            if ([[data retain] objectForKey:@"errorMsg"]) {
//                 [self alertWithFistButton:@"确定" SencodButton:nil Message:[[data retain] objectForKey:@"errorMsg"]];
//            }
           
        }
    }else if (interface == COMMUNITY_COMMENT_LIST){
    if ([status isEqualToString:NETWORK_RETURN_CODE_S_OK]){
        [self hideHudView];
        if (self.getCommentType == GET_LATEST_COMMENT) {
            [self.commentListArray  removeAllObjects];
        }
        self.conmmentListDictionary = [data retain];
        _countString = [[self.conmmentListDictionary objectForKey:@"commentSum"] integerValue];
        NSArray *array = [data objectForKey:@"commentvo"];
      //  NSMutableArray *object_Arr = [[NSMutableArray alloc] init];
        for (NSDictionary *dic in array) {
            CarPoolingCommentModel *commentModel = [[CarPoolingCommentModel alloc] init];
            commentModel.idString = [dic objectForKey:@"id"];
            commentModel.residentIdString = [dic objectForKey:@"residentId"];
            commentModel.residentNameString = [dic objectForKey:@"residentName"];
            commentModel.residentSexString = [dic objectForKey:@"residentSex"];
            commentModel.residentIconString  = [dic objectForKey:@"residentIcon"];
            commentModel.remarkString = [dic objectForKey:@"remark"];
            commentModel.createTimeString = [dic objectForKey:@"createTime"];
            commentModel.replyIdString = [dic objectForKey:@"replyId"];
            commentModel.replyNickNameString = [dic objectForKey:@"replyNickName"];
            commentModel.replyIconString = [dic objectForKey:@"replyIcon"];
            [self.commentListArray addObject:commentModel];
            [commentModel release];
        }
        //self.commentListArray = object_Arr;
       // [object_Arr release]; //add vincent 内存释放
//        [carPoolTableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
         [self doneWithView];
    }}else{
         [self doneWithView];
        NSLog(@"COMMUNITY_COMMENT_LIST fail");
    }
    //添加评论 add by devin
    if (interface == COMMUNITY_ADD_COMMENT) {
        NSString *code = [data objectForKey:ERROR_CODE];
        if ([code isEqualToString:NETWORK_RETURN_CODE_S_OK]) {
            if (_flag == TRUE) {
                [self requestAuctionComments:GET_LATEST_COMMENT searchType:@"3"];
            }else{
                 [self requestAuctionComments:GET_LATEST_COMMENT searchType:@"2"];
            }
//            NSLog(@"回复评论成功");
            //hudViewhudView = [Global showMBProgressHudHint:self SuperView:self.view Msg:@"评论成功" ShowTime:1.0];
            
            [sendTextView hiddenKeyboard];
        }else{
            NSLog(@"网络数据获取失败");
        }
    }
    // 删除评论
    if (interface == COMMUNITY_DELEGATE_COMMENT) {
        NSString *code = [data objectForKey:ERROR_CODE];
        if ([code isEqualToString:NETWORK_RETURN_CODE_S_OK]) {
            selectedId = 0;
            NSLog(@"删除评论成功");
            _countString--;
            [self hideHudView];
           // hudView = [Global showMBProgressHudHint:self SuperView:self.view Msg:@"删除评论成功" ShowTime:1.0];
//            if (_currentDelCommentIndexPath != nil) {
//                CarPoolingCommentModel *commentModel = [self.commentListArray count] > _currentDelCommentIndexPath.row ? [self.commentListArray objectAtIndex:_currentDelCommentIndexPath.row] : nil;
//                if (commentModel) {
            CarPoolingCommentModel *commentModel = [self.commentListArray objectAtIndex:clickIndexPathRow];
            [self.commentListArray removeObject:commentModel];
            [carPoolTableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
             //   }

            }else{
            NSLog(@"网络数据获取失败");
        }
        
    }
    //添加收藏 add by devin
   if (interface == COMMUNITY_ADD_COLLECTION){
        if ([status isEqualToString:NETWORK_RETURN_CODE_S_OK]) {
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
        if ([status isEqualToString:NETWORK_RETURN_CODE_S_OK]) {
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
    [carPoolTableView reloadData];
}

//进入详情的个人资料  add by devin
-(void)iconViewBtnAction:(id)sender{
    UIButton *headbtn = (UIButton *)sender;
    CarPoolingCommentModel *model = [self.commentListArray objectAtIndex:headbtn.tag];
    UserModel *userModel = [UserModel shareUser];
    if ([userModel.userId isEqualToString:model.residentIdString]) {
        NSLog(@"如果是自己的话，不需要进入详情资料");
    }else {
        NeighborhoodIntroduceViewController *introduceVc = [[NeighborhoodIntroduceViewController alloc] initWithUserId:model.residentIdString communityId:nil propertyId:nil name:model.residentNameString];
        [self.navigationController pushViewController:introduceVc animated:YES];
        [introduceVc release];
    }
    
}

-(void)lableTap:(UITapGestureRecognizer *)sender{
    NSLog(@"sender = %d",sender.view.tag);
        CarPoolingCommentModel *model = [self.commentListArray objectAtIndex:sender.view.tag];
        UserModel *userModel = [UserModel shareUser];
        selectedId = [model.residentIdString integerValue] ;
        delegateId = [model.idString integerValue] ;
        
        if ([userModel.userId isEqualToString:[NSString stringWithFormat:@"%d",selectedId]]) {
            clickIndexPathRow = sender.view.tag;
            UIActionSheet *deleSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除" otherButtonTitles:nil, nil];
            [deleSheet showInView:[UIApplication sharedApplication].keyWindow];
            [deleSheet release];
        }else {
            sendTextView.textViewInput.placeholder = [NSString stringWithFormat:@"回复%@",model.residentNameString];
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
