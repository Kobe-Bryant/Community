//
//  NeighborhoodChatViewController.m
//  IMDemo
//
//  Created by Dream on 14-7-18.
//  Copyright (c) 2014年 Yunlai-mac02. All rights reserved.
//

#import "NeighborhoodChatViewController.h"
#import "NSObject_extra.h"
#import "Global.h"
#import "UIViewController+NavigationBar.h"
#import "UIView+AnimationOptionsForCurve.h"
#import "emoji.h"
#import "HPGrowingTextView.h"
#import "faceView.h"
#import "ChartMessage.h"
#import "ChartCellFrame.h"
#import "ChartCell.h"
#import "UIImage+StrethImage.h"


#define KEYBOARDY  282
@interface NeighborhoodChatViewController ()<UITableViewDataSource, UITableViewDelegate,HPGrowingTextViewDelegate,faceViewDelegate>{
    
    UITableView *_chatTableView;
    
    UIToolbar *faceToolBar;
    
    HPGrowingTextView *textViewInput;
    
    UIButton *sendButton;
    
    faceView *keyBoardFaceView;
    
    CGRect heigthAndWindthFrame;

}

@property (assign, nonatomic, readonly) UIEdgeInsets originalTableViewContentInset;
@property (nonatomic,strong) NSMutableArray *cellContentAry;

@end

@implementation NeighborhoodChatViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _cellContentAry = [[NSMutableArray alloc]initWithCapacity:0];
    }
    return self;
}
- (void)dealloc
{
   // [self.cellContentAry release]; self.cellContentAry = nil; // 这里不能释放，会出现僵尸,目前还不知道在哪释放比较好
    [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self scrollToBottomAnimated:NO];
    _originalTableViewContentInset = _chatTableView.contentInset;
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //[self setNavigationTitle:@"我的邻居"];
    
    //自定义返回按钮
    UIButton *backButton = [self setBackBarButton];
    [backButton addTarget:self action:@selector(leftBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self setBackBarButtonItem:backButton];
    
    [self initTableView];   //初始化tableview、
    [self initInputKeyBorder]; //聊天toorbar
}

- (void)initInputKeyBorder {
    
    faceToolBar = [[UIToolbar alloc] init];
    faceToolBar.frame = CGRectMake(0, MainHeight - 49, ScreenWidth, 49);
    if (IOS7_OR_LATER) {
        faceToolBar.barTintColor = [UIColor whiteColor];
    }else{
        faceToolBar.tintColor = [UIColor whiteColor];
    }
    heigthAndWindthFrame = faceToolBar.frame;
    [self.view addSubview:faceToolBar];
    [faceToolBar release];
    
    //  表情添加按钮
    UIImage *addImage = [UIImage imageNamed:@"toolbar_expression.png"];
    UIButton *faceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    faceButton.frame = CGRectMake(5, 5, 40, 40);
    faceButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleTopMargin;
    [faceButton setImage:addImage forState:UIControlStateNormal];
    [faceButton addTarget:self action:@selector(showFace:) forControlEvents:UIControlEventTouchUpInside];
    [faceToolBar addSubview:faceButton];
    
    //发送按钮
    UIImage *sendImage = [UIImage imageNamed:@"bg_chat_sendImage.png"];
    sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [sendButton setTitle:@"发送" forState:UIControlStateNormal];
    [sendButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
    sendButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleTopMargin;
    [sendButton setBackgroundImage:sendImage forState:UIControlStateNormal];
    [sendButton addTarget:self action:@selector(sendAction) forControlEvents:UIControlEventTouchUpInside];
    sendButton.enabled = NO;
    sendButton.layer.borderWidth = 0.5f;
    sendButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    sendButton.layer.masksToBounds = YES;
    sendButton.layer.cornerRadius = 4.0;
    [sendButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    sendButton.frame = CGRectMake(ScreenWidth - 58, 8, 50, 30);
    [faceToolBar addSubview:sendButton];
    
    textViewInput = [[HPGrowingTextView alloc] initWithFrame:CGRectMake(faceButton.frame.size.width+faceButton.frame.origin.x, 6, 210, 28)];
    textViewInput.font = [UIFont systemFontOfSize:15];
    textViewInput.minNumberOfLines = 1;
    textViewInput.maxNumberOfLines = 4;
    textViewInput.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    textViewInput.layer.borderColor = [[UIColor colorWithWhite:.8 alpha:1.0] CGColor];
    textViewInput.layer.borderWidth = 0.65f;
    textViewInput.layer.cornerRadius = 6.0f;
    textViewInput.layer.borderColor = RGB(229, 229, 229).CGColor;
    textViewInput.backgroundColor = [UIColor whiteColor];
    textViewInput.placeholder = @"我也来说一句"; //默认显示的字
    textViewInput.delegate = self;
    textViewInput.textAlignment = NSTextAlignmentLeft;
    textViewInput.autoresizingMask = UIViewAutoresizingFlexibleWidth;//自适应高度
    textViewInput.returnKeyType = UIReturnKeySend;
    [faceToolBar addSubview:textViewInput];
    [textViewInput release];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillDisappear:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillAppear:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    
//    表情键盘 
    if (IOS7_OR_LATER) {
        keyBoardFaceView = [[faceView alloc] initWithFrame:CGRectMake(0, MainHeight - 216, ScreenWidth, 216)];
    }else{
        keyBoardFaceView = [[faceView alloc] initWithFrame:CGRectMake(0, MainHeight - 216, ScreenWidth, 216)];
    }
    keyBoardFaceView.delegate = self;
    keyBoardFaceView.hidden = YES;
    [self.view addSubview:keyBoardFaceView];
    [keyBoardFaceView release];
}

- (void)initTableView {
    _chatTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth,MainHeight - 49) style:UITableViewStylePlain];
    _chatTableView.delegate = self;
    _chatTableView.dataSource = self;
    _chatTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_chatTableView];
    [_chatTableView release];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] init];
	[tapGestureRecognizer addTarget:self action:@selector(gestureRecognizerHandle:)];
	tapGestureRecognizer.cancelsTouchesInView = NO;
	[_chatTableView addGestureRecognizer:tapGestureRecognizer];
    [tapGestureRecognizer release];
    
    //[self initwithData];    //初始化数据，刚开始显示的数据
}

