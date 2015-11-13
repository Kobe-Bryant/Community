//
//  MyBillListBean.m
//  CommunityAPP
//
//  Created by yunlai on 14-3-12.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import "MyBillListBean.h"

@implementation MyBillListBean
@synthesize amountString;
@synthesize countString;
@synthesize damagesString;
@synthesize endTimeString;
@synthesize idString;
@synthesize priceString;
@synthesize readingsString;
@synthesize startTimeString;
@synthesize statusString;
@synthesize titleString;
@synthesize totalString;
@synthesize typeString;
@synthesize unitString;
@synthesize timeLabelString;
@synthesize oldArrearsString;

@synthesize yearTime;
@synthesize yearTotal;

-(void)dealloc{
    [readingsString release];
    [amountString release];
    [countString release];
    [damagesString release];
    [endTimeString release];
    [idString release];
    [priceString release];
    [startTimeString release];
    [statusString release];
    [titleString release];
    [totalString release];
    [typeString release];
    [unitString release];
    [timeLabelString release];
    [oldArrearsString release];
    
    [yearTotal release];
    [yearTime release];
    [super dealloc];
}
@end
