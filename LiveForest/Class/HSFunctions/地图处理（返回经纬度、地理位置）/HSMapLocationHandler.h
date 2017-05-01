//
//  HSMapLocationHandler.h
//  LiveForest
//
//  Created by 傲男 on 15/7/5.
//  Copyright (c) 2015年 HOTeam. All rights reserved.
//

#import <Foundation/Foundation.h>

//头文件
#import <Baidu-Maps-iOS-SDK/BMapKit.h>

@interface HSMapLocationHandler : UIViewController<BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate>

//百度地图
@property (nonatomic, strong) BMKLocationService *locService;
@property (nonatomic, strong) BMKGeoCodeSearch *geoCodeSearch;
@property (nonatomic, strong) BMKReverseGeoCodeOption *reverseGeoSearchOption;

//获取地理位置
- (void)getLocation;

@end
