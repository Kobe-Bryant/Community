//
//  ConvenientSellViewController.m
//  CommunityAPP
//
//  Created by Dream on 14-3-17.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import "ConvenientSellViewController.h"
#import "Global.h"
#import "NSObject_extra.h"
#import "SellToolBar.h"
#import "AddGoodsViewController.h"
#import "SellingDetailViewController.h"
#import "GoodsPrview.h"
#import "CommunityHttpRequest.h"
#import "ASIWebServer.h"
#import "UserModel.h"
#import "AuctionModel.h"
#import "UIImageView+WebCache.h"
#import "CTAssetsPickerController.h"
#import "UIImage+extra.h"
#include <ImageIO/ImageIO.h>
#import "CMDefaultShare.h"
#import "ShareContentViewController.h"
#import "UIViewController+NavigationBar.h"
#import "NeighborhoodIntroduceViewController.h"

@interface ConvenientSellViewController ()<UIActionSheetDelegate,WebServiceHelperDelegate,CTAssetsPickerControllerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,CMShareDelegate,UIScrollViewDelegate>

@property (nonatomic, retain) NSMutableArray *goodsList;        //商品列表
@property (nonatomic, retain) SellToolBar *sellingToolBar;

@property (nonatomic, retain) CommunityHttpRequest *request;
@property (nonatomic, assign) NSInteger requestType;

@property (nonatomic, retain) UIScrollView *adScrollView;
@property (nonatomic, retain) NSMutableArray *goodsPrviews;

@property (nonatomic, retain) NSString *lastId;

@end

@implementation ConvenientSellViewController

@synthesize goodsList = _goodsList;
@synthesize sellingToolBar = _sellingToolBar;
@synthesize request = _request;
@synthesize requestType = _requestType;
@synthesize adScrollView = _adScrollView;
@synthesize lastId = _lastId;

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_request cancelDelegate:self];
    [_goodsList release]; _goodsList = nil;
    [_goodsPrviews release]; _goodsPrviews = nil;
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _goodsList = [[NSMutableArray alloc] init];
        _goodsPrviews = [[NSMutableArray alloc] init];
        _requestType = 2;
    }
    return self;
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
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    imageView.image = [UIImage imageNamed:@"bg.png"];
    [self.view addSubview:imageView];
    [imageView release];
    
    //构建滚动视图
    _adScrollView =[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, MainHeight)] ;
    _adScrollView.bounces = NO;
    _adScrollView.delegate = self;
    _adScrollView.pagingEnabled = YES;
    _adScrollView.showsHorizontalScrollIndicator = NO;
    _adScrollView.showsVerticalScrollIndicator = NO;
    _adScrollView.scrollsToTop = NO;
    [_adScrollView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:_adScrollView];
    [_adScrollView release];
    
    _sellingToolBar = [[SellToolBar alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.frame)-60-StateBarHeight-NavigationBarHeight, 320, 60)];
    [_sellingToolBar.btnTakePhotos addTarget:self action:@selector(addSellPhotos:) forControlEvents:UIControlEventTouchUpInside];
    [_sellingToolBar.btnComment addTarget:self action:@selector(entryComments:) forControlEvents:UIControlEventTouchUpInside];
    [_sellingToolBar.btnShare addTarget:self action:@selector(sharePlatform:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_sellingToolBar];
    [_sellingToolBar release];

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self requestAuctionList];
}


// 导航左右按钮
-(void)leftBtnAction
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ---network
- (void)requestAuctionList{
    
    UserModel *userModel = [UserModel shareUser];
    // 网络请求
    if (_request == nil) {
        _request = [CommunityHttpRequest shareInstance];
    }
    NSString *string = [NSString stringWithFormat:@"?userId=%@&communityId=%@&propertyId=%@&requestType=%@&lastId=%@",userModel.userId,userModel.communityId,userModel.propertyId,[NSNumber numberWithInteger:_requestType],@"0"];//参数
    [_request requestAuctionList:self parameters:string];
}

