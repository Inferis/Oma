//
//  ControlCell.m
//  Oma
//
//  Created by Tom Adriaenssen on 28/01/13.
//  Copyright (c) 2013 Tom Adriaenssen. All rights reserved.
//

#import "ControlCell.h"

@interface ControlCell ()

@property (nonatomic, weak) IBOutlet UILabel* nameLabel;
@property (nonatomic, weak) IBOutlet UILabel* valueLabel;

@end

@implementation ControlCell

- (void)setName:(NSString *)name {
    self.nameLabel.text = name;
}

- (NSString *)name {
    return self.nameLabel.text;
}

- (void)setValue:(NSString *)value {
    self.valueLabel.text = value;
}

- (NSString *)value {
    return self.valueLabel.text;
}

- (void)awakeFromNib {
    self.selectedBackgroundView = [UIView new];
}

@end
