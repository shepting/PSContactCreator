//
//  YMDrawingAdditions.h
//  Yammer
//
//  Created by Dave Schukin on 11/5/12.
//  Copyright (c) 2012 Yammer Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YMDrawingAdditions : NSObject

/**
 * Creates a path using a source rect and corner radius.
 * @param rect The source rect.
 * @param cornerRadius the corner radius.
 * @param strokeWidth The stroke width. Note that this will not actually draw the stroke, it will simply align the path such that Quartz draws the stroke correctly.
 */
CGPathRef YMCreatePathForRoundedRect(CGRect rect, CGFloat cornerRadius, CGFloat strokeWidth);

/**
 * Helper method that returns a CG gradient using an array of colors and an array of locations.
 * @param colors An array of UIColor objects
 * @param locations An array of NSNumber objects, with values ranging from 0.0 to 1.0
 */
CGGradientRef YMCreateGradient(NSArray *colors, NSArray *locations);

@end
