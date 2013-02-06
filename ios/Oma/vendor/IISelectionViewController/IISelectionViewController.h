//
//  IISelectionViewController.h
//  Oma
//
//  Created by Tom Adriaenssen on 05/02/13.
//  Copyright (c) 2013 Tom Adriaenssen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IISelectionViewController : UITableViewController

- (id)initWithItems:(NSArray*)items onSelected:(void(^)(int selectedIndex))onSelected;

@property (nonatomic, retain) NSArray* items;
@property (nonatomic, copy) void(^onSelected)(int selectedIndex);
@property (nonatomic, copy) void(^onViewDidLoad)(IISelectionViewController* controller);

@end
