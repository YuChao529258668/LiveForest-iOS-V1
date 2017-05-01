//
//  HSSettingViewController.h
//  LiveForest
//
//  Created by Swift on 15/5/10.
//  Copyright (c) 2015年 HOTeam. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "UMFeedback.h"//友盟反馈
#import <PgySDK/PgyManager.h>//蒲公英反馈
#import "HSUserInfoHandler.h"

#import "HSQRDisplayVC.h"

#import "QRViewController.h"

@interface HSSettingViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) HSUserInfoHandler *userInfoControl;

@property (nonatomic, strong) QRViewController *qrVC;

- (float)getSettingViewHeight ;

@end
