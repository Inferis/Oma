//
//  DateSelectorViewController.h
//  Oma
//
//  Created by Tom Adriaenssen on 06/02/13.
//  Copyright (c) 2013 Tom Adriaenssen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DateSelectorViewController : UIViewController

@property (nonatomic, retain) NSDate* date;
@property (nonatomic, copy) void(^onSelected)(NSDate* selectedDate);

@end
