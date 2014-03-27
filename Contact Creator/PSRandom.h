//
//  PSRandom.h
//  Contact Creator
//
//  Created by Steven Hepting on 3/26/14.
//  Copyright (c) 2014 Yammer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PSRandom : NSObject

+ (void)fifty:(void (^)(void))block fifty:(void (^)(void))block2;
+ (BOOL)chance:(CGFloat)chance; // 0-1.0

@end
