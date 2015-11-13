//
//  NeighborhoodViewController.m
//  CommunityAPP
//
//  Created by yunlai on 14-3-4.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import "NeighborhoodViewController.h"
#import "NSObject_extra.h"
#import "Global.h"
#import "MyNeighborView.h"
#import "MessagesListView.h"
#import "MainTabbarViewController.h"
#import "UIViewController+NavigationBar.h"
#import "UIImage+extra.h"
#import "UserModel.h"
#import "NeighboorHoodFriendList.h"

@interface NeighborhoodViewController ()

@end

@implementation NeighborhoodViewController

-(void)dealloc{
    [segmentControl release]; segmentControl = nil;
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

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    if (IOS7_OR_LATER) {
        //    滑动返回
        self.navigationController.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
    }
    [self.navigationController setNavigationBarHidden:NO];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    //自适应iOS的导航栏、状态栏
    [self adjustiOS7NaviagtionBar];
    
    [self setNavigationTitle:@"我的邻居"];
    
    NSArray *itemArray = [[NSArray alloc] initWithObjects:@"我的邻居",@"消息列表",
                          nil];
    segmentControl = [[UISegmentedControl alloc] initWithItems:itemArray];
    segmentControl.frame = CGRectMake(80, 7, 160, 30);
    segmentControl.momentary = NO;
    segmentControl.segmentedControlStyle= UISegmentedControlStyleBar;//设置
    if (IOS7_OR_LATER) {
        segmentControl.tintColor= [UIColor whiteColor];
    }else{
        //segmentControl.tintColor= [UIColor colorWithRed:87.0f/255.0 green:182.0/255.0f blue:16.0/255 alpha:1.0];
    }
    [segmentControl addTarget:self action:@selector(segmentControlClick:) forControlEvents:UIControlEventValueChanged];
    segmentControl.selectedSegmentIndex= 0;
    [self.navigationItem setTitleView:segmentControl];
    
    if (!IOS7_OR_LATER) {
        segmentControl.layer.borderColor = [UIColor whiteColor].CGColor;//[UIColor colorWithRed:87.0f/255.0 green:182.0/255.0f blue:16.0/255 alpha:1.0].CGColor;
        segmentControl.layer.borderWidth = 1.0f;
        segmentControl.layer.cornerRadius = 4.0f;
        segmentControl.layer.masksToBounds = YES;
    }
        
    [self segmentControlClick:0];
}

//-(void)requestGruopList{
////    [Global showMBProgressHud:self SuperView:self.view Msg:@"请稍候..."];//       请求验证验证码是否正确
//    // 网络请求
//    if (request == nil) {
//        request = [CommunityHttpRequest shareInstance];
//    }
//    UserModel *userModel = [UserModel shareUser];
//    NSString *string = [NSString stringWithFormat:@"%@",@"3"];//userModel.communityId];//参数
//    [request requestGroupList:self parameters:string];
//}

- (void)segmentControlClick:(UISegmentedControl *)sender
{
    int index = sender.selectedSegmentIndex;
    switch (index) {
        case 0:
        {            
            messageListView.hidden = YES;
            neighborView = [[MyNeighborView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, MainHeight-kButtomBarHeight) delegateController:self];
            [self.view addSubview:neighborView];
            [neighborView release];
        }
            break;
        case 1:
        {
            neighborView.hidden = YES;
            
            messageListView = [[MessagesListView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, MainHeight-kButtomBarHeight) delegateController:self];
            [self.view addSubview:messageListView];
            [messageListView release];
            
        }
            break;
        default:
            break;
    }
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

#pragma mark
-(void) callBackWith: (WInterface) interface status: (NSString*) status data:(id)data{
    NSLog(@"interface :%d status:%@",interface,status);
//    [self hideHudView];
    if (interface == COMMUNITY_GROUP_LIST) {
        NSString *code = [data objectForKey:ERROR_CODE];
        if ([code isEqualToString:NETWORK_RETURN_CODE_S_OK]) {
        
        }else{
            
        }
    }
}
@end
