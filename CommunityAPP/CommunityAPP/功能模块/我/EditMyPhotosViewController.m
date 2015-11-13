//
//  EditMyPhotosViewController.m
//  CommunityAPP
//
//  Created by Stone on 14-4-8.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import "EditMyPhotosViewController.h"
#import "UIImageView+WebCache.h"
#import "UIImage+extra.h"
#import "Global.h"
#import "NSObject_extra.h"
//#import "MainTabbarViewController.h"
#import "CommunityHttpRequest.h"
#import "MyInfoPhoto.h"
#import "CTAssetsPickerController.h"
#import "MySelfViewController.h"
#import "YLMyInfoCTAssetsPickerController.h"
#import "ASIFormDataRequestMyInfo.h"
#import "UserModel.h"
#include <ImageIO/ImageIO.h>
#import "ZoomScrollView.h"
#import "UIViewController+NavigationBar.h"
#import "JSONKit.h"
#import "MobClick.h"

@interface EditMyPhotosViewController ()<UIScrollViewDelegate,UIGestureRecognizerDelegate,CTAssetsPickerControllerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{

}

//@property (nonatomic ,retain) UIImageView *navImageView;
@property (nonatomic ,retain) UIImageView *bottomView;
@property (nonatomic, retain) UILabel *lbTitle;

@property (nonatomic, retain) UIScrollView *photoScrollView;

@property (nonatomic, assign) BOOL isShowMenu;

@property (nonatomic, retain) UIImageView *imageView;

@property (nonatomic, retain) UIButton *btnTakePhotos;  //拍照
@property (nonatomic, retain) UIButton *btnPickPhotos;  //选择照片
@property (nonatomic, retain) UIButton *btnDeletePhotos;   //删除照片

@property (nonatomic, retain) UIImageView *currentImage;

- (void)setNavViewHidden:(BOOL)hidden animated:(BOOL)animated;

- (void)setBottomViewHidden:(BOOL)hidden animated:(BOOL)animated;

@end

@implementation EditMyPhotosViewController

//@synthesize navImageView = _navImageView;
@synthesize bottomView = _bottomView;

@synthesize images = _images;
@synthesize photoScrollView = _photoScrollView;
@synthesize imageView = _imageView;
@synthesize index = _index;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        _isShowMenu = YES;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
    [MobClick beginLogPageView:@"EditMyPhotosPage"]; // 友盟统计
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
    [MobClick endLogPageView:@"EditMyPhotosPage"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController setNavigationBarHidden:NO];
    //自适应iOS的导航栏、状态栏
    [self adjustiOS7NaviagtionBar];
    [self setNavigationTitle:@"编辑资料"];
    //自定义返回按钮
    UIButton *backButton = [self setBackBarButton];
    [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    [self setBackBarButtonItem:backButton];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.wantsFullScreenLayout = YES;
#ifdef __IPHONE_7_0
	if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)]) {
		self.automaticallyAdjustsScrollViewInsets = NO;
        self.extendedLayoutIncludesOpaqueBars = YES;
        self.edgesForExtendedLayout = UIRectEdgeAll;
	}
#endif

    
    _photoScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    _photoScrollView.delegate = self;
    _photoScrollView.pagingEnabled = YES;
    _photoScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    _photoScrollView.autoresizesSubviews = YES;
    [self.view addSubview:_photoScrollView];
    //[self.view insertSubview:_photoScrollView belowSubview:self.navigationController.navigationBar];
    [_photoScrollView release];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [self.view addGestureRecognizer:singleTap];
    [singleTap release];
    
//    self.photoScrollView.maximumZoomScale = 2.0;
//    self.photoScrollView.minimumZoomScale = 0.5;
//    self.photoScrollView.bouncesZoom = TRUE;
//    self.photoScrollView.decelerationRate = UIScrollViewDecelerationRateFast;
//    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
//    [doubleTap setNumberOfTapsRequired:2];
//    [self.photoScrollView addGestureRecognizer:doubleTap];
//    [doubleTap release];
    
    [self layoutImages];
    [self setupBottomView];
    //定位进入前点击的图片
    [_photoScrollView setContentOffset:CGPointMake(CGRectGetWidth(_photoScrollView.bounds)*_index, 0)];
 
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ---

#pragma mark -----------------

