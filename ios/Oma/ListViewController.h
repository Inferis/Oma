//
//  ListViewController.h
//  Oma
//
//  Created by Tom Adriaenssen on 27/01/13.
//  Copyright (c) 2013 Tom Adriaenssen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListViewController : UITableViewController

- (void)getFutureEvents;
- (void)getFutureEventsCallback:(void(^)(void))callback;

@end
