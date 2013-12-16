//
//  YMDrawingAdditions.m
//  Yammer
//
//  Created by Dave Schukin on 11/5/12.
//  Copyright (c) 2012 Yammer Inc. All rights reserved.
//

#import "YMDrawingAdditions.h"

@implementation YMDrawingAdditions

CGPathRef YMCreatePathForRoundedRect(CGRect rect, CGFloat cornerRadius, CGFloat strokeWidth)
{
    CGRect imageBounds = CGRectMake(0.0, 0.0, rect.size.width - 0.5, rect.size.height);
	CGFloat resolution = 0.5 * (rect.size.width / imageBounds.size.width + rect.size.height / imageBounds.size.height);
    
    // The stroke (and therefore the path) must be re-aligned because of the way Quartz handles
    // whole-number coordinates. For a detailed explanation, see this StackOverflow article:
    // http://stackoverflow.com/questions/2488115/how-to-set-up-a-user-quartz2d-coordinate-system-with-scaling-that-avoids-fuzzy-d/2488796#2488796
    CGFloat alignStroke = fmod(0.5 * strokeWidth * resolution, 1.0);
    
    // Create a path in the shape of a rectangle, with control points for rounded corners
	CGMutablePathRef path = CGPathCreateMutable();
	CGPoint point = CGPointMake((rect.size.width - cornerRadius), rect.size.height - 0.5f);
	point.x = (round(resolution * point.x + alignStroke) - alignStroke) / resolution;
	point.y = (round(resolution * point.y + alignStroke) - alignStroke) / resolution;
	CGPathMoveToPoint(path, NULL, point.x, point.y);
	point = CGPointMake(rect.size.width - 0.5f, (rect.size.height - cornerRadius));
	point.x = (round(resolution * point.x + alignStroke) - alignStroke) / resolution;
	point.y = (round(resolution * point.y + alignStroke) - alignStroke) / resolution;
	CGPoint controlPoint1 = CGPointMake((rect.size.width - (cornerRadius / 2.f)), rect.size.height - 0.5f);
	controlPoint1.x = (round(resolution * controlPoint1.x + alignStroke) - alignStroke) / resolution;
	controlPoint1.y = (round(resolution * controlPoint1.y + alignStroke) - alignStroke) / resolution;
	CGPoint controlPoint2 = CGPointMake(rect.size.width - 0.5f, (rect.size.height - (cornerRadius / 2.f)));
	controlPoint2.x = (round(resolution * controlPoint2.x + alignStroke) - alignStroke) / resolution;
	controlPoint2.y = (round(resolution * controlPoint2.y + alignStroke) - alignStroke) / resolution;
	CGPathAddCurveToPoint(path, NULL, controlPoint1.x, controlPoint1.y, controlPoint2.x, controlPoint2.y, point.x, point.y);
	point = CGPointMake(rect.size.width - 0.5f, cornerRadius);
	point.x = (round(resolution * point.x + alignStroke) - alignStroke) / resolution;
	point.y = (round(resolution * point.y + alignStroke) - alignStroke) / resolution;
	CGPathAddLineToPoint(path, NULL, point.x, point.y);
	point = CGPointMake((rect.size.width - cornerRadius), 0.0);
	point.x = (round(resolution * point.x + alignStroke) - alignStroke) / resolution;
	point.y = (round(resolution * point.y + alignStroke) - alignStroke) / resolution;
	controlPoint1 = CGPointMake(rect.size.width - 0.5f, (cornerRadius / 2.f));
	controlPoint1.x = (round(resolution * controlPoint1.x + alignStroke) - alignStroke) / resolution;
	controlPoint1.y = (round(resolution * controlPoint1.y + alignStroke) - alignStroke) / resolution;
	controlPoint2 = CGPointMake((rect.size.width - (cornerRadius / 2.f)), 0.0);
	controlPoint2.x = (round(resolution * controlPoint2.x + alignStroke) - alignStroke) / resolution;
	controlPoint2.y = (round(resolution * controlPoint2.y + alignStroke) - alignStroke) / resolution;
	CGPathAddCurveToPoint(path, NULL, controlPoint1.x, controlPoint1.y, controlPoint2.x, controlPoint2.y, point.x, point.y);
	point = CGPointMake(cornerRadius, 0.0);
	point.x = (round(resolution * point.x + alignStroke) - alignStroke) / resolution;
	point.y = (round(resolution * point.y + alignStroke) - alignStroke) / resolution;
	CGPathAddLineToPoint(path, NULL, point.x, point.y);
	point = CGPointMake(0.0, cornerRadius);
	point.x = (round(resolution * point.x + alignStroke) - alignStroke) / resolution;
	point.y = (round(resolution * point.y + alignStroke) - alignStroke) / resolution;
	controlPoint1 = CGPointMake((cornerRadius / 2.f), 0.0);
	controlPoint1.x = (round(resolution * controlPoint1.x + alignStroke) - alignStroke) / resolution;
	controlPoint1.y = (round(resolution * controlPoint1.y + alignStroke) - alignStroke) / resolution;
	controlPoint2 = CGPointMake(0.0, (cornerRadius / 2.f));
	controlPoint2.x = (round(resolution * controlPoint2.x + alignStroke) - alignStroke) / resolution;
	controlPoint2.y = (round(resolution * controlPoint2.y + alignStroke) - alignStroke) / resolution;
	CGPathAddCurveToPoint(path, NULL, controlPoint1.x, controlPoint1.y, controlPoint2.x, controlPoint2.y, point.x, point.y);
	point = CGPointMake(0.0, (rect.size.height - cornerRadius));
	point.x = (round(resolution * point.x + alignStroke) - alignStroke) / resolution;
	point.y = (round(resolution * point.y + alignStroke) - alignStroke) / resolution;
	CGPathAddLineToPoint(path, NULL, point.x, point.y);
	point = CGPointMake(cornerRadius, rect.size.height - 0.5f);
	point.x = (round(resolution * point.x + alignStroke) - alignStroke) / resolution;
	point.y = (round(resolution * point.y + alignStroke) - alignStroke) / resolution;
	controlPoint1 = CGPointMake(0.0, (rect.size.height - (cornerRadius / 2.f)));
	controlPoint1.x = (round(resolution * controlPoint1.x + alignStroke) - alignStroke) / resolution;
	controlPoint1.y = (round(resolution * controlPoint1.y + alignStroke) - alignStroke) / resolution;
	controlPoint2 = CGPointMake((cornerRadius / 2.f), rect.size.height - 0.5f);
	controlPoint2.x = (round(resolution * controlPoint2.x + alignStroke) - alignStroke) / resolution;
	controlPoint2.y = (round(resolution * controlPoint2.y + alignStroke) - alignStroke) / resolution;
	CGPathAddCurveToPoint(path, NULL, controlPoint1.x, controlPoint1.y, controlPoint2.x, controlPoint2.y, point.x, point.y);
	point = CGPointMake((rect.size.width - cornerRadius), rect.size.height - 0.5f);
	point.x = (round(resolution * point.x + alignStroke) - alignStroke) / resolution;
	point.y = (round(resolution * point.y + alignStroke) - alignStroke) / resolution;
	CGPathAddLineToPoint(path, NULL, point.x, point.y);
	CGPathCloseSubpath(path);
    
    return path;
}

CGGradientRef YMCreateGradient(NSArray *colors, NSArray *locations)
{
    NSInteger locationCount = [locations count];
    
    // CGGradientCreateWithColors takes a CFArray of CGColor objects, and
    // a C-array of CGFloats for locations.
    CGFloat cfLocations[locationCount];
    NSMutableArray *cgColors = [[NSMutableArray alloc] init];
    
    for (NSInteger i = 0; i < locationCount; i++)
    {
        NSNumber *location = [locations objectAtIndex:i];
        cfLocations[i] = [location floatValue];
        
        // Convert the UIColor to CGColor
        UIColor *color = [colors objectAtIndex:i];
        CGColorRef cgColor = [color CGColor];
        [cgColors addObject:(__bridge id)cgColor];
    }
    
    CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
    CFArrayRef cfColors = (__bridge CFArrayRef)cgColors;
    CGGradientRef gradient = CGGradientCreateWithColors(space, cfColors, cfLocations);
    CGColorSpaceRelease(space);
    
    return gradient;
}

@end