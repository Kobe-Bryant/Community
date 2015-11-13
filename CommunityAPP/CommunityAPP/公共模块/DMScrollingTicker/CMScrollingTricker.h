//
//  CMScrollingTricker.h
//  CommunityAPP
//
//  Created by Stone on 14-4-26.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import "DMScrollingTicker.h"

typedef void (^LPScrollingTickerGestureHandler)(NSInteger index);

@interface CMScrollingTricker : DMScrollingTicker{
    LPScrollingTickerGestureHandler gestureHandle;

}

- (void) beginAnimationWithViews:(NSArray *) subviewsItems
                       direction:(LPScrollingDirection) scrollDirection
                           speed:(CGFloat) scrollSpeed
                           loops:(NSUInteger) loops
                          handle:(LPScrollingTickerGestureHandler) handle
                    completition:(LPScrollingTickerAnimationCompletition) completition;


@end
