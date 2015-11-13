//
//  ShareContentViewController.m
//  CommunityAPP
//
//  Created by Stone on 14-4-21.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import "ShareContentViewController.h"
#import "Global.h"
#import "NSObject_extra.h"
#import "SellToolBar.h"
#import "CMDefaultShare.h"
#import "UIViewController+NavigationBar.h"
#import "CommunityHttpRequest.h"
#import "UserModel.h"
#import "ASIWebServer.h"

#define WORD_COUNT_LABEL_PADDING_RIGHT 10
#define WORD_COUNT_LABEL_PADDING_BOTTOM 19

@interface ShareContentViewController ()<UITextViewDelegate,CMShareDelegate,WebServiceHelperDelegate>

@property (nonatomic, retain) NSString *shareContent;

@property (nonatomic, retain) UITextView *textView;

@property (nonatomic, retain) UILabel *wordCountLabel;
@property (nonatomic, retain) CommunityHttpRequest *request;


@end

@implementation ShareContentViewController

- (void)dealloc{
    [_request cancelDelegate:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

- (id)initWithContent:(NSString *)content{
    self = [super init];
    if (self) {
        self.shareContent = content;
        self.shareType = ShareTypeSinaWeibo;
    }
    
    return self;
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
    [self.navigationController setNavigationBarHidden:NO];
    self.view.backgroundColor = [UIColor whiteColor];
    
    //自适应iOS的导航栏、状态栏
    [self adjustiOS7NaviagtionBar];
    [self setNavigationTitle:@"微博分享"];
    //自定义返回按钮
    UIButton *backButton = [self setBackBarButton];
    [backButton addTarget:self action:@selector(leftBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self setBackBarButtonItem:backButton];
    //    右边按钮
    UIImage *rightImage = [UIImage imageNamed:@"icon_phone_add_save.png"];
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setImage:rightImage forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(publishButtonClickHandler:) forControlEvents:UIControlEventTouchUpInside];
    rightBtn.frame = CGRectMake(275,0,44,44);
    [self setRightBarButtonItem:rightBtn];
    
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 12, 300, 153)];
    _textView.backgroundColor = [UIColor clearColor];
    _textView.layer.borderWidth = 1.0f;
    _textView.layer.borderColor = [UIColor grayColor].CGColor;
    _textView.layer.cornerRadius = 2.0f;
    _textView.layer.masksToBounds = YES;
    _textView.font = [UIFont systemFontOfSize:17.0];
    _textView.text = self.shareContent;
    _textView.delegate = self;
    _textView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:_textView];
    [_textView release];
        //字数
    _wordCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(310-40, CGRectGetMaxY(_textView.frame)-25, 50, 25)];
    _wordCountLabel.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    _wordCountLabel.textAlignment = NSTextAlignmentRight;
    _wordCountLabel.backgroundColor = [UIColor clearColor];
    _wordCountLabel.textColor = [UIColor grayColor];
    _wordCountLabel.text = @"140";
    _wordCountLabel.font = [UIFont systemFontOfSize:14];
    [_wordCountLabel sizeToFit];
    [self.view addSubview:_wordCountLabel];
    [_wordCountLabel release];
    
    [self updateWordCount];
    [_textView becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ---Action
- (void)leftBtnAction:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)publishButtonClickHandler:(UIButton *)sender{
    if (self.shareType == ShareTypeSinaWeibo) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveShareWeiboSucceed:) name:kCMShareTencentWeiboSucceed object:nil];
    }else if (self.shareType == ShareTypeTencentWeibo){
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveShareWeiboSucceed:) name:kCMShareTencentWeiboSucceed object:nil];
    }

    [ShareSDK shareWeibo:_textView.text type:self.shareType];
}

- (void)updateWordCount
{
    NSInteger count = 140 - [_textView.text length];
    _wordCountLabel.text = [NSString stringWithFormat:@"%ld", (long)count];
    
    if (count < 0)
    {
        _wordCountLabel.textColor = [UIColor redColor];
    }
    else
    {
        _wordCountLabel.textColor = [UIColor grayColor];
    }
    
    [_wordCountLabel sizeToFit];
}

#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView
{
    [self updateWordCount];
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    if (textView.text.length > 140) {
        return NO;
    }
    
    return YES;
}

- (void)receiveShareWeiboSucceed:(NSNotification *)notice{
    UserModel *userModel = [UserModel shareUser];
    NSString *parameters = [NSString stringWithFormat:@"?%@=%@&%@=%@&%@=%@&%@=%@",USER_ID,userModel.userId,COMMUNITY_ID,userModel.communityId,PROPERTY_ID,userModel.propertyId,@"pointType",@"shared"];
    CommunityHttpRequest *request = [CommunityHttpRequest shareInstance];
    [request requestPointChange:self parameters:parameters];

}

- (void)shareSuccess{

    
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)shareFail{
    NSLog(@"分享失败");
}

#pragma mark ---
-(void)callBackWith:(WInterface)interface status:(NSString *)status data:(id)data{
    if (interface == COMMUNITY_POINT_CHANGE) {
        if ([status isEqualToString:NETWORK_RETURN_CODE_S_OK]) {
            [self shareSuccess];
        }
    }
}

@end
