//
//  ImageProcessor.m
//  MobileCloud
//
//  Created by Matt Zhu on 3/23/16.
//  Copyright © 2016 DHM. All rights reserved.
//

#import "ImageProcessor.h"

@implementation ImageProcessor : NSObject

// special effects, morphology, and noise and color reduction are probably the most intensive

+ (UIImage*) createPosterizeImage:(CGImageRef)srcCGImage {
//    MagickWandGenesis();
//    magick_wand = NewMagickWand();
//    UIImage *src = [UIImage imageNamed:@"mirage"];
//    ConvertImageCommand(<#ImageInfo *#>, <#int#>, <#char **#>, <#char **#>, <#MagickExceptionInfo *#>)
    
    MagickWandGenesis();
    MagickWand *wand = NewMagickWand();
    NSData *data = UIImagePNGRepresentation([UIImage imageNamed:@"mirage"]);
//    NSData *data = UIImageJPEGRepresentation([UIImage imageNamed:@"continuity"],1.0);

    MagickReadImageBlob(wand, [data bytes], [data length]);
    
//    MagickBooleanType = status;
    
    // MagickMorphologyImage(<#MagickWand *#>, <#MorphologyMethod#>, <#const ssize_t#>, <#KernelInfo *#>)
//    MagickBooleanType status = MagickPosterizeImage(wand,6,MagickFalse);
     MagickBooleanType status = MagickNegateImage(wand, MagickFalse);
    if (status == MagickFalse)
    {
        NSLog(@"FAIL");
    }
    
    // Convert wand back to UIImage
    unsigned char * c_blob;
    size_t data_length;
    c_blob = MagickGetImageBlob(wand,&data_length);
    data = [NSData dataWithBytes:c_blob length:data_length];
    UIImage *img = [UIImage imageWithData:data];
    
    DestroyMagickWand(wand);
    MagickWandTerminus();
    return img;
}

+ (UIImage*) createDistanceImage:(CGImageRef)srcCGImage {
    //    MagickWandGenesis();
    //    magick_wand = NewMagickWand();
    //    UIImage *src = [UIImage imageNamed:@"mirage"];
    //    ConvertImageCommand(<#ImageInfo *#>, <#int#>, <#char **#>, <#char **#>, <#MagickExceptionInfo *#>)
    
    MagickWandGenesis();
    MagickWand *wand = NewMagickWand();
    NSData *data = UIImageJPEGRepresentation([UIImage imageNamed:@"continuity.jpg"], 1.0);
    //    NSData *data = UIImagePNGRepresentation([UIImage imageNamed:@"continuity.jpg"]);
    
    MagickReadImageBlob(wand, [data bytes], [data length]);
    
    //    MagickBooleanType = status;
    
    // wand, method, iterations, morphology kernel (array of doubles)
    
    
    //ftp://gd.tuwien.ac.at/graphics/ImageMagick/www/api/morphology.html
    
    // Diamond:1
    // Disk:6.4
//    KernelInfo *kernelInfo = AcquireKernelInfo("Octagonal");
//    KernelInfo *kernelInfo = AcquireKernelInfo("Octagon:3");
    // KernelInfo kernelInfo = AcquireKernelBuiltIn(GaussianKernel,const GeometryInfo *);
    // KernelInfo types defined in morphology.h
    KernelInfo *kernelInfo = AcquireKernelInfo("Octagon");
    CFTimeInterval startTime = CACurrentMediaTime();

    // Octagon:3 with ErodeMorphology and DilateMorphology
    // Octagon with EdgeMorphology
    // Octagonal:10 or Octagonal with Distance
    // EdgeOut, EdgeIn, Edge
    // kernelInfo->
    
    // 1.22093 s
//    MagickBooleanType status = MagickMorphologyImage(wand, DilateMorphology, 1, kernelInfo);
    
    // 1.27547 s
//    MagickBooleanType status = MagickMorphologyImage(wand, ErodeMorphology, 1, kernelInfo);
    
//    MagickBooleanType status = MagickMorphologyImage(wand, DistanceMorphology, 1, kernelInfo);
    
    // 1.48371 s
    MagickBooleanType status = MagickMorphologyImage(wand, EdgeMorphology, 1, kernelInfo);

    /*
     wand – the magick wand.
     gray – A value other than zero shades the intensity of each pixel.
     azimuth, elevation – Define the light source direction.
     azimuth [degrees off the x axis]
     elevation [pixels above the z-axis]
     */
//    MagickBooleanType status = MagickShadeImage(wand, MagickTrue, 70.0, 70.0);
    
    /*
     wand – the magick wand.
     opacity – percentage transparency.
     sigma – the standard deviation of the Gaussian, in pixels.
     x – the shadow x-offset.
     y – the shadow y-offset.
     */
//    MagickBooleanType status = MagickShadowImage(wand, 50.0, 3.0, 30.0, 30.0);

    //wand, (radius?)
    
    // 0.826106 s
//    MagickBooleanType status = MagickSpreadImage(wand, 7.0);
    
    // Wand, pixels, Gaussian
    // 2.9427 s
//    MagickBooleanType status = MagickCharcoalImage(wand, 3.0, 1.0);
    // wand, black point (radius?), white point, ellipse offset x, y

    
//    p_wand = NewPixelWand();
//    PixelSetColor(p_wand,"black");
//    MagickSetImageBackgroundColor(wand,p_wand);
    
//    MagickBooleanType status = MagickVignetteImage(wand, -20.0, 50.0,(long)(MagickGetImageWidth(wand)*.05),(long)MagickGetImageHeight(wand));
    
    // 7.845 s
//    MagickBooleanType status = MagickVignetteImage(wand, 40, 175.0,(long)(MagickGetImageWidth(wand)*0.05),(long)MagickGetImageHeight(wand)*0.05);

    
//    MagickBooleanType status = MagickMorphologyImage(wand, EdgeMorphology, 1, kernelInfo);


    
    CFTimeInterval endTime = CACurrentMediaTime();
    NSLog(@"Total Runtime of image processing: %g s", endTime - startTime);

//    MagickBooleanType status = MagickPosterizeImage(wand,6,MagickFalse);
    //MagickBooleanType status = MagickNegateImage(wand, MagickFalse);
    if (status == MagickFalse)
    {
        NSLog(@"FAIL");
    }
    
    // Convert wand back to UIImage
    unsigned char * c_blob;
    size_t data_length;
    c_blob = MagickGetImageBlob(wand,&data_length);
    data = [NSData dataWithBytes:c_blob length:data_length];
    UIImage *img = [UIImage imageWithData:data];
    
    DestroyMagickWand(wand);
    MagickWandTerminus();
    return img;
}



