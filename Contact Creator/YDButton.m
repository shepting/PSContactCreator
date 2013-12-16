//
//  YDButton.m
//  Yammer
//
//  Created by Dave Schukin on 10/23/12.
//  Copyright (c) 2012 Yammer Inc. All rights reserved.
//

#import "YDButton.h"
#import "UIColor+Extensions.h"
#import "YMDrawingAdditions.h"
#import <QuartzCore/QuartzCore.h>

static NSString * const YDButton_FontName               = @"HelveticaNeue-Bold";
static const CGFloat YDButton_DefaultFontSize           = 20;
static const CGFloat YDButton_ImageTextSpacing          = 5.0;      /** Spacing between the image & text, if an image is set. */
static const CGFloat YDButton_MaxImageWidth             = 20.0;
static const CGFloat YDButton_TintGradientBrightness    = 0.1;      /** The brightness offset from the top of the gradient, to the tint color / middle. */
static const CGFloat YDButton_TintStrokeSaturation      = 0.1;     /** The amount to offset the saturation for stroke when setting via the tint color. */
static const CGFloat YDButton_TintStrokeBrightness      = 0.15;     /** The amount to offset the brightness for stroke when setting via the tint color. */

/**
 * This private interface contains properties that
 * in the future, we will probably want to partially
 * or fully expose in the public class interface.
 * By "partially", consider that while we have a normalGradientColors
 * array, we may just want to have a public property
 * called tintColor, and have the setter compute the top/bottom
 * colors for the gradient.
 */
@interface YDButton ()

/** @name Private interface */

@property (nonatomic, strong, readwrite) UILabel        *textLabel;
@property (nonatomic, strong, readwrite) UIImageView    *imageView;

@property (nonatomic, assign, readwrite) CGFloat        strokeWeight;
@property (nonatomic, strong, readwrite) UIColor        *strokeColor;

@property (nonatomic, assign, readwrite) CGFloat        cornerRadius;

/**
 * The gradient colors for the "normal" state. This is an array so we can future-proof
 * for when we want to have a gradient with more than 2 colors (much like many stock iOS buttons),
 * but for now we only throw two colors in there.
 */
@property (nonatomic, strong, readwrite) NSArray        *normalGradientColors;

@property (nonatomic, assign, readwrite) CGSize         contentShadowOffset;
@property (nonatomic, strong, readwrite) UIColor        *contentShadowColor;

- (NSArray *)highlightedGradientColors;

/**
 * @deprecated - use setTintType: for now.
 *
 * The tint color; this will be used as the middle of the button gradient,
 * and the top and bottom of the gradient will be computed using offsets of this.
 *
 * The implementation file contains constants that dictate saturation/brightness offsets
 * for the gradient and stroke; for example, a gradient brightness offset of .15 indicates
 * that the top of the gradient will be 15% brighter than the middle of the gradient.
 */
@property (nonatomic, strong, readwrite) UIColor    *tintColor;

@end

@implementation YDButton

