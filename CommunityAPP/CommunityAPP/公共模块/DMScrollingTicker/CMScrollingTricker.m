//
//  CMScrollingTricker.m
//  CommunityAPP
//
//  Created by Stone on 14-4-26.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import "CMScrollingTricker.h"

@interface CMScrollingTricker ()<UIGestureRecognizerDelegate>

@end

@implementation CMScrollingTricker

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


- (void) beginAnimationWithViews:(NSArray *) subviewsItems
                       direction:(LPScrollingDirection) scrollDirection
                           speed:(CGFloat) scrollSpeed
                           loops:(NSUInteger) loops
                          handle:(LPScrollingTickerGestureHandler) handle
                    completition:(LPScrollingTickerAnimationCompletition) completition{
    
    [super beginAnimationWithViews:subviewsItems
                         direction:scrollDirection
                             speed:scrollSpeed
                             loops:loops
                      completition:completition];
    
    gestureHandle = handle;
    
    for (LPScrollingTickerLabelItem *item in subviewsItems) {
        NSInteger index = [subviewsItems indexOfObject:item];
        item.tag = index;
        item.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapHandle = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandle:)];
        [item addGestureRecognizer:tapHandle];
        [tapHandle release];
    }


}

- (void)tapHandle:(UITapGestureRecognizer *)sender{
    if (sender.state == UIGestureRecognizerStateEnded) {
        LPScrollingTickerLabelItem *item = (LPScrollingTickerLabelItem *)sender.view;
        NSInteger index = item.tag;
        gestureHandle(index);
    }
}

@end
