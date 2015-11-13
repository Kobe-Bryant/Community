//
//  FoldView.m
//  AllProject_Demo
//
//  Created by Sgs on 14-4-28.
//  Copyright (c) 2014年 Sgs. All rights reserved.
//

#import "FoldView.h"

@implementation FoldView

- (id)initWithFrame:(CGRect)frame Title:(NSString *)title
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.userInteractionEnabled = YES;
        self.isClicked = NO;
        
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headViewClicked:)];
        [self addGestureRecognizer:tapGes];
        [tapGes release];
        
        _lblHeadTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 4, self.frame.size.width, 30)];
        self.lblHeadTitle.backgroundColor = [UIColor clearColor];
        self.lblHeadTitle.textAlignment = NSTextAlignmentLeft;
        self.lblHeadTitle.text = title;
        [self addSubview:self.lblHeadTitle];
        [_lblHeadTitle release];
        
        _imgViewFold = [[UIImageView alloc] initWithFrame:CGRectMake(285, (40 - 25) / 2.0, 25, 25)];
        self.imgViewFold.image = [UIImage imageNamed:@"right_row.png"];
        [self addSubview:self.imgViewFold];
        [_imgViewFold release];
        
        UIImage *line = [UIImage imageNamed:@"bg_speacter_line@2x.png"];
        _lineImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 39,line.size.width ,line.size.height)];
        self.lineImg.image = line;
        [self addSubview:self.lineImg];
        [_lineImg release];
    }
    return self;
}

- (void) setHeaderTitleText:(NSString *)str {
    self.lblHeadTitle.text = str;
}

- (void) setFoldImage:(BOOL)b {
    
    [UIView animateWithDuration:0.6 delay:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        if (b) {
            self.imgViewFold.image = [UIImage imageNamed:@"down_row.png"];
        }
        else {
            self.imgViewFold.image = [UIImage imageNamed:@"right_row.png"];
        }
    } completion:^(BOOL finished) {
        
    }];
    
    self.isClicked = b;
}

- (void) headViewClicked:(UITapGestureRecognizer *)tap {
    FoldView *foldView = (FoldView *)tap.view;
    if ([self.delegate respondsToSelector:@selector(headViewPressed:)]) {
        [self.delegate headViewPressed:foldView.tag];
    }
}

@end
