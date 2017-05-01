//
//  HSImageResultController.m
//  LiveForest
//
//  Created by Swift on 15/6/2.
//  Copyright (c) 2015年 HOTeam. All rights reserved.
//

#import "HSImageResultController.h"

@interface HSImageResultController ()

@end

@implementation HSImageResultController
- (instancetype)init {
    if (self=[super init]) {
        UIImageView *iv=[[UIImageView alloc]initWithImage:self.inputImage];
        //    [UIScreen mainScreen
        UIWindow *w= [[UIApplication sharedApplication]keyWindow];
        [w addSubview:iv];

    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIImageView *iv=[[UIImageView alloc]initWithImage:self.inputImage];
//    [UIScreen mainScreen
    UIWindow *w= [[UIApplication sharedApplication]keyWindow];
    [w addSubview:iv];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
