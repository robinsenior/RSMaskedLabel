//
//  RSMaskedLabelView.m
//  RSMaskedLabel
//
//  Created by Robin Senior on 2013-02-07.
//  Copyright (c) 2013 Nulayer. All rights reserved.
//

#import "RSMaskedLabel.h"

@implementation RSMaskedLabel
{
    UIColor *_maskedBackgroundColor;
    BOOL _maskedTextEnabled;
}

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame]))
        [self RS_commonInit];
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder]))
        [self RS_commonInit];
    return self;
}

- (UIColor*)backgroundColor
{
    return _maskedBackgroundColor;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    _maskedBackgroundColor = backgroundColor;
    [self setNeedsDisplay];
}

- (void)RS_commonInit
{
    _maskedBackgroundColor = [super backgroundColor];
    [super setBackgroundColor:[UIColor clearColor]];
    self.opaque = NO;
    self.maskedTextEnabled = YES;
}

- (void)setTextColor:(UIColor *)textColor
{
    [super setTextColor:textColor];

    self.maskedTextEnabled = false;
}

-(void)setMaskedTextEnabled:(BOOL)maskedTextEnabled
{
    _maskedTextEnabled = maskedTextEnabled;

    if (_maskedTextEnabled) {
        // text color needs to be white for masking to work
        [super setTextColor:[UIColor whiteColor]];
    }

    [self setNeedsDisplay];
}

- (BOOL)isMaskedTextEnabled
{
    return _maskedTextEnabled;
}

- (void)drawRect:(CGRect)rect
{
    if (!self.isMaskedTextEnabled) {
        [super drawRect:rect];
        return;
    }
    
    // Render into a temporary bitmap context at a max of 8 bits per component for subsequent CGImageMaskCreate operations
    UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0);
    
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGImageRef image = CGBitmapContextCreateImage(context);
    UIGraphicsEndImageContext();
    
    // Revert to normal graphics context for the rest of the rendering
    context = UIGraphicsGetCurrentContext();
    
    CGContextConcatCTM(context, CGAffineTransformMake(1, 0, 0, -1, 0, CGRectGetHeight(rect)));
    
    // create a mask from the normally rendered text
    CGImageRef mask = CGImageMaskCreate(CGImageGetWidth(image), CGImageGetHeight(image), CGImageGetBitsPerComponent(image), CGImageGetBitsPerPixel(image), CGImageGetBytesPerRow(image), CGImageGetDataProvider(image), CGImageGetDecode(image), CGImageGetShouldInterpolate(image));
    
    CFRelease(image); image = NULL;
    
    // wipe the slate clean
    CGContextClearRect(context, rect);
    
    CGContextSaveGState(context);
    CGContextClipToMask(context, rect, mask);
    
    if (self.layer.cornerRadius != 0.0f) {
        CGPathRef path = CGPathCreateWithRoundedRect(rect, self.layer.cornerRadius, self.layer.cornerRadius, nil);
        CGContextAddPath(context, path);
        CGContextClip(context);
        CGPathRelease(path);
    }
    
    CFRelease(mask); mask = NULL;
    
    [self RS_drawBackgroundInRect:rect];
    
    CGContextRestoreGState(context);
}

- (void) RS_drawBackgroundInRect:(CGRect)rect
{
    // this is where you do whatever fancy drawing you want to do!
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [_maskedBackgroundColor set];
    CGContextFillRect(context, rect);
}

@end