/*
-(UIImage *)convertImageToTiff
{
    // Get image from bundle.
    char *inputPath = strdup([self.inputImagePath UTF8String]);
    char *outputPath = strdup([self.outputImagePath UTF8String]);
    
    char *argv[] = {"convert", inputPath, "-strip", "-density", "200", "-resize", "1000x486\\!", "-define", "tiff:rows-per-strip=1", "-compress", "Group4", outputPath, NULL};
    
    MagickCoreGenesis(*argv, MagickFalse);
    MagickWand *magick_wand = NewMagickWand();
    NSData * dataObject = UIImageJPEGRepresentation([UIImage imageWithContentsOfFile:self.inputImagePath], 1.0f);
    MagickBooleanType status;
    status = MagickReadImageBlob(magick_wand, [dataObject bytes], [dataObject length]);
    if (status == MagickFalse) {
        NSLog(@"Error %@", magick_wand);
        
    }
    
    ImageInfo *imageInfo = AcquireImageInfo();
    ExceptionInfo *exceptionInfo = AcquireExceptionInfo();
    
    int elements = 0;
    while (argv[elements] != NULL)
    {
        elements++;
    }
    
    // ConvertImageCommand(ImageInfo *, int, char **, char **, MagickExceptionInfo *);
    status = ConvertImageCommand(imageInfo, elements, argv, NULL, exceptionInfo);
    
    if (exceptionInfo->severity != UndefinedException)
    {
        status=MagickTrue;
        CatchException(exceptionInfo);
    }
    
    if (status == MagickFalse) {
        fprintf(stderr, "Error in call");
        ThrowWandException(magick_wand); // Always throws an exception here...
    }
    
    UIImage *convertedImage = [UIImage imageWithContentsOfFile:self.outputImagePath];
    
    return convertedImage;
}
 
 */

