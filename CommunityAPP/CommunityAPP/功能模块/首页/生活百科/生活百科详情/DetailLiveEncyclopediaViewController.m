//
//  DetailLiveEncyclopediaViewController.m
//  CommunityAPP
//
//  Created by Dream on 14-3-18.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import "DetailLiveEncyclopediaViewController.h"
#import "Global.h"
#import "NSObject_extra.h"
#import "CarPoolingDetailCell.h" // 复用添加上下班的cell
#import "CommunityHttpRequest.h"
#import "UserModel.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import "MJPhoto.h"
#import "MJPhotoBrowser.h"
#import "SesameGlobalWebView.h"
#import "LiveEncyclopediaModel.h"
#import "MJRefresh.h"
#import "Reachability.h"
#import "CommonDefine.h"
#import "NeighborhoodIntroduceViewController.h"
#import "CarPoolDetailSectionHeaderView.h"
#import "NSObject+Time.h"
#import "UIViewController+NavigationBar.h"
#import "AppConfig.h"
#import "LiveEncyclopediaModel.h"
#import "MobClick.h"

@interface DetailLiveEncyclopediaViewController (){
    MJRefreshFooterView *_footer;
}

@property (nonatomic, retain) CommunityHttpRequest *request;
@property (nonatomic,retain) NSMutableArray *detailLiveEncyclopediaArr;
@property (nonatomic, assign) GetCemmetnType getCommentType;
@property (nonatomic,retain) UIButton *commentButton;
@property (nonatomic, assign) NSInteger countString;
@end

@implementation DetailLiveEncyclopediaViewController
@synthesize request = _request;
@synthesize passStr = _passStr;
@synthesize selectedId = _selectedId;
@synthesize vcType = _vcType;
@synthesize liveCommentType = _liveCommentType;
@synthesize commentButton = _commentButton;
@synthesize flag = _flag;
@synthesize countString = _countString;
@synthesize liveModel = _liveModel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _detailLiveEncyclopediaArr = [[NSMutableArray alloc]initWithCapacity:0];
        _getCommentType = GET_PAST_COMMENT;
        _selectedId = @"0";
        _vcType = LiveControllerPush; //默认是从生活百科push过来
        _liveCommentType = IsNotLiveMyComment; //默认不是我的评论
        _flag = FALSE; //判断是否是全部评论和我的评论
        _countString = 0;
    }
    return self;
}
- (void)dealloc
{
    [sendTextView release]; sendTextView = nil;
    [hudView release];
    [_request cancelDelegate:self];
    DetailLiveEncyclopediaTableView.delegate = nil;
    DetailLiveEncyclopediaTableView.dataSource = nil;
    [DetailLiveEncyclopediaTableView release]; DetailLiveEncyclopediaTableView = nil;
    [detail release]; detail = nil;
    [_detailLiveEncyclopediaArr release]; _detailLiveEncyclopediaArr = nil;
    [super dealloc];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"DetailLiveEncyclopediaPage"];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"DetailLiveEncyclopediaPage"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.navigationController setNavigationBarHidden:NO];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    //自适应iOS的导航栏、状态栏
    [self adjustiOS7NaviagtionBar];
    [self setNavigationTitle:@"生活百科详情"];
    //自定义返回按钮
    UIButton *backButton = [self setBackBarButton];
    [backButton addTarget:self action:@selector(leftBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self setBackBarButtonItem:backButton];
    
    //    右边按钮  空心的五角星（收藏按钮）（默认就是这个）
    rightImage = [UIImage imageNamed:@"icon_collection.png"];
    rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setImage:rightImage forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightBtnAction) forControlEvents:UIControlEventTouchUpInside];
    rightBtn.frame = CGRectMake(275,0,44,44);
    [self setRightBarButtonItem:rightBtn];
  
    [self loadTableView];
    
    [self hideHudView];
    hudView = [Global showMBProgressHud:self SuperView:self.view Msg:@"请稍候..."];//  请求验证验证码是否正确
     [self requestDetailHeaderData]; //网络请求表头数据
    
    normalImage = [UIImage imageNamed:@"icon_life_like_normal.png"];
    selectedImage = [UIImage imageNamed:@"icon_life_like_click.png"];
    [loveBtn setImage:normalImage forState:UIControlStateNormal];
    [loveBtn setImage:selectedImage forState:UIControlStateSelected];
}

