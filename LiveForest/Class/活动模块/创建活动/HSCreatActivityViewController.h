//
//  HSCreatActivityViewController.h
//  LiveForest
//
//  Created by Swift on 15/4/17.
//  Copyright (c) 2015年 HOTeam. All rights reserved.
//

#import <QiniuSDK.h>

#import <JSONKit-NoWarning/JSONKit.h>
#import <AFNetworking/AFNetworking.h>

#import <TuSDK/TuSDK.h>
#import <UIKit/UIKit.h>

#import "Macros.h"

#import "HSCreateView.h"

//后台请求规范法
#import "HSRequestDataController.h"

//TuSDKPFEditTurnAndCutDelegate
@interface HSCreatActivityViewController : TuSDKICViewController <TuSDKPFCameraDelegate, TuSDKFilterManagerDelegate>
{
    // 自定义系统相册组件
    TuSDKCPAlbumComponent *_albumComponent;
    // 头像设置组件
    TuSDKCPAvatarComponent *_avatarComponent;
    // 图片编辑组件
    TuSDKCPPhotoEditComponent *_photoEditComponent;

}

@property (nonatomic,strong) NSString *imageURL;
@property (strong,nonatomic) AFHTTPRequestOperationManager *manager;
@property (strong, nonatomic) HSCreateView *createView;

@property (strong,nonatomic) HSRequestDataController *requestCtrl;

@end
