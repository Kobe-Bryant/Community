//
//  MySelfViewController.h
//  CommunityAPP
//
//  Created by yunlai on 14-3-4.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyBillViewController.h"
#import "MyScoreViewController.h"
#import "MyPublishViewController.h"
#import "SetUpViewController.h"
#import "MyCommentViewController.h"
#import "MyCollectionViewController.h"

@interface MySelfViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>

{
    
    UITableView *selfTableView;
    UIScrollView *contentScrollView;
    
    UIButton *headerImageBtn;//头像button
    
}
@property(nonatomic,retain)NSData *imageData;
//@property(nonatomic,assign)BOOL yesOrNo;//是否显示返回  add vincent
- (void)savePersonalInfo;

@end