-(void) callBackWith: (WInterface) interface status: (NSString*) status data:(id) data{
    if (interface == COMMUNITY_AUCTION_LIST) {
        [self.goodsList removeAllObjects];
        [self.goodsPrviews removeAllObjects];
        if ([status isEqualToString:NETWORK_RETURN_CODE_S_OK]) {
            NSLog(@"请求拍卖列表成功");
            NSString *lastTime = [data objectForKey:@"lastCorderUpdateTime"];
            NSLog(@"%@",lastTime);
            NSArray *array = [data objectForKey:@"auctions"];
            if ([array count] == 0) {
                [Global showMBProgressHudHint:self SuperView:self.view Msg:@"当前没有数据" ShowTime:1.0];
            }
            for (NSDictionary *dic in array) {
                AuctionModel *model = [[AuctionModel alloc] init];
                model.auctionId = [dic objectForKey:@"auctionId"];
                model.auctionUpdateTime = [dic objectForKey:@"auctionUpdateTime"];
                model.commentNumber = [dic objectForKey:@"commentNumber"];
                model.communityName = [dic objectForKey:@"communityName"];
                model.cost = [dic objectForKey:@"cost"];
                model.images = [dic objectForKey:@"image"];
                model.title = [dic objectForKey:@"title"];
                model.residentId = [dic objectForKey:@"residentId"];
                model.residentIcon = [dic objectForKey:@"residentIcon"];
                model.sharedContent = [dic objectForKey:@"sharedContent"];
                [self.goodsList addObject:model];
                [model release];
            }
            
            [self refreshAuctionList];
        }else{
            
        }
    }
}

- (AuctionModel *)getCurrentAuction{
    NSInteger index = self.adScrollView.contentOffset.x/self.adScrollView.bounds.size.width;
    AuctionModel *model = ([self.goodsList count] > index)?[self.goodsList objectAtIndex:index]:nil;
    return model;
}

- (GoodsPrview *)getCurrentGoodsPrview{
    NSInteger index = self.adScrollView.contentOffset.x/self.adScrollView.bounds.size.width;
    GoodsPrview *goodsPrview = ([self.goodsPrviews count] > index)?[self.goodsPrviews objectAtIndex:index]:nil;
    return goodsPrview;
}

- (void)refreshAuctionList{
    
    for (GoodsPrview *view in self.adScrollView.subviews) {
        [view removeFromSuperview];
    }
    for (int i = 0; i<[_goodsList count]; i++) {
        CGRect imageframe = _adScrollView.frame;
        imageframe.origin.x = ScreenWidth * i;
        imageframe.origin.y = 0;
        
        GoodsPrview *goodsPrview = [[GoodsPrview alloc] initWithFrame:imageframe];
        //goodsPrview.auctionModel = [_goodsList objectAtIndex:i];
        goodsPrview.btnGoodsPrview.tag = i;
        [goodsPrview.btnGoodsPrview addTarget:self action:@selector(goodsDetailEntry:) forControlEvents:UIControlEventTouchUpInside];
        [goodsPrview.userIconTap addTarget:self action:@selector(tapUserIcon:)];
        [_adScrollView addSubview:goodsPrview];
        [self.goodsPrviews  addObject:goodsPrview];
        [goodsPrview release];
        
    }
    _adScrollView.contentSize = CGSizeMake(_goodsList.count * _adScrollView.frame.size.width, _adScrollView.frame.size.height);
    
    [self refreshCurrentAuction];
}


- (void)refreshCurrentAuction{
    AuctionModel *model = [self getCurrentAuction];
    GoodsPrview *goodPrview = [self getCurrentGoodsPrview];
    
    [goodPrview setAuctionModel:model];
}


-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    //CGFloat pageWidth = scrollView.frame.size.width;
    //int pageIndex = floor((scrollView.contentOffset.x - pageWidth/2)/pageWidth) + 1;

    [self refreshCurrentAuction];
    
}
#pragma mark ---Action
- (void)addSellPhotos:(UIButton *)sender{
    
    UIActionSheet* mySheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消"destructiveButtonTitle:@"拍照" otherButtonTitles:@"从相册选择", nil];
    [mySheet showInView:[UIApplication sharedApplication].keyWindow];
    [mySheet release];
}