- (void)privateInit
{
    _textLabel = [[UILabel alloc] init];
    _textLabel.font = [UIFont fontWithName:YDButton_FontName size:YDButton_DefaultFontSize];
    _textLabel.textColor = [UIColor whiteColor];
    _textLabel.backgroundColor = [UIColor clearColor];
    _textLabel.shadowOffset = CGSizeMake(0.0, -1.0);
    _textLabel.shadowColor = [UIColor darkGrayColor];
    
    [self addSubview:_textLabel];
    
    _imageView = [[UIImageView alloc] init];
    _imageView.contentMode = UIViewContentModeCenter;
    _imageView.clipsToBounds = NO;
    _imageView.layer.masksToBounds = NO;
    
    [self addSubview:_imageView];
    
    // Set default values
    _strokeWeight = 1.0;
    _cornerRadius = 4.0;
    _contentShadowOffset = CGSizeMake(0.0, -1.0);
    _contentShadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    self.backgroundColor = [UIColor clearColor];
    
    [self setTintType:YDButtonTintTypeBlue];
    
    //        // Add shadows
    //        for (UIView *view in @[_textLabel, _imageView])
    //        {
    //            view.layer.shadowColor = _contentShadowColor.CGColor;
    //            view.layer.shadowOffset = _contentShadowOffset;
    //            view.layer.shadowOpacity = 1.0;
    //            view.layer.shadowRadius = 0.0;
    //        }
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        [self privateInit];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self)
    {
        [self privateInit];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat boundsWidth = CGRectGetWidth(self.bounds);
    CGFloat boundsHeight = CGRectGetHeight(self.bounds);
    
    // If the image is not nil, then we compute the combined width of the
    // imageView and textLabels, then center them within the button and left-align
    // the text
    if (_imageView.image != nil)
    {
        CGFloat imageTextSpacing = 0;
        
        // If there's an image AND text, then insert a spacing between the two.
        if ([_textLabel.text length] > 0)
        {
            imageTextSpacing = YDButton_ImageTextSpacing;
        }
        
        CGSize textSize = [_textLabel.text sizeWithFont:_textLabel.font];
        CGFloat imageWidth = _imageView.image.size.width;
        CGFloat contentWidth = textSize.width + imageWidth + imageTextSpacing;
        CGFloat contentX = (boundsWidth - contentWidth) / 2.0;
        
        _imageView.frame = CGRectMake(contentX, 0.0, imageWidth, boundsHeight);
        
        // The text view takes the remaining width
        CGFloat textX = CGRectGetMaxX(_imageView.frame) + imageTextSpacing;
        _textLabel.frame = CGRectMake(textX, 0.0, textSize.width, boundsHeight);
        
        // With the image present, the text is left-aligned
        _textLabel.textAlignment = UITextAlignmentLeft;
    }
    else
    {
        // Text view takes the entire width
        _imageView.frame = CGRectZero;
        _textLabel.frame = self.bounds;
        
        // Text view is also centered when there is no image
        _textLabel.textAlignment = UITextAlignmentCenter;
    }
}

#pragma mark -
#pragma mark Accessors

- (NSString *)text
{
    return [self.textLabel text];
}

- (void)setText:(NSString *)text
{
    [self.textLabel setText:text];
    
    // Set the accessbility label to match, since UILabel seems to do this,
    // and this is needed for KIF tests to work
    [self setAccessibilityLabel:text];
    
    // Redraw the button
    [self setNeedsDisplay];
}

- (UIImage *)image
{
    return [self.imageView image];
}

- (void)setImage:(UIImage *)image
{
    [self.imageView setImage:image];
    [self setNeedsDisplay];
}

- (UIFont *)font
{
    return [self.textLabel font];
}

- (void)setFont:(UIFont *)font
{
    [self.textLabel setFont:font];
}

- (UIColor *)tintColor
{
    // -tintColor doesn't need to be implemented for any reason (yet), and it
    // looks like UIControl has a private iVar for this which we don't have access to
//    NSAssert(NO, @"-tintColor is not implemented!");
    return nil;
}

- (void)setTintColor:(UIColor *)tintColor
{
    CGFloat tintHue, tintSaturation, tintBrightness, tintAlpha;
    BOOL didGetComponents = [tintColor getHue:&tintHue saturation:&tintSaturation brightness:&tintBrightness alpha:&tintAlpha];
    
    NSAssert(didGetComponents, @"Unable to get tint color components");
    
    CGFloat topBrightness = tintBrightness + YDButton_TintGradientBrightness;
    CGFloat bottomBrightness = tintBrightness - YDButton_TintGradientBrightness;
    UIColor *topColor = [UIColor colorWithHue:tintHue saturation:tintSaturation brightness:topBrightness alpha:tintAlpha];
    UIColor *bottomColor = [UIColor colorWithHue:tintHue saturation:tintSaturation brightness:bottomBrightness alpha:tintAlpha];
    
    self.normalGradientColors = @[topColor, bottomColor];
    
    // Set the stroke color
    CGFloat strokeSaturation = tintSaturation + YDButton_TintStrokeSaturation;
    CGFloat strokeBrightness = tintBrightness - YDButton_TintStrokeBrightness;
    self.strokeColor = [UIColor colorWithHue:tintHue saturation:strokeSaturation brightness:strokeBrightness alpha:tintAlpha];
    
    [self setNeedsDisplay];
}

- (NSArray *)highlightedGradientColors
{
    return [[_normalGradientColors reverseObjectEnumerator] allObjects];
}

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    
    // When highlighted, make sure the gradient + whatever else gets redrawn
    [self setNeedsDisplay];
}

