//
//  IISelectionViewController.m
//  Oma
//
//  Created by Tom Adriaenssen on 05/02/13.
//  Copyright (c) 2013 Tom Adriaenssen. All rights reserved.
//

#import "IISelectionViewController.h"

@interface IISelectionViewController ()

@end

@implementation IISelectionViewController {
    NSString* _reuseidentifier;
}

- (id)init {
    self = [self initWithStyle:UITableViewStyleGrouped];
    if (self) {
    }
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        _reuseidentifier = [NSString stringWithFormat:@"IISelectionViewController-%d", arc4random()];
    }
    return self;
}

- (id)initWithItems:(NSArray*)items onSelected:(void(^)(int selectedIndex))onSelected {
    if ((self = [self init])) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (self.onViewDidLoad) {
        self.onViewDidLoad(self);
    }

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:_reuseidentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:_reuseidentifier];
    }
    
    cell.textLabel.text = _items[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.onSelected) {
        self.onSelected(indexPath.row);
    }
}

@end
