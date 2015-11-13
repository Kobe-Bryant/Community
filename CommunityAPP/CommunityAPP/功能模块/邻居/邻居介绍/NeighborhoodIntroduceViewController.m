//
//  NeighborhoodIntroduceViewController.m
//  CommunityAPP
//
//  Created by yunlai on 14-4-17.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import "NeighborhoodIntroduceViewController.h"
#import "NSObject_extra.h"
#import "Global.h"
#import "UserModel.h"
#import "UIImageView+WebCache.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"
#import "MyPublishViewController.h"
#import "MyCommentViewController.h"
#import "UIViewController+NavigationBar.h"
#import "AppConfig.h"
#import "DataBaseManager.h"
#import "UIButton+WebCache.h"

@interface NeighborhoodIntroduceViewController ()

@end

@implementation NeighborhoodIntroduceViewController
@synthesize personalInfo;
@synthesize introduceUserIdString;
@synthesize nickNameString;
@synthesize userNameJidString;

-(void)dealloc{
    [userNameJidString release];
    [contentScrollView release];
    [nameLab release];
    [sexImage release];
    [signatureLab release];
    [homeLab release];
    [identifyLab release];
    [jobImage release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(id)initWithUserId:(NSString *)userIdString communityId:(NSString *)communityIdString propertyId:(NSString *)propertyIdString name:(NSString *)nameString{
    self = [super init];
    if (self) {
        // Custom initialization
        personalInfo = [[NSMutableDictionary alloc] init];
        self.introduceUserIdString = userIdString;
        self.nickNameString =  nameString;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view setBackgroundColor:RGB(244, 244, 244)];
    //自适应iOS的导航栏、状态栏
    [self adjustiOS7NaviagtionBar];
    [self setNavigationTitle:self.nickNameString];
    //自定义返回按钮
    UIButton *backButton = [self setBackBarButton];
    [backButton addTarget:self action:@selector(backBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self setBackBarButtonItem:backButton];
    //构建tableview视图
    selfTableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0, ScreenWidth, MainHeight) style:UITableViewStylePlain];
    selfTableView.delegate = self;
    selfTableView.dataSource = self;
    selfTableView.showsVerticalScrollIndicator = NO;
    selfTableView.backgroundColor = [UIColor clearColor];
    selfTableView.backgroundView.backgroundColor = RGB(244, 244, 244);
    selfTableView.tableHeaderView = [self initHeadView];
    selfTableView.tableFooterView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
    selfTableView.tableHeaderView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:selfTableView];
    
    
    //网络请求
    [self hideHudView];
    hudView = [Global showMBProgressHud:self SuperView:self.view Msg:@"请稍候..."];//  请求验证验证码是否正确
    [self requestPersonalInfo];
}

-(void)requestPersonalInfo{
    if (request == nil) {
        request = [CommunityHttpRequest shareInstance];
    }
    UserModel *userModel = [UserModel shareUser];
    NSString *string = [NSString stringWithFormat:@"?updateTime=%@&userId=%@&communityId=%@&propertyId=%@",DEF_UPDATE_TIME,self.introduceUserIdString,userModel.communityId,userModel.propertyId];//参数
    
    [request requestPersonalInfodelegate:self parameters:string];
}

-(void)iconImageViewBtnAction{
    //小区图片
    NSArray *imgArr = [[personalInfo objectForKey:@"icon"] componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@";"]];
    // 1.封装图片数据
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:imgArr.count];
    for (int i = 0; i<imgArr.count; i++) {
        MJPhoto *photo = [[MJPhoto alloc] init];
        photo.url = [NSURL URLWithString:[imgArr objectAtIndex:i]]; // 图片路径
        [photos addObject:photo];
        [photo release];
    }
    
    // 2.显示相册
    MJPhotoBrowser *browser = [[[MJPhotoBrowser alloc] init] autorelease];
    browser.photos = photos; // 设置所有的图片
    [browser show];

}

