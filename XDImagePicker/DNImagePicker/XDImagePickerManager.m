//
//  XDImagePickerManager.m
//  XDImagePicker
//
//  Created by YingshanDeng on 2017/4/1.
//  Copyright © 2017年 YingshanDeng. All rights reserved.
//

#import "XDImagePickerManager.h"
#import "DNImagePickerController.h"
#import <AssetsLibrary/AssetsLibrary.h>

#define CDV_PHOTO_PREFIX @"cdv_photo_"

@interface XDImagePickerManager() <DNImagePickerControllerDelegate>

@property(nonatomic, weak) UIViewController *fromController;
@property(nonatomic, copy) CompletionBlock completionBlock;

@property(nonatomic, assign) NSInteger width;   // max width to allow the images to be
@property(nonatomic, assign) NSInteger height;  // max height to allow the images to be
@property(nonatomic, assign) NSInteger quality; // quality of resized image
@property(nonatomic, assign) NSInteger maximumImagesCount; // max images to be selected

@end

@implementation XDImagePickerManager

+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    static id shareInstance;
    dispatch_once(&onceToken, ^{
        shareInstance = [[XDImagePickerManager alloc] init];
    });
    return shareInstance;
}

- (void)showImagePickerFromController:(UIViewController *)fromController
                         widthOptions:(NSDictionary *)options
                      completionBlock:(CompletionBlock)completionBlock {
    
    self.fromController = fromController;
    self.completionBlock = completionBlock;
    
    self.width = [[options objectForKey:@"width"] integerValue];
    self.height = [[options objectForKey:@"height"] integerValue];
    self.quality = [[options objectForKey:@"quality"] integerValue];
    self.maximumImagesCount = [[options objectForKey:@"maximumImagesCount"] integerValue];
    
    if ([self isPhotoLibraryAvailable]) {
        DNImagePickerController *imagePicker = [[DNImagePickerController alloc] initWithMaximumImagesCount:self.maximumImagesCount];
        imagePicker.imagePickerDelegate = self;
        [self.fromController presentViewController:imagePicker animated:YES completion:nil];
    }
}

#pragma mark DNImagePickerControllerDelegate
- (void)dnImagePickerController:(DNImagePickerController *)imagePicker
                     sendImages:(NSArray *)imageAssets
                    isFullImage:(BOOL)fullImage {
    
    if (!imageAssets || !imageAssets.count) {
        return;
    }
    
    NSString *filePath;
    NSString *docsPath = [NSTemporaryDirectory() stringByStandardizingPath];
    NSFileManager* fileMgr = [[NSFileManager alloc] init];
    NSData *data = nil;
    NSError *error = nil;
    NSMutableArray *imgURLArray = [NSMutableArray array];
    for (ALAsset *asset in imageAssets) {
        
        int i = 1;
        do {
            filePath = [NSString stringWithFormat:@"%@/%@%03d.%@", docsPath, CDV_PHOTO_PREFIX, i++, @"jpg"];
        } while ([fileMgr fileExistsAtPath:filePath]);
        
        @autoreleasepool {
            ALAssetRepresentation *assetRep = [asset defaultRepresentation];
            CGImageRef imgRef = [assetRep fullScreenImage];
            
            UIImage* image = [UIImage imageWithCGImage:imgRef scale:1.0f orientation:UIImageOrientationUp];
            if (self.width == 0 && self.height == 0) {
                data = UIImageJPEGRepresentation(image, self.quality/100.0f);
            } else {
                UIImage* scaledImage = [self imageByScalingNotCroppingForSize:image toSize:CGSizeMake(self.width, self.height)];
                data = UIImageJPEGRepresentation(scaledImage, self.quality/100.0f);
            }
            
            if (![data writeToFile:filePath options:NSAtomicWrite error:&error]) {
                // error
                self.completionBlock(nil);
                break;
            } else {
                [imgURLArray addObject:@{@"image-path": [[NSURL fileURLWithPath:filePath] absoluteString],
                                        @"width": [NSNumber numberWithInteger:image.size.width],
                                        @"height": [NSNumber numberWithInteger:image.size.height]}];
            }
        }
    }
    // callback
    self.completionBlock(imgURLArray);
}

- (void)dnImagePickerControllerDidCancel:(DNImagePickerController *)imagePicker {
    [imagePicker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark helper methods
- (BOOL)isPhotoLibraryAvailable {
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary];
}

// 等比缩放图片到指定size
- (UIImage*)imageByScalingNotCroppingForSize:(UIImage*)anImage toSize:(CGSize)frameSize
{
    UIImage* sourceImage = anImage;
    UIImage* newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = frameSize.width;
    CGFloat targetHeight = frameSize.height;
    CGFloat scaleFactor = 0.0;
    CGSize scaledSize = frameSize;
    
    if (CGSizeEqualToSize(imageSize, frameSize) == NO) {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        // opposite comparison to imageByScalingAndCroppingForSize in order to contain the image within the given bounds
        if (widthFactor == 0.0) {
            scaleFactor = heightFactor;
        } else if (heightFactor == 0.0) {
            scaleFactor = widthFactor;
        } else if (widthFactor > heightFactor) {
            scaleFactor = heightFactor; // scale to fit height
        } else {
            scaleFactor = widthFactor; // scale to fit width
        }
        scaledSize = CGSizeMake(width * scaleFactor, height * scaleFactor);
    }
    
    UIGraphicsBeginImageContext(scaledSize); // this will resize
    
    [sourceImage drawInRect:CGRectMake(0, 0, scaledSize.width, scaledSize.height)];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if (newImage == nil) {
        NSLog(@"could not scale image");
    }
    
    // pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}

@end