//-(void)initwithData
//{  //初始数据从 plish文件获取
//    NSString *path=[[NSBundle mainBundle] pathForResource:@"messages" ofType:@"plist"];
//    NSArray *data=[NSArray arrayWithContentsOfFile:path];
//    
//    for(NSDictionary *dict in data){
//        ChartCellFrame *cellFrame=[[ChartCellFrame alloc]init];
//        ChartMessage *chartMessage=[[ChartMessage alloc]init];
//        chartMessage.dict=dict;
//        cellFrame.chartMessage=chartMessage;
//        [self.cellContentAry addObject:cellFrame];
//    }
//}

#pragma mark - UITableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.cellContentAry count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"ChatCell";
    ChartCell *cell = [_chatTableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[ChartCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.cellFrame=self.cellContentAry[indexPath.row];
    return cell;
}

#pragma mark - UITableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.cellContentAry[indexPath.row] cellHeight];
}

//点击TableView，移除键盘,
- (void)gestureRecognizerHandle:(UITapGestureRecognizer*) gesture {
    if ([[(UIGestureRecognizer *)gesture view] isKindOfClass:[UITableView class]]) {
		[self removeKeyboard];
	}
}

//向下滑动移除键盘
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self removeKeyboard];
}

- (void)removeKeyboard {
    [textViewInput resignFirstResponder];
    if (!keyBoardFaceView.hidden) {
        [UIView animateWithDuration:0.25
                              delay:0.0f
                            options:[UIView animationOptionsForCurve:UIViewAnimationCurveEaseInOut]
                         animations:^{
                             keyBoardFaceView.hidden = YES;
                             
                             faceToolBar.frame = CGRectMake(0, MainHeight -heigthAndWindthFrame.size.height, ScreenWidth, heigthAndWindthFrame.size.height);
                             
                             UIEdgeInsets insets = self.originalTableViewContentInset;
                             insets.bottom = self.view.frame.size.height - faceToolBar.frame.origin.y - faceToolBar.frame.size.height;
                             _chatTableView.contentInset = insets;
                             _chatTableView.scrollIndicatorInsets = insets;
                         }
                         completion:^(BOOL finished) {
                         }];
    }
}

