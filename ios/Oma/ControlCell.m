//
//  ControlCell.m
//  Oma
//
//  Created by Tom Adriaenssen on 28/01/13.
//  Copyright (c) 2013 Tom Adriaenssen. All rights reserved.
//

#import "ControlCell.h"

@interface ControlCell ()


@end

@implementation ControlCell

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [self initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier])) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return self;
}

@end
