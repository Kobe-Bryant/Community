//
//  NeighborhoodViewController.m
//  IMDemo
//
//  Created by Dream on 14-7-18.
//  Copyright (c) 2014年 Yunlai-mac02. All rights reserved.
//

#import "NeighborhoodViewController.h"
#import "NSObject_extra.h"
#import "Global.h"
#import "UIImage+extra.h"
#import "UIViewController+NavigationBar.h"
#import "MyNeihborView.h"
#import "MessageListView.h"
#import "NeighborhoodChatViewController.h"

@interface NeighborhoodViewController ()<MyNeihborViewDelegate,MessageListViewDelegate>{
    
    MyNeihborView *_myNeighborVC;
    MessageListView *_messageListVC;
    
    UISegmentedControl *_segmentControl;
}

@end

@implementation NeighborhoodViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (IOS7_OR_LATER) {
        //    滑动返回
    self.navigationController.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
    }
    [self.navigationController setNavigationBarHidden:NO];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    //自适应iOS的导航栏、状态栏
    [self adjustiOS7NaviagtionBar];
    [self setNavigationTitle:@"我的邻居"];
    
    NSArray *itemArray = [[NSArray alloc]initWithObjects:@"我的邻居",@"邻居消息",nil];
    _segmentControl = [[UISegmentedControl alloc]initWithItems:itemArray];
    _segmentControl.frame = CGRectMake(80, 7, 160, 30);
    _segmentControl.selectedSegmentIndex = 0;
    _segmentControl.segmentedControlStyle= UISegmentedControlStyleBar;//设置
    if (IOS7_OR_LATER) {
        _segmentControl.tintColor= [UIColor whiteColor];
    }else{
        //segmentControl.tintColor= [UIColor colorWithRed:87.0f/255.0 green:182.0/255.0f blue:16.0/255 alpha:1.0];
    }
    [_segmentControl addTarget:self action:@selector(segmentClick:) forControlEvents:UIControlEventValueChanged];
    [self.navigationItem setTitleView:_segmentControl];
    [_segmentControl release];

    _myNeighborVC = [[MyNeihborView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth,MainHeight)];
    _myNeighborVC.delegate = self;
    _myNeighborVC.hidden = NO;
    [self.view addSubview:_myNeighborVC];
    [_myNeighborVC release];
    
    _messageListVC = [[MessageListView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, MainHeight)];
    _messageListVC.delegate = self;
    _messageListVC.hidden = YES;
    [self.view addSubview:_messageListVC];
    [_messageListVC release];
}

//进入聊天界面
- (void)enterChatVc:(NSString *)sender {
    NeighborhoodChatViewController *chatVC = [[NeighborhoodChatViewController alloc]init];
    chatVC.title = sender;
    chatVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:chatVC animated:YES];
    [chatVC release];
}

-(void)segmentClick:(UISegmentedControl *)sender{
    switch (sender.selectedSegmentIndex) {
        case 0:
            _myNeighborVC.hidden = NO;
            _messageListVC.hidden = YES;
            break;
        case 1:
            _myNeighborVC.hidden = YES;
            _messageListVC.hidden =  NO;
            break;
        default:
            break;
    }

}

@end
