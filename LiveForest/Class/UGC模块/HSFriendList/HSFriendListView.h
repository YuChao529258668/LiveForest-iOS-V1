//
//  HSFriendListView.h
//  LiveForest
//
//  Created by apple on 15/7/9.
//  Copyright (c) 2015年 HOTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSFriendListView : UIView

/*展示具体的用户列表*/
@property (strong, nonatomic) IBOutlet UITableView *tableView;  //不能使weak

/*回退箭头按钮*/
@property (strong, nonatomic) IBOutlet UIImageView *imageBack;

/*显示当前的列表名*/
@property (weak, nonatomic) IBOutlet UILabel *label_ListName;


/*指向当前的父UIViewController*/
@property(retain,nonatomic) UIViewController* parentViewController;


@end
