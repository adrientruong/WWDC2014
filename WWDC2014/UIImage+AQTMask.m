//
//  UIImage+AQTMask.m
//  WWDC2014
//
//  Created by Adrien Truong on 4/7/14.
//  Copyright (c) 2014 Adrien Truong. All rights reserved.
//

#import "UIImage+AQTMask.h"

@implementation UIImage (AQTMask)

- (UIImage *)imageWithMask:(UIImage *)mask
{
    CGImageRef imageReference = self.CGImage;
    CGImageRef maskReference = mask.CGImage;
    
    CGImageRef imageMask = CGImageMaskCreate(CGImageGetWidth(maskReference),
                                             CGImageGetHeight(maskReference),
                                             CGImageGetBitsPerComponent(maskReference),
                                             CGImageGetBitsPerPixel(maskReference),
                                             CGImageGetBytesPerRow(maskReference),
                                             CGImageGetDataProvider(maskReference),
                                             NULL, // Decode is null
                                             YES // Should interpolate
                                             );
    
    CGImageRef maskedReference = CGImageCreateWithMask(imageReference, imageMask);
    CGImageRelease(imageMask);
    
    UIImage *maskedImage = [UIImage imageWithCGImage:maskedReference];
    CGImageRelease(maskedReference);
    
    return maskedImage;
}

@end
