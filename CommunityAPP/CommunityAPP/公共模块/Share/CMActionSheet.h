//
//  CMActionSheet.h
//  CMActionSheet
//
//  Created by Stone on 14-4-20.
//  Copyright (c) 2014年 Stone. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CMActionSheetCell;

@protocol CMActionSheetDelegate <NSObject>

- (int)numberOfItemsInActionSheet;
- (CMActionSheetCell*)cellForActionAtIndex:(NSInteger)index;
- (void)DidTapOnItemAtIndex:(NSInteger)index;
- (void)dismissCancle;

@end

@interface CMActionSheet : UIView{

}

@property (nonatomic, assign ,readonly) id<CMActionSheetDelegate>delegate;

-(id)initwithIconSheetDelegate:(id<CMActionSheetDelegate>)delegate ItemCount:(int)cout;

-(void)showInView:(UIView *)view;

-(void)dismiss;

@end
