//
//  MLNavigationController.h
//  MultiLayerNavigation
//
//  Created by long on 13-4-12.
//  Copyright (c) 2013年 long. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VincentNavigationController : UINavigationController <UIGestureRecognizerDelegate>

// Enable the drag to back interaction, Defalt is YES.
@property (nonatomic,assign) BOOL canDragBack;

@end
