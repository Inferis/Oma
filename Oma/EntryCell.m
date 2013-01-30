//
//  EntryCell.m
//  Oma
//
//  Created by Tom Adriaenssen on 27/01/13.
//  Copyright (c) 2013 Tom Adriaenssen. All rights reserved.
//

#import "EntryCell.h"
#import <QuartzCore/QuartzCore.h>
#import "UIColor+Hex.h"

@interface EntryCell ()

@property (nonatomic, weak) IBOutlet UILabel* whenLabel;
@property (nonatomic, weak) IBOutlet UILabel* nameLabel;
@property (nonatomic, weak) IBOutlet UIImageView* avatarImage;
@property (nonatomic, weak) IBOutlet UIButton* disclosureButton;

@end

@implementation EntryCell {
    UIColor* _whenColor;
}

- (void)awakeFromNib {
    self.whenLabel.layer.cornerRadius = 5;
    
    self.avatarImage.superview.layer.shadowColor = [UIColor blackColor].CGColor;
    self.avatarImage.superview.layer.shadowOffset = (CGSize) { 0, 1 };
    self.avatarImage.superview.layer.shadowRadius = 2;
    self.avatarImage.superview.layer.shadowOpacity = 0.4;
    self.avatarImage.superview.layer.cornerRadius = 3;

    self.avatarImage.layer.cornerRadius = 3;

    self.avatarImage.layer.masksToBounds = YES;

    self.selectedBackgroundView = [UIView new];
}

- (void)configureWithEntry:(NSDictionary*)entry {
    NSString* name = entry[@"Name"];
    self.nameLabel.text = name;
    self.avatarImage.image = [UIImage imageNamed:[name stringByAppendingPathExtension:@"png"]];
    self.avatarImage.highlightedImage = self.avatarImage.image;

    self.disclosureButton.hidden = ![name isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"Name"]];

    int when = [entry[@"When"] intValue];
    _whenColor = [self whenColor:when];
    self.whenLabel.text = [self whenDescription:when];
    self.whenLabel.backgroundColor = _whenColor;
    
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    self.whenLabel.backgroundColor = _whenColor;
}

- (NSString*)whenDescription:(int)value {
    switch (value) {
        case 0:
            return @"VM";
        case 1:
            return @"NM";
        case 2:
            return @"AV";
    }
    
    return @"???";
}

- (UIColor*)whenColor:(int)value {
    switch (value) {
        case 0:
            return [UIColor colorWithHex:0xe0d0c0];
        case 1:
            return [UIColor colorWithHex:0xaa978c];
        case 2:
            return [UIColor colorWithHex:0x72523f];
    }
    
    return [UIColor redColor];
}

@end
