//
//  ViewController.m
//  XDImagePicker
//
//  Created by YingshanDeng on 2017/4/1.
//  Copyright © 2017年 YingshanDeng. All rights reserved.
//

#import "ViewController.h"
#import "XDImagePickerManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.frame = CGRectMake(100, 100, 200, 60);
    [btn setTitle:@"click me" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)btnClick:(UIButton *)sender {
    [[XDImagePickerManager shareInstance] showImagePickerFromController:self completionBlock:^(NSMutableArray *imageAssetArray) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
