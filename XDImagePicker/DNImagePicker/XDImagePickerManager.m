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

@interface XDImagePickerManager() <DNImagePickerControllerDelegate>

@property(nonatomic, weak) UIViewController *fromController;

@property (nonatomic, copy) CompletionBlock completionBlock;

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

- (void)showImagePickerFromController:(UIViewController *)fromController completionBlock:(CompletionBlock)completionBlock {
    
    self.fromController = fromController;
    self.completionBlock = completionBlock;
    
    if ([self isPhotoLibraryAvailable]) {
        DNImagePickerController *imagePicker = [[DNImagePickerController alloc] init];
        imagePicker.imagePickerDelegate = self;
        [self.fromController presentViewController:imagePicker animated:YES completion:nil];
    }
    
    
}

#pragma mark DNImagePickerControllerDelegate
- (void)dnImagePickerController:(DNImagePickerController *)imagePicker
                     sendImages:(NSArray *)imageAssets
                    isFullImage:(BOOL)fullImage {
    
    // TODO 获取到选择的图片数组
    NSLog(@"%@", imageAssets);
    
}

- (void)dnImagePickerControllerDidCancel:(DNImagePickerController *)imagePicker {
    [imagePicker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark 判断手机是否有权限
- (BOOL)isPhotoLibraryAvailable {
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary];
}

@end
