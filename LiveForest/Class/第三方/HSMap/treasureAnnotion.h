//
//  treasureAnnotion.h
//  treasure
//
//  Created by apple on 15/4/18.
//  Copyright (c) 2015年 hoteam. All rights reserved.
//
#import <Baidu-Maps-iOS-SDK/BMapKit.h>
#import <Baidu-Maps-iOS-SDK/BMKAnnotation.h>
#import <Baidu-Maps-iOS-SDK/BMKAnnotationView.h>

@interface treasureAnnotion : BMKPinAnnotationView<BMKAnnotation>
///该点的坐标
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (strong, nonatomic) NSString *title;
@end