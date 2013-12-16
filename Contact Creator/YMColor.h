//
//  YMColor.h
//  Yammer
//
//  Created by Dave Schukin on 10/30/12.
//  Copyright (c) 2012 Yammer Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YMColor : UIColor

+ (YMColor *)colorWithHexValue:(NSUInteger)hexValue;

+ (YMColor *)yammerBlue;
+ (YMColor *)yammerOrange;

@end
