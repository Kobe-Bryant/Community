//
//  MySelfViewController.m
//  CommunityAPP
//
//  Created by yunlai on 14-3-4.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import "MySelfViewController.h"
#import "Global.h"
#import "NSObject_extra.h"
#import "CommunityHttpRequest.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import "UIImageView+MJWebCache.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"
#import "UserModel.h"
#import "UIButton+WebCache.h"
#import "ASIFormDataRequest.h"
#import "UserModel.h"
#import "InviteViewController.h"
#import "EditMyInfoViewController.h"
#import "EditMyPhotosViewController.h"
//#import "MainTabbarViewController.h"
#include <ImageIO/ImageIO.h>
#import "UIImage+extra.h"
#import "NSFileManager+Community.h"
#import "CTAssetsPickerController.h"
#import "UIImage+MyInfo.h"
#import "MyInfoPhoto.h"
#import "ASIFormDataRequestMyInfo.h"
#import "UIViewController+NavigationBar.h"
#import "CMBPNotification.h"
#import "UIView+Badge.h"
#import "AppConfig.h"
#import "JSONKit.h"
#import "MobClick.h"

typedef NS_ENUM(NSInteger, CMItemBadgeType) {
    CMItemBadgeNone = 0,        //无
    CMItemBadgeRedCircle,       //红点
    CMItemBadgeBadgeValue,      //数字徽章
};

@interface MySelfTableViewCell : UITableViewCell

@property (nonatomic, assign) NSInteger badgeValue;
@property (nonatomic, assign) CMItemBadgeType badgeType;
@property (nonatomic, retain) UIView *badgeView;

@end

@implementation MySelfTableViewCell{

}

- (void)dealloc{
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.badgeType = CMItemBadgeNone;
        self.badgeView = [[UIView alloc] initWithFrame:CGRectMake(280, 0, 44, 44)];
        self.badgeView.backgroundColor = [UIColor clearColor];
        self.badgeView.badge.transform = CGAffineTransformMakeTranslation(0, 22);
        self.badgeView.badge.minimumDiameter = 12;
        [self.contentView addSubview:self.badgeView];
        [self.badgeView release];
        
    }
    return self;
}


- (void)setBadgeType:(CMItemBadgeType)badgeType{
    _badgeType = badgeType;
    switch (_badgeType) {
        case CMItemBadgeNone:
            self.badgeView.badge.displayWhenZero = NO;
            break;
        case CMItemBadgeRedCircle:
            self.badgeView.badge.displayWhenZero = YES;
            self.badgeView.badge.badgeType = kBadgeCircle;
            break;
        case CMItemBadgeBadgeValue:
            self.badgeView.badge.badgeValue = _badgeValue;
            self.badgeView.badge.badgeType = kBadgeValue;
            break;
        default:
            break;
    }
    
    [self.badgeView.badge setNeedsDisplay];
    
}

/*
- (void)setBadgeValue:(NSString *)badgeValue{
    _badgeValue = badgeValue;
    if(_badgeType == CMItemBadgeBadgeValue){
        lbBadge.hidden = NO;
        lbBadge.text = _badgeValue;
    }
}
*/
@end

@interface MySelfViewController ()<CTAssetsPickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, retain) CommunityHttpRequest *request;
@property (nonatomic, assign) WInterface interface;
@property (nonatomic, retain) NSMutableDictionary *personalInfo;
@property (nonatomic, retain) UILabel *nameLab;
@property (nonatomic, retain) UILabel *homeLab;
@property (nonatomic, retain) UILabel *identifyLab;
@property (nonatomic, retain) UILabel *signatureLab;
@property (nonatomic, retain) UIImageView *sexImage;
@property (nonatomic, retain) UIButton *btnAddPhotos;
@property (nonatomic, retain) NSMutableArray *iconImagesArray;
@property (nonatomic, retain) NSMutableArray *serverImagesArray;
@property (nonatomic, assign) BOOL isIcon;
@property (nonatomic, retain) UIActionSheet *alertIcon;
@property (nonatomic, retain) UIActionSheet *alertMyPhotos;
@property (nonatomic, retain) CTAssetsPickerController *iconPicker;
@property (nonatomic, retain) CTAssetsPickerController *myPhotosPicker;
@property (nonatomic, retain) UIImagePickerController *iconCameraPicker;
@property (nonatomic, retain) UIImagePickerController *myPhotosCameraPicker;
@property (nonatomic, retain) UIImageView *jobImage;

