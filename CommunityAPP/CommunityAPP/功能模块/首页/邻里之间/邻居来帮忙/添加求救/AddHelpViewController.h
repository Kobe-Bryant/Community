//
//  AddHelpViewController.h
//  CommunityAPP
//
//  Created by Dream on 14-3-10.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CTAssetsPickerController.h"
@interface AddHelpViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIActionSheetDelegate,CTAssetsPickerControllerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    UITableView *addHelpTableView;//列表视图
    UIScrollView *contentScrollView;//滚动视图
    UIImageView *imgView;//放大图片
    
    UITextField *helpField;
    UITextField *addField;
}
@property (nonatomic,retain) NSMutableArray *imageArr;//拍照图片集合
@end
