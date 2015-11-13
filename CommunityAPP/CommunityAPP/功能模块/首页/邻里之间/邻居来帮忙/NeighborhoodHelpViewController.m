//
//  NeighborhoodHelpViewController.m
//  CommunityAPP
//
//  Created by Dream on 14-3-10.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import "NeighborhoodHelpViewController.h"
#import "Global.h"
#import "NSObject_extra.h"
#import "NeiHelpCell.h"
#import "AddHelpViewController.h"
#import "UIViewController+NavigationBar.h"
@interface NeighborhoodHelpViewController ()

@end

@implementation NeighborhoodHelpViewController

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
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    //自适应iOS的导航栏、状态栏
    [self adjustiOS7NaviagtionBar];
    [self setNavigationTitle:@"邻居来帮忙"];
    //自定义返回按钮
    UIButton *backButton = [self setBackBarButton];
    [backButton addTarget:self action:@selector(backBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self setBackBarButtonItem:backButton];

    
    //    右边按钮
    UIImage *rightImage = [UIImage imageNamed:@"icon_phone_add.png"];
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setImage:rightImage forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(addBtnAction) forControlEvents:UIControlEventTouchUpInside];
    rightBtn.frame = CGRectMake(275,0,44,44);
    [self setRightBarButtonItem:rightBtn];
    
    neiHelpTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, MainHeight-70) style:UITableViewStylePlain];
    neiHelpTableView.delegate = self;
    neiHelpTableView.dataSource = self;
    [self.view addSubview:neiHelpTableView];
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
    NeiHelpCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NeiHelpCell"];
    if (cell == nil) {
        cell = [[[NeiHelpCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NeiHelpCell"]autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    return cell;
}

#pragma mark --Delegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90.0;
}



//导航栏左右按钮
-(void)backBtnAction
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)addBtnAction
{
    AddHelpViewController *addHelpVc = [[AddHelpViewController alloc]init];
    [self.navigationController pushViewController:addHelpVc animated:YES];
    [addHelpVc release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
