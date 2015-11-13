//
//  CommunitySendTextAndImageView.m
//  CommunityAPP
//
//  Created by yunlai on 14-3-18.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import "CommunitySendTextAndImageView.h"
#import "NSObject_extra.h"
#import "Global.h"
#import "emoji.h"

@implementation CommunitySendTextAndImageView
@synthesize delegate;
@synthesize theSuperView;
@synthesize textViewInput;

-(void)dealloc{
    [blackView release]; blackView= nil;
    [bottomView release]; bottomView = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
    [super dealloc];
}
-(id)initWithFrame:(CGRect)frame superView:(UIView *)superView
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.theSuperView = superView;
        
        //注册键盘通知
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillShow:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillHide:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];

        bottomView  = [[UIView alloc] initWithFrame:CGRectMake(0.0f,superView.frame.size.height - CommunitySendBackHeight,superView.bounds.size.width,CommunitySendBackHeight)];
        [bottomView setBackgroundColor:[UIColor blackColor]];
        [bottomView setUserInteractionEnabled:YES];
        bottomView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        [self.theSuperView addSubview:bottomView];
        
        //表情键盘
        keyBoardFaceView = [[faceView alloc] initWithFrame:CGRectMake(0, self.theSuperView.frame.size.height-KEYBOARD_HEIGHT, ScreenWidth, KEYBOARD_HEIGHT)];
        keyBoardFaceView.delegate = self;
        keyBoardFaceView.hidden = YES;
        [self.theSuperView addSubview:keyBoardFaceView];
        
        textViewInput = [[HPGrowingTextView alloc] initWithFrame:CGRectMake(38+8, 6, 207, 28)];
        textViewInput.font = [UIFont systemFontOfSize:15];
        textViewInput.minNumberOfLines = 1;
        textViewInput.maxNumberOfLines = 4;
        textViewInput.layer.cornerRadius = 10.0f;
        textViewInput.layer.masksToBounds = YES;
//        textViewInput.layer.borderWidth = 1.0f;
//        textViewInput.layer.borderColor = RGB(229, 229, 229).CGColor;
        textViewInput.backgroundColor = [UIColor whiteColor];
        textViewInput.placeholder = @"我也来说一句"; //默认显示的字
        textViewInput.delegate = self;
        textViewInput.textAlignment = NSTextAlignmentLeft;
        textViewInput.autoresizingMask = UIViewAutoresizingFlexibleWidth;//自适应高度
        textViewInput.returnKeyType = UIReturnKeyDefault;
        [bottomView addSubview:textViewInput];
        
        //       添加按钮
        UIImage *addImage = [UIImage imageNamed:@"bg_chat_iconImage.png"];
        UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        addBtn.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleTopMargin;
        [addBtn setBackgroundImage:addImage forState:UIControlStateNormal];
        [addBtn addTarget:self action:@selector(showFace:) forControlEvents:UIControlEventTouchUpInside];
        addBtn.frame = CGRectMake(8, 8, addImage.size.width, addImage.size.height);
        [bottomView addSubview:addBtn];
        
        //发送
        UIImage *sendImage = [UIImage imageNamed:@"bg_chat_sendImage.png"];
        sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [sendButton setTitle:@"发送" forState:UIControlStateNormal];
        [sendButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
        sendButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleTopMargin;
        [sendButton setBackgroundImage:sendImage forState:UIControlStateNormal];
        [sendButton addTarget:self action:@selector(sendAction) forControlEvents:UIControlEventTouchUpInside];
        sendButton.enabled = NO;
        [sendButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        sendButton.frame = CGRectMake(textViewInput.frame.size.width+textViewInput.frame.origin.x+8,(CommunitySendBackHeight-sendImage.size.height)/2,sendImage.size.width,sendImage.size.height);
        [bottomView addSubview:sendButton];
    }
    return self;
}


//显示表情
-(void)showFace:(UIButton *)sender
{
    [sender setSelected:!sender.selected];
    if (sender.selected)
    {
        //选择表情 隐藏键盘
        if (textViewInput.isFirstResponder)
        {
            textViewInput.placeholder = @"";
            [textViewInput resignFirstResponder];
        }
        CGRect rect = CGRectMake(0,0,ScreenWidth,KEYBOARD_HEIGHT);
        [self containerViewUpAnimation:rect withDuration:[NSNumber numberWithFloat:KEYBOARD_DURATION] withCurve:[NSNumber numberWithFloat:KEYBOARD_CURVE]];
        
        keyBoardFaceView.hidden = NO;
        
        [self someViewAnimation:keyBoardFaceView withUpOrDown:YES];
    }
    else
    {
        //选择键盘 隐藏表情
        [keyBoardFaceView setHidden:YES];
        [textViewInput becomeFirstResponder];
    }
    
}

//动画
- (void)someViewAnimation:(UIView *)someView withUpOrDown:(BOOL)upOrDown
{
    CGRect someViewFrame = someView.frame;
    someViewFrame.origin.y = upOrDown ? self.theSuperView.frame.size.height - KEYBOARD_HEIGHT : self.theSuperView.frame.size.height;
    
    [UIView animateWithDuration:KEYBOARD_DURATION animations:^{
        someView.frame = someViewFrame;
    } completion:^(BOOL finished) {
        
    }];
}


