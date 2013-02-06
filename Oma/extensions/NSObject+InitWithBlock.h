//
//  NSObject+InitWithBlock.h
//  Oma
//
//  Created by Tom Adriaenssen on 06/02/13.
//  Copyright (c) 2013 Tom Adriaenssen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (InitWithBlock)

- (id)initWith:(void(^)(id object))initializer;
+ (id)newWith:(void(^)(id object))initializer;


@end
