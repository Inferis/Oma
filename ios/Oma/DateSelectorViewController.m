//
//  DateSelectorViewController.m
//  Oma
//
//  Created by Tom Adriaenssen on 06/02/13.
//  Copyright (c) 2013 Tom Adriaenssen. All rights reserved.
//

#import "DateSelectorViewController.h"
#import "TSQCalendarView.h"
#import "NSDate+Extensions.h"

@interface DateSelectorViewController () <TSQCalendarViewDelegate>

@end

@implementation DateSelectorViewController {
    TSQCalendarView* _calendar;
}

	- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Kies datum";
    
    _calendar = [TSQCalendarView new];
    _calendar.firstDate = [NSDate today];
    _calendar.lastDate = [[NSDate today] dateByAddingTimeInterval:60*60*24*120];
    _calendar.frame = self.view.bounds;
    _calendar.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
    [self.view addSubview:_calendar];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    _calendar.selectedDate = _date;
    _calendar.delegate = self;
}

- (void)calendarView:(TSQCalendarView *)calendarView didSelectDate:(NSDate *)date {
    _date = date;
    if (self.onSelected) {
        self.onSelected(date);
    }
}

@end