//回复bar 往上动画
- (void)containerViewUpAnimation:(CGRect)keyboardBounds withDuration:(NSNumber *)duration withCurve:(NSNumber *)curve
{
    // get a rect for the textView frame
	CGRect containerFrame = bottomView.frame;
	//新增一个遮罩按钮
    if (blackView == nil)
    {
        blackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, MainHeight - (keyboardBounds.size.height + containerFrame.size.height)-1)];
        [blackView setBackgroundColor:[UIColor clearColor]];
        [self.theSuperView addSubview:blackView];
        
        //    添加当前的界面的手势
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenKeyboard)];
        tapGesture.cancelsTouchesInView = NO;
        [blackView addGestureRecognizer:tapGesture];
        [tapGesture release];
    }
	
    containerFrame.origin.y = MainHeight - (keyboardBounds.size.height + containerFrame.size.height);
	
	// animations settings
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
	
	// set views with new info
	bottomView.frame = containerFrame;
	
	// commit animations
	[UIView commitAnimations];
}
///回复bar 往下动画
- (void)containerViewDownAnimation:(NSNumber *)duration withCurve:(NSNumber *)curve
{
    // get a rect for the textView frame
    CGRect containerFrame = bottomView.frame;
    containerFrame.origin.y = MainHeight - containerFrame.size.height;
    
    NSLog(@"==============  %f",containerFrame.origin.y);

    // animations settings
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    [UIView setAnimationDelegate:self];
    
    // set views with new info
    bottomView.frame = containerFrame;
    
    // commit animations
    [UIView commitAnimations];
    
    //移出遮罩按钮
    [blackView removeFromSuperview];
    blackView = nil;
}

//关闭键盘
-(void)hiddenKeyboard
{
    //关闭所有
    [self containerViewDownAnimation:[NSNumber numberWithFloat:KEYBOARD_DURATION] withCurve:[NSNumber numberWithFloat:KEYBOARD_CURVE]];
    [self someViewAnimation:keyBoardFaceView withUpOrDown:NO];
    
	[textViewInput resignFirstResponder];
    
    [self performSelector:@selector(backReplyTopic) withObject:nil afterDelay:KEYBOARD_DURATION];
}

//点击空白处键盘消失
-(void)backReplyTopic
{
    if(bottomView.frame.origin.y == theSuperView.frame.size.height - CommunitySendBackHeight)
    {
        textViewInput.text = @"";
        textViewInput.placeholder = @"我也来说一句";
    }
}

-(void)sendAction{

    if (textViewInput.text.length>0) {
        NSLog(@"点击发送");
        if ([delegate respondsToSelector:@selector(sendTextAction:)])
        {
            [delegate sendTextAction:textViewInput.text];
            textViewInput.text = @"";
            textViewInput.placeholder = @"我也来说一句";
        }
    }
}


#pragma mark -
#pragma mark 键盘通知调用
//Code from Brett Schumann
-(void) keyboardWillShow:(NSNotification *)note
{
    // get keyboard size and loctaion
	CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    // Need to translate the bounds to account for rotation.
    keyboardBounds = [theSuperView convertRect:keyboardBounds toView:nil];
    blackView.frame = CGRectMake(0, 0, ScreenWidth, MainHeight-keyboardBounds.size.height-CommunitySendBackHeight);
    [self containerViewUpAnimation:keyboardBounds withDuration:duration withCurve:curve];
    [self someViewAnimation:keyBoardFaceView withUpOrDown:NO];
}

-(void)keyboardWillHide:(NSNotification *)note
{
    [self hiddenKeyboard];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

#pragma mark -
#pragma mark faceViewDelegate 委托
- (void)faceView:(faceView *)faceView didSelectAtString:(NSString *)faceString
{
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


#pragma mark -
#pragma mark UIExpandingTextView delegate
#pragma mark HPGrowingTextView 委托
- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height
{
    float diff = (growingTextView.frame.size.height - height);
    NSLog(@"height %f",height);
    NSLog(@"growingTextView.frame.size.height %f",growingTextView.frame.size.height);
	CGRect r = bottomView.frame;
    r.size.height -= diff;
    r.origin.y += diff;
	bottomView.frame = r;
    blackView.frame = CGRectMake(0, 0, ScreenWidth, MainHeight-KEYBOARD_HEIGHT-r.size.height);

//    backGrougBtn.frame = CGRectMake(backGrougBtn.frame.origin.x, backGrougBtn.frame.origin.y, backGrougBtn.frame.size.width, backGrougBtn.frame.size.height + diff);
//    
//    if (height > 45.0f)
//    {
//        remainCountLabel.hidden = NO;
//    }
//    else
//    {
//        remainCountLabel.hidden = YES;
//    }
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
//- (BOOL)growingTextViewShouldReturn:(HPGrowingTextView *)growingTextView{
//    [self sendAction];
//    return YES;
//}
- (void)growingTextViewDidChange:(HPGrowingTextView *)growingTextView{
    if (textViewInput.text.length>0) {
        sendButton.enabled = YES;
    }
}
@end
