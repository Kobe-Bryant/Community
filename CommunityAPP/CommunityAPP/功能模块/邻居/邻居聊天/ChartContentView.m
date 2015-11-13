//
//  ChartContentView.m
//  气泡
//
//  Created by zzy on 14-5-13.
//  Copyright (c) 2014年 zzy. All rights reserved.
//
#define kContentStartMargin 25
#import "ChartContentView.h"
#import "ChartMessage.h"
@implementation ChartContentView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _backImageView=[[UIImageView alloc]init];
        self.backImageView.userInteractionEnabled=YES;
        [self addSubview:self.backImageView];
        [_backImageView release];
        
        _contentLabel=[[TQRichTextView alloc]init];
        self.contentLabel.font=[UIFont fontWithName:@"HelveticaNeue" size:13];
        [self addSubview:self.contentLabel];
        [self.contentLabel release];

        [self addGestureRecognizer: [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longTap:)]];

        [self addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapPress:)]];
    }
    return self;
}
-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    self.backImageView.frame=self.bounds;
    CGFloat contentLabelX=0;
    if(self.chartMessage.messageType==kMessageFrom){
     
        contentLabelX=kContentStartMargin*0.8;
    }else if(self.chartMessage.messageType==kMessageTo){
        contentLabelX= kContentStartMargin*0.5;
    }
    self.contentLabel.frame=CGRectMake(contentLabelX,8, self.frame.size.width-kContentStartMargin-5, self.frame.size.height);

}
-(void)longTap:(UILongPressGestureRecognizer *)longTap
{
    if([self.delegate respondsToSelector:@selector(chartContentViewLongPress:content:)]){
        
        [self.delegate chartContentViewLongPress:self content:self.contentLabel.text];
    }
}
-(void)tapPress:(UILongPressGestureRecognizer *)tapPress
{
    if([self.delegate respondsToSelector:@selector(chartContentViewTapPress:content:)]){
    
        [self.delegate chartContentViewTapPress:self content:self.contentLabel.text];
    }
}
@end
