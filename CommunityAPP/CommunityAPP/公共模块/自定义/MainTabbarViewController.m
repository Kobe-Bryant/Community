//
//  MainTabbarViewController.m
//  CommunityAPP
//
//  Created by yunlai on 14-3-4.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import "MainTabbarViewController.h"
#import "Global.h"

@interface MainTabbarViewController ()

@end

@implementation MainTabbarViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.view.window setRootViewController:self.navigationController];
    
    CGFloat h = [[UIScreen mainScreen] applicationFrame].size.height;
    CGFloat w = [[UIScreen mainScreen] bounds].size.width;
    
    CGRect bottomRect;
    bottomRect = CGRectMake(0, h - 29, w, kButtomBarHeight);
    bottomView = [[UIView alloc] initWithFrame:bottomRect];
    [bottomView setBackgroundColor:[UIColor blackColor]];
    [self.view addSubview:bottomView];
    

    [self initButtons];
    [self hideTabBar:self];
}

- (void) initButtons {
    CGFloat btn_x = 0;
    // 首页
    UIButton *btnHome = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnHome setFrame:CGRectMake(btn_x, 0, kBottomButtonWidth, kButtomBarHeight)];
    [btnHome setImage:[UIImage imageNamed:@"icon_home.png"] forState:UIControlStateNormal];
    [btnHome setImage:[UIImage imageNamed:@"icon_home.png"] forState:UIControlStateHighlighted];
    [btnHome setImage:[UIImage imageNamed:@"icon_home_selected.png"] forState:UIControlStateSelected];
    [btnHome setTag:0];
    [btnHome addTarget:self action:@selector(btnDown:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:btnHome];
    
    btn_x = btn_x + kBottomButtonWidth;
    
    // 便民
    UIButton *convenientMyDesign = [UIButton buttonWithType:UIButtonTypeCustom];
    [convenientMyDesign setFrame:CGRectMake(btn_x, 0, kBottomButtonWidth, kButtomBarHeight)];
    [convenientMyDesign setImage:[UIImage imageNamed:@"icon_convenient.png"] forState:UIControlStateNormal];
    [convenientMyDesign setImage:[UIImage imageNamed:@"icon_convenient_selected.png"] forState:UIControlStateHighlighted];
    [convenientMyDesign setImage:[UIImage imageNamed:@"icon_convenient_selected.png"] forState:UIControlStateSelected];
    [convenientMyDesign setTag:1];
    [convenientMyDesign addTarget:self action:@selector(btnDown:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:convenientMyDesign];
    
    // 邻里
    btn_x += kBottomButtonWidth;
    
    UIButton *nerbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [nerbtn setImage:[UIImage imageNamed:@"icon_collective.png"] forState:UIControlStateNormal];
    [nerbtn setImage:[UIImage imageNamed:@"icon_collective_selected.png"] forState:UIControlStateHighlighted];
    [nerbtn setImage:[UIImage imageNamed:@"icon_collective_selected.png"] forState:UIControlStateSelected];
    [nerbtn setFrame:CGRectMake(btn_x, 0, kBottomButtonWidth, kButtomBarHeight)];
    [nerbtn setSelected:YES];
    [nerbtn setTag:2];
    [nerbtn addTarget:self action:@selector(btnDown:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:nerbtn];
    
    // 个人
    btn_x += kBottomButtonWidth;
    
    UIButton *btnMyself = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnMyself setImage:[UIImage imageNamed:@"icon_my.png"] forState:UIControlStateNormal];
    [btnMyself setImage:[UIImage imageNamed:@"icon_my_selected.png"] forState:UIControlStateHighlighted];
    [btnMyself setImage:[UIImage imageNamed:@"icon_my_selected.png"] forState:UIControlStateSelected];
    [btnMyself setFrame:CGRectMake(btn_x, 0, kBottomButtonWidth, kButtomBarHeight)];
    [btnMyself setTag:3];
    [btnMyself addTarget:self action:@selector(btnDown:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:btnMyself];
    
    imgViewLine = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bottom_line.png"]];
    [imgViewLine setFrame:CGRectMake(0, kButtomBarHeight - kBottomLineHeight, kBottomButtonWidth, kBottomLineHeight)];
    [bottomView addSubview:imgViewLine];
}

- (void) btnDown:(id)sender {
    UIButton *btn = (UIButton *)sender;
    [self setSelectedIndex:btn.tag];
}

- (void) setLineFrame:(NSInteger)tag {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    
    [imgViewLine setFrame:CGRectMake(tag * kBottomButtonWidth, imgViewLine.frame.origin.y, imgViewLine.frame.size.width, imgViewLine.frame.size.height)];
    
    [UIView commitAnimations];
}

- (void) setSelectedIndex:(NSUInteger)selectedIndex {
    currentIndex = selectedIndex;
    [super setSelectedIndex:selectedIndex];
    [self setBtnSelected:selectedIndex];
    [self setLineFrame:selectedIndex];
}

- (void) setBtnSelected:(NSInteger)tag {
    for(UIView *v in bottomView.subviews) {
        if ([v isKindOfClass:[UIButton class]]) {
            if (((UIButton *)v).tag == tag)
                [(UIButton *)v setSelected:YES];
            else
                [(UIButton *)v setSelected:NO];
        }
    }
}

- (void) hideTabBar:(UITabBarController *) tabbarcontroller {
    for (UIView *view in tabbarcontroller.view.subviews) {
        if([view isKindOfClass:[UITabBar class]]) {
            [view setFrame:CGRectMake(view.frame.origin.x, [[UIScreen mainScreen] applicationFrame].size.height + 20, view.frame.size.width, view.frame.size.height)];
        }
        else {
            [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, [[UIScreen mainScreen] applicationFrame].size.height)];
        }
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)hideNewTabBar
{
//    [UIView beginAnimations:@"MoveUp" context:nil];
//    [UIView setAnimationDuration:0.24];
//    [bottomView setHidden:YES];
//    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
//    [UIView commitAnimations];
    
    CATransition *animation = [CATransition animation];
    animation.duration = 0.15;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
	animation.fillMode = kCAFillModeBoth;
	animation.type = kCATransitionFade;
	animation.subtype = kCATransitionFromBottom;
    [bottomView setHidden:YES];
	[[bottomView layer] addAnimation:animation forKey:nil];
}
- (void)showNewTabBar
{
//    [UIView beginAnimations:nil context:NULL];
//    [UIView setAnimationDuration:0.24];
//    [bottomView setHidden:NO];
//    [UIView commitAnimations];
    CATransition *animation = [CATransition animation];
    animation.duration = 0.15;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
	animation.fillMode = kCAFillModeBoth;
	animation.type = kCATransitionFade;
	animation.subtype = kCATransitionMoveIn;
    [bottomView setHidden:NO];
	[[bottomView layer] addAnimation:animation forKey:nil];
}
@end