-(void)loadTableView{
    //列表视图
    DetailLiveEncyclopediaTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, MainHeight-CommunitySendBackHeight) style:UITableViewStylePlain];
    DetailLiveEncyclopediaTableView.backgroundView = nil;
    DetailLiveEncyclopediaTableView.backgroundColor = [UIColor clearColor];
    DetailLiveEncyclopediaTableView.delegate = self;
    DetailLiveEncyclopediaTableView.dataSource = self;
    DetailLiveEncyclopediaTableView.showsVerticalScrollIndicator = NO;
    DetailLiveEncyclopediaTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    DetailLiveEncyclopediaTableView.tableFooterView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
    DetailLiveEncyclopediaTableView.tableHeaderView = [self initHeadView];
    [self.view addSubview:DetailLiveEncyclopediaTableView];
    
    //添加上拉刷新
    [self addFooter];
    
    //    发送面板
    sendTextView = [[CommunitySendTextAndImageView alloc] initWithFrame:CGRectMake(0, ScreenHeight-CommunitySendBackHeight, ScreenWidth, CommunitySendBackHeight) superView:self.view];
    sendTextView.delegate = self;
    [self.view addSubview:sendTextView];
    
}
- (void)setBaseId:(NSString *)baseId{
    [super setBaseId:baseId];
    if (_passStr != baseId) {
        [_passStr release];
        _passStr = [baseId retain];
        
    }
}

-(void)requestDetailHeaderData{
    //加载网络数据
    if (_request == nil) {
        _request = [CommunityHttpRequest shareInstance];
    }
    //表头的数据加载
    UserModel *userModel = [UserModel shareUser];
    NSString *parameters = [NSString stringWithFormat:@"?%@=%@&userId=%@&%@=%@&%@=%@&%@=%@",UPDATE_TIME,DEF_UPDATE_TIME,userModel.userId,@"id",_passStr ,COMMUNITY_ID,userModel.communityId,PROPERTY_ID,userModel.propertyId];//参数
    [_request requestDetailLiveEncyclopedia:self parameters:parameters];
  
}
-(void)requestCommentData:(GetCemmetnType)type searchType:(NSString *)searchType{
    //表头网络数据请求完后加载评论数据
    //评论的数据加载
    UserModel *userModel = [UserModel shareUser];
    DetailLiveEncyclopediaModel *detailModel = [self.detailLiveEncyclopediaArr lastObject];

    if (detailModel == nil) {
        lastCommentId = 0;
    }else{
        lastCommentId = detailModel.commentId;
    }
    self.getCommentType = type;
    if (type == GET_PAST_COMMENT) {
        //不做处理
    }else{
        lastCommentId = 0;
    }
    
    NSString *string = nil;
    if (self.liveCommentType == IsHisLiveMyComment) {
        string =[NSString stringWithFormat:@"?lastId=%d&userId=%@&%@=%@&%@=%@&moduleTypeId=%d&commentId=%d&searchType=%@",lastCommentId,_comModel.mycommentResidentId,COMMUNITY_ID,userModel.communityId,PROPERTY_ID,userModel.propertyId,2,detail.detailLiveId,searchType];
    }else{
        string = [NSString stringWithFormat:@"?lastId=%d&userId=%@&%@=%@&%@=%@&moduleTypeId=%d&commentId=%d&searchType=%@",lastCommentId,userModel.userId,COMMUNITY_ID,userModel.communityId,PROPERTY_ID,userModel.propertyId,2,detail.detailLiveId,searchType];
    }
    [_request requestComments:self parameters:string];

}
#pragma mark ---refresh
- (void)addFooter{
    __unsafe_unretained DetailLiveEncyclopediaViewController *vc = self;
   MJRefreshFooterView *footer = [MJRefreshFooterView footer];
    footer.scrollView = DetailLiveEncyclopediaTableView;
    footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        //下拉刷新再次请求评论数据
         NSLog(@"%@",vc);
        if (_flag == TRUE) {
            [self requestCommentData:GET_PAST_COMMENT searchType:@"3"];
        }else{
            [self requestCommentData:GET_PAST_COMMENT searchType:@"2"];
        }
    };
    _footer = footer;
    
}
- (void)doneWithView{
    [_footer endRefreshing];
}