@end

@implementation MySelfViewController

@synthesize request = _request;
@synthesize interface = _interface;
@synthesize personalInfo = _personalInfo;
@synthesize nameLab = _nameLab;
@synthesize homeLab = _homeLab;
@synthesize identifyLab = _identifyLab;
@synthesize signatureLab = _signatureLab;
@synthesize sexImage = _sexImage;
@synthesize imageData = _imageData;
@synthesize btnAddPhotos = _btnAddPhotos;
@synthesize serverImagesArray = _serverImagesArray;
@synthesize alertIcon = _actionIcon;
@synthesize alertMyPhotos = _actionMyPhotos;
@synthesize jobImage = _jobImage;
//@synthesize yesOrNo;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _personalInfo = [[NSMutableDictionary alloc] init];
        _serverImagesArray = [[NSMutableArray alloc] init];
        _iconImagesArray = [[NSMutableArray alloc] init];
    }
    return self;
}
- (void)dealloc
{
    selfTableView.dataSource = nil; selfTableView.delegate = nil;
    [_request cancelDelegate:self];
    [_personalInfo release];
    [_serverImagesArray release];
    [_iconImagesArray release];
    [selfTableView release]; selfTableView = nil;
    [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self requestPersonalInfo];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recivedMyComment:) name:kCMBPMyComments object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recivedMyBill:) name:kCMBPMyBills object:nil];
    
    [MobClick beginLogPageView:@"MySelfPage"]; // 友盟统计
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"MySelfPage"];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    if (IOS7_OR_LATER) {
        //    滑动返回
        self.navigationController.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
    }

    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.navigationController setNavigationBarHidden:NO];
    
    //自适应iOS的导航栏、状态栏
    [self adjustiOS7NaviagtionBar];
    [self setNavigationTitle:@"我的"];
    
    
    //构建tableview视图
    selfTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, MainHeight-kButtomBarHeight) style:UITableViewStylePlain];
    selfTableView.delegate = self;
    selfTableView.dataSource = self;
    selfTableView.showsVerticalScrollIndicator = NO;
    selfTableView.backgroundColor = nil;//RGB(244, 244, 244);
    selfTableView.sectionHeaderHeight = 5.0;
    selfTableView.sectionFooterHeight = 5.0;
    selfTableView.backgroundView = [[[UIView alloc] initWithFrame:selfTableView.bounds] autorelease];
    selfTableView.backgroundView.backgroundColor = RGB(244, 244, 244);
    selfTableView.tableHeaderView = [self initHeadView];
    selfTableView.tableFooterView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
    [self.view addSubview:selfTableView];
    
//    add vincent 2014.3.12
    if ([self getCacheUrlString:GlobalCommubityMyPersonalInformation]) {
        
        NSMutableDictionary *dic = (NSMutableDictionary *)[self getCacheDataDictionaryString:GlobalCommubityMyPersonalInformation];
        [_personalInfo setDictionary:dic];
        [self refreshPersonalInfo];
        
        [selfTableView reloadData];
        
    }
}

//返回  点击头像进入显示返回
-(void)backBtnAction{
    [self.navigationController popViewControllerAnimated:YES];
}

//强求当前的数据
-(void)requestPersonalInfo{
    if (_request == nil) {
        _request = [CommunityHttpRequest shareInstance];
    }
    UserModel *userModel = [UserModel shareUser];
    NSString *string = [NSString stringWithFormat:@"?updateTime=%@&userId=%@&communityId=%@&propertyId=%@",DEF_UPDATE_TIME,userModel.userId,userModel.communityId,userModel.propertyId];//参数

    [_request requestPersonalInfodelegate:self parameters:string];
}

