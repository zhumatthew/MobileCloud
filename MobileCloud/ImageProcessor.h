//
//  Header.h
//  MobileCloud
//
//  Created by Matt Zhu on 3/23/16.
//  Copyright © 2016 DHM. All rights reserved.
//

#import "MagickWand.h"
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

typedef enum { SpreadTransformation, CharcoalTransformation, VignetteTransformation } TransformationMethod;

@interface ImageProcessor : NSObject

+ (UIImage*) createPosterizeImage:(CGImageRef)srcCGImage;
+ (UIImage*) createDistanceImage:(CGImageRef)srcCGImage;
+ (UIImage*) convertImage;

+ (UIImage*) dilateImage:(NSString *)srcImage;

@end
