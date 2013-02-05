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

- (void)setControl:(UIView *)control {
    [_control removeFromSuperview];
    _control = control;
    if (_control)
        [self addSubview:_control];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.control.frame = self.bounds;
}

@end