/*
- (IBAction)buttonConv04:(id)sender {
    
    // MagickWandGenesis();
    
    int arg_count = 4;
    char *input_image = strdup([[[NSBundle mainBundle] pathForResource:@"img_0" ofType:@"wmf"] UTF8String]);
    char *output_image = strdup([[[NSBundle mainBundle] pathForResource:@"iphone" ofType:@"png"] UTF8String]);
    char *args[] = {"convert", input_image, "-negate", output_image, NULL};
    
    MagickCoreGenesis(*args, MagickTrue);
    magick_wand = NewMagickWand();
    NSData * dataObject = UIImageJPEGRepresentation([UIImage imageWithContentsOfFile:[NSString stringWithUTF8String:input_image]], 1.0f);
    MagickBooleanType status;
    status = MagickReadImageBlob(magick_wand, [dataObject bytes], [dataObject length]);
    
    if (status == MagickFalse) {
        ThrowWandException(magick_wand);
    }
    
    int args_count;
    for(args_count = 0; args[args_count] != (char *)NULL; args_count++);
    
    ImageInfo *image_info = AcquireImageInfo();
    ExceptionInfo *exception = AcquireExceptionInfo();
    
    status = ConvertImageCommand(image_info, arg_count, args, NULL, exception);
    
    if (exception->severity != UndefinedException)
    {
        status = MagickTrue;
        CatchException(exception);
    }
    
    if (status == MagickFalse)
    {
        NSLog(@"FAIL");
    }
    
    NSData * dataObject2 = UIImageJPEGRepresentation([UIImage imageWithContentsOfFile:[NSString stringWithUTF8String:output_image]], 1.0f);
    status = MagickReadImageBlob(magick_wand, [dataObject2 bytes], [dataObject2 length]);
    
    size_t my_size;
    unsigned char * my_image = MagickGetImageBlob(magick_wand, &my_size);
    NSData * data = [[NSData alloc] initWithBytes:my_image length:my_size];
    free(my_image);
    magick_wand = DestroyMagickWand(magick_wand);
    MagickWandTerminus();
    UIImage * image = [[UIImage alloc] initWithData:data];
    
    free(input_image);
    free(output_image);
    
    image_info=DestroyImageInfo(image_info);
    exception=DestroyExceptionInfo(exception);
    
    MagickCoreTerminus();
    
    [iKK_imageView setImage:image];
}
 */

+ (UIImage*)convertImage {
    
    CFTimeInterval startTime = CACurrentMediaTime();
    
    NSLog(@"I am using MagicWand Library");
    //GIT path https://github.com/marforic/imagemagick_lib_iphone
    
    MagickWandGenesis();
    MagickWand *magick_wand = NewMagickWand();
    
    MagickSetFormat(magick_wand, "jpg");
    
    char *input_image = strdup([[[NSBundle mainBundle] pathForResource:@"mirage" ofType:@"png"] UTF8String]);
    
    //NSData * dataObject = UIImagePNGRepresentation([UIImage imageNamed:@"daftpunk.jpg"]);
    NSData * dataObject = UIImagePNGRepresentation([UIImage imageWithContentsOfFile:[NSString stringWithUTF8String:input_image]]);
    
    NSLog(@"Initial format: %@",[self mimeTypeByGuessingFromData:dataObject]);
    //UIImageJPEGRepresentation([imageViewButton imageForState:UIControlStateNormal], 90);
    MagickBooleanType status;
    status = MagickReadImageBlob(magick_wand, [dataObject bytes], [dataObject length]);
    if (status == MagickFalse) {
//        ThrowWandException(magick_wand);
    }
    
    size_t my_size;
    unsigned char * my_image = MagickGetImageBlob(magick_wand, &my_size);
    NSData * data = [[NSData alloc] initWithBytes:my_image length:my_size];
    free(my_image);
    magick_wand = DestroyMagickWand(magick_wand);
    MagickWandTerminus();
    UIImage * image = [[UIImage alloc] initWithData:data];
    
    NSLog(@"Final format: %@",[self mimeTypeByGuessingFromData:data]);
    
    CFTimeInterval endTime = CACurrentMediaTime();
    NSLog(@"Total Runtime: %g s", endTime - startTime);

    
    return image;
    
}