- (void)entryComments:(UIButton *)sender{
    NSString *auctionId = @"";
    AuctionModel *auctionModel = [self getCurrentAuction];
    if (auctionModel) {
        auctionId = auctionModel.auctionId;
    }
    
    SellingDetailViewController *vc = [[[SellingDetailViewController alloc] initWithNibName:nil bundle:nil] autorelease];
    vc.entryType = CMEntryPush;
    vc.type = CMAUCTION;
    vc.baseId = auctionId;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)sharePlatform:(UIButton *)sender{
    [[CMDefaultShare shareInstance] popInController:self delegate:self];
}

-(void)goodsDetailEntry:(GoodsPrviewButton *)sender{
    NSLog(@"%@",sender);
    
    NSString *auctionId = @"";
    if ([sender isKindOfClass:[GoodsPrviewButton class]]) {
        auctionId = sender.auctionModel.auctionId;
    }

    SellingDetailViewController *vc = [[[SellingDetailViewController alloc] initWithNibName:nil bundle:nil] autorelease];
    vc.entryType = CMEntryPush;
    vc.type = CMAUCTION;
    vc.baseId = auctionId;
    [self.navigationController pushViewController:vc animated:YES];

}

- (void)tapUserIcon:(id)sender{
    NSString *residentId = @"";
    AuctionModel *auctionModel = [self getCurrentAuction];
    if (auctionModel) {
        residentId = auctionModel.residentId;
    }
    
    NeighborhoodIntroduceViewController *introduceVc = [[NeighborhoodIntroduceViewController alloc] initWithUserId:residentId communityId:nil propertyId:nil name:nil];
    [self.navigationController pushViewController:introduceVc animated:YES];
    [introduceVc release];
}

//选择照相，或者照片库
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;
{
    if (buttonIndex == 0) {
        
        BOOL iscamera = [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
        if (!iscamera) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"没有相机" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
            [alert show];
            [alert release];
            return;
        }
        UIImagePickerController *pick = [[[UIImagePickerController alloc] init] autorelease];
        pick.delegate = self;
        pick.sourceType = UIImagePickerControllerSourceTypeCamera;
        pick.allowsEditing = YES;
        [self presentViewController:pick animated:YES completion:NULL];
        
    }
    if (buttonIndex == 1) {
        CTAssetsPickerController *picker = [[[CTAssetsPickerController alloc] init] autorelease];
        picker.maximumNumberOfSelection = 5;
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
    }else{
        
        [picker dismissViewControllerAnimated:YES completion:nil];
        
        UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
        NSString *str = (NSString*)kCGImagePropertyTIFFDictionary;
        NSDictionary *dic = [[info objectForKey:UIImagePickerControllerMediaMetadata] objectForKey:str];
        
        image.fileName = [[dic objectForKey:@"DateTime"] stringByAppendingPathExtension:@"jpg"];
        
        UIImage *newImage = [UIImage writeImageToSandBox:image name:image.fileName];
        image = nil;
        AddGoodsViewController *addGoodsVC = [[AddGoodsViewController alloc] initWithNibName:nil bundle:nil];
        [addGoodsVC.imageArr addObject:newImage];
        [self.navigationController pushViewController:addGoodsVC animated:YES];
        [addGoodsVC release];
        
    }
}

