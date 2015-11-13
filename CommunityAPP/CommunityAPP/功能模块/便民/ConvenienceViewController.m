//
//  ConvenienceViewController.m
//  CommunityAPP
//
//  Created by yunlai on 14-3-4.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import "ConvenienceViewController.h"
#import "NSObject_extra.h"
#import "Global.h"
#import "AppDelegate.h"
#import "DPRequest.h"
#import "SBJsonParser.h"
#import "ConvenienceListViewController.h"
//#import "MainTabbarViewController.h"
#import "UIViewController+NavigationBar.h"
#import "MobClick.h"

@interface ConvenienceViewController ()

@end

@implementation ConvenienceViewController
@synthesize listDictionary;

-(void)dealloc{
    [contentScrollView release]; contentScrollView = nil;
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

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
    [MobClick beginLogPageView:@"ConveniencePage"];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
    [MobClick endLogPageView:@"ConveniencePage"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.navigationController setNavigationBarHidden:NO];
    
    if (IOS7_OR_LATER) {
        //    滑动返回
        self.navigationController.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
    }

    //自适应iOS的导航栏、状态栏
    [self adjustiOS7NaviagtionBar];
    [self setNavigationTitle:@"便民"];
    
    [self hideHudView];
    
    hudView = [Global showMBProgressHud:self SuperView:self.view Msg:@"请稍候..."];
//    请求当前的数据
    [self conveniencRequest];

}

//加载当前的试图
-(void)loadContentScrollView{
    //    滚动试图
    contentScrollView =[[UIScrollView alloc]initWithFrame:CGRectMake(0,0, ScreenWidth, ScreenHeight-kButtomBarHeight)] ;
    contentScrollView.layer.borderWidth = 1.0f;
    contentScrollView.layer.borderColor = RGB(229, 229, 229).CGColor;
    contentScrollView.showsHorizontalScrollIndicator = NO;
    contentScrollView.showsVerticalScrollIndicator = NO;
    contentScrollView.scrollsToTop = NO;
    [contentScrollView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:contentScrollView];
    
//    按钮的高度
    int height=0;
    for (int i = 0; i<[self.listDictionary count]; i++) {
        CGRect imageframe = contentScrollView.frame;
        imageframe.origin.x = 11.5;
        imageframe.origin.y = height+15*(i+1)+16*(i);

        float sizelines=(float)[[self.listDictionary objectForKey:[[self.listDictionary allKeys] objectAtIndex:i]] count]/3;
        int sizeLines=ceilf(sizelines);
        int contentHeight = 30*sizeLines+15*sizeLines;
        height = contentHeight+height;
        
        UIImageView *iconImageView = [self newImageViewWithImage:nil frame:CGRectMake(imageframe.origin.x, imageframe.origin.y, 20, 20)];
        [contentScrollView addSubview:iconImageView];
        
//        图片的匹配
        if ([[[self.listDictionary allKeys] objectAtIndex:i] isEqualToString:@"酒店"]) {
            iconImageView.image = [UIImage imageNamed:@"bg_convenience_iconImage3.png"];
        }else if ([[[self.listDictionary allKeys] objectAtIndex:i] isEqualToString:@"丽人"]) {
            iconImageView.image = [UIImage imageNamed:@"bg_convenience_iconImage4.png"];
        }else if ([[[self.listDictionary allKeys] objectAtIndex:i] isEqualToString:@"结婚"]) {
            iconImageView.image = [UIImage imageNamed:@"bg_convenience_iconImage2.png"];
        }else if ([[[self.listDictionary allKeys] objectAtIndex:i] isEqualToString:@"美食"]) {
            iconImageView.image = [UIImage imageNamed:@"bg_convenience_iconImage0.png"];
        }else if ([[[self.listDictionary allKeys] objectAtIndex:i] isEqualToString:@"亲子"]) {
            iconImageView.image = [UIImage imageNamed:@"bg_convenience_iconImage6.png"];
        }else if ([[[self.listDictionary allKeys] objectAtIndex:i] isEqualToString:@"生活服务"]) {
            iconImageView.image = [UIImage imageNamed:@"bg_convenience_iconImage7.png"];
        }else if ([[[self.listDictionary allKeys] objectAtIndex:i] isEqualToString:@"运动健身"]) {
            iconImageView.image = [UIImage imageNamed:@"bg_convenience_iconImage9.png"];
        }else if ([[[self.listDictionary allKeys] objectAtIndex:i] isEqualToString:@"汽车服务"]) {
            iconImageView.image = [UIImage imageNamed:@"bg_convenience_iconImage5.png"];
        }else if ([[[self.listDictionary allKeys] objectAtIndex:i] isEqualToString:@"购物"]) {
            iconImageView.image = [UIImage imageNamed:@"bg_convenience_iconImage1.png"];
        }else if ([[[self.listDictionary allKeys] objectAtIndex:i] isEqualToString:@"休闲娱乐"]) {
            iconImageView.image = [UIImage imageNamed:@"bg_convenience_iconImage8.png"];
        }
        
        [iconImageView release];
        
        // title
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(iconImageView.frame.size.width+iconImageView.frame.origin.x+2, imageframe.origin.y, 70, 20)];
        titleLabel.text = [[self.listDictionary allKeys] objectAtIndex:i];
        titleLabel.textColor = RGB(84, 84, 84);
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = [UIFont systemFontOfSize:15];
        [contentScrollView addSubview:titleLabel];
        [titleLabel release];
        
//        线
        UIImage *lineImage = [UIImage imageNamed:@"bg_convenience_spImage.png"];
        UIImageView *lineImageView = [self newImageViewWithImage:[UIImage imageNamed:@"bg_convenience_spImage.png"] frame:CGRectMake(80, imageframe.origin.y+9, lineImage.size.width, lineImage.size.height)];
        [contentScrollView addSubview:lineImageView];
        [lineImageView release];

        for (int j = 0; j<[[self.listDictionary objectForKey:[[self.listDictionary allKeys] objectAtIndex:i]] count]; j++) {
            UIButton *itemBtn = [self newButtonWithImage:[UIImage imageNamed:@"bg_convenience_btnImage1.png"] highlightedImage:[UIImage imageNamed:@"bg_convenience_allBtn_s1.png"] frame:CGRectMake(imageframe.origin.x+94*(j%3)+8*(j%3), iconImageView.frame.size.height+iconImageView.frame.origin.y+14*(j/3+1)+30*(j/3), 92, 30) title:[[self.listDictionary objectForKey:[[self.listDictionary allKeys] objectAtIndex:i]] objectAtIndex:j] titleColor:RGB(84, 84, 84) titleShadowColor:nil font:[UIFont systemFontOfSize:14] target:self action:@selector(itemBtnAction:)];
            itemBtn.tag = j;
            [contentScrollView addSubview:itemBtn];
        }
    }
