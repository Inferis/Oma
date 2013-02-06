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

@property (nonatomic, weak) IBOutlet UILabel* weekLabel;
@property (nonatomic, weak) IBOutlet UILabel* dateLabel;

@end

@implementation EntryCell {
    UIColor* _whenColor;
}

- (void)awakeFromNib {
    NSArray* names = @[@"Tom", @"Jelle", @"Lieven", @"Pierre"];
    [self avatar:^(int index, UIImageView* avatarImage, UIImageView* noImage, UILabel* oLabel, UILabel* mLabel, UILabel* aLabel) {
        avatarImage.superview.layer.shadowColor = [UIColor blackColor].CGColor;
        avatarImage.superview.layer.shadowOffset = (CGSize) { 0, 1 };
        avatarImage.superview.layer.shadowRadius = 2;
        avatarImage.superview.layer.shadowOpacity = 0.4;
        avatarImage.superview.layer.cornerRadius = 3;
        avatarImage.layer.cornerRadius = 3;
        avatarImage.layer.masksToBounds = YES;

        avatarImage.image = [UIImage imageNamed:[names[index] stringByAppendingPathExtension:@"png"]];
        avatarImage.highlightedImage = avatarImage.image;

        oLabel.superview.layer.cornerRadius = 3;
        oLabel.superview.layer.masksToBounds = YES;
        
        oLabel.backgroundColor = [UIColor colorWithHex:0x68c6f2];
        mLabel.textColor = [UIColor blackColor];
        mLabel.backgroundColor = [UIColor colorWithHex:0xffae00];
        mLabel.textColor = [UIColor blackColor];
        aLabel.backgroundColor = [UIColor colorWithHex:0x333333];
    }];
    

    self.selectedBackgroundView = [UIView new];
}

- (void)avatar:(void(^)(int index, UIImageView* avatarImage, UIImageView* noImage, UILabel* oLabel, UILabel* mLabel, UILabel* aLabel))block {
    for (int i=0; i<4; ++i) {
        block(i, (UIImageView*)[self viewWithTag:101 + i], (UIImageView*)[self viewWithTag:201 + i], (UILabel*)[self viewWithTag:110 + i*10], (UILabel*)[self viewWithTag:111 + i*10], (UILabel*)[self viewWithTag:112 + i*10]);
    }
}

- (void)configureWithEntry:(NSDictionary*)entry {
    NSArray* who = entry[@"Who"];
    who = @[
            [who select:^(NSDictionary* x) { return [x[@"Name"] isEqualToString:@"Tom"]; }],
            [who select:^(NSDictionary* x) { return [x[@"Name"] isEqualToString:@"Jelle"]; }],
            [who select:^(NSDictionary* x) { return [x[@"Name"] isEqualToString:@"Lieven"]; }],
            [who select:^(NSDictionary* x) { return [x[@"Name"] isEqualToString:@"Pierre"]; }],
          ];
    
    NSDateComponents* comps = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] components:NSWeekdayCalendarUnit fromDate:[APPDELEGATE.jsonDateFormatter dateFromString:entry[@"Date"]]];
    self.weekLabel.text = [@"zomadiwodovrza" substringWithRange:NSMakeRange(([comps weekday]-1)*2, 2)];
    self.dateLabel.text = [entry[@"Date"] substringFromIndex:6];
    
    [self avatar:^(int index, UIImageView *avatarImage, UIImageView* noImage, UILabel *oLabel, UILabel *mLabel, UILabel *aLabel) {
        NSArray* labels = @[oLabel, mLabel, aLabel];
        
        avatarImage.superview.alpha = 0.1;
        for (int i=0; i<3; ++i) {
            NSDictionary* item = [who[index] detect:^BOOL(NSDictionary* x) { return [x[@"When"] intValue] == i; }];
            UILabel* label = labels[i];
            if (item) {
                label.alpha = 1;
                avatarImage.superview.alpha = 1;
            }
            else {
                label.alpha = 0.10;
            }
        }

        if ([who[index] any:^BOOL(NSDictionary* x) { return [x[@"When"] intValue] == 3; }]) {
            noImage.alpha = 0.8;
            avatarImage.superview.alpha = 1;
        }
        else
            noImage.alpha = 0;

    }];

    NSString* name = [[NSUserDefaults standardUserDefaults] objectForKey:@"Name"];
    if ([(NSArray*)entry[@"Who"] any:^BOOL(NSDictionary* x) { return [x[@"Name"] isEqualToString:name]; }]) {
        self.selectionStyle = UITableViewCellSelectionStyleBlue;
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryType = UITableViewCellAccessoryNone;
    }
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
}


@end