//
- (UIView *)initHeadView{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 160)];
    view.backgroundColor = [UIColor whiteColor];
    //个人资料
    //头像image
    headerImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    headerImageBtn.frame = CGRectMake(14,10,60,60);
    headerImageBtn.layer.cornerRadius = 29.0;
    headerImageBtn.layer.masksToBounds = YES;
    [headerImageBtn addTarget:self action:@selector(headerImageBtn:) forControlEvents:UIControlEventTouchUpInside];
    [headerImageBtn setImageWithURL:[NSURL URLWithString:[_personalInfo objectForKey:@"icon"]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"default_head.png"]];//logo.png
    
    //
    //性别image
    _sexImage = [[UIImageView alloc]initWithFrame:CGRectMake(86, 15, 12, 12)];
    
    //姓名lable
    _nameLab = [[UILabel alloc]initWithFrame:CGRectMake(101, 11, 250, 23)];
    _nameLab.font = [UIFont systemFontOfSize:17.0];
    _nameLab.textColor = RGB(68, 68, 68);

    //座右铭lable
    _signatureLab = [[UILabel alloc]initWithFrame:CGRectMake(85, 30, 200, 20)];
    _signatureLab.font = [UIFont systemFontOfSize:13.0];
    _signatureLab.lineBreakMode = NSLineBreakByTruncatingTail;
    _signatureLab.textColor = RGB(100, 100, 100);
    
    //小区标志图片
    UIImage *homeimg = [UIImage imageNamed:@"building_icon.png"];
    UIImageView *homeImage = [[UIImageView alloc]initWithFrame:CGRectMake(85, 57, 15, 15)];
    homeImage.image = homeimg;
    
    //小区位置lable
    _homeLab = [[UILabel alloc]initWithFrame:CGRectMake(104, 53, 80, 21)];
    _homeLab.font = [UIFont systemFontOfSize:13.0];
    _homeLab.lineBreakMode = NSLineBreakByTruncatingTail;
    _homeLab.textColor = RGB(100, 100, 100);
    
    //职位标志图片
    UIImage *jobimg = [UIImage imageNamed:@"housing_icon.png"];
    _jobImage = [[UIImageView alloc]initWithFrame:CGRectMake(190, 57, 15, 15)];
    _jobImage.image = jobimg;
    
    //职位lable
    _identifyLab = [[UILabel alloc]initWithFrame:CGRectMake(209, 53, 100, 21)];
    _identifyLab.font = [UIFont systemFontOfSize:13.0];
    _identifyLab.textColor = RGB(100, 100, 100);
    
    UIButton *btnAssessory = [UIButton buttonWithType:UIButtonTypeCustom];
    btnAssessory.frame = CGRectMake(88, 0, 320-86, 80);
    btnAssessory.imageEdgeInsets = UIEdgeInsetsMake(0, 203, 0, 15);
    [btnAssessory setImage:[UIImage imageNamed:@"arrow_icon.png"] forState:UIControlStateNormal];
    [btnAssessory addTarget:self action:@selector(editMyInfo:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btnAssessory];

    //线
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 79, ScreenWidth, 1)];
    lineView.backgroundColor = RGB(244, 244, 244);
    [view addSubview:lineView];
    [lineView release];
    
    //滚动视图
    contentScrollView =[[UIScrollView alloc]initWithFrame:CGRectMake(0, 80, ScreenWidth, 80)] ;
    contentScrollView.pagingEnabled = YES;
    contentScrollView.showsHorizontalScrollIndicator = NO;
    contentScrollView.showsVerticalScrollIndicator = NO;
    contentScrollView.scrollsToTop = NO;
    contentScrollView.backgroundColor = RGB(240, 240, 240);
    [view addSubview:contentScrollView];
    [contentScrollView release];
    
    [view addSubview:_nameLab];
    [view addSubview:_sexImage];
    [view addSubview:_signatureLab];
    [view addSubview:headerImageBtn];
    [view addSubview:homeImage];
    [view addSubview:_jobImage];
    [view addSubview:_homeLab];
    [view addSubview:_identifyLab];
    [_nameLab release];
    [_sexImage release];
    [_jobImage release];
    [_signatureLab release];
    [homeImage release];
    [_homeLab release];
    [_identifyLab release];
    
    return view;
}

- (void)recivedMyComment:(NSNotification *)notice{
    [self refreshCommentStatus];
}

