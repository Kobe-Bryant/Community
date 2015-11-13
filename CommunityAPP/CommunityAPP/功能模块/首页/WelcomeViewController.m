//
//  WelcomeViewController.m
//  CommunityAPP
//
//  Created by Stone on 14-4-28.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import "WelcomeViewController.h"
#import "AppDelegate.h"

@interface WelcomeViewController ()

@end

@implementation WelcomeViewController

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
    self.view.backgroundColor = [UIColor redColor];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    if (isIPhone5) {
        imageView.image = [UIImage imageNamed:@"Default-568h@2x.png"];
    }else{
        imageView.image = [UIImage imageNamed:@"Default.png"];
    }
    
    [self.view addSubview:imageView];
    [imageView release];
    
    [self performSelector:@selector(entryMainView:) withObject:nil afterDelay:0.5f];
}

- (void)entryMainView:(id)sender{
    
    [UIView animateWithDuration:0.2
                          delay:1.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.view.alpha = 0.8;
                     } completion:^(BOOL finished) {
                         AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                         
                         if( [delegate respondsToSelector:@selector(loadAnimationEndedCallback:)] )
                         {
                             [delegate loadAnimationEndedCallback:nil];
                         }
                     }];
    return;
    [self dismissViewControllerAnimated:NO completion:nil];
    return;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
