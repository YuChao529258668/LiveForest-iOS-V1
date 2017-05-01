//
//  AppDelegate.h
//  LiveForest
//
//  Created by 微光 on 15/4/10.
//  Copyright (c) 2015年 HOTeam. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "HSTabBarController.h"
#import "SingletonForRootViewCtrl.h"
#import "DoubleBounceView.h"
#import "Macros.h"
#import "HSLoginViewController.h"
#import <HealthKit/HealthKit.h>
//百度地图
#import <Baidu-Maps-iOS-SDK/BMapKit.h>

//TUSDK
#import <TuSDK/TuSDK.h>
#import "ImageTipLabel.h"

//蒲公英
#import <PgySDK/PgyManager.h>

//友盟推送by qiang on 6.23
#import "UMessage.h"

#import "HSRequestDataController.h"

#import "HSDataFormatHandle.h"

#import "Reachability.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,BMKGeneralDelegate>{
    Reachability  *hostReach;
}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) HSLoginViewController *loginVC;
@property (strong,nonatomic) AFHTTPRequestOperationManager *manager;

@property (strong, nonatomic) BMKMapManager *mapManager;

//标签系统
@property (strong, nonatomic) UIImage *imageOfTuSDK;
@property (nonatomic) CGRect frameOfImageOfTuSDK;
@property (strong, nonatomic) UITextField *tagTextField;
@property (strong, nonatomic) UIImage *resultImage;
@property (strong, nonatomic) UIImage *inputImage;
@property (strong, nonatomic) TuSDKResult *result;
@property (strong, nonatomic) ImageTipLabel *imageTipLabel;
@property (strong, nonatomic) UIImage *imageWithLabels;

//网络请求
@property (nonatomic, strong) HSRequestDataController *requestCtrl;

//友盟推送消息
@property (nonatomic, strong) NSDictionary *userInfo;
@property (nonatomic, strong) NSString *pushMessageLanuchApp; //作为判断是否是推送唤起了应用

@end

