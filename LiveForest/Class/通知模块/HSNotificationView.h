//
//  HSNotificationView.h
//  LiveForest
//
//  Created by 微光 on 15/4/28.
//  Copyright (c) 2015年 HOTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSNotificationView : UIView

@property (strong, nonatomic) IBOutlet UIView *notiView;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) UIImageView *backGroundView;

@property (strong, nonatomic) UIButton *backBtn;
@end