- (void)setupBottomView{
    _bottomView = [[UIImageView alloc] initWithFrame:CGRectMake(15, CGRectGetHeight(self.view.frame)-60-15, 290, 60)];
    _bottomView.image = [UIImage imageNamed:@"edit_myInfo_bg.png"];
    _bottomView.autoresizingMask = (UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin);
    _bottomView.userInteractionEnabled = YES;
    [self.view addSubview:_bottomView];
    [_bottomView release];
    
    //拍照的按钮
    _btnTakePhotos = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnTakePhotos.frame = CGRectMake(30, 0, 60, 60);
    [_btnTakePhotos setImage:[UIImage imageNamed:@"edit_myInfo_takephotos.png"] forState:UIControlStateNormal];
    [_btnTakePhotos addTarget:self action:@selector(takePhoto:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:_btnTakePhotos];
    
    
    _btnPickPhotos = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnPickPhotos.frame = CGRectMake(30+60+25, 0, 60, 60);
    [_btnPickPhotos setImage:[UIImage imageNamed:@"edit_myInfo_pickPhotos.png"] forState:UIControlStateNormal];
    [_btnPickPhotos addTarget:self action:@selector(pickPhoto:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:_btnPickPhotos];
    
    _btnDeletePhotos = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnDeletePhotos.frame = CGRectMake(CGRectGetMaxX(_btnPickPhotos.frame)+25, 0, 60, 60);
    [_btnDeletePhotos setImage:[UIImage imageNamed:@"edit_myInfo_delete"] forState:UIControlStateNormal];
    [_btnDeletePhotos addTarget:self action:@selector(deletePhoto:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:_btnDeletePhotos];
    
}

- (void)layoutImages{
    for (UIView *view in self.photoScrollView.subviews) {
        [view removeFromSuperview];
    }
    for (int i = 0; i < [self.images count]; i++) {
        MyInfoPhoto *photo = [self.images objectAtIndex:i];
        CGRect rect = CGRectMake(i*CGRectGetWidth(_photoScrollView.bounds), 0, CGRectGetWidth(_photoScrollView.bounds), CGRectGetHeight(_photoScrollView.bounds));
        
        ZoomScrollView *zoomView = [[ZoomScrollView alloc] initWithFrame:rect];
        
        zoomView.myInfoPhoto = photo;
        [_photoScrollView addSubview:zoomView];
        [zoomView release];
    }
    
    [_photoScrollView setContentSize:CGSizeMake(CGRectGetWidth(_photoScrollView.bounds)*[self.images count], CGRectGetHeight(_photoScrollView.bounds))];

}


- (void)setNavViewHidden:(BOOL)hidden animated:(BOOL)animated{
    __block BOOL flag = hidden; //0 up 1 down
    
    if (flag) {
        // fade in navigation
        
        [[UIApplication sharedApplication] setStatusBarHidden:FALSE withAnimation:UIStatusBarAnimationNone];
        //            if (IOS7_OR_LATER) {
        //                if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        //                    // iOS 7
        //                    [self prefersStatusBarHidden];
        //                    [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
        //                }
        //            }
        //self.navImageView.alpha = 1.0;
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        [UIView animateWithDuration:0.4 animations:^{

            
            self.bottomView.alpha = 1.0;
        } completion:^(BOOL finished) {
        }];
    }
    else {
        // fade out navigation
        [[UIApplication sharedApplication] setStatusBarHidden:TRUE withAnimation:UIStatusBarAnimationFade];
        //            if (IOS7_OR_LATER) {
        //                if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        //                    // iOS 7
        //                    [self prefersStatusBarHidden];
        //                    [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
        //                }
        //            }
        //self.navImageView.alpha = 0.0;
        [self.navigationController setNavigationBarHidden:YES animated:YES];
        [UIView animateWithDuration:0.4 animations:^{

            //self.navigationController.navigationBar.alpha = 0.0;
            self.bottomView.alpha = 0.0;
        } completion:^(BOOL finished) {
        }];
    }

}


- (void)setBottomViewHidden:(BOOL)hidden animated:(BOOL)animated{
    if (animated) {
        
    }
}

//- (BOOL)prefersStatusBarHidden
//{
//    return !_isShowMenu;
//}


#pragma mark
- (void)backAction:(UIButton *)sender{
    //[self.navigationController setNavigationBarHidden:YES animated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)takePhoto:(UIButton *)sender{
    NSLog(@"%@",NSStringFromSelector(_cmd));
    BOOL iscamera = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
    if (!iscamera) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"没有相机" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        [alert release];
        return;
    }
    UIImagePickerController *pick = [[UIImagePickerController alloc] init];
    pick.delegate = self;
    pick.sourceType = UIImagePickerControllerSourceTypeCamera;
    pick.allowsEditing = YES;
    [self presentViewController:pick animated:YES completion:NULL];
    [pick release];
    
}


- (MyInfoPhoto *)currentMyPhoto{
    NSInteger index = (NSInteger)_photoScrollView.contentOffset.x /_photoScrollView.bounds.size.width;
    if ([self.images count] > index) {
      return [self.images objectAtIndex:index];
    }
    return nil;
}
- (void)pickPhoto:(UIButton *)sender{
    NSLog(@"%@",NSStringFromSelector(_cmd));
    YLMyInfoCTAssetsPickerController *picker = [[YLMyInfoCTAssetsPickerController alloc] init] ;
    picker.myInfoPhoto = [self currentMyPhoto];
    picker.maximumNumberOfSelection = 1;
    if (picker.maximumNumberOfSelection>1) {
        return;
    }
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:NULL];
    [picker release];
}


- (void)deletePhoto:(UIButton *)sender{
    NSLog(@"%@",NSStringFromSelector(_cmd));
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"是否删除照片" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    alert.tag = 10000;
    [alert show];
    [alert release];
}

- (void)handleSingleTap:(UITapGestureRecognizer *)sender{
    _isShowMenu = !_isShowMenu;
    [self setNavViewHidden:_isShowMenu animated:YES];
}


- (void)setMenuHidden:(BOOL)hidden animated:(BOOL)animated{
    
}
#pragma mark ---
#pragma mark --UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 10000) {
        if (buttonIndex == 0) {
            MyInfoPhoto *photo = [self currentMyPhoto];
            photo.detailType = YLPhotoDelete;
            
            [self requestAddAuction:photo];
        }
    }
}
#pragma mark ---
#pragma mark --UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    BOOL iscamera = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
    if (!iscamera) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"没有相机" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        [alert release];
    }else{
        [picker dismissViewControllerAnimated:YES completion:^{}];
        
        UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
        NSLog(@"%@",NSStringFromCGSize(image.size));
        NSString *str = (NSString*)kCGImagePropertyTIFFDictionary;
        NSDictionary *dic = [[info objectForKey:UIImagePickerControllerMediaMetadata] objectForKey:str];
        image.fileName = [[dic objectForKey:@"DateTime"] stringByAppendingPathExtension:@"jpg"];
        UIImage *newImage = [UIImage writeImageToSandBox:image name:image.fileName];
        image = nil;
        
        MyInfoPhoto *photo = [self currentMyPhoto];
        photo.image = newImage;
        photo.fileName = newImage.fileName;
        photo.strUrl = @"";
        photo.detailType = YLPhotoUpdate;
        photo.photoState = YLStateUploading;
        
        [self requestAddAuction:photo];
        
        
    }
}



