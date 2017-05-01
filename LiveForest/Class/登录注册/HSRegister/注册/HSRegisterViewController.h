//
//  HSRegisterViewController.h
//  LiveForest
//
//  Created by 微光 on 15/4/11.
//  Copyright (c) 2015年 HOTeam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JSONKit-NoWarning/JSONKit.h>
#import <AFNetworking/AFNetworking.h>
#import "Macros.h"

#import "HSPassValueToPersonalInfoCompletingDelegate.h"

#import "HSRequestDataController.h"

//信息补全页面
#import "HSInfoCompletingVC.h"

@interface HSRegisterViewController : UIViewController{
    
//    NSObject<UIViewPassValueDelegate> * passDelegate;
}
@property (strong, nonatomic) IBOutlet UITextField *password;

@property (strong,nonatomic) AFHTTPRequestOperationManager *manager;

//数据传输ByQiang on 6.25
@property(nonatomic, strong) NSObject<HSPassValueToPersonalInfoCompletingDelegate> *passValueDelegate;

@property (strong,nonatomic) HSRequestDataController *requestCtrl;

@property (strong, nonatomic) UIImageView *tmpImgView;

@property (strong, nonatomic) IBOutlet UIProgressView *progress1;
@property (strong, nonatomic) IBOutlet UIProgressView *progress2;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (strong, nonatomic) IBOutlet UIButton *weixinBtn;
@property (strong, nonatomic) IBOutlet UILabel *weixinLabel;
@property (strong, nonatomic) IBOutlet UIButton *weiboBtn;
@property (strong, nonatomic) IBOutlet UILabel *weiboxLabel;
@end
