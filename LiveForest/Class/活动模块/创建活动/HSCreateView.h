//
//  HSShareView.h
//  LiveForest
//
//  Created by 微光 on 15/4/27.
//  Copyright (c) 2015年 HOTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSCreateView : UIView
@property (strong, nonatomic) IBOutlet UIView *createView;

@property (strong, nonatomic) IBOutlet UIButton *shareBtn;

@property (strong, nonatomic) IBOutlet UIButton *albumBtn;

@property (strong, nonatomic) IBOutlet UIButton *cameraBtn;

@property (strong, nonatomic) IBOutlet UIImageView *firstImageVIew;

@property (strong, nonatomic) IBOutlet UIImageView *avarlImage;
@property (strong, nonatomic) IBOutlet UILabel *mapLabel;

@property (strong, nonatomic) IBOutlet UITextField *activityTitle;
@property (strong, nonatomic) IBOutlet UITextView *activityDescription;
@property (strong, nonatomic) IBOutlet UIButton *mapBtn;
@property (strong, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UIImageView *bottomBarImage;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIButton *timeBtn;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (strong, nonatomic) IBOutlet UITextField *activityKind;//todo:只有5sxib

@end
