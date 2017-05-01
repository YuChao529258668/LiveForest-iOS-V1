//
//  HSNotificationViewController.h
//  LiveForest
//
//  Created by 傲男 on 15/7/17.
//  Copyright (c) 2015年 HOTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HSNotificationView.h"

#import "HSOfficialViewController.h"

@interface HSNotificationViewController : UITableViewController

@property (nonatomic, strong) HSNotificationView *notificationView;

@property (nonatomic, strong) NSMutableArray *notiArray;

@property (nonatomic, strong) HSOfficialViewController *offVC;

@end
