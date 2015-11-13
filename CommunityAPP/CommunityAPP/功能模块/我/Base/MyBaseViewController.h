//
//  MyBaseViewController.h
//  CommunityAPP
//
//  Created by Dream on 14-4-17.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger,CMMyType){
    CMLIVEPEDIA = 0,        //生活百科
    CMSHARECAR,             //拼车上下班
    CMAUCTION,              //随手拍了买
};

@interface MyBaseViewController : UIViewController

@property (nonatomic, strong) NSString *baseId;
@property (nonatomic, assign) CMMyType type;

@end
