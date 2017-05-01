//
//  HSFriendListViewControllerTableViewController.h
//  LiveForest
//
//  Created by apple on 15/7/7.
//  Copyright (c) 2015年 HOTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HSFriendListViewCell.h"
#import "HSFriendListView.h"

//引入好友界面
#import "HSVisitMineController.h"

//引入数据操作
#import "HSRequestDataController.h"
#import "HSDataFormatHandle.h"
#import "MBProgressHUD.h"

//UITableViewController默认实现了两个Protocol
@interface HSFriendListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

- (instancetype)initWithParameter:(BOOL)isFans;

- (instancetype)initWithParameter:(BOOL)isFans withFriend:(NSString*)user_id_by_friend;

@end