//发送消息点击按钮事件
-(void)sendAction {
    NSLog(@"发送");
    
    ChartCellFrame *cellFrame = [[ChartCellFrame alloc]init];
    ChartMessage *chartMessage = [[ChartMessage alloc]init];
    
    int random=arc4random_uniform(2);  // 随机函数，自己跟自己聊天
    NSLog(@"%d",random);
    chartMessage.icon=[NSString stringWithFormat:@"icon%02d.jpg",random+1];
    chartMessage.messageType=random;
    chartMessage.content = textViewInput.text;
    cellFrame.chartMessage=chartMessage;
    
    [self.cellContentAry addObject:cellFrame];
    [_chatTableView reloadData];
   // [cellFrame release]; // 这里不能释放，会出现僵尸
   // [chartMessage release]; // 这里不能释放，会出现僵尸
    textViewInput.text = @"";
    
    //滚动到当前行
    [self scrollToBottomAnimated:YES];
    
}

//界面滚动到底部
- (void)scrollToBottomAnimated:(BOOL)animated
{
    NSInteger rows = [_chatTableView numberOfRowsInSection:0];
	
    if(rows > 0) {
        [_chatTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:rows - 1 inSection:0]
                              atScrollPosition:UITableViewScrollPositionBottom
                                      animated:animated];
    }
}

- (void)showFace:(id)sender {
    if (keyBoardFaceView.hidden) {
        [textViewInput resignFirstResponder];
        [UIView animateWithDuration:0.2
                              delay:0.0f
                            options:[UIView animationOptionsForCurve:UIViewAnimationCurveEaseInOut]
                         animations:^{
                            // CGFloat keyboardY =  KEYBOARDY;
                             
                             CGRect inputViewFrame = faceToolBar.frame;
                             CGFloat inputViewFrameY;
//                             if (isIPhone5) {
                             inputViewFrameY =  self.view.frame.size.height - inputViewFrame.size.height - keyBoardFaceView.frame.size.height;  //keyboardY - inputViewFrame.size.height;
//                             }else{
//                                 inputViewFrameY = keyboardY - inputViewFrame.size.height-84;
//                             }
                             
                             faceToolBar.frame = CGRectMake(inputViewFrame.origin.x,
                                                            inputViewFrameY,
                                                            inputViewFrame.size.width,
                                                            inputViewFrame.size.height);
                             
                             UIEdgeInsets insets = self.originalTableViewContentInset;
                             insets.bottom = self.view.frame.size.height - faceToolBar.frame.origin.y - inputViewFrame.size.height;
                             
                             _chatTableView.contentInset = insets;
                             _chatTableView.scrollIndicatorInsets = insets;
                             
                             keyBoardFaceView.hidden = NO;
                             
                         }
                         completion:^(BOOL finished) {
                         }];
        if (![textViewInput isFirstResponder]) {
            [self scrollToBottomAnimated:NO];
        }
    }else{
        keyBoardFaceView.hidden = YES;
        [textViewInput becomeFirstResponder];
    }
}

