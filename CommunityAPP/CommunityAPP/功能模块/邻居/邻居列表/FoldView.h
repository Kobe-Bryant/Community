//
//  FoldView.h
//  AllProject_Demo
//
//  Created by Sgs on 14-4-28.
//  Copyright (c) 2014年 Sgs. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FoldViewDelegate <NSObject>

@optional
- (void) headViewPressed:(NSInteger)tag;

@end

@interface FoldView : UIImageView

@property (nonatomic, retain) UILabel *lblHeadTitle;
@property (nonatomic, retain) UIImageView *imgViewFold;
@property (nonatomic, retain) UIImageView *lineImg;
@property (nonatomic, assign) BOOL isClicked;
@property (nonatomic, retain) id <FoldViewDelegate> delegate;

- (id)initWithFrame:(CGRect)frame Title:(NSString *)title;

- (void) setHeaderTitleText:(NSString *)str;

- (void) setFoldImage:(BOOL)b;

@end