#pragma mark ---CTAssetsPickerControllerDelegate
- (void)assetsPickerController:(CTAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets{
    if ([assets count] > 0) {
        //NSMutableArray *array = [[[NSMutableArray alloc] init] autorelease];
        for (ALAsset *asset in assets)
        {

            ALAssetRepresentation *assetRepresentation = [asset defaultRepresentation];
            UIImage *image = [UIImage imageWithCGImage:assetRepresentation.fullScreenImage];
            
            UIImage *compressImage = [UIImage writeImageToSandBox:image name:assetRepresentation.filename];
            if ([picker isKindOfClass:[YLMyInfoCTAssetsPickerController class]]) {
                MyInfoPhoto *photo = [self currentMyPhoto];
                photo.image = compressImage;
                photo.fileName = assetRepresentation.filename;
                photo.strUrl = @"";
                photo.detailType = YLPhotoUpdate;
                photo.photoState = YLStateUploading;
                
                [self requestAddAuction:photo];
                
            }
        }
    }
}

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
    
    if (photo.isIcon) {
        [uploadImageRequest setPostValue:@"2" forKey:@"requestType"];
    }else{
        [uploadImageRequest setPostValue:@"3" forKey:@"requestType"];
    }
    NSString *strDetail = @"U";
    if (photo.detailType == YLPhotoUpdate) {
        strDetail = @"U";
        NSData *data = UIImageJPEGRepresentation(photo.image,0.2);
        [uploadImageRequest addData:data withFileName:photo.fileName andContentType:nil forKey:@"imageStream"];
        [uploadImageRequest setPostValue:photo.imageId forKey:@"imgId"];
    }else if (photo.detailType == YLPhotoDelete){
        strDetail = @"D";
        [uploadImageRequest setPostValue:photo.imageId forKey:@"imgId"];
    }else if (photo.detailType == YLPHotoADD){
        strDetail = @"A";
        NSData *data = UIImageJPEGRepresentation(photo.image,0.2);
        [uploadImageRequest addData:data withFileName:photo.fileName andContentType:nil forKey:@"imageStream"];
    }
    [uploadImageRequest setPostValue:strDetail forKey:@"imgState"];
    
    [uploadImageRequest setPostFormat:ASIMultipartFormDataPostFormat];
    
    //标识
    uploadImageRequest.myInfoPhoto = photo;
    [uploadImageRequest setDelegate:self];
    [uploadImageRequest setDidFinishSelector:@selector(responseComplete:)];
    [uploadImageRequest setDidFailSelector : @selector (responseFailed:)];
    [uploadImageRequest startAsynchronous];
}


