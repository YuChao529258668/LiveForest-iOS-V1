//
//  HSIndexView.h
//  LiveForest
//
//  Created by 微光 on 15/4/24.
//  Copyright (c) 2015年 HOTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

//shimmer by qiang on 5.14
#import <FBShimmeringView.h>

@interface HSIndexView : UIView
@property (strong, nonatomic) IBOutlet UIImageView *topImage;
@property (strong, nonatomic) IBOutlet UIImageView *reflectedImage;
@property (strong, nonatomic) IBOutlet UIButton *shareBtn;
@property (strong, nonatomic) IBOutlet UIButton *treatureBtn;
@property (strong, nonatomic) IBOutlet UIButton *NotiBtn;

@property (strong, nonatomic) FBShimmeringView *shimmeringView;
@end
