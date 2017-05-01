//
//  HSHandleMapLocation.h
//  LiveForest
//
//  Created by 傲男 on 15/6/26.
//  Copyright (c) 2015年 HOTeam. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Baidu-Maps-iOS-SDK/BMapKit.h>

@interface HSHandleMapLocation : NSObject

//@property (nonatomic, strong)BMKReverseGeoCodeResult *result ;
//百度地图
@property (nonatomic, strong) BMKLocationService *locService;
@property (nonatomic, strong) BMKGeoCodeSearch *geoCodeSearch;
@property (nonatomic, strong) BMKReverseGeoCodeOption *reverseGeoSearchOption;
@end
