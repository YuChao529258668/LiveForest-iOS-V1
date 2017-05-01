//
//  HSGameProcessViewController.h
//  LiveForest
//
//  Created by 钱梦颖 on 15/9/9.
//  Copyright (c) 2015年 HOTeam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSRequestDataController.h"
@interface HSGameProcessViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *energyLabel;
@property (weak, nonatomic) IBOutlet UILabel *activityLabel;
@property (weak, nonatomic) IBOutlet UIImageView *planetImageView;
@property (weak, nonatomic) IBOutlet UILabel *planetLabel;

@property(strong,nonatomic)HSRequestDataController *requestDataCtrl;
//@property (weak, nonatomic) IBOutlet UIButton *lookDetailButtonClicked;


@property(nonatomic,copy)NSString *energyNumber;
@property(nonatomic,copy)NSString *activityNumber;
@end
