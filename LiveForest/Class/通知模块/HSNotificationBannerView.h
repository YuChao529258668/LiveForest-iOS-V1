//
//  HSNotificationBannerView.h
//  LiveForest
//
//  Created by 傲男 on 15/9/2.
//  Copyright (c) 2015年 HOTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSNotificationBannerView : UIView
@property (strong, nonatomic) IBOutlet UIImageView *iconImageView;
@property (strong, nonatomic) IBOutlet UILabel *contentDescriptionLabel;
@property (strong, nonatomic) IBOutlet UILabel *detailContentDescriptionLabel;

@end
