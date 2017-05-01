//
//  HSInviteFriendsView.h
//  LiveForest
//
//  Created by 傲男 on 15/7/8.
//  Copyright (c) 2015年 HOTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

//shimmer
#import <FBShimmeringView.h>

//我的邀请view
#import "HSMyInviteHistoryView.h"

#import "HSConstLayout.h"

@interface HSInviteFriendsView : UIView

@property (strong, nonatomic) FBShimmeringView *shimmeringView;
@property (strong, nonatomic) IBOutlet UIImageView *topImage;
@property (strong, nonatomic) IBOutlet UIImageView *reflectedImage;
@property (strong, nonatomic) UIButton *clickYueBanBtn;
@property (strong, nonatomic) UILabel *yueBanDescriptionLabel;


@property (strong, nonatomic) IBOutlet UISwitch *isFriendsBtn;

@property (strong, nonatomic) IBOutlet UILabel *isFriendsLabel;

@property (strong, nonatomic) IBOutlet UIButton *historyBtn;
@property (strong, nonatomic) IBOutlet UILabel *historyLabel;

@property (strong, nonatomic) HSMyInviteHistoryView *myInviteHistoryView;
@end
