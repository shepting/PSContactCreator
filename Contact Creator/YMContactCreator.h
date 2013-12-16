//
//  YMContactCreator.h
//  Contact Creator
//
//  Created by Steven Hepting on 12/7/12.
//  Copyright (c) 2012 Yammer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YMContactCreator : NSObject

+ (void)askAndCreateContactsWithCount:(NSInteger)numContacts;
- (void)createNContacts:(NSInteger)n;

@end
