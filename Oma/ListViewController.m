//
//  ListViewController.m
//  Oma
//
//  Created by Tom Adriaenssen on 27/01/13.
//  Copyright (c) 2013 Tom Adriaenssen. All rights reserved.
//

#import "ListViewController.h"
#import "UITableViewCell+AutoDequeue.h"
#import "EntryCell.h"
#import "EntryViewController.h"
#import "NameChooserViewController.h"
#import "UIColor+Hex.h"
#import <QuartzCore/QuartzCore.h>
#import "WBNoticeView.h"

@interface ListViewController ()

@end

@implementation ListViewController {
    Tin* _tin;
    NSArray* _entries;
    NSDateFormatter* _formatter;
    UIBarButtonItem* _peopleButton;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Oma";
    
    _peopleButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"people.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(openNameChooser)];
    
    [[NSUserDefaults standardUserDefaults] addObserver:self
                                            forKeyPath:@"Name"
                                               options:NSKeyValueObservingOptionNew
                                               context:NULL];
    
    self.navigationItem.leftBarButtonItems = @[_peopleButton];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addEntry:)];

    self.refreshControl = [UIRefreshControl new];
    self.refreshControl.tintColor = [UIColor colorWithHex:0xaa978c];
    [self.refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
    [EntryCell tableViewRegisterAutoDequeueFromNib:self.tableView];

    // setup tin
    _tin = [Tin new];
    _tin.baseURI = BASEURI;
    
    _formatter = [NSDateFormatter new];
    _formatter.dateFormat = @"EEE dd.MM";
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSString* name = [[NSUserDefaults standardUserDefaults] objectForKey:@"Name"];
    if (!name) {
        [self openNameChooser];
    }
    else {
        UIView* view = [[UIView alloc] initWithFrame:(CGRect) { 0, 0, 28, 28 }];
        view.layer.cornerRadius = 3;
        view.layer.shadowColor = [UIColor colorWithHex:0x383d37].CGColor;
        view.layer.shadowOffset = (CGSize) { 0, -1 };
        view.layer.shadowRadius = 0;
        view.layer.shadowOpacity = 1;

        UIImageView* avatarView = [[UIImageView alloc] initWithFrame:view.bounds];
        avatarView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        avatarView.image = [UIImage imageNamed:[name stringByAppendingPathExtension:@"png"]];
        avatarView.layer.cornerRadius = 3;
        avatarView.layer.masksToBounds = YES;
        [view addSubview:avatarView];
        
        self.navigationItem.leftBarButtonItems = @[_peopleButton, [[UIBarButtonItem alloc] initWithCustomView:view]];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    [self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (!_entries && [[NSUserDefaults standardUserDefaults] objectForKey:@"Name"])
        [self getFutureEvents];
}

- (void)getFutureEvents {
    [self getFutureEventsCallback:nil];
}

- (void)getFutureEventsCallback:(void(^)(void))callback {
    [self.refreshControl beginRefreshing];
    [self.tableView scrollRectToVisible:self.refreshControl.frame animated:YES];
    [_tin get:@"oma/futureevents" query:nil success:^(TinResponse *response) {
        if (response.parsedResponse) {
            _entries = response.parsedResponse;
        }
        else {
            NSLog(@"getFutureEvents failed: %@", response.error);
            WBNoticeView* notice = [[WBNoticeView alloc] init];
            [notice showErrorNoticeInView:self.view title:@"Aiai!" message:@"De gegevens konden niet opgehaald worden. Lastig."];
            _entries = nil;
        }
        
        [self.refreshControl endRefreshing];
        [self.tableView reloadData];
        if (callback)
            callback();
    }];
}

- (void)openNameChooser {
    NameChooserViewController* nameController = [[NameChooserViewController alloc] initWithNibName:nil bundle:nil];
    UINavigationController* navController = [[UINavigationController alloc] initWithRootViewController:nameController];
    navController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    navController.navigationBar.tintColor = [UIColor colorWithHex:0xaa978c];
    [self presentViewController:navController animated:YES completion:nil];
}

#pragma mark - Actions

- (void)refresh:(id)sender {
    [self getFutureEvents];
}

- (void)addEntry:(id)sender {
    EntryViewController* entryController = [[EntryViewController alloc] initWithNibName:nil bundle:nil];
    entryController.listController = self;
    [self.navigationController pushViewController:entryController animated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_entries count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int count = [_entries[section][@"Who"] count];
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EntryCell* cell = (EntryCell*)[EntryCell tableViewAutoDequeueCell:tableView];
    
    NSDictionary* entry = _entries[indexPath.section][@"Who"][indexPath.row];
    [cell configureWithEntry:entry];
    cell.selectionStyle = [entry[@"Name"] isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"Name"]] ? UITableViewCellSelectionStyleBlue : UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary* entry = _entries[indexPath.section][@"Who"][indexPath.row];
    if ([entry[@"Name"] isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"Name"]])
        return indexPath;
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSDictionary* entry = _entries[section];

    
    UIView* view = [[UIView alloc] initWithFrame:(CGRect) { 0, 0, 320, 44 }];
    view.backgroundColor = [UIColor clearColor];
    
    UIImageView* bgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"header.png"]];
    bgView.frame = view.bounds;
    bgView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [view addSubview:bgView];
    
    UILabel* title = [[UILabel alloc] initWithFrame:CGRectInset(CGRectOffset(view.bounds, 0, 10), 20, 10)];
    [title setFont:[UIFont fontWithName:@"Baskerville-BoldItalic" size:18]];
    title.backgroundColor = [UIColor clearColor];
    title.opaque = NO;
    title.textAlignment = NSTextAlignmentCenter;
    
    NSDate* date = [APPDELEGATE.jsonDateFormatter dateFromString:entry[@"Date"]];
    title.text = [_formatter stringFromDate:date];
    [view addSubview:title];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 20;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIImageView* view = [[UIImageView alloc] initWithFrame:(CGRect) { 0, 0, 320, 20 }];
    view.image = [UIImage imageNamed:@"footer.png"];
    
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    EntryViewController* entryController = [[EntryViewController alloc] initWithNibName:nil bundle:nil];
    entryController.listController = self;
    entryController.entry = _entries[indexPath.section][@"Who"][indexPath.row];
    
    
    [self.navigationController pushViewController:entryController animated:YES];
}

@end
