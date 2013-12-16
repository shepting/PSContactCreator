//
//  YMColor.m
//  Yammer
//
//  Created by Dave Schukin on 10/30/12.
//  Copyright (c) 2012 Yammer Inc. All rights reserved.
//

#import "YMColor.h"
#import "UIColor+Extensions.h"

@implementation YMColor

+ (YMColor *)colorWithHexValue:(NSUInteger)hexValue
{
    // Initially implemented this myself, then realized one of our 3rd party
    // libraries already did, so now it just wraps it. Whatever.
    return (YMColor *)[self colorWithRGBHex:hexValue];
}

+ (YMColor *)yammerBlue
{
    return (YMColor *)[self colorWithRed:76.0/255.0 green:139.0/255.0 blue:209.0/255.0 alpha:1.0];
}

+ (YMColor *)yammerOrange
{
    return (YMColor *)[self colorWithRed:246.0/255.0 green:142.0/255.0 blue:9.0/255.0 alpha:1.0];
}

@end
