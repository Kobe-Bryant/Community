//
//  CMActionSheetCell.h
//  CMActionSheet
//
//  Created by Stone on 14-4-20.
//  Copyright (c) 2014年 Stone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShareItemModel : NSObject

@property (nonatomic, retain) NSString *iconName;
@property (nonatomic, assign) NSInteger shareType;
@property (nonatomic, retain) NSString *title;

- (id)initWithIcon:(NSString *)imageName
          title:(NSString *)title
      shareType:(NSInteger)shareType;

@end

@interface CMActionSheetCell : UIView

@property (nonatomic,retain)UIImageView* iconView;
@property (nonatomic,retain)UILabel*     titleLabel;
@property (nonatomic,assign)int          shareType;

@end
