//
//  AddCarPoolingViewController.h
//  CommunityAPP
//
//  Created by Dream on 14-3-7.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CTAssetsPickerController.h"
@interface AddCarPoolingViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,UITextFieldDelegate,CTAssetsPickerControllerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    UITableView *addCarTableView;//列表视图
    UIScrollView *contentScrollView;//滚动视图
    UIButton *taxiBtn;//拼的士button
    UIButton *carBtn;//我有车button
    
    UIImageView *imgView;//放大图片
    
    UITextField *addField;//添加拼车最后一个补充说明textfield
}
@property (nonatomic,retain) NSMutableArray *imageArr;//拍照图片集合

@end
