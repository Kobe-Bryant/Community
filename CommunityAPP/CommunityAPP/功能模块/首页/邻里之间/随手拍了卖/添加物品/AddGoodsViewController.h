//
//  AddGoodsViewController.h
//  CommunityAPP
//
//  Created by Dream on 14-3-17.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CTAssetsPickerController.h"
@interface AddGoodsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIActionSheetDelegate,CTAssetsPickerControllerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    UITableView *addGoodsTableView;
    UIScrollView *contentScrollView;//滚动视图
    UIImageView *imgView;//放大图片
    
    UITextField *titleField;
    UITextField *priceField;
    //UITextField *descriptionField;
    UITextView  *txDescription;
}
@property (nonatomic,retain) NSMutableArray *imageArr;//拍照图片集合

@end
