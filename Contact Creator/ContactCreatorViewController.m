//
//  PSViewController.m
//  Contact Creator
//
//  Created by Steven Hepting on 12/6/12.
//  Copyright (c) 2012 Yammer. All rights reserved.
//

#import "ContactCreatorViewController.h"
#import "PSContactCreator.h"
#import "QuartzCore/QuartzCore.h"

const CGFloat BUTTON_DISTANCE = 200.0;
const CGFloat FIELD_DISTANCE = 210.0;
const CGFloat LABEL_DISTANCE = 220.0;


@implementation ContactCreatorViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.numContactsField.borderStyle = UITextBorderStyleRoundedRect;
//    self.generateButton.layer.zPosition = 2.0;
//    self.view.layer.zPosition = 3.0;
    [self.generateButton addTarget:self action:@selector(generateButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    UIGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundTapped)];
    singleTap.delegate = self;
    [self.view addGestureRecognizer:singleTap];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)backgroundTapped
{
    NSLog(@"Background tapped.");
    [self.numContactsField resignFirstResponder];
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    [self slideView:self.nameLabel distance:-LABEL_DISTANCE];
    [self slideView:self.numContactsField distance:-FIELD_DISTANCE];
    [self slideView:self.generateButton distance:-BUTTON_DISTANCE];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    [self slideView:self.nameLabel distance:LABEL_DISTANCE];
    [self slideView:self.numContactsField distance:FIELD_DISTANCE];
    [self slideView:self.generateButton distance:BUTTON_DISTANCE];
}

- (void)slideView:(UIView *)view distance:(CGFloat)distance
{
    CGRect newFrame = CGRectOffset(view.frame, 0, distance);
    
    [UIView animateWithDuration:0.25 animations:^{
        view.frame = newFrame;
    }];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    // Disallow recognition of tap gestures in the segmented control.
    if ((touch.view == self.generateButton)) {//change it to your condition
        return NO;
    }
    return YES;
}

- (IBAction)generateButtonPressed:(id)sender {
    NSLog(@"Generate button pressed.");
    
    NSInteger numContacts = [self.numContactsField.text integerValue];
    [PSContactCreator askAndCreateContactsWithCount:numContacts];

}

- (IBAction)deleteButtonPressed:(id)sender {
    NSLog(@"Delete button pressed.");

    [PSContactCreator deleteAllGeneratedContacts];
}
@end
