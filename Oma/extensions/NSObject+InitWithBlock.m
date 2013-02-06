//
//  NSObject+InitWithBlock.m
//  Oma
//
//  Created by Tom Adriaenssen on 06/02/13.
//  Copyright (c) 2013 Tom Adriaenssen. All rights reserved.
//

#import "NSObject+InitWithBlock.h"

@implementation NSObject (InitWithBlock)

- (id)initWith:(void(^)(id object))initializer {
    if ((self = [self init])) {
        if (initializer) initializer(self);
    }
    return self;
}

+ (id)newWith:(void (^)(id))initializer {
    return [[self alloc] initWith:initializer];
}

@end