- (void)refreshCommentStatus{
    NSArray *array = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:1 inSection:1]];
    [selfTableView reloadRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)recivedMyBill:(NSNotification *)notice{
    [self refreshBillsStatus];
}

- (void)refreshBillsStatus{
    NSArray *array = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]];
    [selfTableView reloadRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationAutomatic];
}


#pragma mark ---Action
- (void)editMyInfo:(UIButton *)sender{
    EditMyInfoViewController *editMyInfo = [[EditMyInfoViewController alloc] initWithNibName:nil bundle:nil];
    editMyInfo.personalInfo = _personalInfo;
    editMyInfo.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:editMyInfo animated:YES];
    [editMyInfo release];
}

#pragma mark -- uitableviewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 2;
            break;
        case 1:
            if ([[_personalInfo objectForKey:@"identity"] isEqualToString:@"业主"]) {

                return 4;
            }else{
                return 3;
            }
            break;
        case 2:
            return 1;
            break;
            
        default:
            break;
    }
    return section;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"Cell";
    MySelfTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[[MySelfTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
        cell.textLabel.font = [UIFont systemFontOfSize:15.0];
        cell.textLabel.textColor = RGB(100, 100, 100);
        //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.accessoryView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow_right_icon.png"]] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = nil;
        cell.backgroundView = [[[UIView alloc] initWithFrame:cell.bounds] autorelease];
        cell.backgroundView.backgroundColor = [UIColor whiteColor];

    }
    NSInteger section = [indexPath section];
    NSInteger row = [indexPath row];
    cell.badgeType = CMItemBadgeNone;
    switch (section) {
        case 0:
            if (row ==0) {
                cell.textLabel.text = @"我的账单";

                if (![CMBPNotification shareInstance].isBillRead) {
                    cell.badgeType = CMItemBadgeRedCircle;
                }else{
                    cell.badgeType = CMItemBadgeNone;
                }
            }else if (row == 1) {
                cell.textLabel.text = @"我的积分";
            }
         
            break;
        case 1:
            if (row ==0){
                cell.textLabel.text = @"我的发布";
            }else if (row ==1) {
                cell.textLabel.text = @"我的评论";
                
                if (![CMBPNotification shareInstance].isCommentRead) {
                    cell.badgeType = CMItemBadgeRedCircle;
                }else{
                    cell.badgeType = CMItemBadgeNone;
                }
                
            }else if (row ==2) {
                cell.textLabel.text = @"我的收藏";
            }else if (row == 3) {
                cell.textLabel.text = @"邀请码";
            }
            break;
        case 2:
            if (row ==0) {
                cell.textLabel.text = @"设置";
            }
            break;
            
        default:
            break;
    }
    return cell;
}