#pragma mark --CTAssetsPickerControllerDelegate
-(void)assetsPickerController:(CTAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets
{
    if ([assets count] > 0) {
        NSMutableArray *array = [[[NSMutableArray alloc] init] autorelease];
        for (ALAsset *asset in assets)
        {
            ALAssetRepresentation *assetRepresentation = [asset defaultRepresentation];
            UIImage *image = [UIImage imageWithCGImage:assetRepresentation.fullScreenImage];
            UIImage *newImage = [UIImage writeImageToSandBox:image name:assetRepresentation.filename];
            [array addObject:newImage];
            
        }
        
        AddGoodsViewController *addGoodsVC = [[AddGoodsViewController alloc] initWithNibName:nil bundle:nil];
        [addGoodsVC.imageArr addObjectsFromArray:array];
        [self.navigationController pushViewController:addGoodsVC animated:YES];
        [addGoodsVC release];

    }
    

}

#pragma mark ---CMShareDelegate
- (void)shareWithType:(ShareType)shareType{
    switch (shareType) {
        case ShareTypeSinaWeibo:    //新浪微博
            [self shareSinaWeibo];
            break;
        case ShareTypeTencentWeibo: //腾讯微博
            [self shareTencentWeibo];
            break;
        case ShareTypeWeixiSession: //微信
            [self shareWeChatSession];
            break;
            
        case ShareTypeWeixiTimeline:    //朋友圈
            [self shareWeChatTimeline];
            break;
            
        case ShareTypeSMS:      //短信
            [self shareSendSMS];
            break;
            
        case ShareTypeMail:     //邮件
            [self shareSendMail];
            break;
        case ShareTypeCopy:     //复制链接
            [self shareCopy];
            break;
        default:
            break;
    }
    [self shareCancel];
}
- (void)shareCancel{
    CMDefaultShare *defaultShare = [CMDefaultShare shareInstance];
    defaultShare.delegate = nil;
}

/**
 *  分享到新浪微博
 */
- (void)shareSinaWeibo{
    
    AuctionModel *model = [self getCurrentAuction];
    
    ShareContentViewController *viewController = [[ShareContentViewController alloc] initWithContent:model.sharedContent];
    viewController.shareType = ShareTypeSinaWeibo;
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];

}
/**
 *  分享到腾讯微博
 */
- (void)shareTencentWeibo{
    AuctionModel *model = [self getCurrentAuction];
    
    ShareContentViewController *viewController = [[ShareContentViewController alloc] initWithContent:model.sharedContent];
    viewController.shareType = ShareTypeTencentWeibo;
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];
}

/**
 *  分享到微信好友
 */
- (void)shareWeChatSession{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveShareWeiboSucceed:) name:kCMShareWeChatSessionSucceed object:nil];
    
    AuctionModel *model = [self getCurrentAuction];
    [ShareSDK shareWeChat:model.sharedContent type:ShareTypeWeixiSession];
}

/**
 *  分享到微信朋友圈
 */
- (void)shareWeChatTimeline{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveShareWeiboSucceed:) name:kCMShareWeChatTimelineSucceed object:nil];
    AuctionModel *model = [self getCurrentAuction];
    [ShareSDK shareWeChat:model.sharedContent type:ShareTypeWeixiTimeline];
}

/**
 *  邮件分享
 */
- (void)shareSendMail{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveShareWeiboSucceed:) name:kCMShareMailSucceed object:nil];
    AuctionModel *model = [self getCurrentAuction];
    [ShareSDK shareSendMail:model.sharedContent];
}

/**
 *  短信分享
 */
- (void)shareSendSMS{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveShareWeiboSucceed:) name:kCMShareSMSSucceed object:nil];
    AuctionModel *model = [self getCurrentAuction];
    [ShareSDK shareSendSMS:model.sharedContent];
}

/**
 *  链接分享
 */
- (void)shareCopy{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveShareWeiboSucceed:) name:kCMShareCopySucceed object:nil];
    AuctionModel *model = [self getCurrentAuction];
    [ShareSDK shareCopy:model.sharedContent];
}

- (void)receiveShareWeiboSucceed:(NSNotification *)notice{
    UserModel *userModel = [UserModel shareUser];
    NSString *parameters = [NSString stringWithFormat:@"?%@=%@&%@=%@&%@=%@&%@=%@",USER_ID,userModel.userId,COMMUNITY_ID,userModel.communityId,PROPERTY_ID,userModel.propertyId,@"pointType",@"shared"];
    CommunityHttpRequest *request = [CommunityHttpRequest shareInstance];
    [request requestPointChange:nil parameters:parameters];
}

@end