- (UIView *)initHeadView{
    UIView *view = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 160)] autorelease];
    view.backgroundColor = [UIColor redColor];
    
    //个人资料
    iconImageViewBtn = [self newButtonWithImage:[UIImage imageNamed:@"default_head.png"] highlightedImage:nil frame:CGRectMake(14,10,60,60) title:nil titleColor:nil titleShadowColor:nil font:nil target:self action:@selector(iconImageViewBtnAction)];
    iconImageViewBtn.layer.cornerRadius = 29.0;
    iconImageViewBtn.layer.masksToBounds = YES;
    
    //
    //性别image
    sexImage = [[UIImageView alloc]initWithFrame:CGRectMake(86, 15, 12, 12)];
    //姓名lable
    nameLab = [[UILabel alloc]initWithFrame:CGRectMake(101, 11, 170, 21)];
    nameLab.font = [UIFont systemFontOfSize:16.0];
    nameLab.textColor = RGB(68, 68, 68);
    
    //座右铭lable
    signatureLab = [[UILabel alloc]initWithFrame:CGRectMake(85, 30, 250, 21)];
    signatureLab.font = [UIFont systemFontOfSize:13.0];
    signatureLab.lineBreakMode = NSLineBreakByTruncatingTail;
    signatureLab.textColor = RGB(68, 68, 68);
    
    //小区标志图片
    UIImage *homeimg = [UIImage imageNamed:@"building_icon.png"];
    UIImageView *homeImage = [[UIImageView alloc]initWithFrame:CGRectMake(87, 57, 15, 15)];
    homeImage.image = homeimg;
    
    //小区位置lable
    homeLab = [[UILabel alloc]initWithFrame:CGRectMake(106, 53, 80, 21)];
    homeLab.font = [UIFont systemFontOfSize:13.0];
    homeLab.lineBreakMode = NSLineBreakByTruncatingTail;
    homeLab.textColor = RGB(68, 68, 68);
    
    //职位标志图片
    UIImage *jobimg = [UIImage imageNamed:@"housing_icon.png"];
    jobImage = [[UIImageView alloc]initWithFrame:CGRectMake(190, 57, 15, 15)];
    jobImage.image = jobimg;
    
    //职位lable
    identifyLab = [[UILabel alloc]initWithFrame:CGRectMake(209, 53, 100, 21)];
    identifyLab.font = [UIFont systemFontOfSize:13.0];
    identifyLab.textColor = RGB(68, 68, 68);
    
    //滚动视图
    contentScrollView =[[UIScrollView alloc]initWithFrame:CGRectMake(0, 80, ScreenWidth, 80)] ;
    contentScrollView.pagingEnabled = YES;
    contentScrollView.showsHorizontalScrollIndicator = NO;
    contentScrollView.showsVerticalScrollIndicator = NO;
    contentScrollView.scrollsToTop = NO;
    contentScrollView.backgroundColor = RGB(226, 226, 226);
    [view addSubview:contentScrollView];
    
    [view addSubview:nameLab];
    [view addSubview:sexImage];
    [view addSubview:signatureLab];
    [view addSubview:iconImageViewBtn];
//    [iconImageView release];
    [view addSubview:homeImage];
    [view addSubview:jobImage];
    [view addSubview:homeLab];
    [view addSubview:identifyLab];
    [homeImage release];
    return view;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
  
}
//add vincent
-(void)sendMassage{
    NSString *currentJidString = [NSString stringWithFormat:@"%@@%@",self.userNameJidString,kHost];
    DataBaseManager *dbManager = [DataBaseManager shareDBManeger];
    NSArray *jidArray = [dbManager selectJidYesOrNo:currentJidString];
//    FriendListDetailInfromation *listDetailModel = [jidArray objectAtIndex:0];
//    NeighborChatMessageViewController *chatMessageVc = [[NeighborChatMessageViewController alloc] init];
//    chatMessageVc.listModel = listDetailModel;
//    chatMessageVc.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:chatMessageVc animated:YES];
//    [chatMessageVc release];
}

//返回导航按钮
-(void)backBtnAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)refreshPersonalInfo{
    if (personalInfo) {
        
//        _homeLab.text = [_personalInfo objectForKey:@"communityName"];
//        CGSize titleSize = [_homeLab.text sizeWithFont:[UIFont systemFontOfSize:13.0] constrainedToSize:CGSizeMake(MAXFLOAT, 30)];//获取小区的字符的宽度
//        _homeLab.frame = CGRectMake(104, 53,MIN(titleSize.width, 153), 21);//小区字符长度超过153，则显示省略号
//        _jobImage.frame = CGRectMake(_homeLab.frame.size.width+_homeLab.frame.origin.x+10, 57, 15, 15);
//        _identifyLab.frame = CGRectMake(_jobImage.frame.size.width+_jobImage.frame.origin.x+3, 53, 40, 21);
        
        
        nameLab.text = [personalInfo objectForKey:@"nickName"];
        signatureLab.text = [personalInfo objectForKey:@"signature"];
        homeLab.text = [personalInfo objectForKey:@"communityName"];
        CGSize titleSize = [homeLab.text sizeWithFont:[UIFont systemFontOfSize:13.0] constrainedToSize:CGSizeMake(MAXFLOAT, 30)];
        homeLab.frame = CGRectMake(104, 53,MIN(titleSize.width, 153), 21);
        jobImage.frame = CGRectMake(homeLab.frame.size.width+homeLab.frame.origin.x+10, 57, 15, 15);
        identifyLab.frame = CGRectMake(jobImage.frame.size.width+jobImage.frame.origin.x+3, 53, 40, 21);
        identifyLab.text = [personalInfo objectForKey:@"identity"];
        if ([[personalInfo objectForKey:@"sex"] isEqualToString:@"男"]) {
            UIImage *seximg = [UIImage imageNamed:@"icon_male1.png"];
            sexImage.image = seximg;
        }else{
            sexImage.image = [UIImage imageNamed:@"icon_female1.png"];
        }
        [iconImageViewBtn setImageWithURL:[NSURL URLWithString:[personalInfo objectForKey:@"icon"]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"default_head.png"]];
//        [iconImageView setImageWithURL:[NSURL URLWithString:[personalInfo objectForKey:@"icon"]] placeholderImage:[UIImage imageNamed:@"default_head.png"]];//logo.png
        NSString *images = [personalInfo objectForKey:@"imgs"];
        //小区图片
        NSArray *imgArr = [images componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@";"]];
        
        for (int i = 0; i < [imgArr count]; i++) {
            UIImage *defaultImage = [UIImage imageNamed:@"bg_sample_1.png"];
            CGRect imageframe;
            imageframe.origin.x = 10*(i+1)+defaultImage.size.width*i;
            imageframe.origin.y = 10;
            
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(75*i+10,7.5, 65, 65)];
            imageView.tag = i;
            imageView.userInteractionEnabled = YES;
            [imageView setImageWithURL:[NSURL URLWithString:[imgArr objectAtIndex:i]] placeholderImage:defaultImage];
            [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)]];
            imageView.clipsToBounds = YES;
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            [contentScrollView addSubview:imageView];
            [imageView release];
        }
        contentScrollView.contentSize = CGSizeMake(imgArr.count*75+10,75);
    }
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

