//
//  EntryViewController.m
//  Oma
//
//  Created by Tom Adriaenssen on 28/01/13.
//  Copyright (c) 2013 Tom Adriaenssen. All rights reserved.
//

#import "EntryViewController.h"
#import "UITableViewCell+AutoDequeue.h"
#import "DeleteButtonCell.h"
#import "ControlCell.h"
#import "ListViewController.h"

@interface EntryViewController () <UIPickerViewDataSource, UIPickerViewDelegate>

@end

@implementation EntryViewController {
    Tin* _tin;
    NSDateFormatter* _formatter;
    UIDatePicker* _datepicker;
    UIPickerView* _whenpicker;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _formatter = [NSDateFormatter new];
    _formatter.dateFormat = @"EEE dd.MM";

    UIBarButtonItem* done = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done)];
    UIBarButtonItem* delete = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(deleteEntry)];
    NSDate* tomorrow = [[NSDate date] dateByAddingTimeInterval:24*60*60];
    delete.tintColor = [UIColor redColor];
    if (!self.entry) {
        self.entry = @{@"Date": @([tomorrow timeIntervalSince1970]), @"When": @1 };
        self.navigationItem.rightBarButtonItems = @[ done ];
    }
    else {
        self.navigationItem.rightBarButtonItems = @[
                                                    delete,
                                                    done
                                                    ];
    }

    _datepicker = [UIDatePicker new];
    _datepicker.datePickerMode = UIDatePickerModeDate;
    _datepicker.minimumDate = tomorrow;

    _whenpicker = [UIPickerView new];
    _whenpicker.dataSource = self;
    _whenpicker.delegate = self;
    _whenpicker.showsSelectionIndicator = YES;
    
    // setup tin
    _tin = [Tin new];
    _tin.baseURI = BASEURI;

    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
}

- (void)done {
    MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    
    NSString* url;
    NSDictionary* data;
    if (_entry[@"Id"]) {
        hud.labelText = @"Bewaren...";
        data = @{
                 @"id": _entry[@"Id"],
                 @"date": @([_datepicker.date timeIntervalSince1970]),
                 @"when": @([_whenpicker selectedRowInComponent:0]),
                 };
        url = @"oma/edit";
    }
    else {
        hud.labelText = @"Aanmaken...";
        data = @{
                 @"name": [[NSUserDefaults standardUserDefaults] objectForKey:@"Name"],
                 @"date": @([_datepicker.date timeIntervalSince1970]),
                 @"when": @([_whenpicker selectedRowInComponent:0]),
                 };
        url = @"oma/add";
    }

    [_tin post:url body:data success:^(TinResponse *response) {
        if (!response.error) {
            [self.listController getFutureEventsCallback:^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                dispatch_delayed(0.3, ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
            }];
        }
        else {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            dispatch_delayed(0.3, ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
    }];
}

- (void)deleteEntry {
    MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    
    hud.labelText = @"Verwijderen...";
    NSDictionary* data = @{ @"id": _entry[@"Id"] };

    [_tin post:@"oma/delete" body:data success:^(TinResponse *response) {
        if (!response.error) {
            [self.listController getFutureEventsCallback:^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                dispatch_delayed(0.3, ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
            }];
        }
        else {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            dispatch_delayed(0.3, ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
    }];
}

#pragma mark - picker view data source

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return 3;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    switch (row) {
        case 0:
            return @"voormiddag";
        case 1:
            return @"namiddag";
        case 2:
            return @"avond";
    }
    return @"geen idee jos";
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 216;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"Datum";
    }
    else {
        return @"Wanneer";
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ControlCell* cell = [ControlCell tableViewAutoDequeueCell:tableView];
    
    if (indexPath.section == 0) {
        cell.control = _datepicker;
        NSDate* date = [NSDate dateWithTimeIntervalSince1970:[_entry[@"Date"] doubleValue]];
        NSLog(@"%@", date);
        [_datepicker setDate:date animated:YES];
    }
    else {
        cell.control = _whenpicker;
        [_whenpicker selectRow:[_entry[@"When"] intValue] inComponent:0 animated:YES];
    }
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 1:
                [UIView animateWithDuration:0.3 animations:^{
                
                }];
                break;
            case 2:
                [UIView animateWithDuration:0.3 animations:^{
                    
                }];
                break;
        }
    }
}

@end
