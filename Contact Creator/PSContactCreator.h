//
//  PSContactCreator.h
//  Contact Creator
//
//  Created by Steven Hepting on 12/7/12.
//  Copyright (c) 2012 Yammer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PSContactCreator : NSObject

+ (void)askAndCreateContactsWithCount:(NSInteger)numContacts;
+ (void)deleteAllGeneratedContacts;

- (void)createNContacts:(NSInteger)n;

@end
