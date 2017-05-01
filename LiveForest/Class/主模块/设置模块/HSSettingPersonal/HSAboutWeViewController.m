//
//  HSAboutWeViewController.m
//  LiveForest
//
//  Created by wangfei on 7/22/15.
//  Copyright (c) 2015 HOTeam. All rights reserved.
//

#import "HSAboutWeViewController.h"

@interface HSAboutWeViewController ()
@property (weak, nonatomic) IBOutlet UILabel *appNameVersion;

@end

@implementation HSAboutWeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSDictionary *dict = [[NSBundle mainBundle] infoDictionary];
    NSLog(@"%@",dict);
    NSString *appName = dict[@"CFBundleName"];
    NSString *shortVersion = dict[@"CFBundleShortVersionString"];
    
    self.appNameVersion.text = [NSString stringWithFormat:@"%@ v%@",appName,shortVersion];
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
