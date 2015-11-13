
//
//  AddCarPoolingViewController.h
//  CommunityAPP
//
//  Created by Dream on 14-3-7.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CTAssetsPickerController.h"
#import "MBProgressHUD.h"
#import "DatePickField.h"
@interface AddCarPoolingViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,UITextFieldDelegate,CTAssetsPickerControllerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    UITableView *addCarTableView;//列表视图
    UIScrollView *contentScrollView;//滚动视图
    UIScrollView *backScroll;
    UIButton *taxiBtn;//拼的士button
    UIButton *carBtn;//我有车button
    
    UIImageView *imgView;//放大图片

    UITextField *arriveField;
    UITextField *nameField;
    UITextField *phoneField;
    //UITextField *addField;//添加拼车最后一个补充说明textfield
    UITextView  *txDescription;
    DatePickField *timeField; //自定义选择时间textField
    DatePickField *offworkField; //自定义选择时间textField
    UIToolbar *toolbar; //uiDateView头上的toolbar

    MBProgressHUD *hudView;
    
    //添加照片button
    UIButton *addPicBtn;//修改bug
}
@property (nonatomic,retain) NSMutableArray *imageArr;//拍照图片集合

@end
