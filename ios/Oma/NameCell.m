//
//  NameCell.m
//  Oma
//
//  Created by Tom Adriaenssen on 28/01/13.
//  Copyright (c) 2013 Tom Adriaenssen. All rights reserved.
//

#import "NameCell.h"
#import <QuartzCore/QuartzCore.h>

@interface NameCell ()

@property (nonatomic, weak) IBOutlet UILabel* nameLabel;
@property (nonatomic, weak) IBOutlet UIImageView* avatarImage;

@end

@implementation NameCell

- (void)awakeFromNib {
    self.avatarImage.superview.layer.shadowColor = [UIColor blackColor].CGColor;
    self.avatarImage.superview.layer.shadowOffset = (CGSize) { 0, 1 };
    self.avatarImage.superview.layer.shadowRadius = 2;
    self.avatarImage.superview.layer.shadowOpacity = 0.4;
    self.avatarImage.superview.layer.cornerRadius = 5;
    
    self.avatarImage.layer.cornerRadius = 5;
    self.avatarImage.layer.masksToBounds = YES;

    self.selectedBackgroundView = [UIView new];
}

- (void)setName:(NSString *)name {
    _name = name;
    self.nameLabel.text = name;
    self.avatarImage.image = [UIImage imageNamed:[name stringByAppendingPathExtension:@"png"]];
    self.avatarImage.highlightedImage = self.avatarImage.image;
}

@end