//+ (UIImage*)convertImage {
//    
//    // MagickWandGenesis();
//    
//    CFTimeInterval startTime = CACurrentMediaTime();
//    
//    char *input_image = strdup([[[NSBundle mainBundle] pathForResource:@"mirage" ofType:@"png"] UTF8String]);
//    char *output_image = strdup([[[NSBundle mainBundle] pathForResource:@"mirage" ofType:@"png"] UTF8String]);
//    
//    // NSLog(@"Initial format: %@",[self mimeTypeByGuessingFromData:UIImageJPEGRepresentation([UIImage imageWithContentsOfFile:[NSString stringWithUTF8String:input_image]], 1.0f)]);
//
//
//    //char *output_image = strdup([[[[[NSBundle mainBundle] pathForResource:@"mirage" ofType:@"png"] stringByDeletingLastPathComponent] stringByAppendingPathComponent:@"mirage.jpg"] UTF8String]);
//    char *args[] = {"convert", input_image, "-monitor", "-negate", output_image, NULL};
//    
//    MagickCoreGenesis(*args, MagickTrue);
//    MagickWand *magick_wand = NewMagickWand();
//    NSData * dataObject = UIImagePNGRepresentation([UIImage imageWithContentsOfFile:[NSString stringWithUTF8String:input_image]]);
//    MagickBooleanType status;
//    status = MagickReadImageBlob(magick_wand, [dataObject bytes], [dataObject length]);
//    
//    if (status == MagickFalse) {
//        //ThrowWandException(magick_wand);
//    }
//    
//    
//    
//    int arg_count;
//    for(arg_count = 0; args[arg_count] != (char *)NULL; arg_count++);
//    
//    ImageInfo *image_info = AcquireImageInfo();
//    ExceptionInfo *exception = AcquireExceptionInfo();
//    
//    status = ConvertImageCommand(image_info, arg_count, args, NULL, exception);
//    
//    if (exception->severity != UndefinedException)
//    {
//        status = MagickTrue;
//        CatchException(exception);
//    }
//    
//    if (status == MagickFalse)
//    {
//        NSLog(@"FAIL");
//    }
//    
//    NSData * dataObject2 = UIImageJPEGRepresentation([UIImage imageWithContentsOfFile:[NSString stringWithUTF8String:output_image]], 1.0f);
//    status = MagickReadImageBlob(magick_wand, [dataObject2 bytes], [dataObject2 length]);
//    
//    size_t my_size;
//    unsigned char * my_image = MagickGetImageBlob(magick_wand, &my_size);
//    NSData * data = [[NSData alloc] initWithBytes:my_image length:my_size];
//    free(my_image);
//    magick_wand = DestroyMagickWand(magick_wand);
//    MagickWandTerminus();
//    UIImage * image = [[UIImage alloc] initWithData:data];
//    
//    free(input_image);
//    free(output_image);
//    
//    NSLog(@"Final format: %@",[self mimeTypeByGuessingFromData:data]);
//
//    
//    image_info=DestroyImageInfo(image_info);
//    exception=DestroyExceptionInfo(exception);
//    
//    MagickCoreTerminus();
//    
//    CFTimeInterval endTime = CACurrentMediaTime();
//    NSLog(@"Total Runtime: %g s", endTime - startTime);
//    
//    return image;
//    
//}

/*


+ (UIImage*)convertImage {
    MagickWandGenesis();
    MagickWand *magick_wand = NewMagickWand();
    //UIImageJPEGRepresentation([imageViewButton imageForState:UIControlStateNormal], 90);
    NSData * dataObject = UIImagePNGRepresentation([UIImage imageNamed:@"mirage"]);
    // NSData *dataObject = UIImageJPEGRepresentation([UIImage imageNamed:@"continuity"],1.0);

    
    NSLog(@"Initial format: %@",[self mimeTypeByGuessingFromData:dataObject]);
    
    MagickBooleanType status;
    status = MagickReadImageBlob(magick_wand, [dataObject bytes], [dataObject length]);
    
    if (status == MagickFalse) {
//        ThrowWandException(magick_wand);
    }
    
    // Get image from bundle.
    char *input_image = strdup([[[NSBundle mainBundle] pathForResource:@"mirage" ofType:@"png"] UTF8String]);
    char *output_image = strdup([[[[[NSBundle mainBundle] pathForResource:@"mirage" ofType:@"png"] stringByDeletingLastPathComponent] stringByAppendingPathComponent:@"mirage.jpg"] UTF8String]);
    

    // output_image	char *	"/private/var/mobile/Containers/Bundle/Application/20CEE1FB-6C2B-44D1-B513-1B47E2C530E1/MobileCloud.app/mirage.jpg"	0x00000001740f8480
    
//    char *input_image = strdup([@"input" UTF8String]);
//    char *output_image = strdup([@"output" UTF8String]);
    // char *output_image = strdup([@"output" UTF8String])
    
    // output_image = [@"wassup" UTF8String];

    
//    int arg_count = 3;
//    char *argv[] = {"convert", input_image, output_image, NULL};
    // char *argv[] = {"convert", "jpg", NULL};
    
    int arg_count = 5;
    char *argv[] = {"convert", input_image, "-define", "jpeg:optimize-coding=on", output_image, NULL};

    
    // int arg_count = 4;
    // char *argv[] = {"convert", input_image, "jpg", output_image, NULL};
    //char *argv[] = { "convert", input_image, "-resize", "100x100", output_image, NULL };

//    const char *argv[] = { "convert", input_image, "-resize", "100x100", output_image, NULL };
    // ConvertImageCommand(ImageInfo *, int, char **, char **, MagickExceptionInfo *);
    status = ConvertImageCommand(AcquireImageInfo(), arg_count, (char**)argv, NULL, AcquireExceptionInfo());
    
    if (status == MagickFalse) {
//        ThrowWandException(magick_wand);
    }
    
    size_t my_size;
    unsigned char * my_image = MagickGetImageBlob(magick_wand, &my_size);
    NSData * data = [[NSData alloc] initWithBytes:my_image length:my_size];
    free(my_image);
    magick_wand = DestroyMagickWand(magick_wand);
    MagickWandTerminus();
    
    NSLog(@"Final format: %@",[self mimeTypeByGuessingFromData:data]);
    
    UIImage *image = [[UIImage alloc] initWithData:data];
    
    return image;

    
    // [imageViewButton setImage:image forState:UIControlStateNormal];
}
 
 */

