//
//  UIImage+OrientationFix.m
//  SpookCam
//
//  Created by Rahul Shivkumar on 7/17/15.
//
//  Copyright (c) 2015 test. All rights reserved.

#import "UIImage+OrientationFix.h"

@implementation UIImage (OrientationFix)

- (UIImage *)imageWithFixedOrientation {
    if (self.imageOrientation == UIImageOrientationUp)
        return self;
    
    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
    [self drawInRect:(CGRect){0, 0, self.size}];
    UIImage *normalizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return normalizedImage;
}

@end
