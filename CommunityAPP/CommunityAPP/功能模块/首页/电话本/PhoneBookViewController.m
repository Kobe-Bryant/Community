//
//  PhoneBookViewController.m
//  CommunityAPP
//
//  Created by yunlai on 14-3-5.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import "PhoneBookViewController.h"
#import "Global.h"
#import "NSObject_extra.h"
#import "AddPhoneViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "DetailPhoneNumViewController.h"
#import "MakePhoneCall.h"
#import "CommunityHttpRequest.h"
#import "ASIWebServer.h"
#import "UserModel.h"
#import "ContactsTypeModel.h"
#import "DataBaseManager.h"
#import "ContactModel.h"
#import "NSObject+Time.h"
#import "ContactCell.h"
#import "UIViewController+NavigationBar.h"
#import "MobClick.h"

@interface ContactsTypeButton : UIButton

@property (nonatomic, retain) ContactsTypeModel *contactTypeModel;


@end

@implementation ContactsTypeButton

@synthesize contactTypeModel = _contactTypeModel;


- (id)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)setContactTypeModel:(ContactsTypeModel *)contactTypeModel{
    if (_contactTypeModel != contactTypeModel) {
        [_contactTypeModel release];
        _contactTypeModel = [contactTypeModel retain];
    }
    [self setTitle:contactTypeModel.typeName forState:UIControlStateNormal];
}

@end

@interface PhoneBookViewController ()<UITableViewDataSource,UITableViewDelegate>


//@property(nonatomic,assign)int currentTag;                  //当前分类的tag
@property(nonatomic,retain)UIScrollView *itemScrollView;    //分类的容器ScrollView
@property(nonatomic,retain) NSMutableArray *itemViews;
@property (nonatomic, retain) DataBaseManager *dbManager;

@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) NSMutableArray *contactsType;
@property (nonatomic, retain) NSMutableArray *localContactType;
@property (nonatomic, retain) NSMutableArray *contacts;

@property (nonatomic, retain) CommunityHttpRequest *contactsTypeRequest;
@property (nonatomic, retain) CommunityHttpRequest *contactsListRequest;
@property (nonatomic, retain) CommunityHttpRequest *contactsDeleteRequest;

@property (nonatomic, retain) UpdateTimeModel *contactsTypeUpdateTime;

@property(copy,nonatomic) void (^AlertView)(NSString * title,NSString * message);//显示提示框

@property (nonatomic, retain)  UIImageView *currentBgView;
@property (nonatomic, retain) ContactsTypeButton *selectedTypeBtn;
@property (nonatomic, retain) UIWebView *phoneCallWebView;

@property (nonatomic, retain) ContactsTypeModel *recentlyModel;

@end

@implementation PhoneBookViewController
@synthesize itemViews = _itemViews;
@synthesize itemScrollView;
//@synthesize currentTag;
@synthesize tableView = _tableView;
@synthesize AlertView=_AlertView;
@synthesize contactsType = _contactsType;
@synthesize contactsListRequest = _contactsListRequest;
@synthesize contactsTypeRequest = _contactsTypeRequest;
@synthesize contactsTypeUpdateTime = _contactsTypeUpdateTime;
@synthesize selectedTypeBtn = _selectedTypeBtn;
@synthesize currentBgView = _currentBgView;
@synthesize phoneCallWebView = _phoneCallWebView;
@synthesize recentlyModel = _recentlyModel;


