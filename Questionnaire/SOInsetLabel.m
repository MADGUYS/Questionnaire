//
//  SOInsetLabel.m
//
//  Created by Joseph Hankin on 11/2/12.
//  From code posted by Rob Mayoff.
//  http://stackoverflow.com/questions/8467141/ios-how-to-achieve-emboss-effect-for-the-text-on-uilabel
//  Copyright (c) 2012 Joseph Hankin. All rights reserved.
//

#import "SOInsetLabel.h"

@implementation SOInsetLabel

@synthesize upwardShadowColor;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.font = [UIFont boldSystemFontOfSize:30];
        self.backgroundColor = [UIColor clearColor];
        self.textColor = [UIColor colorWithWhite:0 alpha:0.1];
        self.shadowColor = [UIColor colorWithWhite:0 alpha:0.3];
        self.shadowOffset = CGSizeMake(0, -0.5);
        self.upwardShadowColor = [UIColor colorWithWhite:1 alpha:0.5];
        self.upwardShadowOffset = CGSizeMake(0, 1);
        self.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}

- (void)drawTextInRect:(CGRect)rect {
    
    self.backgroundColor = [UIColor clearColor];
    self.shadowColor = [UIColor colorWithWhite:0 alpha:0.3];
    self.shadowOffset = CGSizeMake(0, -0.5);
    self.upwardShadowColor = [UIColor colorWithWhite:1 alpha:0.5];
    self.upwardShadowOffset = CGSizeMake(0, 1);
    
    UIImage *interiorShadowImage = [self imageWithInteriorShadowAndString:self.text
                                                                     font:self.font
                                                                textColor:self.textColor
                                                                     size:rect.size];
    UIImage *finalImage = [self imageWithUpwardShadowAndImage:interiorShadowImage];
    [finalImage drawInRect:rect];
}

- (UIImage *)maskWithString:(NSString *)string font:(UIFont *)font size:(CGSize)size
{
    CGRect rect = { CGPointZero, size };
    CGFloat scale = [UIScreen mainScreen].scale;
    CGColorSpaceRef grayscale = CGColorSpaceCreateDeviceGray();
    CGContextRef gc = CGBitmapContextCreate(NULL, size.width * scale, size.height * scale, 8, size.width * scale, grayscale, kCGImageAlphaOnly);
    CGContextScaleCTM(gc, scale, scale);
    CGColorSpaceRelease(grayscale);
    UIGraphicsPushContext(gc); {
        [[UIColor whiteColor] setFill];
        [string drawInRect:rect withFont:font];
    } UIGraphicsPopContext();
    
    CGImageRef cgImage = CGBitmapContextCreateImage(gc);
    CGContextRelease(gc);
    UIImage *image = [UIImage imageWithCGImage:cgImage scale:scale orientation:UIImageOrientationDownMirrored];
    CGImageRelease(cgImage);
    
    return image;
}

- (UIImage *)invertedMaskWithMask:(UIImage *)mask
{
    CGRect rect = { CGPointZero, mask.size };
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, mask.scale); {
        [[UIColor blackColor] setFill];
        UIRectFill(rect);
        CGContextClipToMask(UIGraphicsGetCurrentContext(), rect, mask.CGImage);
        CGContextClearRect(UIGraphicsGetCurrentContext(), rect);
    }
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIImage *)imageWithInteriorShadowAndString:(NSString *)string font:(UIFont *)font textColor:(UIColor *)textColor size:(CGSize)size
{
    CGRect rect = { CGPointZero, size };
    UIImage *mask = [self maskWithString:string font:font size:rect.size];
    UIImage *invertedMask = [self invertedMaskWithMask:mask];
    UIImage *image;
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, [UIScreen mainScreen].scale); {
        CGContextRef gc = UIGraphicsGetCurrentContext();
        // Clip to the mask that only allows drawing inside the string's image.
        CGContextClipToMask(gc, rect, mask.CGImage);
        // We apply the mask twice because we're going to draw through it twice.
        // Only applying it once would make the edges too sharp.
        CGContextClipToMask(gc, rect, mask.CGImage);
        mask = nil; // done with mask; let ARC free it
        
        // Draw the red text.
        [textColor setFill];
        CGContextFillRect(gc, rect);
        
        // Draw the interior shadow.
        CGContextSetShadowWithColor(gc, CGSizeZero, 1.6, self.shadowColor.CGColor);
        [invertedMask drawAtPoint:CGPointZero];
        invertedMask = nil; // done with invertedMask; let ARC free it
        
        image = UIGraphicsGetImageFromCurrentImageContext();
    }
    UIGraphicsEndImageContext();
    return image;
}

- (UIImage *)imageWithUpwardShadowAndImage:(UIImage *)image
{
    UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale); {
        CGContextSetShadowWithColor(UIGraphicsGetCurrentContext(), self.upwardShadowOffset, 0, self.upwardShadowColor.CGColor);
        [image drawAtPoint:CGPointZero];
    }
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultImage;
}


@end