- (void)responseComplete:(ASIFormDataRequestMyInfo *)request{
    NSString* response = [request responseString];
    NSLog(@"response %@",response);
    
    NSDictionary *dictionary = [response objectFromJSONString];
    NSString *code = [dictionary objectForKey:@"errorCode"] ;
    if ([code isEqualToString:NETWORK_RETURN_CODE_S_OK]) {
        NSLog(@"上传成功");
        ASIFormDataRequestMyInfo *myInfoRequest = (ASIFormDataRequestMyInfo *)request;
        if (myInfoRequest.myInfoPhoto.isIcon) {
            myInfoRequest.myInfoPhoto.photoComeFrom = YLPhotoFromServer;
            myInfoRequest.myInfoPhoto.strUrl = [dictionary objectForKey:@"imgs"];
            
            
            if (myInfoRequest.myInfoPhoto.detailType == YLPhotoDelete) {
                if ([self.images containsObject:myInfoRequest.myInfoPhoto]) {
                    [self.images removeObject:myInfoRequest.myInfoPhoto];
                }
                if ([self.images count] == 0) {
                    [self backAction:nil];
                }
            }
            [self layoutImages];
            
            
        }else{
            myInfoRequest.myInfoPhoto.strUrl = [dictionary objectForKey:@"imgs"];
            myInfoRequest.myInfoPhoto.imageId = [dictionary objectForKey:@"imgIds"];
            myInfoRequest.myInfoPhoto.photoComeFrom = YLPhotoFromServer;
            if (myInfoRequest.myInfoPhoto.detailType == YLPhotoDelete) {
                if ([self.images containsObject:myInfoRequest.myInfoPhoto]) {
                    [self.images removeObject:myInfoRequest.myInfoPhoto];
                }
                if ([self.images count] == 0) {
                    [self backAction:nil];
                }
            }
            
            [self layoutImages];
        }
        
    }else{
        NSLog(@"上传失败");
    }

}

- (void)responseFailed:(ASIFormDataRequestMyInfo *)request{
    NSString* response = [request responseString];
    NSLog(@"response %@",response);
    
    NSDictionary *dictionary = [response objectFromJSONString];
    NSString *code = [dictionary objectForKey:@"errorCode"] ;
    if ([code isEqualToString:NETWORK_RETURN_CODE_S_OK]) {
        NSLog(@"上传成功");
        ASIFormDataRequestMyInfo *myInfoRequest = (ASIFormDataRequestMyInfo *)request;
        if (myInfoRequest.myInfoPhoto.isIcon) {
            myInfoRequest.myInfoPhoto.photoComeFrom = YLPhotoFromServer;
            myInfoRequest.myInfoPhoto.strUrl = [dictionary objectForKey:@"imgs"];
            
            
        }else{
            myInfoRequest.myInfoPhoto.strUrl = [dictionary objectForKey:@"imgs"];
            myInfoRequest.myInfoPhoto.imageId = [dictionary objectForKey:@"imgIds"];
            myInfoRequest.myInfoPhoto.photoComeFrom = YLPhotoFromServer;
            if (myInfoRequest.myInfoPhoto.detailType == YLPhotoDelete) {
                if ([self.images containsObject:myInfoRequest.myInfoPhoto]) {
                    [self.images removeObject:myInfoRequest.myInfoPhoto];
                }
            
            }
            
            [self layoutImages];
        }
        
    }else{
        NSLog(@"上传失败");
    }
    

}



@end