-(void)dealloc{
    [_localContactType release]; _localContactType = nil;
    [_contactsDeleteRequest cancelDelegate:self];
    [_contactsListRequest cancelDelegate:self];
    [_contactsTypeRequest cancelDelegate:self];
    [_itemViews release];       _itemViews = nil;
    [itemScrollView release];  itemScrollView= nil;
    [_currentBgView release];  _currentBgView = nil;
    [_tableView release];     _tableView = nil;
    [_contactsType release]; _contactsType = nil;
    [_contacts release];    _contacts = nil;
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _dbManager = [DataBaseManager shareDBManeger];
        
        _contactsType = [[NSMutableArray alloc] init];
        _localContactType = [[NSMutableArray alloc] init];
        _contacts = [[NSMutableArray alloc] init];
        
        self.itemViews = [[NSMutableArray alloc] init];
        
        _recentlyModel = [[ContactsTypeModel alloc] init];
        _recentlyModel.typeId = [MY_RECENTLY_TYPE_ID integerValue];
        _recentlyModel.typeName = @"最近";
        _recentlyModel.isRecently = YES;
        _recentlyModel.isRequestSucceed = YES;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
    [MobClick beginLogPageView:@"PhoneBookPage"];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
    [MobClick endLogPageView:@"PhoneBookPage"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    //自适应iOS的导航栏、状态栏
    [self adjustiOS7NaviagtionBar];
    [self setNavigationTitle:@"电话本"];
    //自定义返回按钮
    UIButton *backButton = [self setBackBarButton];
    [backButton addTarget:self action:@selector(backBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self setBackBarButtonItem:backButton];
    
    //    右边按钮
    UIImage *rightImage = [UIImage imageNamed:@"icon_phone_add.png"];
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setImage:rightImage forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightBtnAction) forControlEvents:UIControlEventTouchUpInside];
    rightBtn.frame = CGRectMake(275,0,44,44);
    [self setRightBarButtonItem:rightBtn];
    

    //    上面的类型
    UIView *typeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
    typeView.backgroundColor = [UIColor whiteColor];
    [typeView.layer setMasksToBounds:YES];
    [typeView.layer setBorderWidth:1]; //边框宽度
    typeView.layer.borderColor = RGB(182, 182, 182).CGColor;
    [self.view addSubview:typeView];
    [typeView release];
    
    //构建滚动视图
    itemScrollView =[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, typeView.frame.size.height)] ;
    itemScrollView.pagingEnabled = NO;
    itemScrollView.showsHorizontalScrollIndicator = NO;
    itemScrollView.showsVerticalScrollIndicator = NO;
    itemScrollView.scrollsToTop = NO;
    [itemScrollView setBackgroundColor:[UIColor clearColor]];
    [typeView addSubview:itemScrollView];
    
    self.selectedTypeBtn = nil;
    
    
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(typeView.frame), ScreenWidth, MainHeight - CGRectGetMaxY(typeView.frame)) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
    if (IOS7_OR_LATER) {
        if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [_tableView setSeparatorInset:UIEdgeInsetsZero];
        }
    }
    [self.view addSubview:_tableView];

    [self setAlertView:^(NSString *title, NSString *msg) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                        message:msg
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
    }];
    
    [self selectContactsTypeUpdateTime];
    [self selectAllContactsType];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self requestContactsType];
        
    });
    
}


