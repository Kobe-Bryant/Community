//
//  RulesRegulationsViewController.m
//  CommunityAPP
//
//  Created by yunlai on 14-3-6.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import "RulesRegulationViewController.h"
#import "NSObject_extra.h"
#import "Global.h"
#import "RuleRegulationUITableViewCell.h"
#import "RulesRegulationsDetailViewController.h"
#import "RuleRegulationManager.h"
#import "CommunityHttpRequest.h"
#import "DataBaseManager.h"
#import "UIImageView+WebCache.h"
#import "NoticeDetailViewController.h"
#import "AppConfig.h"
#import "UserModel.h"
#import "UpdateTimeModel.h"
#import "UIViewController+NavigationBar.h"
#import "NSObject+Time.h"
#import "MobClick.h"

@interface RulesRegulationViewController ()<RuleRegulationDelegate>

@property (nonatomic, retain) RuleRegulationManager *ruleRegulationManager;
@property (nonatomic, retain) NSMutableArray *rulesArray;
@property (nonatomic, retain) UITableView    *tableView;
@property (nonatomic, retain) DataBaseManager *dbManager;


@end

@implementation RulesRegulationViewController

@synthesize ruleRegulationManager = _ruleRegulationManager;
@synthesize rulesArray = _rulesArray;
@synthesize tableView = _tableView;

- (void)dealloc{
    _ruleRegulationManager.delegate = nil;
    _ruleRegulationManager = nil;
    
    [_rulesArray release]; _rulesArray = nil;
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _rulesArray = [[NSMutableArray alloc]  init];
         _dbManager = [DataBaseManager shareDBManeger];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
    [MobClick beginLogPageView:@"RulesRegulationPage"]; // 友盟统计
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
    [MobClick endLogPageView:@"RulesRegulationPage"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    //自适应iOS的导航栏、状态栏
    [self adjustiOS7NaviagtionBar];
    [self setNavigationTitle:@"规章制度"];
    //自定义返回按钮
    UIButton *backButton = [self setBackBarButton];
    [backButton addTarget:self action:@selector(backBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self setBackBarButtonItem:backButton];

    
    
    //    列表
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth,MainHeight)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.tableFooterView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
    [self.view addSubview:_tableView];
    [_tableView release];
    
    [self findLocalData];

    // 网络请求
    if (_ruleRegulationManager == nil) {
        _ruleRegulationManager = [RuleRegulationManager shareInstance];
    }
    _ruleRegulationManager.delegate = self;
    [_ruleRegulationManager getRuleRegulation];

}

- (void)findLocalData{
    [self.rulesArray removeAllObjects];
    NSArray *array = [_dbManager selectRulesRegulationModel];
    [self.rulesArray addObjectsFromArray:array];
    [_tableView reloadData];
}

- (NSString *)getUrlParameter{
    UserModel *userModel = [UserModel shareUser];
    
    NSString *string = [NSString stringWithFormat:@"?updateTime=%@&userId=%@&communityId=%@&propertyId=%@",DEF_UPDATE_TIME,userModel.userId,userModel.communityId,userModel.propertyId];//参数
    
    return string;
}

//返回
-(void)backBtnAction{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma UITableViewDelegate
#pragma mark UITableViewDataSource implementation
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.rulesArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identify = @"identify";
    
    RuleRegulationUITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[[RuleRegulationUITableViewCell alloc] initWithStyle:
                 UITableViewCellStyleSubtitle reuseIdentifier:identify] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    
    RulesRegulationModel *model = [self.rulesArray objectAtIndex:indexPath.row];
    cell.titleLabel.text = model.title;
    NSDate *formateDate = [NSObject fromatterDateFromStr:model.contentLabel];
    NSString *time = [NSObject compareCurrentTime:formateDate];
    //存放网络数据
    cell.timeLabel.text = time;
    [cell.iconImageView setImageWithURL:[NSURL URLWithString:model.icon] placeholderImage:[UIImage imageNamed:@"bg_sample_1.png"]];

    //当extro为一时，标为已读
    if (model.isRead) {
        cell.titleLabel.frame = CGRectMake(cell.iconImageView.frame.origin.x+cell.iconImageView.frame.size.width+9,cell.iconImageView.frame.origin.y+5, 235, 20);
        cell.titleLabel.font = [UIFont systemFontOfSize:15];
        cell.redpointLable.hidden = YES;
        
    }else{
        cell.redpointLable.hidden = NO;
        cell.titleLabel.frame = CGRectMake(cell.iconImageView.frame.origin.x+cell.iconImageView.frame.size.width+21,cell.iconImageView.frame.origin.y+5, 235, 20);
        cell.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    }

    return cell;
}

#pragma mark UITableViewDelegate implementation
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    RulesRegulationModel *model = [self.rulesArray objectAtIndex:indexPath.row];
    model.read = YES;
    [_dbManager updateRuleRegulationById:model.ruleId state:model.isRead];
    RulesRegulationsDetailViewController *detailVc = [[RulesRegulationsDetailViewController alloc] init];
    detailVc.ruleModel = model;
    [self.navigationController pushViewController:detailVc animated:YES];
    [detailVc release];
    
    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75;
}

#pragma mark ---CallBack
-(void) callBackWith: (WInterface) interface status: (NSString*) status data:(id) data{
    NSLog(@"interface :%d status:%@",interface,status);
}

#pragma mark ---RuleRegulationDelegate
- (void)shareRuleRegulationSucceed:(id)response{
    NSLog(@"response:%@",response);
    if ([response isKindOfClass:[NSDictionary class]]) {
        NSString *code = [response objectForKey:ERROR_CODE];
        if ([code isEqualToString:NETWORK_RETURN_CODE_S_OK]) {
            [self findLocalData];
            
        }else{
            NSLog(@"数据异常");
        }
        
    }
    
    [self.tableView reloadData];
}

- (void)shareRuleRegulationFailed:(id)response{
    NSLog(@"response:%@",response);
    NSLog(@"数据异常");
    [self.tableView reloadData];
}

@end
