//
//  AppDelegate.h
//  Oma
//
//  Created by Tom Adriaenssen on 27/01/13.
//  Copyright (c) 2013 Tom Adriaenssen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic, readonly) NSDateFormatter* jsonDateFormatter;

@end