//右边按钮
-(void)rightBtnAction{
    AddPhoneViewController *addPhoneVc = [[AddPhoneViewController alloc] init];
    addPhoneVc.prviewController = self;
    [self.navigationController pushViewController:addPhoneVc animated:YES];
    [addPhoneVc release];
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

#pragma mark ---Database
- (void)selectAllContactsType{
    [self.contactsType removeAllObjects];
    [self addRecentlyType];
    NSArray *array  = [_dbManager selectAllContactsType];
    
    [self.contactsType addObjectsFromArray:array];
    
    [self refreshTypeList];
    
}

- (void)addRecentlyType{
    [self.contactsType removeAllObjects];
    [self.contactsType addObject:_recentlyModel];   //添加最近
}

- (void)selectAllContactByType:(NSInteger)type{
    [self.contacts removeAllObjects];
    NSArray *array = [_dbManager selectContactsbyType:type];
    [self.contacts addObjectsFromArray:array];
    
    [self refreshContactList];
    
}

- (void)selectContactsTypeUpdateTime{
    _contactsTypeUpdateTime = [_dbManager selectUpdateTimeByInterface:COMMUNITY_CONTACTS_TYPE];
    
}

- (void)showMyConatcts:(BOOL)show{
    if (_selectedTypeBtn.contactTypeModel.typeId == [MY_PRIVATE_CONTACTS_TYPE_ID integerValue]) {
        _selectedTypeBtn.contactTypeModel.isRequestSucceed = NO;
        [self itemViewTapped:_selectedTypeBtn];
        return;
    }else{
        for (ContactsTypeButton *btn in self.itemViews) {
            if (btn.contactTypeModel.typeId == [MY_PRIVATE_CONTACTS_TYPE_ID integerValue]){
                btn.contactTypeModel.isRequestSucceed = NO;
                [self itemViewTapped:btn];
            }
        }
    }
}


-(void)itemViewTapped:(id)sender{
    
    ContactsTypeButton *btn = (ContactsTypeButton *)sender;
    _selectedTypeBtn = btn;
    _selectedTypeBtn.selected = YES;
    
    [self refreshContactButtonState];
    
    [self typeChangeAnimation:btn];
    
    
    [self selectAllContactByType:btn.contactTypeModel.typeId];
    [self refreshContactList];
    
    if (!btn.contactTypeModel.isRequestSucceed && !btn.contactTypeModel.isRecently) {
        [self requestContactsList:btn.contactTypeModel.typeId];
    }
    
    //最近
    if (btn.contactTypeModel.isRecently) {
        NSArray *array = [_dbManager selectAllMadePhoneCall];
        [self.contacts removeAllObjects];
        [self.contacts addObjectsFromArray:array];
        [self refreshContactList];
    }
    
}

- (void)refreshContactButtonState{
    for (ContactsTypeButton *btn in self.itemViews) {
        if (btn == _selectedTypeBtn) {
            btn.selected = YES;
            btn.enabled = NO;
        }else{
            btn.selected = NO;
            btn.enabled = YES;
        }
        
    }
}

- (BOOL)isHadRecentlyCall{
    NSArray *array = [_dbManager selectAllMadePhoneCall];
    if ([array count] == 0) {
        return NO;
    }
    
    return YES;
}

- (void)layoutItemViews
{
    CGFloat x = 15;
    
    for (NSUInteger i = 0; i < self.itemViews.count; i++) {
        ContactsTypeButton *itemView = self.itemViews[i];
        CGFloat width = [itemView.contactTypeModel.typeName sizeWithFont:[UIFont systemFontOfSize:15]].width+22;
        
        itemView.frame = CGRectMake(x, 4., width, 30);
        x += width + 5;
    }
    self.itemScrollView.contentSize = CGSizeMake(x, CGRectGetHeight(self.itemScrollView.frame));
    
    CGRect frame = self.itemScrollView.frame;
    if (320 > x) {
        frame.origin.x = (320 - x) / 2.;
        frame.size.width = x;
    } else {
        frame.origin.x = 0.;
        frame.size.width = 320;
    }
    self.itemScrollView.frame = frame;
}

- (void)typeChangeAnimation:(id)sender
{
    if ([sender isKindOfClass:[ContactsTypeButton class]]) {
        ContactsTypeButton *itemView = _selectedTypeBtn;
        [UIView beginAnimations:@"typeChangeAnimation" context:NULL];
        UIImage *currentImage = [UIImage imageNamed:@"bg_award_btnLine.png"];
        [_currentBgView setFrame:CGRectMake(CGRectGetMinX(itemView.frame), 36, CGRectGetWidth(itemView.frame)/*labelWindth+10*/, currentImage.size.height)];
        _currentBgView.image = currentImage;
        [UIView commitAnimations];
    }
}


#pragma mark ---network
//请求电话本分类
- (void)requestContactsType{
    UserModel *userModel = [UserModel shareUser];
    NSString *parameters = [NSString stringWithFormat:@"?%@=%@&%@=%@&%@=%@",USER_ID,userModel.userId,COMMUNITY_ID,userModel.communityId,PROPERTY_ID,userModel.propertyId];
    
    
    if (_contactsTypeRequest == nil) {
        _contactsTypeRequest = [CommunityHttpRequest shareInstance];
    }
    [_contactsTypeRequest requestContactTypes:self parameters:parameters];
    
}

- (void)requestContactsList:(NSInteger)type{
    UserModel *userModel = [UserModel shareUser];
    NSString *parameters = [NSString stringWithFormat:@"?%@=%@&%@=%@&%@=%@&typeId=%d",USER_ID,userModel.userId,COMMUNITY_ID,userModel.communityId,PROPERTY_ID,userModel.propertyId,type];
    
    if (_contactsListRequest == nil) {
        _contactsListRequest = [CommunityHttpRequest shareInstance];
    }
    [_contactsListRequest requestContacts:self parameters:parameters];
}


- (void)requestDeleteMyContact:(NSInteger)contactId{
    
    UserModel *userModel = [UserModel shareUser];
    NSString *parameters = [NSString stringWithFormat:@"?%@=%@&%@=%@&%@=%@&%@=%@&id=%d",UPDATE_TIME,DEF_UPDATE_TIME,USER_ID,userModel.userId,COMMUNITY_ID,userModel.communityId,PROPERTY_ID,userModel.propertyId,contactId];
    
    if (_contactsDeleteRequest == nil) {
        _contactsDeleteRequest = [CommunityHttpRequest shareInstance];
    }
    [_contactsDeleteRequest deleteContact:self parameters:parameters];
}

-(void) callBackWith: (WInterface) interface status: (NSString*) status data:(id) data{
    if (interface == COMMUNITY_CONTACTS_TYPE) {     //电话本类型
        
        if ([status isEqualToString:NETWORK_RETURN_CODE_S_OK]) {
            //清除本地数据库中的数据集内存中的数据
            [_dbManager deleteAllContactsType];
            [self.contactsType removeAllObjects];
            
            [self addRecentlyType];
            NSArray *array = [data objectForKey:@"list"];

            for (NSDictionary *dic in array) {
                ContactsTypeModel *model = [[ContactsTypeModel alloc] init];
                model.typeId = [[dic objectForKey:@"id"] integerValue];
                model.typeName = [dic objectForKey:@"typeName"];
                //插入数据库
                BOOL flag = [_dbManager insertContactsTypeModel:model];
                if (flag) {
                    
                }
                [self.contactsType addObject:model];
                [model release];
            }
            [self refreshTypeList];
        }

    }else if (interface == COMMUNITY_CONTACTS_LIST){    //电话本类型
        NSLog(@"COMMUNITY_CONTACTS_LIST :%@",data);
        
        if ([status isEqualToString:NETWORK_RETURN_CODE_S_OK]) {
            [_dbManager deleteAllContactsByType:self.selectedTypeBtn.contactTypeModel.typeId];
            [self.contacts removeAllObjects];
            self.selectedTypeBtn.contactTypeModel.isRequestSucceed = YES;
            NSArray *array = [data objectForKey:@"list"];
            if ([array count] > 0) {
                [self.contacts removeAllObjects];
            }
            for (NSDictionary *dic in array) {
                ContactModel *model = [[ContactModel alloc] init];
                model.contactId = [[dic objectForKey:@"id"] integerValue];
                model.contactName = [dic objectForKey:@"contact"];
                model.contactDescription = [dic objectForKey:@"description"];
                model.type = [dic objectForKey:@"typeId"];
                model.phoneNumber = [dic objectForKey:@"phoneNumber"];
                model.typeName = [dic objectForKey:@"typeName"];
            
                //插入数据库
                BOOL flag = [_dbManager insertContact:model];
                if (flag) {
                    
                }
                [self.contacts addObject:model];
                [model release];
            }
            [self refreshContactList];
        }
        
    }else if(interface == COMMUNITY_PRIVATE_CONTACTS_DELETE){
        
        if ([status isEqualToString:NETWORK_RETURN_CODE_S_OK]) {

        }else{
            NSLog(@"OMMUNITY_PRIVATE_CONTACTS_DELETE failed");
        }
    }
}


- (void)refreshTypeList{
    //label的添加
    [self.itemViews removeAllObjects];
    for (ContactsTypeButton *btn in self.itemScrollView.subviews) {
        [btn removeFromSuperview];
    }
    
    // 动画背景
    UIImage *currentImage = [UIImage imageNamed:@"bg_award_btnLine.png"];
    _currentBgView = [[UIImageView alloc] initWithImage:currentImage];
    [_currentBgView setFrame:CGRectMake(8, 36, currentImage.size.width+10, currentImage.size.height)];
    [itemScrollView addSubview:_currentBgView];
    
    NSMutableArray *mutableItemViews = [NSMutableArray arrayWithCapacity:self.contactsType.count];
    for (int i = 0; i<[self.contactsType count]; i++) {
        CGRect frame = CGRectMake(0.,0., 100, 30);
        
        ContactsTypeButton *itemView = [[ContactsTypeButton alloc] initWithFrame:frame];
        [itemView addTarget:self action:@selector(itemViewTapped:) forControlEvents:UIControlEventTouchUpInside];
        [itemView setTitleColor:RGB(53, 53, 53) forState:UIControlStateNormal];
        [itemView setTitleColor:RGB(87, 182, 16) forState:UIControlStateSelected];
        [itemView setTitleColor:RGB(87, 182, 16) forState:UIControlStateDisabled];
        itemView.titleLabel.font = [UIFont systemFontOfSize:14];
        itemView.contactTypeModel = [self.contactsType objectAtIndex:i];
        [self.itemScrollView addSubview:itemView];
        itemView.tag = i;
        [mutableItemViews addObject:itemView];
    }
    [self.itemViews addObjectsFromArray:mutableItemViews];
    [self layoutItemViews];
    
    if ([self isHadRecentlyCall]) {
        _selectedTypeBtn = [self.itemViews count] > 0 ? [self.itemViews objectAtIndex:0] : nil;
    }else{
        _selectedTypeBtn = [self.itemViews count] > 1 ? [self.itemViews objectAtIndex:1] : nil;
    }
    [self  performSelector:@selector(itemViewTapped:) withObject:_selectedTypeBtn  afterDelay:0.0001];
}

- (void)refreshContactList{
    [_tableView reloadData];
}

#pragma mark ---UITableView DataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identify = @"identify";
    ContactCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[[ContactCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify] autorelease];
        cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }

    
    ContactModel *contactModel = ([_contacts count] > indexPath.row) ? [_contacts objectAtIndex:indexPath.row] : nil;
    cell.textLabel.text = contactModel.contactName;
    cell.contactModel = contactModel;
    cell.btnPhoneCall.tag = indexPath.row;
    [cell.btnPhoneCall addTarget:self action:@selector(makePhoneCall:) forControlEvents:UIControlEventTouchUpInside];
    
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [_contacts count];
}