#pragma mark -- uitableviewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0.0f;
    }
    return 10.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *__view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 10.0f)];
    [__view setBackgroundColor:RGB(236, 236, 236)];
    return __view;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    switch (section) {
        case 0:
            //我的账单
            if (row == 0) {
                [CMBPNotification shareInstance].isBillRead = YES;
                [self refreshBillsStatus];
                MyBillViewController *billVc =[[MyBillViewController alloc]init];
                billVc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:billVc animated:YES];
                [billVc release];
            }
            //我的积分
            if (row ==1) {
                MyScoreViewController *scoreVc = [[MyScoreViewController alloc]init];
                scoreVc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:scoreVc animated:YES];
                [scoreVc release];
            }
            break;
        case 1:
            //我的发布
            if (row == 0) {
                MyPublishViewController *publishVc = [[MyPublishViewController alloc]initWithUserId:nil title:@"我的发布"];
                 publishVc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:publishVc animated:YES];
                [publishVc release];
                
            }
            //我的评论
            if (row == 1) {
                
                [CMBPNotification shareInstance].isCommentRead = YES;
                [self refreshCommentStatus];
                MyCommentViewController *commentVc = [[MyCommentViewController alloc]initWithUserId:nil title:@"我的评论"];
                commentVc.hisOrmycomment = MYCOMMENT;
                 commentVc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:commentVc animated:YES];
                [commentVc release];
                
            }
            //我的收藏
            if (row == 2) {
                MyCollectionViewController *collectionVc = [[MyCollectionViewController alloc]init];
                collectionVc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:collectionVc animated:YES];
                [collectionVc release];
                
            }
            //邀请码
            if (row == 3) {
                InviteViewController *inviteVc = [[InviteViewController alloc]init];
                inviteVc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:inviteVc animated:YES];
                [inviteVc release];
            }
            break;
        case 2:
            //设置
            if (row == 0) {
                SetUpViewController *setupVc = [[SetUpViewController alloc]init];
                setupVc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:setupVc animated:YES];
                [setupVc release];
                
            }
            break;
            
        default:
            break;
    }
     [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark
-(void) callBackWith: (WInterface) interface status: (NSString*) status data:(id) data{
    NSLog(@"interface :%d status:%@",interface,status);
    if (interface == COMMUNITY_PERSONAL_INFO) {
        NSString *code = [data objectForKey:ERROR_CODE];
        if ([code isEqualToString:NETWORK_RETURN_CODE_S_OK]) {
            _personalInfo = [data retain];
            [self refreshPersonalInfo];
            [selfTableView  reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
            //        add vincent 保存当前我的资料的数据
            [self savePersonalInfo];
        }else{
            NSLog(@"个人资料获取失败");
        }
    }
    else {
        NSLog(@"个人资料获取失败");
    }
}

- (void)savePersonalInfo{
     [self saveCacheUrlString:GlobalCommubityMyPersonalInformation andNSDictionary:_personalInfo];
}

- (void)refreshPersonalInfo{
    if (_personalInfo) {
        [self setNavigationTitle:[_personalInfo objectForKey:@"nickName"]];
        _nameLab.text = [_personalInfo objectForKey:@"nickName"];
        _signatureLab.text = [_personalInfo objectForKey:@"signature"];
        _homeLab.text = [_personalInfo objectForKey:@"communityName"];
        CGSize titleSize = [_homeLab.text sizeWithFont:[UIFont systemFontOfSize:13.0] constrainedToSize:CGSizeMake(MAXFLOAT, 30)];//获取小区的字符的宽度
        _homeLab.frame = CGRectMake(104, 53,MIN(titleSize.width, 153), 21);//小区字符长度超过153，则显示省略号
        _jobImage.frame = CGRectMake(_homeLab.frame.size.width+_homeLab.frame.origin.x+10, 57, 15, 15);
        _identifyLab.frame = CGRectMake(_jobImage.frame.size.width+_jobImage.frame.origin.x+3, 53, 40, 21);
        
        _identifyLab.text = [_personalInfo objectForKey:@"identity"];
        if ([[_personalInfo objectForKey:@"sex"] isEqualToString:@"男"]) {
            UIImage *seximg = [UIImage imageNamed:@"icon_male1.png"];
            _sexImage.image = seximg;
        }else{
            _sexImage.image = [UIImage imageNamed:@"icon_female1.png"];
        }
        [headerImageBtn setImageWithURL:[NSURL URLWithString:[_personalInfo objectForKey:@"icon"]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"default_head.png"]];//logo.png
        //存储icon
        [self saveIconPhoto];
        
        NSString *images = [_personalInfo objectForKey:@"imgs"];
        //小区图片
        NSArray *imgArr = [images componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@";"]];
        NSString *imageIds = [_personalInfo objectForKey:@"imgIds"];
        NSArray *imgIdArr = [imageIds componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@";"]];
        [self.serverImagesArray removeAllObjects];
        if (images.length > 0 && [imgArr count] >= 1) {
            
            for (int i = 0; i < [imgArr count]; i++) {
                MyInfoPhoto *photo = [[[MyInfoPhoto alloc] init] autorelease];
                photo.photoComeFrom = YLPhotoFromServer;
                photo.strUrl = [imgArr objectAtIndex:i];
                photo.imageId = [imgIdArr objectAtIndex:i];
                [self.serverImagesArray addObject:photo];
            }
        }
        [self refreshMyPhotos];
    }
}

- (void)saveIconPhoto{
    [self.iconImagesArray removeAllObjects];
    MyInfoPhoto *photo = [[[MyInfoPhoto alloc] init] autorelease];
    photo.photoComeFrom = YLPhotoFromServer;
    photo.strUrl = [_personalInfo objectForKey:@"icon"];
    photo.isIcon = YES;
    [self.iconImagesArray addObject:photo];
}

