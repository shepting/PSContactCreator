//
//  YMViewController.h
//  Contact Creator
//
//  Created by Steven Hepting on 12/6/12.
//  Copyright (c) 2012 Yammer. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YDButton;

@interface YMViewController : UIViewController <UIGestureRecognizerDelegate>

- (IBAction)generateButtonPressed:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UITextField *numContactsField;
@property (weak, nonatomic) IBOutlet UIButton *generateButton;

@end
