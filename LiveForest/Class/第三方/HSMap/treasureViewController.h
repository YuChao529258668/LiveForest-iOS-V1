//
//  treasureViewController.h
//  treasure
//
//  Created by apple on 15/4/18.
//  Copyright (c) 2015年 hoteam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Baidu-Maps-iOS-SDK/BMapKit.h>

@interface treasureViewController : UIViewController<BMKMapViewDelegate, BMKLocationServiceDelegate ,BMKPoiSearchDelegate ,BMKRouteSearchDelegate, BMKGeoCodeSearchDelegate>
@property (strong, nonatomic) BMKMapView *mapView;
@property (strong, nonatomic) BMKLocationService *locService;
@property (strong, nonatomic) BMKPoiSearch *poisearch;
@property (strong, nonatomic) BMKRouteSearch *routesearch;
@property (strong, nonatomic) BMKGeoCodeSearch *geocodesearch;


@property (assign, nonatomic) CLLocationCoordinate2D userLocation;
@property (assign, nonatomic) CLLocationCoordinate2D targetLocation;
@property (strong, nonatomic) NSArray* poiInfoList;
@property (strong, nonatomic) BMKReverseGeoCodeResult *geoReverseResult;
@property (assign, nonatomic) int size;



@property (strong, nonatomic) UIButton *mapBtnStart;
@property (strong, nonatomic) UIButton *mapBtnReset;
@property (strong, nonatomic) UIButton *mapBtnEnd;
@property (strong, nonatomic) UIButton *mapBtnFinish;

@end
