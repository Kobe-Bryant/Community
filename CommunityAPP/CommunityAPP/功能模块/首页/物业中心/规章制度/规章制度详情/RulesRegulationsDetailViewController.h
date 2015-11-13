//
//  RulesRegulationsViewController.h
//  CommunityAPP
//
//  Created by yunlai on 14-3-5.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RulesRegulationModel.h"

@interface RulesRegulationsDetailViewController : UIViewController<UIScrollViewDelegate,UIWebViewDelegate>
{
    UIScrollView *contentScrollView;
    
    NSString *curHeight;

}
@property (nonatomic,retain) NSString *contentUrl;
@property(nonatomic,retain)RulesRegulationModel *ruleModel;
@end