- (void)tapImage:(UITapGestureRecognizer *)tap
{
     NSString *images = [personalInfo objectForKey:@"imgs"];
     //小区图片
     NSArray *imgArr = [images componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@";"]];
     // 1.封装图片数据
     NSMutableArray *photos = [NSMutableArray arrayWithCapacity:imgArr.count];
     for (int i = 0; i<imgArr.count; i++) {
     MJPhoto *photo = [[MJPhoto alloc] init];
     photo.url = [NSURL URLWithString:[imgArr objectAtIndex:i]]; // 图片路径
     photo.srcImageView = contentScrollView.subviews[i]; // 来源于哪个UIImageView
     [photos addObject:photo];
    [photo release];
     }
     
     // 2.显示相册
     MJPhotoBrowser *browser = [[[MJPhotoBrowser alloc] init] autorelease];
     browser.currentPhotoIndex = tap.view.tag; // 弹出相册时显示的第一张图片是？
     browser.photos = photos; // 设置所有的图片
     [browser show];
}

#pragma mark -- uitableviewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
        cell.textLabel.font = [UIFont systemFontOfSize:15.0];
        cell.textLabel.textColor = RGB(53, 53, 53);
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.backgroundView = [[[UIView alloc]initWithFrame:cell.bounds] autorelease];
        cell.backgroundView.backgroundColor = [UIColor whiteColor];
    }
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"他的评论";
            break;
        case 1:
            cell.textLabel.text = @"他的发布";
            break;
        default:
            break;
    }
    return cell;
}

#pragma mark -- uitableviewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //ta的发布
    if (indexPath.row == 0) {
        MyCommentViewController *commentVc = [[MyCommentViewController alloc] initWithUserId:self.introduceUserIdString title:@"他的评论"];
        commentVc.hisOrmycomment = HISCOMMENT;
        [self.navigationController pushViewController:commentVc animated:YES];
        [commentVc release];
    }else if (indexPath.row == 1) {
        MyPublishViewController *publishVc = [[MyPublishViewController alloc]initWithUserId:self.introduceUserIdString title:@"他的发布"];
        publishVc.isWhoPublish = IsHisPublish;
        [self.navigationController pushViewController:publishVc animated:YES];
        [publishVc release];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    //发送消息
    NSString *currentJidString = [NSString stringWithFormat:@"%@@%@",self.userNameJidString,kHost];
    DataBaseManager *dbManager = [DataBaseManager shareDBManeger];
    NSArray *jidArray = [dbManager selectNeighboorHoodFriendList:currentJidString];
    if ([jidArray count]==0) {
        return nil;
    }else{
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, 320.f, 50.f)];
        footerView.backgroundColor = [UIColor clearColor];
        UIImage *loginImg = [UIImage imageNamed:@"login1.png"];
        
        UIButton *nextBtn = [self newButtonWithImage:loginImg highlightedImage:nil frame:CGRectMake(10, 60, loginImg.size.width, loginImg.size.height) title:@"发送消息" titleColor:[UIColor whiteColor] titleShadowColor:nil font:[UIFont systemFontOfSize:19.0] target:self action:@selector(sendMassage)];
        [footerView addSubview:nextBtn];
        [nextBtn release];
        return [footerView autorelease];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 100.0f;
}


#pragma mark
-(void) callBackWith: (WInterface) interface status: (NSString*) status data:(id) data{
    NSLog(@"interface :%d status:%@",interface,status);
    [self hideHudView];
    if (interface == COMMUNITY_PERSONAL_INFO) {
        NSString *code = [data objectForKey:ERROR_CODE];
        if ([code isEqualToString:NETWORK_RETURN_CODE_S_OK]) {
            personalInfo = [data retain];
            
            self.userNameJidString = [data objectForKey:@"userName"];
            
            [self refreshPersonalInfo];
            
            [selfTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
        }else{
            [Global showMBProgressHudHint:self SuperView:self.view Msg:[data objectForKey:ERROR_MSG] ShowTime:1.0];
        }
    }
}

- (void) hideHudView
{
    if (hudView) {
        [hudView hide:YES];
    }
}
@end
