//
//  ImageProcessor.m
//  MobileCloud
//
//  Created by Matt Zhu on 3/23/16.
//  Copyright © 2016 DHM. All rights reserved.
//

#import "ImageProcessor.h"

@implementation ImageProcessor : NSObject

+ (UIImage*) createPosterizeImage:(CGImageRef)srcCGImage {
//    MagickWandGenesis();
//    magick_wand = NewMagickWand();
//    UIImage *src = [UIImage imageNamed:@"mirage"];
//    ConvertImageCommand(<#ImageInfo *#>, <#int#>, <#char **#>, <#char **#>, <#MagickExceptionInfo *#>)
    
    MagickWandGenesis();
    MagickWand *wand = NewMagickWand();
    NSData *data = UIImagePNGRepresentation([UIImage imageNamed:@"mirage"]);
    MagickReadImageBlob(wand, [data bytes], [data length]);
    
//    MagickBooleanType = status;
    
    MagickBooleanType status = MagickPosterizeImage(wand,6,MagickFalse);
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


- (void)convertImage {
    MagickWandGenesis();
    magick_wand = NewMagickWand();
    //UIImageJPEGRepresentation([imageViewButton imageForState:UIControlStateNormal], 90);
    NSData * dataObject = UIImagePNGRepresentation([UIImage imageNamed:@"mirage"]);
    
    MagickBooleanType status;
    status = MagickReadImageBlob(magick_wand, [dataObject bytes], [dataObject length]);
    
    if (status == MagickFalse) {
//        ThrowWandException(magick_wand);
    }
    
    // Get image from bundle.
    const char *input_image = [[[NSBundle mainBundle] pathForResource:@"mirage" ofType:@"png"] UTF8String];
    const char *output_image = [[[NSBundle mainBundle] pathForResource:@"mirage" ofType:@"png"] UTF8String];
    
    const char *argv[] = { "convert", input_image, "-resize", "100x100", output_image, NULL };
    // ConvertImageCommand(ImageInfo *, int, char **, char **, MagickExceptionInfo *);
    status = ConvertImageCommand(AcquireImageInfo(), 4, (char**)argv, NULL, AcquireExceptionInfo());
    
    if (status == MagickFalse) {
//        ThrowWandException(magick_wand);
    }
    
    size_t my_size;
    unsigned char * my_image = MagickGetImageBlob(magick_wand, &my_size);
    NSData * data = [[NSData alloc] initWithBytes:my_image length:my_size];
    free(my_image);
    magick_wand = DestroyMagickWand(magick_wand);
    MagickWandTerminus();
    UIImage *image = [[UIImage alloc] initWithData:data];
    
    // [imageViewButton setImage:image forState:UIControlStateNormal];
}



/*
 If you want to use the default progress monitor which writes progress to stdout, simply add -monitor to your argv[] array. If you want a custom moniter, call SetImageInfoProgressMonitor() before ConvertImageCommand(). You can pass any data you want as the final parameter and access it with your custom monitor method. The method has this signature:
 
 MagickBooleanType MonitorProgress(const char *text,const MagickOffsetType offset,const MagickSizeType extent,void *client_data)
 It is called by ImageMagick periodically. Progress is measured by the offset end extent value (e.g. 35 out of 100). The text tells the what operation is in progress (e.g. resizing). You can halt progress by returning MagickFalse or continue progress by returning MagickTrue.
 */

@end