- (void)refreshMyPhotos{
    
    for(UIView *subView in contentScrollView.subviews){
        [subView removeFromSuperview];
    }
    for (int i = 0; i<[self.serverImagesArray count]; i++) {
        MyInfoPhoto *photo = [self.serverImagesArray objectAtIndex:i];
        UIImage *defaultImage = [UIImage imageNamed:@"pic_default.png"];
        CGRect imageframe;
        imageframe.origin.x = 10*(i+1)+defaultImage.size.width*i;
        imageframe.origin.y = 10;
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(75*i+10,7.5, 65, 65)];

        imageView.tag = i;
        imageView.userInteractionEnabled = YES;
        [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)]];
        imageView.clipsToBounds = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        [contentScrollView addSubview:imageView];
        [imageView release];
        if (photo.photoComeFrom == YLPhotoFromServer) {
            //[imageView setImageWithURL:[NSURL URLWithString:[self.serverImagesArray objectAtIndex:i]] placeholderImage:defaultImage];
            [imageView setImageWithURL:[NSURL URLWithString:photo.strUrl]
                      placeholderImage:defaultImage
                             completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                                 if (error == nil) {
                                     photo.image = image;
                                 }
                             }];
        }else if (photo.photoComeFrom == YLPhotoFromLibrary || photo.photoComeFrom == YLPhotoFromCamera){
        }
    }
    //添加照片button
    _btnAddPhotos = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnAddPhotos.frame = CGRectMake(10,7.5, 65, 65);
    [_btnAddPhotos setImage:[UIImage imageNamed:@"icon_car_add.png"] forState:UIControlStateNormal];
    [_btnAddPhotos addTarget:self action:@selector(addPicBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [contentScrollView addSubview:_btnAddPhotos];
    
    if ([self.serverImagesArray count] >= 5) {
        _btnAddPhotos.hidden = YES;
        contentScrollView.contentSize = CGSizeMake((self.serverImagesArray.count-1)*75+85,75);
    }else{
        _btnAddPhotos.frame = CGRectMake(75*(self.serverImagesArray.count)+10,7.5, 65, 65);
        contentScrollView.contentSize = CGSizeMake((self.serverImagesArray.count)*75+85,75);
    }
    NSLog(@"%@",NSStringFromCGSize(contentScrollView.contentSize));
}

- (void)tapImage:(UITapGestureRecognizer *)tap
{
    if ([self.serverImagesArray count] > 0) {
        UIView *view = tap.view;
//        MainTabbarViewController *tabBarController = (MainTabbarViewController *)self.tabBarController;
//        [tabBarController hideNewTabBar];
        
        EditMyPhotosViewController *vc = [[EditMyPhotosViewController alloc] initWithNibName:nil bundle:nil];
        vc.hidesBottomBarWhenPushed = YES;
        vc.images  = self.serverImagesArray;
        vc.index = view.tag;
        [self.navigationController pushViewController:vc animated:YES];
        [vc release];
    }
    
    return;

}


-(void)headerImageBtn:(UIButton *)sender
{
    self.isIcon = YES;
    if ([sender imageForState:UIControlStateNormal] == nil) {       //没有自定义图就添加
        _actionIcon = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消"destructiveButtonTitle:@"拍照" otherButtonTitles:@"从相册选择", nil];
        [_actionIcon showInView:[UIApplication sharedApplication].keyWindow];
        [_actionIcon release];
    }else{
    
        EditMyPhotosViewController *vc = [[EditMyPhotosViewController alloc] initWithNibName:nil bundle:nil];
        vc.images  = self.iconImagesArray;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        [vc release];
    }
}

- (void)addPicBtnAction:(UIButton *)sender{
    
    self.isIcon = NO;
    _actionMyPhotos = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消"destructiveButtonTitle:@"拍照" otherButtonTitles:@"从相册选择", nil];
    [_actionMyPhotos showInView:[UIApplication sharedApplication].keyWindow];
    [_actionMyPhotos release];
}

#pragma mark --- UIActionSheetDelegate
//选择照相，或者照片库
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;
{
    if (buttonIndex == 0) {
        
        BOOL iscamera = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
        if (!iscamera) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"没有相机" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
            [alert release];
            return;
        }

        if (actionSheet == _actionIcon) {
            _iconCameraPicker = [[UIImagePickerController alloc]init];
            _iconCameraPicker.delegate = self;
            _iconCameraPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            _iconCameraPicker.allowsEditing = YES;
            [self presentViewController:_iconCameraPicker animated:YES completion:NULL];
            [_iconCameraPicker release];
            
        }else{
            _myPhotosCameraPicker = [[UIImagePickerController alloc]init];
            _myPhotosCameraPicker.delegate = self;
            _myPhotosCameraPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            _myPhotosCameraPicker.allowsEditing = YES;
            [self presentViewController:_myPhotosCameraPicker animated:YES completion:NULL];
            [_myPhotosCameraPicker release];
        }
    }
    if (buttonIndex == 1) {
        if (actionSheet == _actionIcon) {
            _iconCameraPicker  =[[UIImagePickerController alloc] init];
            _iconCameraPicker.allowsEditing = YES;
            //设置委托
            _iconCameraPicker.delegate=self;
            _iconCameraPicker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:_iconCameraPicker animated:YES completion:NULL];
            [_iconCameraPicker release];
            
//            _iconPicker = [[CTAssetsPickerController alloc] init];
//            _iconPicker.maximumNumberOfSelection = 5 - [self.serverImagesArray count];
//            _iconPicker.delegate = self;
//            [self presentViewController:_myPhotosPicker animated:YES completion:NULL];
//            [_iconPicker release];
        }else{
            _myPhotosPicker = [[CTAssetsPickerController alloc] init];
            _myPhotosPicker.maximumNumberOfSelection = 5 - [self.serverImagesArray count];
            _myPhotosPicker.delegate = self;
            [self presentViewController:_myPhotosPicker animated:YES completion:NULL];
            [_myPhotosPicker release];
        }
        

    }
}