#pragma mark  ---UITableView Delegate

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.selectedTypeBtn.contactTypeModel.typeId == [MY_PRIVATE_CONTACTS_TYPE_ID integerValue] || self.selectedTypeBtn.contactTypeModel.typeId == [MY_RECENTLY_TYPE_ID integerValue]) {
        return UITableViewCellEditingStyleDelete;
    }
    
    return UITableViewCellEditingStyleNone;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.selectedTypeBtn.contactTypeModel.typeId == [MY_PRIVATE_CONTACTS_TYPE_ID integerValue] || self.selectedTypeBtn.contactTypeModel.typeId == [MY_RECENTLY_TYPE_ID integerValue]) {
        return YES;
    }
    
    return NO;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{

}

- (NSString *)tableView:(UITableView *)tableVie titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ContactModel *model = ([self.contacts count] > indexPath.row) ? [self.contacts objectAtIndex:indexPath.row] : nil;
    DetailPhoneNumViewController *detailPhoneVC = [[DetailPhoneNumViewController alloc] initWithNibName:nil bundle:nil];
    detailPhoneVC.contactModel = model;
    detailPhoneVC.prviewController = self;
    [self.navigationController pushViewController:detailPhoneVC animated:YES];
    [detailPhoneVC release];
}

/// 当点击删除时，删除该条记录
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.selectedTypeBtn.contactTypeModel.typeId == [MY_PRIVATE_CONTACTS_TYPE_ID integerValue]) {
        if (editingStyle == UITableViewCellEditingStyleDelete) {
          ContactModel *model = ([self.contacts count] > indexPath.row) ? [self.contacts objectAtIndex:indexPath.row] : nil;
            if (model) {
                
                [self requestDeleteMyContact:model.contactId];
                 BOOL flag = [_dbManager deleteMyContact:model];
                if (flag) {
                    [self.contacts removeObject:model];
                    NSArray *array = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section]];
                    [tableView deleteRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationAutomatic];
                }
            }
        }
    }else if (self.selectedTypeBtn.contactTypeModel.typeId == [MY_RECENTLY_TYPE_ID integerValue]){
        ContactModel *model = ([self.contacts count] > indexPath.row) ? [self.contacts objectAtIndex:indexPath.row] : nil;
        if (model) {
            BOOL flag = [_dbManager deleteMadePhoneCall:model.contactId];
            if (flag) {
                NSLog(@"删除浏览记录成功");
                [self.contacts removeObject:model];
                NSArray *array = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section]];
                [tableView deleteRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationAutomatic];
            }else{
                NSLog(@"删除浏览记录失败");
            }
        }
    }

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.0f;
}


