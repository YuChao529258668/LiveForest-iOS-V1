//
//  HSInfoCompletingVC.h
//  LiveForest
//
//  Created by 傲男 on 15/6/15.
//  Copyright (c) 2015年 HOTeam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TuSDK/TuSDK.h>
#import "HSInfoCompletingView.h"
#import "HSUserInfoHandler.h"

#import "Macros.h"
#import "HSRequestDataController.h"

#import "SingletonForRootViewCtrl.h"

#import "MBProgressHUD.h"

@interface HSInfoCompletingVC :  TuSDKICViewController <TuSDKPFCameraDelegate,TuSDKFilterManagerDelegate,UIActionSheetDelegate>
{
    // 自定义系统相册组件
    TuSDKCPAlbumComponent *_albumComponent;
    // 头像设置组件
    TuSDKCPAvatarComponent *_avatarComponent;
    // 图片编辑组件
    TuSDKCPPhotoEditComponent *_photoEditComponent;
    // 多功能图片编辑组件
    TuSDKCPPhotoEditMultipleComponent *_photoEditMultipleComponent;
}
@property (nonatomic,strong) NSString *imageURL; //用户选取头像的路径
@property (nonatomic,strong) NSString *globalImageURL; //用户已经有了头像路径，直接使用，除非 替换

@property (nonatomic, strong) HSInfoCompletingView* infoCompletingView;

@property (nonatomic, strong) HSUserInfoHandler *userInfoControl;
//请求数据
@property (nonatomic, strong) HSRequestDataController *requestDataCtrl;

@property (nonatomic, strong) NSDictionary *requestData ;
@end
