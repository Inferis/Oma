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

@interface EntryViewController ()

@end

@implementation EntryViewController {
    NSDateFormatter* _formatter;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _formatter = [NSDateFormatter new];
    _formatter.dateFormat = @"EEE dd.MM";

    [ControlCell tableViewRegisterAutoDequeueFromNib:self.tableView];
    
    if (!self.entry) {
        self.entry = @{@"Date": @([[NSDate date] timeIntervalSince1970]), @"When": @2 };
    }

    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
        return 4;
    else
        return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1)
        return 44;
    
    if (indexPath.row == 0 || indexPath.row == 3)
        return 20;
    
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* result;
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            result = [UITableViewCell tableViewAutoDequeueCell:tableView];
            result.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"header.png"]];
        }
        else if (indexPath.row == 3) {
            result = [UITableViewCell tableViewAutoDequeueCell:tableView];
            result.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"footer.png"]];
        }
        else {
            ControlCell* cell = [ControlCell tableViewAutoDequeueCell:tableView];
            if (indexPath.row == 1) {
                cell.name = @"Datum";
                cell.value = [_formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[self.entry[@"Date"] doubleValue]]];
            }
            else {
                cell.name = @"Wanneer";
                switch ([self.entry[@"When"] intValue]) {
                    case 0:
                        cell.value = @"voormiddag";
                        break;
                        
                    case 1:
                        cell.value = @"namiddag";
                        break;

                    case 2:
                        cell.value = @"avond";
                        break;

                    default:
                        cell.value = @"??";
                        break;
                }
            }
            result = cell;
        }
    }
    else {
        DeleteButtonCell* cell = [DeleteButtonCell tableViewAutoDequeueCell:tableView];
        result = cell;
    }
    
    return result;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 1:
                [UIView animateWithDuration:0.3 animations:^{
                    <#code#>
                }];
                break;
            case 2:
                [UIView animateWithDuration:0.3 animations:^{
                    <#code#>
                }];
                break;
        }
    }
}

@end
