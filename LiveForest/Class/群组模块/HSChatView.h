//
//  HSChatView.h
//  LiveForest
//
//  Created by 微光 on 15/4/25.
//  Copyright (c) 2015年 HOTeam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FBShimmeringView.h>

@interface HSChatView : UIView
@property (strong, nonatomic) IBOutlet UIImageView *topImage;
@property (strong, nonatomic) IBOutlet UIImageView *reflectedImage;

@property (strong, nonatomic) FBShimmeringView *shimmeringView;
@end
