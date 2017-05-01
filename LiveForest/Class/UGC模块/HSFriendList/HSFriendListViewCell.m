//
//  HSFrientListViewCell.m
//  LiveForest
//
//  Created by apple on 15/7/8.
//  Copyright (c) 2015年 HOTeam. All rights reserved.
//

#import "HSFriendListViewCell.h"

@implementation HSFriendListViewCell

@synthesize imageview_avatar;
@synthesize label_username;
@synthesize imageview_sex;
@synthesize label_age;

#pragma View Lifecycle

- (void)awakeFromNib {
    // Initialization code
    
    //配置头像imageView
    imageview_avatar.contentMode=UIViewContentModeScaleAspectFit;
//    imageview_avatar.layer.masksToBounds =YES;
    imageview_avatar.layer.cornerRadius =imageview_avatar.frame.size.height/2;
    imageview_avatar.clipsToBounds = YES;
}

#pragma mark - Internal Helpers

@end
