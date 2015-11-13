//
//  DatePickField.m
//  DatePickView
//
//  Created by Dream on 14-4-29.
//  Copyright (c) 2014年 Yunlai-mac02. All rights reserved.
//

#import "DatePickField.h"

@implementation DatePickField{
    UIDatePicker *datePicker;
    NSDateFormatter *dateFormatter;

}
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 200, 320, 216)];
        [datePicker setAutoresizingMask:(UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight)];
        [datePicker setDatePickerMode:UIDatePickerModeTime];
     
        [datePicker addTarget:self action:@selector(timeChanged:) forControlEvents:UIControlEventValueChanged];
        self.inputView = datePicker;
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"HH:mm"];
       // [self setSelectedItem:[dateFormatter stringFromDate:datePicker.date]];
        [datePicker release];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidBeginEditingNotification:) name:UITextFieldTextDidBeginEditingNotification object:nil];
        
    }
    return self;
}

- (void)textFieldTextDidBeginEditingNotification:(NSNotification *)notice{
    if (self.text.length == 0 && [self isFirstResponder]) {
        self.text = [dateFormatter stringFromDate:datePicker.date];
    }
}


-(void)timeChanged:(UIDatePicker*)tPicker{
    [self setSelectedItem:[dateFormatter stringFromDate:datePicker.date]];
    
}
-(void)setSelectedItem:(NSString *)selectedItem{
    NSDate *date = [dateFormatter dateFromString:selectedItem];
    if (date)
    {
        _selectedItem = selectedItem;
        [self setText:_selectedItem];
        [datePicker setDate:date animated:YES];
    }
    else
    {
        NSLog(@"Invalid time or time format:%@",selectedItem);
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
