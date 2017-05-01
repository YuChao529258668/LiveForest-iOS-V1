//
//  HSQRDisplayVC.h
//  LiveForest
//
//  Created by 傲男 on 15/7/13.
//  Copyright (c) 2015年 HOTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HSInviteFriendQRController.h"

#import "HSConstLayout.h"

#import "HSUserInfoHandler.h"

#import "HSRequestDataController.h"

@interface HSQRDisplayVC : UIViewController<UIGestureRecognizerDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *qrImage;
@property (strong, nonatomic) IBOutlet UIImageView *avatarImg;
@property (strong, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (strong, nonatomic) IBOutlet UIImageView *sexImg;

@property (nonatomic, strong) HSUserInfoHandler *userInfoControl;
@property (nonatomic, strong) HSRequestDataController *requestDataCtrl;

@end
