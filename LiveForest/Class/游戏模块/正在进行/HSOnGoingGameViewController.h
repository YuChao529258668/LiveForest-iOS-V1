//
//  HSOnGoingGameViewController.h
//  LiveForest
//
//  Created by 钱梦颖 on 15/9/9.
//  Copyright (c) 2015年 HOTeam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSRequestDataController.h"
@interface HSOnGoingGameViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *onGoingDetailLabel;
@property(nonatomic,strong)HSRequestDataController *requestDataCtrl;

- (IBAction)continueGameButtonClicked:(id)sender;

@end
