//
//  HSFrientListViewCell.h
//  LiveForest
//
//  Created by apple on 15/7/8.
//  Copyright (c) 2015年 HOTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSFriendListViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *imageview_avatar;
@property (strong, nonatomic) IBOutlet UILabel *label_username;
@property (strong, nonatomic) IBOutlet UIImageView *imageview_sex;
@property (strong, nonatomic) IBOutlet UILabel *label_age;

@end
