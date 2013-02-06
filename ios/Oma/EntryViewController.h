//
//  EntryViewController.h
//  Oma
//
//  Created by Tom Adriaenssen on 28/01/13.
//  Copyright (c) 2013 Tom Adriaenssen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ListViewController;

@interface EntryViewController : UITableViewController

@property (nonatomic, strong) NSDictionary* entry;
@property (nonatomic, weak) ListViewController* listController;

@end
