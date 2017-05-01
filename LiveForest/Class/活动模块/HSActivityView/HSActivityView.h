//
//  HSActivityView.h
//  LiveForest
//
//  Created by 微光 on 15/4/25.
//  Copyright (c) 2015年 HOTeam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBShimmeringView.h"
@interface HSActivityView : UIView
@property (strong, nonatomic) IBOutlet UIButton *createActivity;
@property (strong, nonatomic) IBOutlet UIButton *findActivity;
@property (strong, nonatomic) IBOutlet UIButton *NotiBtn;
@property (strong, nonatomic) IBOutlet UIImageView *topImage;
@property (strong, nonatomic) IBOutlet UIImageView *reflectedImage;
@property (strong, nonatomic) IBOutlet UILabel *activityName;
@property (strong, nonatomic) IBOutlet UILabel *publisherName;
@property (strong, nonatomic) IBOutlet UILabel *locationDescription;

@property (strong, nonatomic) FBShimmeringView* shimmeringView;
@end
