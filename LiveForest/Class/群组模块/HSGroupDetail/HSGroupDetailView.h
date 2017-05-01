//
//  HSGroupDetailView.h
//  LiveForest
//
//  Created by 微光 on 15/5/11.
//  Copyright (c) 2015年 HOTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSGroupDetailView : UIView

@property (strong, nonatomic) IBOutlet UIImageView *topImage;

@property (strong, nonatomic) IBOutlet UIImageView *reflectedImage;

@property (strong, nonatomic) IBOutlet UIButton *backBtn;

@property (strong, nonatomic) IBOutlet UIButton *chatBtn;

@property (strong, nonatomic) IBOutlet UIButton *joinBtn;

@property (assign, nonatomic) BOOL hasJoin;

@end
