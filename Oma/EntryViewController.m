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
#import "IISelectionViewController.h"
#import "DateSelectorViewController.h"

@interface EntryViewController () <UIPickerViewDataSource, UIPickerViewDelegate>

@end

@implementation EntryViewController {
    Tin* _tin;
    NSDateFormatter* _formatter;
    int _when;
    NSDate* _date;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _formatter = [NSDateFormatter new];
    _formatter.dateFormat = @"EEE dd.MM";

    UIBarButtonItem* done = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done)];
    UIBarButtonItem* delete = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(deleteEntry)];
    delete.tintColor = [UIColor redColor];
    if (!self.entry) {
        NSDate* tomorrow = [[NSDate date] dateByAddingTimeInterval:24*60*60];
        self.entry = @{@"Date": [APPDELEGATE.jsonDateFormatter stringFromDate:tomorrow], @"When": @1 };
        self.navigationItem.rightBarButtonItems = @[ done ];
    }
    else {
        self.navigationItem.rightBarButtonItems = @[
                                                    delete,
                                                    done
                                                    ];
    }

    
    
    // setup tin
    _tin = [Tin new];
    _tin.baseURI = BASEURI;
    
    _when = [_entry[@"When"] intValue];
    _date = [APPDELEGATE.jsonDateFormatter dateFromString:_entry[@"Date"]];

    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg.png"]];
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
                 @"date": [APPDELEGATE.jsonDateFormatter stringFromDate:_date],
                 @"when": @(_when),
                 };
        url = @"oma/edit";
    }
    else {
        hud.labelText = @"Aanmaken...";
        data = @{
                 @"name": [[NSUserDefaults standardUserDefaults] objectForKey:@"Name"],
                 @"date": [APPDELEGATE.jsonDateFormatter stringFromDate:_date],
                 @"when": @(_when),
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
            NSLog(@"Save error %@", response.error);
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

    _tin.contentType = @"application/json";
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
            NSLog(@"Delete error %@", response.error);
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            dispatch_delayed(0.3, ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ControlCell* cell = [ControlCell tableViewAutoDequeueCell:tableView];
    
    if (indexPath.row == 0) {
        cell.textLabel.text = @"Datum";
        cell.detailTextLabel.text = [_formatter stringFromDate:_date];
    }
    else {
        cell.textLabel.text = @"Wanneer";
        switch (_when) {
            case 0:
                cell.detailTextLabel.text = @"Ochtend";
                break;

            case 1:
                cell.detailTextLabel.text = @"Namiddag";
                break;

            case 2:
                cell.detailTextLabel.text = @"Avond";
                break;

            case 03:
                cell.detailTextLabel.text = @"Ik kan niet!";
                cell.detailTextLabel.textColor = [UIColor colorWithRed:0.8 green:0 blue:0 alpha:1];
                break;

            default:
                break;
        }
    }
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0: {
                DateSelectorViewController* selector = [DateSelectorViewController new];
                selector.date = _date;
                selector.onSelected = ^(NSDate* newDate) {
                    _date = newDate;
                    [self.navigationController popViewControllerAnimated:YES];
                    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                };
                [self.navigationController pushViewController:selector animated:YES];
                
                break;
            }
                
            case 1: {
                IISelectionViewController* selector = [IISelectionViewController new];
                selector.onViewDidLoad = ^(IISelectionViewController* controller) {
                    controller.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg.png"]];
                };
                selector.items = @[ @"Voormiddag", @"Namiddag", @"Avond", @"Ik kan niet"];
                selector.onSelected = ^(int index) {
                    _when = index;
                    [self.navigationController popViewControllerAnimated:YES];
                    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                };
                [self.navigationController pushViewController:selector animated:YES];
                break;
            }
        }
    }
}

@end
