//
//  CarPoolingViewController.m
//  CommunityAPP
//
//  Created by Dream on 14-3-7.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import "CarPoolingViewController.h"
#import "Global.h"
#import "NSObject_extra.h"
#import "CarPoolingCell.h"
#import "AddCarPoolingViewController.h"
@interface CarPoolingViewController ()

@end

@implementation CarPoolingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [carPoolingTableView release]; carPoolingTableView = nil;
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    //    导航
    UIImage *navImage = [UIImage imageNamed:@"top_bar_home.png"];
    UIImageView *navImageView = [[UIImageView alloc] init];
    navImageView.image = navImage;
    navImageView.frame = CGRectMake(0,[Global judgementIOS7:0], ScreenWidth, navImage.size.height);
    navImageView.userInteractionEnabled = YES;
    [self.view addSubview:navImageView];
    [navImageView release];
    
    //    title
    UILabel *titleLabel = [self newLabelWithText:@"添加拼车" frame:CGRectMake(0, 0, 320, navImageView.frame.size.height) font:[UIFont systemFontOfSize:22] textColor:[UIColor whiteColor]];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [navImageView addSubview:titleLabel];
    [titleLabel release];
    
    //   返回
    UIImage *backImage = [UIImage imageNamed:@"icon_back.png"];
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setBackgroundImage:backImage forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnAction) forControlEvents:UIControlEventTouchUpInside];
    backBtn.frame = CGRectMake(0,(navImageView.frame.size.height-backImage.size.height)/2,backImage.size.width,backImage.size.height);
    [navImageView addSubview:backBtn];
    
    //    右边按钮
    UIImage *rightImage = [UIImage imageNamed:@"icon_phone_add.png"];
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setImage:rightImage forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(addBtnAction) forControlEvents:UIControlEventTouchUpInside];
    rightBtn.frame = CGRectMake(275,0,44,44);
    [navImageView addSubview:rightBtn];
    
    //列表视图
    carPoolingTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, navImageView.frame.size.height+navImageView.frame.origin.y, ScreenWidth, ScreenHeight-70) style:UITableViewStylePlain];
    carPoolingTableView.delegate = self;
    carPoolingTableView.dataSource = self;
    [self.view addSubview:carPoolingTableView];
}

#pragma mark -- uitableviewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CarPoolingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CarPoolingCell"];
    if (cell == nil) {
        cell = [[[CarPoolingCell alloc] initWithStyle:
                 UITableViewCellStyleSubtitle reuseIdentifier:@"CarPoolingCell"] autorelease];
    }
    return cell;
}

#pragma mark --Delegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90.0;
}


//导航栏左边按钮
-(void)backBtnAction
{
    [self.navigationController popViewControllerAnimated:YES];
}
//导航栏右边按钮
-(void)addBtnAction
{
    AddCarPoolingViewController *addCarVc = [[AddCarPoolingViewController alloc]init];
    [self.navigationController pushViewController:addCarVc animated:YES];
    [addCarVc release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
