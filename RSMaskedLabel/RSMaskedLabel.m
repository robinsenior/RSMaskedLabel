//
//  RSMaskedLabel.m
//  RSMaskedLabel
//
//  Created by Robin Senior on 12-01-04.
//  Copyright (c) 2012 Robin Senior. All rights reserved.
//

#import "RSMaskedLabel.h"
#import <QuartzCore/QuartzCore.h>

@interface UIImage (RSAdditions)
+ (UIImage *) imageWithView:(UIView *)view;
- (UIImage *) invertAlpha;
@end

@interface RSMaskedLabel ()
{
    CGImageRef invertedAlphaImage;
}
@property (nonatomic, retain) UILabel *knockoutLabel;
@property (nonatomic, retain) CALayer *textLayer;
- (void) RS_commonInit;
@end

@implementation RSMaskedLabel
@synthesize knockoutLabel, textLayer;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        [self RS_commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) 
    {
        [self RS_commonInit];
    }
    return self;
}

+ (Class)layerClass
{
    return [CAGradientLayer class];
}

- (void) RS_commonInit
{
    [self setBackgroundColor:[UIColor clearColor]];
     
    // create the UILabel for the text
    knockoutLabel = [[UILabel alloc] initWithFrame:[self frame]];
    [knockoutLabel setText:@"booyah"];
    [knockoutLabel setTextAlignment:UITextAlignmentCenter];
    [knockoutLabel setFont:[UIFont boldSystemFontOfSize:72.0]];
    [knockoutLabel setNumberOfLines:1];
    [knockoutLabel setBackgroundColor:[UIColor clearColor]];
    [knockoutLabel setTextColor:[UIColor whiteColor]];
    
    // create our filled area (in this case a gradient)
    NSArray *colors = [[NSArray arrayWithObjects:
                        (id)[[UIColor colorWithRed:0.349 green:0.365 blue:0.376 alpha:1.000] CGColor],
                        (id)[[UIColor colorWithRed:0.455 green:0.490 blue:0.518 alpha:1.000] CGColor],
                        (id)[[UIColor colorWithRed:0.412 green:0.427 blue:0.439 alpha:1.000] CGColor],
                        (id)[[UIColor colorWithRed:0.208 green:0.224 blue:0.235 alpha:1.000] CGColor],
                        nil] retain];
    
    NSArray *gradientLocations = [NSArray arrayWithObjects:
                                  [NSNumber numberWithFloat:0.0],
                                  [NSNumber numberWithFloat:0.54],
                                  [NSNumber numberWithFloat:0.55],
                                  [NSNumber numberWithFloat:1], nil];
    
    // render our label to a UIImage
    // if you remove the call to invertAlpha it will mask the text
    invertedAlphaImage = [[[UIImage imageWithView:knockoutLabel] invertAlpha] CGImage];

    // create a new CALayer to use as the mask
    textLayer = [CALayer layer];
    // stick the image in the layer
    [textLayer setContents:(id)invertedAlphaImage];

    // create a nice gradient layer to use as our fill
    CAGradientLayer *gradientLayer = (CAGradientLayer *)[self layer];
    
    [gradientLayer setBackgroundColor:[[UIColor clearColor] CGColor]];
    [gradientLayer setColors: colors];
    [gradientLayer setLocations:gradientLocations];
    [gradientLayer setStartPoint:CGPointMake(0.0, 0.0)];
    [gradientLayer setEndPoint:CGPointMake(0.0, 1.0)];
    [gradientLayer setCornerRadius:10];
    
    // mask the text layer onto our gradient
    [gradientLayer setMask:textLayer];
}

- (void)layoutSubviews
{
    // resize the text layer
    [textLayer setFrame:[self bounds]];
}

- (void)dealloc 
{
    CGImageRelease(invertedAlphaImage);
    [knockoutLabel release];
    [textLayer     release];
    [super         dealloc];
}

@end

@implementation UIImage (RSAdditions)

/*
 create a UIImage from a UIView
 */
+ (UIImage *) imageWithView:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;
}

/*
 get the image to invert its alpha channel
 */
- (UIImage *)invertAlpha
{
    // scale is needed for retina devices
    CGFloat scale = [self scale];
    CGSize size = self.size;
    int width = size.width * scale;
    int height = size.height * scale;
    
    CGColorSpaceRef colourSpace = CGColorSpaceCreateDeviceRGB();
    
    unsigned char *memoryPool = (unsigned char *)calloc(width*height*4, 1);
    
    CGContextRef context = CGBitmapContextCreate(memoryPool, width, height, 8, width * 4, colourSpace, kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedLast);
    
    CGColorSpaceRelease(colourSpace);
    
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), [self CGImage]);
    
    for(int y = 0; y < height; y++)
    {
        unsigned char *linePointer = &memoryPool[y * width * 4];
        
        for(int x = 0; x < width; x++)
        {
            linePointer[3] = 255-linePointer[3];
            linePointer += 4;
        }
    }
    
    // get a CG image from the context, wrap that into a
    CGImageRef cgImage = CGBitmapContextCreateImage(context);
    UIImage *returnImage = [UIImage imageWithCGImage:cgImage scale:scale orientation:UIImageOrientationUp];
    
    // clean up
    CGImageRelease(cgImage);
    CGContextRelease(context);
    free(memoryPool);
    
    // and return
    return returnImage;
}
@end