- (void)setTintType:(YDButtonTintType)tintType
{
    NSUInteger topHexValue;
    NSUInteger bottomHexValue;
    NSUInteger strokeHexValue;
    NSUInteger textHexValue;
    
    // These values shouldn't be here... though I'm not sure where to put them. -DS
    switch (tintType) {
        case YDButtonTintTypeOrange:
            topHexValue = 0xFBB700;
            bottomHexValue = 0xFF8800;
            strokeHexValue = 0x9F5404;
            textHexValue = 0xFFFFFF;
            break;
        case YDButtonTintTypeGrey:
            topHexValue = 0xFBFBFB;
            bottomHexValue = 0xCCCCCC;
            strokeHexValue = 0x666666;
            textHexValue = 0x333333;
            break;
        case YDButtonTintTypeGreen:
            topHexValue = 0x7ABD01;
            bottomHexValue = 0x63A500;
            strokeHexValue = 0x3A6E0A;
            textHexValue = 0xFFFFFF;
            break;
        case YDButtonTintTypeActionBar:
            topHexValue = 0x989898;
            bottomHexValue = 0x7D7D7D;
            strokeHexValue = 0x666666;
            textHexValue = 0xFFFFFF;
            break;
        case YDButtonTintTypeBlue:
            topHexValue = 0x48AFF3;
            bottomHexValue = 0x248BCD;
            strokeHexValue = 0x27759C;
            textHexValue = 0xFFFFFF;
            break;
        default:
            break;
    }
    
    UIColor *topColor = [UIColor colorWithRGBHex:topHexValue];
    UIColor *bottomColor = [UIColor colorWithRGBHex:bottomHexValue];
    UIColor *strokeColor = [UIColor colorWithRGBHex:strokeHexValue];
    UIColor *textColor = [UIColor colorWithRGBHex:textHexValue];
    
    self.normalGradientColors = @[topColor, bottomColor];
    self.textLabel.textColor = textColor;
    self.strokeColor = strokeColor;
}

#pragma mark -
#pragma mark Core graphics

- (void)drawRect:(CGRect)rect
{
    // Yuck, Core Graphics code that draws a gradient with a stroke around it.
    self.backgroundColor = [UIColor clearColor];
	CGRect imageBounds = CGRectMake(0.0, 0.0, self.bounds.size.width - 0.5, self.bounds.size.height);
    
	CGGradientRef gradient;
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGPoint point2;
    
	CGFloat resolution = 0.5 * (self.bounds.size.width / imageBounds.size.width + self.bounds.size.height / imageBounds.size.height);
	
	CGFloat stroke = self.strokeWeight * resolution;
    
	if (stroke < 1.0)
    {
        stroke = ceil(stroke);
    }
	else
    {
        stroke = round(stroke);
    }
    
	stroke /= resolution;
    
    // Create a path in the shape of a rectangle, with control points for rounded corners
    CGPathRef path = YMCreatePathForRoundedRect([self bounds], [self cornerRadius], stroke);
    
    // If you want to support more than 2 gradient colors,
    // the only thing that needs to be changed
    // is this hardcoded gradientLocations array.
    NSAssert([self.normalGradientColors count] == 2, @"Only two gradient colors supported at the moment");
    NSArray *gradientLocations = @[@0.0, @1.0];
    
    if (self.state == UIControlStateHighlighted)
    {
        gradient = YMCreateGradient([self highlightedGradientColors], gradientLocations);
    }
    else
    {
        gradient = YMCreateGradient([self normalGradientColors], gradientLocations);
    }
    
	CGContextAddPath(context, path);
	CGContextSaveGState(context);
	CGContextEOClip(context);
	CGPoint point = CGPointMake((self.bounds.size.width / 2.0), 0.0);
    point2 = CGPointMake((self.bounds.size.width / 2.0), self.bounds.size.height);
	CGContextDrawLinearGradient(context, gradient, point, point2, (kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation));
	CGContextRestoreGState(context);
	[self.strokeColor setStroke];
	CGContextSetLineWidth(context, stroke);
	CGContextSetLineCap(context, kCGLineCapSquare);
	CGContextAddPath(context, path);
	CGContextStrokePath(context);
	CGPathRelease(path);
    CGGradientRelease(gradient);
}

#pragma mark -
#pragma mark Class methods

+ (UIFont *)largeFont
{
    return [UIFont boldSystemFontOfSize:20.0];
}

@end
