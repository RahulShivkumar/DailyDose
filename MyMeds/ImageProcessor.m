//
//  ImageProcessor.m
//  MyMeds
//
//  Created by Rahul Shivkumar on 7/17/15.
//  Copyright (c) 2015 test. All rights reserved.
//

#import "ImageProcessor.h"

#define Mask8(x) ( (x) & 0xFF )
#define R(x) ( Mask8(x) )
#define G(x) ( Mask8(x >> 8 ) )
#define B(x) ( Mask8(x >> 16) )
#define A(x) ( Mask8(x >> 24) )
#define RGBAMake(r, g, b, a) ( Mask8(r) | Mask8(g) << 8 | Mask8(b) << 16 | Mask8(a) << 24 )

@implementation ImageProcessor

+ (instancetype)sharedProcessor {
    static id sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

#pragma mark - Public

- (void)processImage:(UIImage*)inputImage {
    UIImage * outputImage = [self smoothenImage:inputImage];
    
    if ([self.delegate respondsToSelector:
         @selector(imageProcessorFinishedProcessingWithImage:)]) {
        [self.delegate imageProcessorFinishedProcessingWithImage:outputImage];
    }
}

- (UIImage*)smoothenImage:(UIImage*)img{
    //Setup pixel extractor
    
    UInt32 * inputPixels;
    
    CGImageRef inputCGImage = [img CGImage];
    NSUInteger inputWidth = CGImageGetWidth(inputCGImage);
    NSUInteger inputHeight = CGImageGetHeight(inputCGImage);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    NSUInteger bytesPerPixel = 4;
    NSUInteger bitsPerComponent = 8;
    
    NSUInteger inputBytesPerRow = bytesPerPixel * inputWidth;
    
    inputPixels = (UInt32 *)calloc(inputHeight * inputWidth, sizeof(UInt32));
    
    CGContextRef context = CGBitmapContextCreate(inputPixels, inputWidth, inputHeight,
                                                 bitsPerComponent, inputBytesPerRow, colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    
    CGContextDrawImage(context, CGRectMake(0, 0, inputWidth, inputHeight), inputCGImage);
    
    for (NSUInteger j = 0; j < inputHeight; j++) {
        for (NSUInteger i = 0; i < inputWidth; i++) {
            UInt32 * currentPixel = inputPixels + (j * inputWidth) + i;
            UInt32 color = *currentPixel;
            
            // Read out the colors
            UInt32 r = R(color);
            UInt32 g = G(color);
            UInt32 b = B(color);
            // Add some red
            
            if (r < 150 && g < 150 && b < 150){
                r = 10;
                g = 10;
                b = 10;
            } else {
                r = 255;
                g = 255;
                b = 255;
            }
         
            

            // Write back the color
            *currentPixel = RGBAMake(r, g, b, A(color));
        }
    }
    CGImageRef newCGImage = CGBitmapContextCreateImage(context);
    UIImage *processedImage = [UIImage imageWithCGImage:newCGImage];
    
    return processedImage;
}

#undef RGBAMake
#undef R
#undef G
#undef B
#undef A
#undef Mask8

@end