//    最后一个元素的高度
    float sizelines=(float)[[self.listDictionary objectForKey:[[self.listDictionary allKeys] lastObject]] count]/3;
    int sizeLines=ceilf(sizelines);
    int contentHeight = 30*sizeLines+15*sizeLines;
    
    contentScrollView.contentSize = CGSizeMake(ScreenWidth,height+contentHeight+15+16*self.listDictionary.count);
    
    //    大众点评的logo
    UIImage *apiImage = [UIImage imageNamed:@"bg_dpApi_logo.png"];
    UIImageView *apiImageView = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth-apiImage.size.width-10, MainHeight-50-apiImage.size.height, apiImage.size.width, apiImage.size.height)];
    [apiImageView setImage:apiImage];
    [self.view addSubview:apiImageView];
    [self.view insertSubview:apiImageView aboveSubview:contentScrollView];
    [apiImageView release];
    
}

-(void)itemBtnAction:(id)sender{
    UIButton *btn = (UIButton *)sender;
    
    ConvenienceListViewController *listVc = [[ConvenienceListViewController alloc] init];
    if ([[[btn titleForState:UIControlStateNormal] substringToIndex:2]isEqualToString:@"全部"]) {
        listVc.searchTextString = [[btn titleForState:UIControlStateNormal] substringFromIndex:2];
    }else{
        listVc.searchTextString = [btn titleForState:UIControlStateNormal];
    }
    listVc.hidesBottomBarWhenPushed = YES;

    [self.navigationController pushViewController:listVc animated:YES];
    [listVc release];
}

-(void)conveniencRequest{
    [[AppDelegate instance] setAppKey:kDPAppKey];
	[[AppDelegate instance] setAppSecret:kDPAppSecret];
    [[[AppDelegate instance] dpapi] requestWithURL:DZDP_GET_CATEGORIES_WITH_BUSINESSES paramsString:@"" delegate:self];
}


////全部分类
//-(void)allClassificationBtnAction{
//    
//}

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
- (void)request:(DPRequest *)request didFailWithError:(NSError *)error {
    [self hideHudView];
    if (error.code) {
        //NSDictionary *dictionary = [[error description] objectFromJSONString];
        [self alertWithFistButton:@"确定" SencodButton:nil Message:@"服务器罢工了"];
    }
    
    
    NSLog(@"[error description] %@",[error description]);
}

- (void)request:(DPRequest *)request didFinishLoadingWithResult:(id)result {
    [self hideHudView];
    
//    [result description];

    NSArray *listArray = [result objectForKey:@"categories"];
    self.listDictionary = [[NSMutableDictionary alloc] init];
    
    for (NSDictionary *dic in listArray) {
        NSMutableArray *subcategories_array = [dic objectForKey:@"subcategories"];
        NSMutableArray *small_Category_NameArray = [[NSMutableArray alloc] init];
        [small_Category_NameArray insertObject:[NSString stringWithFormat:@"全部%@",[dic objectForKey:@"category_name"]] atIndex:0];
        for (NSDictionary *tempDic in subcategories_array) {
            [small_Category_NameArray addObject:[tempDic objectForKey:@"category_name"]];
            [self.listDictionary setObject:small_Category_NameArray forKey:[dic objectForKey:@"category_name"]];
        }
    }
    [self loadContentScrollView];
}

@end
