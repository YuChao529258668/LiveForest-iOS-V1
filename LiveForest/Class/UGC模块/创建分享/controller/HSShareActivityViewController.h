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

#import "HSShareView.h"

#import "HSRequestDataController.h"

//头文件
#import <Baidu-Maps-iOS-SDK/BMapKit.h>

#import "HSUserInfoHandler.h"

//获取地理位置
#import "HSMapLocationHandler.h"

#import "HSDataFormatHandle.h"

//菊花加载 on 7.30 
#import "MBProgressHUD.h"

//TuSDKPFEditTurnAndCutDelegate
@interface HSShareActivityViewController : TuSDKICViewController <TuSDKPFCameraDelegate, UIActionSheetDelegate, TuSDKFilterManagerDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate,TuSDKPFStickerViewDelegate>
{
    // 自定义系统相册组件
//    TuSDKCPAlbumComponent *_albumComponent;
    // 头像设置组件
    TuSDKCPAvatarComponent *_avatarComponent;
    // 图片编辑组件
    TuSDKCPPhotoEditComponent *_photoEditComponent;
    
    
    //6.1
    // 自定义系统相册组件
    TuSDKCPAlbumComponent *_albumComponent;
    // 多功能图片编辑组件
    TuSDKCPPhotoEditMultipleComponent *_photoEditMultipleComponent;

//    图片的数组下标
    int arr_index;

    //省
    NSString *province;
    //市
    NSString *city;
    //区
    NSString *district;
    //经度
    NSString *longitude;
    //纬度
    NSString *latitude;
    //位置
    NSString *location;
}

@property (nonatomic,strong) NSString *imageURL;
@property (strong,nonatomic) AFHTTPRequestOperationManager *manager;
@property (strong, nonatomic) HSShareView *shView;

//请求数据
@property (nonatomic, strong) HSRequestDataController *requestDataCtrl;

//百度地图
@property (nonatomic, strong) BMKLocationService *locService;
@property (nonatomic, strong) BMKGeoCodeSearch *geoCodeSearch;
@property (nonatomic, strong) BMKReverseGeoCodeOption *reverseGeoSearchOption;

@property (nonatomic, strong) HSUserInfoHandler *userInfoControl;

@end
