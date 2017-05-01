//
//  GraphicUtils.m
//  LiveForest
//
//  Created by apple on 15/7/28.
//  Copyright (c) 2015年 HOTeam. All rights reserved.
//

#import "GraphicUtils.h"

@implementation GraphicUtils


#pragma mark - 图片处理

#pragma mark 模糊处理
- (UIImage *)blurImage:(UIImage *)image withBlurLevel:(CGFloat)blur
{
    CIContext *context = [CIContext contextWithOptions:nil];
    
    CIImage *inputImage = [CIImage imageWithCGImage:image.CGImage];
    
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"
                                  keysAndValues:kCIInputImageKey, inputImage,
                        @"inputRadius", @(blur),nil];
    
    CIImage *outputImage = filter.outputImage;
    
    CGImageRef outImage = [context createCGImage:outputImage fromRect:[outputImage extent]];
    
    return [UIImage imageWithCGImage:outImage];
}

@end