#pragma mark --CTAssetsPickerControllerDelegate
-(void)assetsPickerController:(CTAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets
{
    if ([assets count] > 0) {
        //NSMutableArray *array = [[[NSMutableArray alloc] init] autorelease];
        
        if (picker == _myPhotosPicker) {
            for (ALAsset *asset in assets)
            {
                ALAssetRepresentation *assetRepresentation = [asset defaultRepresentation];
                UIImage *image = [UIImage imageWithCGImage:assetRepresentation.fullScreenImage];
                
                UIImage *compressImage = [UIImage writeImageToSandBox:image name:assetRepresentation.filename];
                //[array addObject:compressImage];
                
                MyInfoPhoto *photo = [[[MyInfoPhoto alloc] init] autorelease];
                photo.image = compressImage;
                photo.photoComeFrom = YLPhotoFromLibrary;
                photo.photoState = YLStateUploading;
                photo.fileName = assetRepresentation.filename;
                photo.photoIndex = [self.serverImagesArray count];
                //[self.serverImagesArray addObject:photo];
            
                [self requestAddAuction:photo];
            }
            
            [Global showMBProgressHud:self SuperView:self.view Msg:@"请稍等..."];
            //[self refreshMyPhotos];

        }else if (_iconPicker == picker){
            
        }
        
    }
}

#pragma mark ---network
- (void)requestAddAuction:(MyInfoPhoto *)photo{
     NSString *str = HTTPURLPREFIX; //
     NSString *urlString = [str stringByAppendingString:MY_MEANS_POST];
     UserModel *userModel = [UserModel shareUser];
    ASIFormDataRequestMyInfo *uploadImageRequest = [ASIFormDataRequestMyInfo requestWithURL:[NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    [uploadImageRequest setStringEncoding:NSUTF8StringEncoding];
    [uploadImageRequest setRequestMethod:@"POST"];
    [uploadImageRequest setPostValue:userModel.userId forKey:@"userId"];
    [uploadImageRequest setPostValue:userModel.communityId forKey:@"communityId"];
    [uploadImageRequest setPostValue:userModel.propertyId forKey:@"propertyId"];
    
    if (photo.isIcon) {
       [uploadImageRequest setPostValue:@"2" forKey:@"requestType"];
    }else{
        [uploadImageRequest setPostValue:@"3" forKey:@"requestType"];
    }
    NSString *strDetail = @"U";
    if (photo.detailType == YLPhotoUpdate) {
        strDetail = @"U";
    }else if (photo.detailType == YLPhotoDelete){
        strDetail = @"D";
    }else if (photo.detailType == YLPHotoADD){
        strDetail = @"A";
    }
    [uploadImageRequest setPostValue:strDetail forKey:@"imgState"];
    
    NSData *data = UIImageJPEGRepresentation(photo.image,0.2); //UIImagePNGRepresentation(photo.image);
    [uploadImageRequest addData:data withFileName:photo.fileName andContentType:@"image/jpeg" forKey:@"imageStream"];
    [uploadImageRequest setPostFormat:ASIMultipartFormDataPostFormat];
    
    //标识
    uploadImageRequest.myInfoPhoto = photo;
    [uploadImageRequest setDelegate:self];
    [uploadImageRequest setDidFinishSelector:@selector(responseComplete:)];
    [uploadImageRequest setDidFailSelector : @selector (responseFailed:)];
    [uploadImageRequest startAsynchronous];
}

- (void)responseComplete:(ASIFormDataRequest *)request{
    NSString* response = [request responseString];
    NSLog(@"response %@",response);
    
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSDictionary *dictionary = [response objectFromJSONString];
    NSString *code = [dictionary objectForKey:@"errorCode"] ;
    if ([code isEqualToString:NETWORK_RETURN_CODE_S_OK]) {
        NSLog(@"上传成功");
        ASIFormDataRequestMyInfo *myInfoRequest = (ASIFormDataRequestMyInfo *)request;
        if (myInfoRequest.myInfoPhoto.isIcon) {
            myInfoRequest.myInfoPhoto.photoComeFrom = YLPhotoFromServer;
            myInfoRequest.myInfoPhoto.strUrl = [dictionary objectForKey:@"imgs"];
            [headerImageBtn setImageWithURL:[NSURL URLWithString:myInfoRequest.myInfoPhoto.strUrl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"default_head.png"]];
            
        }else{
            myInfoRequest.myInfoPhoto.strUrl = [dictionary objectForKey:@"imgs"];
            myInfoRequest.myInfoPhoto.imageId = [dictionary objectForKey:@"imgIds"];
            myInfoRequest.myInfoPhoto.photoComeFrom = YLPhotoFromServer;
            NSLog(@"refreshMyPhotos");
            [self.serverImagesArray addObject:myInfoRequest.myInfoPhoto];
            [self refreshMyPhotos];
        }
        
    }else{
        NSLog(@"上传失败");
    }
}
- (void)responseFailed:(ASIFormDataRequest *)request{
    NSString* response = [request responseString];
    NSLog(@"response %@",response);
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSDictionary *dictionary = [response objectFromJSONString];
    NSString *code = [dictionary objectForKey:@"errorCode"] ;
    if ([code isEqualToString:NETWORK_RETURN_CODE_S_OK]) {
        NSLog(@"上传成功");
        
    }else{
        NSLog(@"上传失败");
    }
}



#pragma mark --UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    NSString *str = (NSString*)kCGImagePropertyTIFFDictionary;
    NSDictionary *dic = [[info objectForKey:UIImagePickerControllerMediaMetadata] objectForKey:str];
    image.fileName = [[dic objectForKey:@"DateTime"] stringByAppendingPathExtension:@"jpg"];
    UIImage *newImage = [UIImage writeImageToSandBox:image name:image.fileName];
    
    MyInfoPhoto *photo = [[[MyInfoPhoto alloc] init] autorelease];
    photo.image = newImage;
    photo.photoComeFrom = YLPhotoFromLibrary;
    photo.fileName=  image.fileName;
    photo.isIcon = YES;
    
    if (picker == _myPhotosCameraPicker) {
        photo.isIcon = NO;
    }else if (picker == _iconCameraPicker){
        photo.isIcon = YES;
    }
    
    [self requestAddAuction:photo];//调用上传头像方法
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    image = nil;
}


@end