#pragma mark - public method
- (void)keyboardWillAppear:(NSNotification *)note{
    CGRect inputBarFrame = faceToolBar.frame;
    inputBarFrame.origin.y = self.view.frame.size.height - inputBarFrame.size.height - [[note.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    [UIView animateWithDuration:[[note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue]
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState | [[note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue]
                     animations:^{
                         faceToolBar.frame = inputBarFrame;
                         
                         UIEdgeInsets insets = self.originalTableViewContentInset;
                         insets.bottom = self.view.frame.size.height - faceToolBar.frame .origin.y - faceToolBar.frame.size.height;
                         
                         _chatTableView.contentInset = insets;
                         _chatTableView.scrollIndicatorInsets = insets;
                         //						 chatTableVIew.frame = CGRectMake(0, chatTableVIew.frame.origin.y, 320, inputBarFrame.origin.y);
                     }
                     completion:^(BOOL finished){
                         //键盘呼起时将聊天表滑到底部
                         [self scrollToBottomAnimated:NO];
                     }];
    
}

- (void)keyboardWillDisappear:(NSNotification *)note{
    CGRect inputBarFrame = faceToolBar.frame;
    inputBarFrame.origin.y = faceToolBar.frame.origin.y + [[note.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    
    [UIView animateWithDuration:[[note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue]
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState | [[note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue]
                     animations:^{
                         faceToolBar.frame = inputBarFrame;
                         
                         UIEdgeInsets insets = self.originalTableViewContentInset;
                         insets.bottom = self.view.frame.size.height - faceToolBar.frame .origin.y - faceToolBar.frame.size.height;
                         
                         _chatTableView.contentInset = insets;
                         _chatTableView.scrollIndicatorInsets = insets;
                         
                         //						 chatTableVIew.frame = CGRectMake(0, chatTableVIew.frame.origin.y, 320, inputBarFrame.origin.y);
                     }
                     completion:nil];
    
}

#pragma mark -
#pragma mark UIExpandingTextView delegate
#pragma mark HPGrowingTextView 委托
- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height
{
    float diff = (growingTextView.frame.size.height - height);
	CGRect r = faceToolBar.frame;
    r.size.height -= diff;
    r.origin.y += diff;
    
    heigthAndWindthFrame = r;
    
	faceToolBar.frame = r;
}

- (BOOL)growingTextViewShouldBeginEditing:(HPGrowingTextView *)growingTextView
{
	return YES;
}

- (void)growingTextViewDidBeginEditing:(HPGrowingTextView *)growingTextView
{
}

- (BOOL)growingTextView:(HPGrowingTextView *)growingTextView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
	return YES;
}

- (BOOL)growingTextViewShouldReturn:(HPGrowingTextView *)growingTextView{
    [self sendAction]; //还有待修改。。。。。
    return YES;
}

- (void)growingTextViewDidChange:(HPGrowingTextView *)growingTextView{
    if (textViewInput.text.length>0) {
        sendButton.enabled = YES;
    }else{
        sendButton.enabled = NO;
    }
}

#pragma mark -
#pragma mark faceViewDelegate 委托
- (void)faceView:(faceView *)faceView didSelectAtString:(NSString *)faceString {
    NSRange range = textViewInput.selectedRange;
    NSMutableString *textString = [NSMutableString stringWithString:textViewInput.text];
    [textString insertString:faceString atIndex:range.location];
    range.location = range.location + faceString.length;
    textViewInput.text = textString;
    if (range.location <= textString.length)
    {
        textViewInput.selectedRange = range;
    }
    
}

- (void)delFaceString
{
    NSRange range = textViewInput.selectedRange;
    if (range.location > 0)
    {
        NSMutableString *textString = [NSMutableString stringWithString:textViewInput.text];
        //先判断是否是系统表情
        range.length = 2;
        range.location = range.location - 2;
        NSString *emojiString = [textString substringWithRange:range];
        NSRange currentRange;
        NSRange delRange = range;
        
        if (![[emoji getEmoji] containsObject:emojiString])
        {
            range.length = 1;
            range.location = textViewInput.selectedRange.location - 1;
            delRange = range;
            
            NSString *rightBracket = [textString substringWithRange:range];
            
            //判断是否是自定义表情
            if ([rightBracket isEqualToString:@"]"])
            {
                if (textString.length >= 3)
                {
                    NSRange range1 = (NSRange){range.location - 2, 1};
                    NSString *leftBracket1 = [textString substringWithRange:range1];
                    if ([leftBracket1 isEqualToString:@"["])
                    {
                        delRange = range1;
                        delRange.length = 3;
                        //currentRange = (NSRange){delRange.location, 0};
                    }
                    else
                    {
                        if (textString.length >= 4)
                        {
                            NSRange range2 = (NSRange){range.location - 3, 1};
                            NSString *leftBracket2 = [textString substringWithRange:range2];
                            if([leftBracket2 isEqualToString:@"["])
                            {
                                delRange = range2;
                                delRange.length = 4;
                                //currentRange = (NSRange){delRange.location, 0};
                            }
                            else
                            {
                                if (textString.length >= 5)
                                {
                                    NSRange range3 = (NSRange){range.location - 4, 1};
                                    NSString *leftBracket3 = [textString substringWithRange:range3];
                                    if([leftBracket3 isEqualToString:@"["])
                                    {
                                        delRange = range3;
                                        delRange.length = 5;
                                        //currentRange = (NSRange){delRange.location, 0};
                                    }
                                }
                            }
                            
                        }
                    }
                }
            }
        }
        
        currentRange = (NSRange){delRange.location, 0};
        
        [textString deleteCharactersInRange:delRange];
        textViewInput.text = textString;
        if (currentRange.location < textString.length)
        {
            textViewInput.selectedRange = currentRange;
        }
    }
}

//导航栏左按钮
-(void)leftBtnAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
