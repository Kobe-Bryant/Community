//
//  CommunitySendTextAndImageView.h
//  CommunityAPP
//
//  Created by yunlai on 14-3-18.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HPGrowingTextView.h"
#import "faceView.h"

@protocol CommunitySendTextAndImageViewDelegate <NSObject>
-(void)sendTextAction:(NSString *)inputText;
@end

@interface CommunitySendTextAndImageView : UIView<UITextViewDelegate,faceViewDelegate,HPGrowingTextViewDelegate>{
    HPGrowingTextView *textViewInput;
    UIView *blackView;//遮罩层
    
    UIView *bottomView;
    faceView *keyBoardFaceView;
    
    UIButton *sendButton;//发送按钮
}
@property(nonatomic,retain)HPGrowingTextView *textViewInput;
@property(nonatomic,retain)UIView *theSuperView;
@property(nonatomic,assign)id<CommunitySendTextAndImageViewDelegate> delegate;
-(id)initWithFrame:(CGRect)frame superView:(UIView *)superView;
//关闭键盘
-(void)hiddenKeyboard;
@end
