//
//  NSArray+randomItem.m
//  Contact Creator
//
//  Created by Steven Hepting on 3/26/14.
//  Copyright (c) 2014 Yammer. All rights reserved.
//

#import "NSArray+Random.h"

@implementation NSArray (Random)

- (id)randomItem
{
    return self[arc4random_uniform((u_int32_t)[self count])];
}

@end
