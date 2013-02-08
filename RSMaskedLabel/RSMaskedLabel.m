//
//  RSMaskedLabelView.m
//  RSMaskedLabel
//
//  Created by Robin Senior on 2013-02-07.
//  Copyright (c) 2013 Nulayer. All rights reserved.
//

#import "RSMaskedLabel.h"

@interface RSMaskedLabel()
- (void) RS_commonInit;
- (void) RS_drawBackgroundInRect:(CGRect)rect;
@end

@implementation RSMaskedLabel

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

- (void)RS_commonInit
{
    [super setTextColor:[UIColor whiteColor]];
    [self setBackgroundColor:[UIColor clearColor]];
    [self setOpaque:NO];
}

- (void)setTextColor:(UIColor *)textColor
{
    // text color needs to be white for masking to work
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // let the superclass draw the label normally
    [super drawRect:rect];
    
    CGContextConcatCTM(context, CGAffineTransformMake(1, 0, 0, -1, 0, CGRectGetHeight(rect)));
    
    // create a mask from the normally rendered text
    CGImageRef image = CGBitmapContextCreateImage(context);
    CGImageRef mask = CGImageMaskCreate(CGImageGetWidth(image), CGImageGetHeight(image), CGImageGetBitsPerComponent(image), CGImageGetBitsPerPixel(image), CGImageGetBytesPerRow(image), CGImageGetDataProvider(image), CGImageGetDecode(image), CGImageGetShouldInterpolate(image));
    
    CFRelease(image); image = NULL;
    
    // wipe the slate clean
    CGContextClearRect(context, rect);
    
    CGContextSaveGState(context);
    CGContextClipToMask(context, rect, mask);
    
    CFRelease(mask);  mask = NULL;
    
    [self RS_drawBackgroundInRect:rect];
    
    CGContextRestoreGState(context);
    
}

- (void) RS_drawBackgroundInRect:(CGRect)rect
{
    // this is where you do whatever fancy drawing you want to do!
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [[UIColor whiteColor] set];
    CGContextFillRect(context, rect);
}

@end
