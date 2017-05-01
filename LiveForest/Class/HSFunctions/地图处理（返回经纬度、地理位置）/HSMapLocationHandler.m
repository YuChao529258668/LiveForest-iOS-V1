//
//  HSMapLocationHandler.m
//  LiveForest
//
//  Created by 傲男 on 15/7/5.
//  Copyright (c) 2015年 HOTeam. All rights reserved.
//

#import "HSMapLocationHandler.h"

@implementation HSMapLocationHandler

- (instancetype)init{
    self = [super init];
    
    if(self){
        //地理位置
        _locService = [[BMKLocationService alloc] init];
        _locService.delegate = self;
        
        _geoCodeSearch = [[BMKGeoCodeSearch alloc] init];
        _geoCodeSearch.delegate = self;
        
        _reverseGeoSearchOption = [[BMKReverseGeoCodeOption alloc] init];
    }
    
    return self;
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    _locService.delegate = nil;
    _geoCodeSearch.delegate = nil;
}

//定位

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _locService.delegate = self;
}

- (void)getLocation {
    //设置定位精确度
    [BMKLocationService setLocationDesiredAccuracy:kCLLocationAccuracyBest];
    //指定最小距离更新(米)
    [BMKLocationService setLocationDistanceFilter:kCLDistanceFilterNone];
    //启动LocationService
    [_locService startUserLocationService];
}


/**
 *用户方向更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation {

}

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation {
    _reverseGeoSearchOption.reverseGeoPoint = userLocation.location.coordinate;
    BOOL flag = [_geoCodeSearch reverseGeoCode:_reverseGeoSearchOption];
    if (NO == flag) {
        NSLog(@"reverseGeoCodeSearch failed");
    }
    [_locService stopUserLocationService];
}

- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error {
    //省
    NSString *province = [NSString stringWithString:result.addressDetail.province];
    //市
    NSString *city = [NSString stringWithString:result.addressDetail.city];
    //区
    NSString *district = [NSString stringWithString:result.addressDetail.district];
    //经度
    NSString *longitude = [NSString stringWithFormat:@"%f",result.location.longitude];
    //纬度
    NSString *latitude = [NSString stringWithFormat:@"%f",result.location.latitude];
    //位置
    NSString *location = [NSString stringWithString:result.address];
    NSLog(@"location:%@",location);
}

/**
 *定位失败后，会调用此函数
 *@param error 错误号
 */
- (void)didFailToLocateUserWithError:(NSError *)error {
    NSLog(@"baidu map location failed error:%@",error);
}


@end
