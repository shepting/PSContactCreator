//
//  PSRandom.m
//  Contact Creator
//
//  Created by Steven Hepting on 3/26/14.
//  Copyright (c) 2014 Yammer. All rights reserved.
//

#import "PSRandom.h"

@implementation PSRandom

+ (void)initialize
{
    srand48(time(0));
}

+ (void)fifty:(void (^)(void))block fifty:(void (^)(void))block2
{
    
}

+ (BOOL)chance:(CGFloat)chance
{
    NSAssert(chance <= 1.0, @"Chance must be less than or equal to 1.0");
    NSAssert(chance >= 0.0, @"Chance must be greater than or equal to 0.0");
    
    if (drand48() < chance) {
        return YES;
    } else {
        return NO;
    }
}

@end
