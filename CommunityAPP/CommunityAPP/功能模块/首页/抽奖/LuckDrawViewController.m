//
//  LuckDrawViewController.m
//  CommunityAPP
//
//  Created by yunlai on 14-4-20.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import "LuckDrawViewController.h"
#import "Global.h"
#import "NSObject_extra.h"
#import "LuckDrawView.h"
#import "AwardRecordingView.h"
#import "AwardView.h"
#import "AwardAddAddressViewController.h"
#import "AwardAddressDetailViewController.h"
#import "AwardDetailViewController.h"
#import "DeliveryAddressView.h"
#import "UIViewController+NavigationBar.h"
#import "AddAndChoseAddressViewController.h"
#import "MobClick.h"

#define SelectVisible (sender.tag-100)
@interface LuckDrawViewController ()

@end

@implementation LuckDrawViewController

-(void)dealloc{
    [luckDrawView release]; luckDrawView = nil;
    [addressView release]; addressView = nil;
    [awardView release];  awardView = nil;
    [recordView release]; recordView = nil;
    [selectedImageView release]; selectedImageView = nil;
    [choseView release];  choseView = nil;
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
         SelectedTagChang = 100;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
    [MobClick beginLogPageView:@"LuckDrawPage"];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
    [MobClick endLogPageView:@"LuckDrawPage"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    //自适应iOS的导航栏、状态栏
    [self adjustiOS7NaviagtionBar];
    [self setNavigationTitle:@"抽奖"];
    //自定义返回按钮
    UIButton *backButton = [self setBackBarButton];
    [backButton addTarget:self action:@selector(backBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self setBackBarButtonItem:backButton];

//    加载当前的选项卡
    [self loadChoseView];
    [self setSelectedIndex:0];
}

-(void)loadChoseView{
    choseView = [[UIView alloc] initWithFrame:CGRectMake(0,0, ScreenWidth, 40)];
    choseView.backgroundColor = [UIColor whiteColor];//RGB(245, 245, 245);
    choseView.layer.borderWidth = 1;
    choseView.layer.borderColor = RGB(227, 226, 224).CGColor;
    [self.view addSubview:choseView];

    NSArray *choseListArray = [[NSArray alloc] initWithObjects:@"今日抽奖",@"获奖记录",@"奖品详情",@"收货地址", nil];
    for (int i = 0; i<[choseListArray count]; i++) {
        UIButton *segmentedButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [segmentedButton setTitle:[NSString stringWithFormat:@"%@",[choseListArray objectAtIndex:i]] forState:UIControlStateNormal];
        [segmentedButton setFrame:CGRectMake(80*i, 5, 80, 30)];
        [segmentedButton setTitleColor:RGB(53, 53, 53) forState:UIControlStateNormal];
        segmentedButton.tag = i+100;
        if (i==0)
        {
            segmentedButton.selected = YES;
        }
        [segmentedButton setTitleColor:RGB(87, 182, 16) forState:UIControlStateSelected];
        segmentedButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [segmentedButton addTarget:self action:@selector(segmentedButton:) forControlEvents:UIControlEventTouchUpInside];
        [choseView addSubview:segmentedButton];
    }
    
    //设置选中背景
    UIImage *selecetedImage = [UIImage imageNamed:@"bg_award_btnLine.png"];
    selectedImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 38, 80, selecetedImage.size.height)];
    [selectedImageView setImage:selecetedImage];
    [choseView addSubview:selectedImageView];
}

//点击button调用方法
-(void)segmentedButton:(UIButton*)sender
{
    //取消当前选择
    if (sender.tag!=SelectedTagChang)
    {
        UIButton * allButton = (UIButton*)[choseView viewWithTag:SelectedTagChang];
        allButton.selected=NO;
        SelectedTagChang = sender.tag;
    }
    if (!sender.selected) {
        sender.selected = YES;
        //button 背景图片
        [UIView animateWithDuration:0.25 animations:^{
            [selectedImageView setFrame:CGRectMake(sender.frame.origin.x, 38, 80, 2)];
        } completion:^(BOOL finished){
            [self setSelectedIndex:SelectVisible];
        }];
    } //重复点击选中按钮
    else {
        
    }
}

//选择index
- (void)setSelectedIndex:(NSInteger)selectedIndex
{
    switch (selectedIndex) {
        case 0:
//            加载抽奖
        {
//            LuckDrawView
            recordView.hidden = YES;
            awardView.hidden = YES;
            addressView.hidden = YES;
            
            luckDrawView = [[LuckDrawView alloc] initWithFrame:CGRectMake(0, choseView.frame.size.height+choseView.frame.origin.y, ScreenWidth, MainHeight-choseView.frame.size.height-choseView.frame.origin.y) viewController:self];
            [self.view addSubview:luckDrawView];
        }
            break;
        case 1:
//          获奖记录
        {
            addressView.hidden = YES;
            awardView.hidden = YES;
            luckDrawView.hidden = YES;
            
            recordView = [[AwardRecordingView alloc] initWithFrame:CGRectMake(0, choseView.frame.size.height+choseView.frame.origin.y, ScreenWidth, MainHeight-choseView.frame.size.height-choseView.frame.origin.y) viewController:self];
            [self.view addSubview:recordView];
        }
            break;
        case 2:
//          奖项
        {
            addressView.hidden = YES;
            recordView.hidden = YES;
            luckDrawView.hidden = YES;
            
            awardView = [[AwardView alloc] initWithFrame:CGRectMake(0, choseView.frame.size.height+choseView.frame.origin.y, ScreenWidth, MainHeight-choseView.frame.size.height-choseView.frame.origin.y) viewController:self];
            [self.view addSubview:awardView];
        }
            break;
        case 3:
//          收货地址
        {
            recordView.hidden = YES;
            awardView.hidden = YES;
            luckDrawView.hidden = YES;
            
            addressView = [[DeliveryAddressView alloc] initWithFrame:CGRectMake(0, choseView.frame.size.height+choseView.frame.origin.y, ScreenWidth, MainHeight-choseView.frame.size.height-choseView.frame.origin.y) viewController:self];
            [self.view addSubview:addressView];
        }
            break;
        default:
            break;
    }

}
//返回导航按钮
-(void)backBtnAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

//添加收货地址
-(void)addAddress{
    AwardAddAddressViewController *addressVc = [[AwardAddAddressViewController alloc] init];
    [self.navigationController pushViewController:addressVc animated:YES];
    [addressVc release];
}

//完善收货地址
-(void)finishAddress{
    AddAndChoseAddressViewController *addressVc = [[AddAndChoseAddressViewController alloc] init];
    [self.navigationController pushViewController:addressVc animated:YES];
    [addressVc release];

}

//地址详情
-(void)addressDetail:(AddressListModel *)model{
    AwardAddressDetailViewController *addressDetail = [[AwardAddressDetailViewController alloc] init];
    addressDetail.addressModel = model;
    [self.navigationController pushViewController:addressDetail animated:YES];
    [addressDetail release];
}

//奖品详情
-(void)awardDetail:(AwardRecordingModel *)awardRecordingModel{
    AwardDetailViewController *awardDetail = [[AwardDetailViewController alloc] init];
    awardDetail.model = awardRecordingModel;
    [self.navigationController pushViewController:awardDetail animated:YES];
    [awardDetail release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

@end
