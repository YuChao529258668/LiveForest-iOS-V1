//
//  mapViewController.h
//  LiveForest
//
//  Created by 傲男 on 15/6/18.
//  Copyright (c) 2015年 HOTeam. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Baidu-Maps-iOS-SDK/BMapKit.h>

#import "Macros.h"

@interface mapViewController : UIViewController<BMKMapViewDelegate,BMKLocationServiceDelegate,UITextFieldDelegate,BMKSuggestionSearchDelegate,UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,BMKGeoCodeSearchDelegate>

@property (nonatomic, strong) BMKMapView *mapView;
@property (nonatomic, strong) BMKLocationService *locService;
@property (nonatomic, strong) BMKSuggestionSearch *suggestionSearch;
@property (nonatomic, strong) BMKGeoCodeSearch *geoCodeSearch;
@property (nonatomic, strong) BMKGeoCodeSearchOption *geoSearchOption;
@property (nonatomic, strong) UIButton *searchBtn;
@property (nonatomic, strong) UIButton *cancerBtn;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UITableView *plainTableView;
@property (nonatomic, strong) BMKSuggestionSearchOption *searchOption;
@property (nonatomic, strong) NSMutableArray *suggestionResult;
@property (nonatomic, strong) BMKPointAnnotation *pointAnnotation;
@property (nonatomic, strong) UIButton *myLocationBtn;
@property (nonatomic, assign) CLLocationCoordinate2D activityCoordinate;
@property (nonatomic, strong) BMKReverseGeoCodeOption *reverseSearchOption;


@end