#pragma mark -- uitableviewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.detailLiveEncyclopediaArr count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CarPoolingDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CarPoolingDetailCell"];
    if (cell == nil) {
        cell = [[[CarPoolingDetailCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CarPoolingDetailCell"]autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    DetailLiveEncyclopediaModel *model = [self.detailLiveEncyclopediaArr objectAtIndex:indexPath.row];
        //名字
        cell.titleLabel.text = model.commentresidentName;
        //头像
        [cell.iconImageBtn setImageWithURL:[NSURL URLWithString: model.commentresidentIcon] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"notice_icon.png"]];
        cell.iconImageBtn.tag = indexPath.row;
        [cell.iconImageBtn addTarget:self action:@selector(iconViewBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        //时间
        NSDate *formateDate = [NSObject fromatterDateFromStr:model.commentcreateTime];
        NSString *time = [NSObject compareCurrentTime:formateDate];
        cell.timeLabel.text = time;
        //自适应
        CGFloat textHeight = [TQRichTextView getRechTextViewHeightWithText:model.remark viewWidth:250 font:[UIFont systemFontOfSize:14.0] lineSpacing:1.8];
        CGRect rect = cell.contentLabel.frame;
        cell.contentLabel.frame = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, textHeight);
        //内容
        if (model.replyId) {
            cell.contentLabel.text = [NSString stringWithFormat:@"回复 %@:%@",model.replyNickName,model.remark];
            [TQRichTextView getRechTextViewHeightWithText:cell.contentLabel.text viewWidth:290 font:[UIFont systemFontOfSize:20.0] lineSpacing:1.8];
        }else{
            cell.contentLabel.text = [NSString stringWithFormat:@"%@",model.remark];
        }
        UITapGestureRecognizer *labTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(lableTap:)];
        cell.contentLabel.tag = indexPath.row;
        [cell.contentLabel addGestureRecognizer:labTap];
        [labTap release];
        //性别
        if ([model.commentresidentSex isEqualToString:@"男"]) {
            cell.maleImageView.image = [UIImage imageNamed:@"icon_male1.png"];
        }else{
            cell.maleImageView.image = [UIImage imageNamed:@"icon_female1.png"];
        }
    return cell;
}

#pragma mark -- uitableviewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    DetailLiveEncyclopediaModel *model = ([self.detailLiveEncyclopediaArr  count]>indexPath.row)?[self.detailLiveEncyclopediaArr objectAtIndex:indexPath.row]:nil;
    NSString *strRemark = model.remark;
    //逻辑判断高度
    CGFloat textHeight = [TQRichTextView getRechTextViewHeightWithText:strRemark viewWidth:250 font:[UIFont systemFontOfSize:14.0] lineSpacing:1.8];
    CGFloat height = MAX(textHeight+45.0f, 65.0f);
    return height;

}

-(void)refreshLove{
  loveLable.text = [NSString stringWithFormat:@"%d",detail.detailLiveFavour];
}
- (void)refreshHeaderView{
    titleLable.text = detail.detailLiveTitle;
    [contentImg setImageWithURL:[NSURL URLWithString:detail.detailLiveContentImg] placeholderImage:[UIImage imageNamed:@"bg_sample_3.png"]];
    loveLable.text = [NSString stringWithFormat:@"%d",detail.detailLiveFavour];
    endTypeLable.text = detail.detailLiveTypeLable;
    endLable.text = detail.detailLiveCreateTime;
    //加载URL或者HTML5标签
    if (![detail.detailIsUrl isEqualToString:@"0"]) {
        NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:detail.detailLiveContent]  cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                            timeoutInterval:40.0];
        [contentWebView loadRequest:request];
    }else{
        NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
        NSString *filePath =[resourcePath stringByAppendingPathComponent:@"detailpageContent.html"];
        NSString *htmlstring=[[NSString alloc] initWithContentsOfFile:filePath  encoding:NSUTF8StringEncoding error:nil];
        NSString *newContent =[htmlstring stringByReplacingOccurrencesOfString:@"${content}" withString:detail.detailLiveContent];
        [htmlstring  release]; //add vincent 内存释放

        NSString *path1 = [[NSBundle mainBundle] resourcePath];
        NSURL *baseURL = [NSURL fileURLWithPath:path1];
        [contentWebView loadHTMLString:newContent baseURL:baseURL];
    }
}

