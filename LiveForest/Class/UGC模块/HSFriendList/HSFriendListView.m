//
//  HSFriendListView.m
//  LiveForest
//
//  Created by apple on 15/7/9.
//  Copyright (c) 2015年 HOTeam. All rights reserved.
//

#import "HSFriendListView.h"
#import "HSFriendListViewCell.h"
@implementation HSFriendListView

@synthesize tableView;
@synthesize parentViewController;

#pragma mark - View Lifecycle

#pragma mark Override initWithFrame: ,从Xib文件中加载当前视图

- (instancetype)init{
    NSLog(@"HSFriendListView-initWithFrame");
    
    //从关联的Xib文件中加载本视图
    NSArray* nibView =  [[NSBundle mainBundle]
                         loadNibNamed:@"HSFriendListView" owner:self options:nil];
    
    self = nibView[0];

    //对当前的View进行控制
    if (self) {
        //添加对于返回按钮的监听事件
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageBackTapped:)];
        tapGestureRecognizer.numberOfTapsRequired = 1;
        [self.imageBack addGestureRecognizer:tapGestureRecognizer];
        self.imageBack.userInteractionEnabled = YES;

    }
    
    return self;
}


#pragma mark - User Interaction

- (void)imageBackTapped:(id)sender{
    
    [self.parentViewController dismissViewControllerAnimated:YES completion:^{
        NSLog(@"Back From HSFriendListView");
    }];
    
}

@end
