//
//  XDImagePickerManager.h
//  XDImagePicker
//
//  Created by YingshanDeng on 2017/4/1.
//  Copyright © 2017年 YingshanDeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

typedef void (^CompletionBlock)(NSArray *imageURLArray);

@interface XDImagePickerManager : NSObject

+ (instancetype)shareInstance;

- (void)showImagePickerFromController:(UIViewController *)fromController
                         widthOptions:(NSDictionary *)options
                      completionBlock:(CompletionBlock)completionBlock;
@end