+ (NSString *)mimeTypeByGuessingFromData:(NSData *)data {
    
    char bytes[12] = {0};
    [data getBytes:&bytes length:12];
    
    const char bmp[2] = {'B', 'M'};
    const char gif[3] = {'G', 'I', 'F'};
    const char swf[3] = {'F', 'W', 'S'};
    const char swc[3] = {'C', 'W', 'S'};
    const char jpg[3] = {0xff, 0xd8, 0xff};
    const char psd[4] = {'8', 'B', 'P', 'S'};
    const char iff[4] = {'F', 'O', 'R', 'M'};
    const char webp[4] = {'R', 'I', 'F', 'F'};
    const char ico[4] = {0x00, 0x00, 0x01, 0x00};
    const char tif_ii[4] = {'I','I', 0x2A, 0x00};
    const char tif_mm[4] = {'M','M', 0x00, 0x2A};
    const char png[8] = {0x89, 0x50, 0x4e, 0x47, 0x0d, 0x0a, 0x1a, 0x0a};
    const char jp2[12] = {0x00, 0x00, 0x00, 0x0c, 0x6a, 0x50, 0x20, 0x20, 0x0d, 0x0a, 0x87, 0x0a};
    
    
    if (!memcmp(bytes, bmp, 2)) {
        return @"image/x-ms-bmp";
    } else if (!memcmp(bytes, gif, 3)) {
        return @"image/gif";
    } else if (!memcmp(bytes, jpg, 3)) {
        return @"image/jpeg";
    } else if (!memcmp(bytes, psd, 4)) {
        return @"image/psd";
    } else if (!memcmp(bytes, iff, 4)) {
        return @"image/iff";
    } else if (!memcmp(bytes, webp, 4)) {
        return @"image/webp";
    } else if (!memcmp(bytes, ico, 4)) {
        return @"image/vnd.microsoft.icon";
    } else if (!memcmp(bytes, tif_ii, 4) || !memcmp(bytes, tif_mm, 4)) {
        return @"image/tiff";
    } else if (!memcmp(bytes, png, 8)) {
        return @"image/png";
    } else if (!memcmp(bytes, jp2, 12)) {
        return @"image/jp2";
    }
    
    return @"application/octet-stream"; // default type
    
}



/*
 If you want to use the default progress monitor which writes progress to stdout, simply add -monitor to your argv[] array. If you want a custom moniter, call SetImageInfoProgressMonitor() before ConvertImageCommand(). You can pass any data you want as the final parameter and access it with your custom monitor method. The method has this signature:
 
 MagickBooleanType MonitorProgress(const char *text,const MagickOffsetType offset,const MagickSizeType extent,void *client_data)
 It is called by ImageMagick periodically. Progress is measured by the offset end extent value (e.g. 35 out of 100). The text tells the what operation is in progress (e.g. resizing). You can halt progress by returning MagickFalse or continue progress by returning MagickTrue.
 */

@end