//
//  HSLoadViewController.h
//  HotSNS
//
//  Created by Swift on 15/3/27.
//  Copyright (c) 2015年 余超. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CommonCrypto/CommonDigest.h>
#import "HSConstLayout.h"
#import "Macros.h"

#import <JSONKit-NoWarning/JSONKit.h>
#import <AFNetworking/AFNetworking.h>

#import "HSRequestDataController.h"

#import <QiniuSDK.h>
#import <SDWebImage/UIImageView+WebCache.h>

#import "HSUserInfoHandler.h"

//获取设备号
#import "HSUtilsVC.h"

//#import "HSPassValueToPersonalInfoCompletingDelegate.h"
#import "HSInfoCompletingVC.h"

@interface HSLoginViewController : UIViewController<UITextFieldDelegate>

@property (strong,nonatomic) AFHTTPRequestOperationManager *manager;

@property (strong,nonatomic) HSRequestDataController *requestCtrl;

//请求数据
//@property (nonatomic, strong) HSRequestDataController *requestDataCtrl;
@property (strong, nonatomic) UIImageView *tmpImgView;

//数据传输ByQiang on 6.25
//@property(nonatomic, strong) NSObject<HSPassValueToPersonalInfoCompletingDelegate> *passValueDelegate;
@property (strong, nonatomic) IBOutlet UIProgressView *progress1;
@property (strong, nonatomic) IBOutlet UIProgressView *progress2;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (strong, nonatomic) IBOutlet UIButton *weixinBtn;
@property (strong, nonatomic) IBOutlet UILabel *weixinLabel;
@property (strong, nonatomic) IBOutlet UIButton *weiboBtn;
@property (strong, nonatomic) IBOutlet UILabel *weiboxLabel;






@end