- (void)makePhoneCall:(UIButton *)sender{
    NSLog(@"%@",NSStringFromSelector(_cmd));
    NSLog(@"%d",sender.tag);
    NSString *msg;

    ContactModel *model = ([self.contacts count] > sender.tag)?[self.contacts objectAtIndex:sender.tag]:nil;
    if (model == nil) {
        return;
    }

    BOOL call_ok = [self makeCall:model.phoneNumber];
    
    if (call_ok) {
        ContactModel *currentModel = [model copy];
        
        currentModel.typeName = @"最近";
        currentModel.type = @"最近";
        currentModel.lastCallTime = [NSObject getCurrentTime];
        _dbManager = [DataBaseManager shareDBManeger];
        
        BOOL flag = [_dbManager insertMadePhoneCall:currentModel];
        if (flag) {
            NSLog(@"插入拨打电话记录成功");
        }else{
            NSLog(@"插入拨打电话记录失败");
        }
    }else{
        msg=@"设备不支持电话功能";
        [self alertWithTitle:nil msg:msg];
    }
    
}

- (BOOL) makeCall:(NSString *)phoneNumber
{
    if (phoneNumber==nil ||[phoneNumber isEqualToString:@""])
    {
        return NO;
    }
    BOOL call_ok = false;
      NSString *numberAfterClear = [[phoneNumber componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789-+()"] invertedSet]] componentsJoinedByString:@""];
    NSURL *phoneNumberURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", numberAfterClear]];
    NSLog(@"make call, URL=%@", phoneNumberURL);
    
    call_ok = [[UIApplication sharedApplication] canOpenURL:phoneNumberURL];
    if (call_ok) {
        if ( !_phoneCallWebView ) {
            _phoneCallWebView = [[UIWebView alloc]initWithFrame:CGRectZero];// 这个webView只是一个后台的容易 不需要add到页面上来 效果跟方法二一样 但是这个方法是合法的
        }
        [_phoneCallWebView loadRequest:[NSURLRequest requestWithURL:phoneNumberURL]];
        [self.view addSubview:_phoneCallWebView];
    }
    
    return call_ok;
}

- (void) alertWithTitle: (NSString *)title msg: (NSString *)msg
{
    if (self.AlertView) {
        self.AlertView(title,msg);
    }
}



@end