- (UIView *)initHeadView{
    //背景view
    backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth,270+10)];
    backView.backgroundColor = RGB(244, 244, 244);
    //放各种控件的view
    mainView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth,270)];
    mainView.backgroundColor = [UIColor whiteColor];
    mainView.layer.borderWidth = 1.0f;
    mainView.layer.borderColor = RGB(230, 230, 230).CGColor;
    
    titleLable = [self newLabelWithText:@"掌握几个时段规律护肤效果最好" frame:CGRectMake(20,15, 300, 20) font:[UIFont systemFontOfSize:15] textColor:RGB(51, 51, 51)];
    titleLable.backgroundColor = [UIColor clearColor];
    
    // 内容图片
    UIImage *headImage = [UIImage imageNamed:@"bg_sample_3.png"];
    contentImg = [self newImageViewWithImage:headImage frame:CGRectMake(19, titleLable.frame.size.height+titleLable.frame.origin.y+10, 280, 160)];
    contentImg.userInteractionEnabled = YES;
    UITapGestureRecognizer *imgTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imgTap:)];
    [contentImg addGestureRecognizer:imgTap];
    [imgTap release];
    
    contentWebView = [[UIWebView alloc]init];
    contentWebView.frame = CGRectMake(8, contentImg.frame.size.height+contentImg.frame.origin.y-5, 317, 280);
    contentWebView.scalesPageToFit = NO;
    contentWebView.delegate = self;
    contentWebView.scrollView.scrollEnabled = NO;
    [mainView addSubview:contentWebView];
    [contentWebView release];

    //间隔线
    lineImage = [UIImage imageNamed:@"life-line.png"];
    lineImg = [self newImageViewWithImage:lineImage frame:CGRectMake(20, 232,lineImage.size.width, lineImage.size.height)];
    //点赞图片
    loveImage = [UIImage imageNamed:@"icon_life_like_normal.png"];
    loveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loveBtn.frame = CGRectMake(20,237, loveImage.size.width, loveImage.size.height);
    [loveBtn setImage:loveImage forState:UIControlStateNormal];
    [loveBtn addTarget:self action:@selector(love) forControlEvents:UIControlEventTouchUpInside];
    //点赞
    loveLable = [[UILabel alloc]initWithFrame:CGRectMake(loveBtn.frame.size.width+loveBtn.frame.origin.x+5,239, 50, 20)];
    loveLable.text = @" ";
    loveLable.font = [UIFont systemFontOfSize:12];
    loveLable.textColor = RGB(153, 153, 153);
    loveLable.backgroundColor = [UIColor clearColor];
    
    //详情类型
    endTypeLable = [[UILabel alloc]initWithFrame:CGRectMake(loveBtn.frame.size.width+loveBtn.frame.origin.x+110,239, 40, 20)];
    endTypeLable.text = @"美容";
    endTypeLable.font = [UIFont systemFontOfSize:12];
    endTypeLable.textColor = RGB(153, 153, 153);
    endTypeLable.backgroundColor = [UIColor clearColor];
    
    //地址日期
    endLable = [[UILabel alloc]initWithFrame:CGRectMake(loveBtn.frame.size.width+loveBtn.frame.origin.x+140,239, 180, 20)];
    endLable.text = @"2014-02-12 06:30";
    endLable.font = [UIFont systemFontOfSize:12];
    endLable.textColor = RGB(153, 153, 153);
    endLable.backgroundColor = [UIColor clearColor];
   
    [mainView addSubview:lineImg];
    [mainView addSubview:endTypeLable];
    [mainView addSubview:endLable];
    [mainView addSubview:loveBtn];
    [mainView addSubview:loveLable];
    [mainView addSubview:contentImg];
    [mainView addSubview:titleLable];
    [backView addSubview:mainView];
    [titleLable release];
    [mainView release];
    [lineImg release];
    [endTypeLable release];
    [endLable release];
    [contentImg release];
    [loveLable release];
    return backView;
}
#pragma mark - uiwebViewdelegate
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30.0f;
}
- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *sectionView = [[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 30)] autorelease];
        sectionView.backgroundColor = [UIColor whiteColor];
        sectionView.layer.borderWidth = 0.5f;
        sectionView.layer.borderColor = RGB(223, 223, 223).CGColor;
        //评论条数
        commentCount = [[UILabel alloc]initWithFrame:CGRectMake(15, 5, 100, 20)];
        commentCount.text = [NSString stringWithFormat:@"%d条评论",_countString];
        commentCount.font = [UIFont systemFontOfSize:13.0];
        commentCount.textColor = RGB(80, 80, 80);
        //查看评论按钮，从我的评论push过来
        if (self.vcType == MyConrrollerPush&&(self.liveCommentType == IsLiveMyComment||self.liveCommentType == IsHisLiveMyComment)) {
            _commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
            _commentButton.frame = CGRectMake(250, 1, 60, 30);
            if (_flag == TRUE) {
                if (self.liveCommentType == IsHisLiveMyComment) {
                    [_commentButton setTitle:@"他的评论" forState:UIControlStateNormal];
                }
                if (self.liveCommentType == IsLiveMyComment) {
                    [_commentButton setTitle:@"我的评论" forState:UIControlStateNormal];
                }
            }else{
               [_commentButton setTitle:@"全部评论" forState:UIControlStateNormal];
            }
            _commentButton.titleLabel.font = [UIFont systemFontOfSize:13.0];
            [_commentButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [_commentButton addTarget:self action:@selector(comment) forControlEvents:UIControlEventTouchUpInside];
            [sectionView addSubview:_commentButton];
        }
        [sectionView addSubview:commentCount];
        [commentCount release];
    return sectionView;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    clickIndexPathRow = indexPath.row;
    DetailLiveEncyclopediaModel *model = [self.detailLiveEncyclopediaArr objectAtIndex:indexPath.row];
    UserModel *userModel = [UserModel shareUser];
    self.selectedId = [NSString stringWithFormat:@"%d",model.commentresidentId];
    delegateId = model.commentId;
    if ([userModel.userId isEqualToString:_selectedId]) {
        UIActionSheet *deleSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除" otherButtonTitles:nil, nil];
        [deleSheet showInView:[UIApplication sharedApplication].keyWindow];
        [deleSheet release];
    }else {
        sendTextView.textViewInput.placeholder = [NSString stringWithFormat:@"回复%@",model.commentresidentName];
        [sendTextView.textViewInput becomeFirstResponder];
    }
    
}
#pragma mark -- uiactionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        NSLog(@"删除");
        //网络请求
        [self hideHudView];
        hudView = [Global showMBProgressHud:self SuperView:self.view Msg:@"请稍候..."];//  请求验证验证码是否正确
        //加载网络数据  删除自己的评论
        if (_request == nil) {
            _request = [CommunityHttpRequest shareInstance];
        }
        UserModel *userModel = [UserModel shareUser];
        NSString *parameters = [NSString stringWithFormat:@"?%@=%@&%@=%@&%@=%@&id=%d",USER_ID,userModel.userId ,COMMUNITY_ID,userModel.communityId,PROPERTY_ID,userModel.propertyId,delegateId];//参数
        [_request requestDelegateComment:self parameters:parameters];
    }
}
#pragma CommunitySendTextAndImageViewDelegate
-(void)sendTextAction:(NSString *)inputText{
    NSLog(@"sendTextAction%@",inputText);
    //加载网络数据  添加评论
    if (_request == nil) {
        _request = [CommunityHttpRequest shareInstance];
    }
    UserModel *userModel = [UserModel shareUser];
    NSString *parameter2 = [NSString stringWithFormat:@"?userId=%@&communityId=%@&propertyId=%@&replyId=%@&moduleTypeId=%d&commentId=%d&remark=%@&receiveId=%@",userModel.userId,userModel.communityId,userModel.propertyId,_selectedId,2,detail.detailLiveId,inputText,@"0"];
    [_request requestAddComment:self parameters:parameter2];
    //[DetailLiveEncyclopediaTableView reloadData];
    _selectedId = @"0";
}

- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType {
    return YES;
}
-(void)webViewDidFinishLoad:(UIWebView *)webView{
   int yy = [[webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.scrollHeight"] intValue];
	CGRect newFrame = webView.frame;
	newFrame.size.height = yy;
	webView.frame = newFrame;
    mainView.frame = CGRectMake(0, 0, ScreenWidth,240+yy);
    lineImg.frame = CGRectMake(20, 202+yy,lineImage.size.width, lineImage.size.height);
    loveBtn.frame = CGRectMake(20,207+yy, loveImage.size.width, loveImage.size.height);
    loveLable.frame = CGRectMake(loveBtn.frame.size.width+loveBtn.frame.origin.x+10,209+yy, 50, 20);
    endTypeLable.frame = CGRectMake(loveBtn.frame.size.width+loveBtn.frame.origin.x+105,209+yy, 40, 20);
    endLable.frame = CGRectMake(loveBtn.frame.size.width+loveBtn.frame.origin.x+135,209+yy, 180, 20);
    backView.frame = CGRectMake(0, 0, ScreenWidth, 280+yy-30);
    //加载tableview
   
    DetailLiveEncyclopediaTableView.tableHeaderView = backView;
}
//点赞网络数据
-(void)love{
    if (detail.detailLiveFavourId == 0) {
        NSLog(@"点赞了");
        //加载网络数据
        if (_request == nil) {
            _request = [CommunityHttpRequest shareInstance];
        }
        UserModel *userModel = [UserModel shareUser];
        NSString *parameters1 = [NSString stringWithFormat:@"?%@=%@&%@=%@&%@=%@&moduleTypeId=%d&detailsId=%d",USER_ID,userModel.userId,COMMUNITY_ID,userModel.communityId,PROPERTY_ID,userModel.propertyId,2,detail.detailLiveId];
        [_request requestAddLove:self parameters:parameters1];
    }else{
        NSLog(@"取消点赞了");
        //加载网络数据
        if (_request == nil) {
            _request = [CommunityHttpRequest shareInstance];
        }
        UserModel *userModel = [UserModel shareUser];
        NSString *parameters2 = [NSString stringWithFormat:@"?%@=%@&%@=%@&%@=%@&favourId=%d",USER_ID,userModel.userId,COMMUNITY_ID,userModel.communityId,PROPERTY_ID,userModel.propertyId,detail.detailLiveFavourId];
        [_request requestDeleLove:self parameters:parameters2];
    }
}
//导航栏返回按钮
-(void)leftBtnAction{
    self.liveModel.liveCommentCount = _countString;
    self.liveModel.liveFavour = detail.detailLiveFavour;
    self.liveModel.liveFavourId = detail.detailLiveFavourId;
    [self.navigationController popViewControllerAnimated:YES];
}

//进入详情的个人资料
-(void)iconViewBtnAction:(id)sender{
    UIButton *headbtn = (UIButton *)sender;
    DetailLiveEncyclopediaModel *model = [self.detailLiveEncyclopediaArr objectAtIndex:headbtn.tag];
    UserModel *userModel = [UserModel shareUser];
    if ([userModel.userId isEqualToString:[NSString stringWithFormat:@"%d",model.commentresidentId]]) {
        NSLog(@"如果是自己的话，不需要进入详情资料");
    }else {
    NeighborhoodIntroduceViewController *introduceVc = [[NeighborhoodIntroduceViewController alloc] initWithUserId:[NSString stringWithFormat:@"%d",model.commentresidentId] communityId:nil propertyId:nil name:model.commentresidentName];
    [self.navigationController pushViewController:introduceVc animated:YES];
        [introduceVc release];
    }
    
}
//全部评论和个人评论
-(void)comment{
    if (_flag == TRUE) {
        [_commentButton setTitle:@"全部评论" forState:UIControlStateNormal];
        [self requestCommentData:GET_LATEST_COMMENT searchType:@"2"];//2表示全部评论
        _flag = FALSE;
    }else if(_flag == FALSE){
        if (self.liveCommentType == IsHisLiveMyComment) {
            [_commentButton setTitle:@"他的评论" forState:UIControlStateNormal];
        }
        if (self.liveCommentType == IsLiveMyComment) {
            [_commentButton setTitle:@"我的评论" forState:UIControlStateNormal];
        }
        [self requestCommentData:GET_LATEST_COMMENT searchType:@"3"];//3代表我的评论
        _flag =  TRUE;
    }
}

// 收藏功能
-(void)rightBtnAction{
    if (detail.detailCollectId == 0) {
        NSLog(@"加入收藏");
        if (_request == nil) {
            _request = [CommunityHttpRequest shareInstance];
        }
        UserModel *userModel = [UserModel shareUser];
        /*publisherId = 0 ,代表生活百科发布人（其实是没有发布人）
         */
        NSString *parameters = [NSString stringWithFormat:@"?%@=%@&%@=%@&%@=%@&moduleTypeId=%d&detailsId=%d&publisherId=%d",USER_ID,userModel.userId ,COMMUNITY_ID,userModel.communityId,PROPERTY_ID,userModel.propertyId,2,detail.detailLiveId,0];//参数
        [_request requestAddCollect:self parameters:parameters];

    }else{
         NSLog(@"取消收藏");
        NSLog(@"detail.detailCollectId =＝ %d",detail.detailCollectId);

        if (_request == nil) {
            _request = [CommunityHttpRequest shareInstance];
        }
        UserModel *userModel = [UserModel shareUser];
        /*publisherId = 0 ,代表生活百科发布人（其实是没有发布人）
         */
        NSString *parameters = [NSString stringWithFormat:@"?collectId=%d&%@=%@&%@=%@&%@=%@",detail.detailCollectId,USER_ID,userModel.userId ,COMMUNITY_ID,userModel.communityId,PROPERTY_ID,userModel.propertyId];//参数
        [_request requestCancelCollect:self parameters:parameters];

    }
}

-(void) callBackWith: (WInterface) interface status: (NSString*) status data:(id) data{
    if (interface == COMMUNITY_LIVEENCYCLOPEDIA_INFO) {
        if ([status isEqualToString:NETWORK_RETURN_CODE_S_OK]) {
            [self hideHudView];
            NSDictionary *dic = [data objectForKey:@"encyclop"] ;
                //表头网络请求
                detail = [[DetailLiveEncyclopediaModel alloc]init];
                detail.detailLiveTitle = [dic objectForKey:@"title"];
                detail.detailLiveContent = [dic objectForKey:@"content"];
                detail.detailLiveId = [[dic objectForKey:@"id"] integerValue];
                detail.detailLiveFavour = [[dic objectForKey:@"favour"] integerValue];
                detail.detailLiveFavourId = [[dic objectForKey:@"favourId"] integerValue];
                detail.detailLiveCommentCount = [[dic objectForKey:@"commentCount"] intValue];
                detail.detailLiveTypeLable = [dic objectForKey:@"type"];
                detail.detailLiveCreateTime = [dic objectForKey:@"createTime"];
                detail.detailLiveContentImg = [dic objectForKey:@"cover"];
                detail.detailIsUrl = [dic objectForKey:@"isUrl"];
                detail.detailCollectId = [[dic objectForKey:@"collectId"] integerValue];
        }
        //点赞按钮
        if (detail.detailLiveFavourId == 0) {
            loveBtn.selected = NO;
        }else{
            loveBtn.selected = YES;
        }
        // 导航栏右按钮 判断石否收藏标识
        if (detail.detailCollectId == 0) {
            rightImage = [UIImage imageNamed:@"icon_collection.png"];
            [rightBtn setImage:rightImage forState:UIControlStateNormal];
        }else{
            rightImage = [UIImage imageNamed:@"icon_already_collection.png"];
            [rightBtn setImage:rightImage forState:UIControlStateNormal];
        }
        // 刷新headerView视图数据
        [self refreshHeaderView];
        //加载完headerView数据再请求评论网络数据
        if (_flag == TRUE) {
             [self requestCommentData:GET_LATEST_COMMENT searchType:@"3"];
        }else{
           [self requestCommentData:GET_LATEST_COMMENT searchType:@"2"];
        }
    }
    //评论列表
   else if (interface == COMMUNITY_COMMENT_LIST) {
    //评论的网络请求
     if ([status isEqualToString:NETWORK_RETURN_CODE_S_OK]) {
         if (self.getCommentType == GET_LATEST_COMMENT) {
             [self.detailLiveEncyclopediaArr  removeAllObjects];
         }
        NSArray *array = [data objectForKey:@"commentvo"];
        _countString = [[data objectForKey:@"commentSum"] integerValue];
            for (NSDictionary *dic in array) {
            DetailLiveEncyclopediaModel *model = [[DetailLiveEncyclopediaModel alloc]init];
            model.commentId = [[dic objectForKey:@"id"] integerValue];
            model.commentresidentId = [[dic objectForKey:@"residentId"] integerValue];
            model.commentmoduleTypeId = [[dic objectForKey:@"moduleTypeId"] integerValue];
            model.commentcommunityId = [[dic objectForKey:@"communityId"] integerValue];
            model.commentcommentId = [[dic objectForKey:@"commentId"] integerValue];
            model.commentresidentName = [dic objectForKey:@"residentName"];
            model.commentresidentSex = [dic objectForKey:@"residentSex"];
            model.commentresidentIcon = [dic objectForKey:@"residentIcon"];
            model.commentcreateTime = [dic objectForKey:@"createTime"];
            model.replyId = [[dic objectForKey:@"replyId"] integerValue];
            model.replyNickName = [dic objectForKey:@"replyNickName"];
            model.replyIcon = [dic objectForKey:@"replyIcon"];
            model.remark = [dic objectForKey:@"remark"];
           [self.detailLiveEncyclopediaArr addObject:model];
            [model release]; //add vincent 内存释放
        }
         [DetailLiveEncyclopediaTableView reloadData];
         [self doneWithView];
       }else{
         [self doneWithView];
        NSLog(@"生活百科评论数据获取失败");
       }}
    //添加评论
    else if (interface == COMMUNITY_ADD_COMMENT) {
        NSString *code = [data objectForKey:ERROR_CODE];
        if ([code isEqualToString:NETWORK_RETURN_CODE_S_OK]) {
            NSLog(@"回复评论成功");
        if (_flag == TRUE) {
            [self requestCommentData:GET_LATEST_COMMENT searchType:@"3"];
        }else{
            [self requestCommentData:GET_LATEST_COMMENT searchType:@"2"];
        }
        //hudView = [Global showMBProgressHudHint:self SuperView:self.view Msg:@"评论成功" ShowTime:1.0];
            [sendTextView hiddenKeyboard];
        }else{
            NSLog(@"添加评论数据获取失败");
        }
       }
    //删除评论
    else if (interface == COMMUNITY_DELEGATE_COMMENT) {
        NSString *code = [data objectForKey:ERROR_CODE];
        if ([code isEqualToString:NETWORK_RETURN_CODE_S_OK]) {
            NSLog(@"删除评论成功");
            _selectedId = @"0";
            [self hideHudView];
            _countString--;
            DetailLiveEncyclopediaModel *model = [self.detailLiveEncyclopediaArr objectAtIndex:clickIndexPathRow];
            [self.detailLiveEncyclopediaArr removeObject:model];
            [DetailLiveEncyclopediaTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
             //   }
         }else{
            NSLog(@"删除评论数据获取失败");
            }}
    //添加收藏
    else if (interface == COMMUNITY_ADD_COLLECTION){
        if ([status isEqualToString:NETWORK_RETURN_CODE_S_OK]) {
            rightImage = [UIImage imageNamed:@"icon_already_collection.png"];
            [rightBtn setImage:rightImage forState:UIControlStateNormal];
            NSDictionary *dic =[data objectForKey:@"collects"];
            detail.detailCollectId = [[dic objectForKey:@"id"] integerValue] ;
            if ([[data objectForKey:@"errorCode"] isEqualToString:@"000"]) {
            hudView = [Global showMBProgressHudHint:self SuperView:self.view Msg:@"收藏成功" ShowTime:1.0];
            }else{
            hudView = [Global showMBProgressHudHint:self SuperView:self.view Msg:@"收藏失败" ShowTime:1.0];
            }
        }
    }
    //取消收藏
    else if (interface == COMMUNITY_CANCEL_COLLECTION){
        if ([status isEqualToString:NETWORK_RETURN_CODE_S_OK]) {
            rightImage = [UIImage imageNamed:@"icon_collection.png"];
            [rightBtn setImage:rightImage forState:UIControlStateNormal];
            NSDictionary *dic =[data objectForKey:@"collects"];
            detail.detailCollectId = [[dic objectForKey:@"id"] integerValue] ;
        if ([[data objectForKey:@"errorCode"] isEqualToString:@"000"]) {
            hudView = [Global showMBProgressHudHint:self SuperView:self.view Msg:@"取消收藏成功" ShowTime:1.0];
        }else{
            hudView = [Global showMBProgressHudHint:self SuperView:self.view Msg:@"取消收藏失败" ShowTime:1.0];
        }
      }
    }
    //点赞
    else if (interface == COMMUNITY_ADD_LOVE) {
        NSString *code = [data objectForKey:ERROR_CODE];
        if ([code isEqualToString:NETWORK_RETURN_CODE_S_OK]) {
            loveBtn.selected = YES;
            detail.detailLiveFavourId = [[data objectForKey:@"id"]integerValue];
            detail.detailLiveFavour++;
            [self refreshLove];
        }
    }
    //取消点赞
    else if(interface == COMMUNITY_DELE_LOVE){
        NSString *code = [data objectForKey:ERROR_CODE];
        if ([code isEqualToString:NETWORK_RETURN_CODE_S_OK]) {
            loveBtn.selected = NO;
            detail.detailLiveFavourId = 0;
            detail.detailLiveFavour--;
           [self refreshLove];
        }
    }
}
-(void)imgTap:(UITapGestureRecognizer *)tap{
    NSMutableArray *photos = [[NSMutableArray alloc]initWithCapacity:0];
    MJPhoto *photo = [[MJPhoto alloc] init];
    photo.url = [NSURL URLWithString:detail.detailLiveContentImg];//显示等待菊花
    photo.srcImageView = contentImg; // 来源于哪个UIImageView
    [photos addObject:photo];
    [photo release];
    
    // 2.显示相册
    MJPhotoBrowser *browser = [[[MJPhotoBrowser alloc] init] autorelease];
    browser.currentPhotoIndex = tap.view.tag; // 弹出相册时显示的第一张图片是？
    browser.photos = photos; // 设置所有的图片
    [browser show];
}

-(void)lableTap:(UITapGestureRecognizer *)sender{
    NSLog(@"sender = %d",sender.view.tag);
    DetailLiveEncyclopediaModel *model = [self.detailLiveEncyclopediaArr objectAtIndex:sender.view.tag];
    UserModel *userModel = [UserModel shareUser];
    self.selectedId = [NSString stringWithFormat:@"%d",model.commentresidentId];
    delegateId = model.commentId;
    if ([userModel.userId isEqualToString:_selectedId]) {
        clickIndexPathRow = sender.view.tag;
        UIActionSheet *deleSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除" otherButtonTitles:nil, nil];
        [deleSheet showInView:[UIApplication sharedApplication].keyWindow];
        [deleSheet release];
    }else {
        sendTextView.textViewInput.placeholder = [NSString stringWithFormat:@"回复%@",model.commentresidentName];
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
