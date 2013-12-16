//
//  YDButton.h
//  Yammer
//
//  Created by Dave Schukin on 10/23/12.
//  Copyright (c) 2012 Yammer Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YMColor.h" // Import it since pretty much every import of this button will also need to import the color

typedef enum {
    YDButtonTintTypeOrange,
    YDButtonTintTypeGrey,
    YDButtonTintTypeGreen,
    YDButtonTintTypeActionBar,
    YDButtonTintTypeBlue
} YDButtonTintType;

/**
 * Custom button that can have text, and an optional image.
 * If no image is set, the text is centered; otherwise the
 * text is flush against the image.
 *
 * This class has internal support for varying gradient colors,
 * strokes, corner radiuses, etc, and at the moment exposes the least
 * possible so we don't create any leaky abstractions (e.g. while
 * exposing the UILabel object allows more flexibility w/ fonts etc,
 * it makes recomputing frames and all that more complicated). So
 * we'll publicly expose properties only as needed.
 */
@interface YDButton : UIControl

/** @name Configuring button presentation */

/** The text in the button. */
@property (nonatomic, strong, readwrite) NSString   *text;

/** The image; defaults to nil. */
@property (nonatomic, strong, readwrite) UIImage    *image;

/** The font. */
@property (nonatomic, strong, readwrite) UIFont     *font;

/**
 * Sets the gradient & stroke for a given tint type.
 */
- (void)setTintType:(YDButtonTintType)tintType;

/** @name Other stuff */

/**
 * @deprecated - DONT USE THIS!!!!!
 */
@property (nonatomic, assign, readwrite) NSInteger  tag;

/**
 * This should probably go somewhere else... YMFont?
 */
+ (UIFont *)largeFont;

@end
