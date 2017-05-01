//
//  treasureViewController.m
//  treasure
//
//  Created by apple on 15/4/18.
//  Copyright (c) 2015年 hoteam. All rights reserved.
//

#import "treasureViewController.h"
#import "treasureAnnotion.h"
#import "UIImage+Rotate.h"
#import "HSConstLayout.h"
/**
 *  百度地图图标资源加载
 */
#define MYBUNDLE_NAME @ "mapapi.bundle"
#define MYBUNDLE_PATH [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: MYBUNDLE_NAME]
#define MYBUNDLE [NSBundle bundleWithPath: MYBUNDLE_PATH]

/**
 *  百度地图 路径规划的标准类
 */
@interface RouteAnnotation : BMKPointAnnotation

@property (assign, nonatomic) int type;///<0:起点 1：终点 2：公交 3：地铁 4:驾乘 5:途经点
@property (assign, nonatomic) int degree;

@end

@implementation RouteAnnotation

@end


@interface treasureViewController ()
@property (strong, nonatomic) RouteAnnotation *targetAnnotation;
@end

@implementation treasureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // Do any additional setup after loading the view.
    _mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [_mapView setZoomLevel:17];
    [self.view addSubview: _mapView];
    
    //back按钮
    UIButton *back = [[UIButton alloc]initWithFrame:CGRectMake(10, 15, 50, 30)];
    back.backgroundColor = [UIColor blueColor];
    [back setTitle:@"Back" forState:UIControlStateNormal];
    [back addTarget:self action:@selector(backPress) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:back];
    //btnStart
    _mapBtnStart = [[UIButton alloc]initWithFrame:CGRectMake(10, 55, 100, 30)];
    _mapBtnStart.backgroundColor = [UIColor greenColor];
    [_mapBtnStart setTitle:@"开始寻宝" forState:UIControlStateNormal];
    [_mapBtnStart addTarget:self action:@selector(btnStart) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:_mapBtnStart];
    //btnReset
    _mapBtnReset = [[UIButton alloc]initWithFrame:CGRectMake(10, 95, 100, 30)];
    _mapBtnReset.backgroundColor = [UIColor greenColor];
    [_mapBtnReset setTitle:@"重置地图" forState:UIControlStateNormal];
    [_mapBtnReset addTarget:self action:@selector(btnReset) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:_mapBtnReset];
    //btnEnd
    _mapBtnEnd = [[UIButton alloc]initWithFrame:CGRectMake(10, 55, 100, 30)];
    _mapBtnEnd.backgroundColor = [UIColor greenColor];
    [_mapBtnEnd setTitle:@"结束寻宝" forState:UIControlStateNormal];
    [_mapBtnEnd addTarget:self action:@selector(btnEnd) forControlEvents:UIControlEventTouchUpInside];
    //[self.view addSubview:mapBtnEnd];
    //btnFinish
    _mapBtnFinish = [[UIButton alloc]initWithFrame:CGRectMake(10, 95, 100, 30)];
    _mapBtnFinish.backgroundColor = [UIColor greenColor];
    [_mapBtnFinish setTitle:@"完成寻宝" forState:UIControlStateNormal];
    [_mapBtnFinish addTarget:self action:@selector(btnFinish) forControlEvents:UIControlEventTouchUpInside];
    //[self.view addSubview:mapBtnFinish];
    
    
    
    [self treasureState1];
    _locService = [[BMKLocationService alloc]init];
    
    [self startLocation];
    
    _poisearch = [[BMKPoiSearch alloc]init];
    _routesearch = [[BMKRouteSearch alloc]init];
    _geocodesearch = [[BMKGeoCodeSearch alloc] init];
}

/**
 *  通过bundle加载百度地图的image文件
 *
 *  @param filename 文件名
 *
 *  @return 返回对应文件路径
 */
- (NSString*)getMyBundlePath1:(NSString *)filename
{
    
    NSBundle * libBundle = MYBUNDLE ;
    if ( libBundle && filename ){
        NSString * s=[[libBundle resourcePath ] stringByAppendingPathComponent : filename];
        return s;
    }
    return nil ;
}
/**
 *  内存溢出事件
 */
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark BMKMapViewDelegate
#pragma mark -mapview呈现之前事件
/**
 *  在mapview呈现之前设置定位、POI、路径规划、geo反查的代理
 */
-(void)viewWillAppear:(BOOL)animated
{
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _locService.delegate = self;
    _poisearch.delegate = self;
    _routesearch.delegate = self;
    _geocodesearch.delegate = self;
    
}
#pragma mark -mapview消失之前事件
/**
 *  在mapview销毁之前让self放弃代理,否则影响内存释放
 */
-(void)viewWillDisappear:(BOOL)animated
{
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
    _locService.delegate = nil;
    _poisearch.delegate = nil;
    _routesearch.delegate = nil;
    _geocodesearch.delegate = nil;
}
#pragma mark -根据annotation类型生成对应的annotation的view
/**
 *  根据anntation生成对应的View
 *  1.普通view  BMKPointAnnotation对应用户起点
 *  2.宝藏view  treasureAnnotion对应宝藏点
 *  3.路径view  RouteAnnotation对应规划的路径的点
 */
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[RouteAnnotation class]]) {
        NSLog(@"RouteAnnotation");
        return [self getRouteAnnotationView:mapView viewForAnnotation:(RouteAnnotation*)annotation];
    }else if ([annotation isKindOfClass:[BMKPointAnnotation class]]){
        NSLog(@"BMKPointAnnotation");
        NSString *AnnotationViewID = @"userloaction";
        BMKPinAnnotationView *annotationView = (BMKPinAnnotationView *)[_mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
        if (annotationView == nil) {
            annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
            // 设置颜色
            annotationView.pinColor = BMKPinAnnotationColorPurple;
            // 从天上掉下效果
            //annotationView.animatesDrop = YES;
            // 设置可拖拽
            //annotationView.draggable = YES;
        }
        return annotationView;
        
    }else{
        NSLog(@"treasureAnnotion");
        treasureAnnotion  *treasureAnnotationView = [[treasureAnnotion alloc] initWithAnnotation:annotation reuseIdentifier:@"userloaction"];
        treasureAnnotationView.image = [UIImage imageNamed:@"treasure.png"];
        return treasureAnnotationView;
        
    }
}
#pragma mark -根据覆盖物的类型生成覆盖物view
/**
 *  根据覆盖物的类型生成对应的覆盖物的view
 *  对应地图路径规划的路径的每一段的折线
 */
- (BMKOverlayView*)mapView:(BMKMapView *)map viewForOverlay:(id<BMKOverlay>)overlay
{
    if ([overlay isKindOfClass:[BMKPolyline class]]) {
        BMKPolylineView* polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay];
        polylineView.fillColor = [[UIColor cyanColor] colorWithAlphaComponent:1];
        polylineView.strokeColor = [[UIColor blueColor] colorWithAlphaComponent:0.7];
        polylineView.lineWidth = 3.0;
        return polylineView;
    }
    return nil;
}
#pragma mark -annotation的点击事件（!!!!这里很奇怪，如果普通或者是自定义annotation,如果没有paopaoview，这个点击事件不会被触发）
- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view{
    NSLog(@"didSelectAnnotationView");
}
#pragma mark -annotation paopaoview的点击事件
/**
 *  每个annotation的点击事件
 *  利用annnotaion点击会产生paopaoview来达到annotation点击事件
 *  通过判断annotation的类型，如果是宝藏的annotation，则先销毁paopao，再销毁annotation的view
 */
// 当点击annotation view弹出的泡泡时，调用此接口
- (void)mapView:(BMKMapView *)mapView annotationViewForBubble:(BMKAnnotationView *)view;
{
    NSLog(@"%@",view);
    NSString *name = [[view class] description];
    if ([name isEqualToString:@"BMKPinAnnotationView"]) {
        NSLog(@"BMKPinAnnotationView");
    }else{
        //销毁宝藏的paopaoview 和宝藏的view
        UIView *paopao = [view paopaoView];
        NSLog(@"销毁paopaoview%@",paopao);
        [paopao removeFromSuperview];
        NSLog(@"销毁treasureview%@",view);
        [view removeFromSuperview];
        
    }
    
}



#pragma mark BMKLocationServiceDelegate
#pragma mark -开始定位事件
-(void)startLocation{
    NSLog(@"进入普通定位态");
    [_locService startUserLocationService];
    _mapView.showsUserLocation = NO;//先关闭显示的定位图层
    _mapView.userTrackingMode = BMKUserTrackingModeNone;//设置定位的状态
    _mapView.showsUserLocation = YES;//显示定位图层
}
#pragma mark -结束定位事件
-(void)stopLocation{
    [_locService stopUserLocationService];
    _mapView.showsUserLocation = NO;
}
#pragma mark -用户更新坐标点事件
/**
 *  1.用户更新坐标点，完成后将用户新的坐标点存到_userLocation中，并把用户当前位置设为地图中心，
 *  2.同时调用地图GEO反查，根据当前坐标点，反查出来当前用户坐标点对应的city,address，
 *  3.根据当前位置进行周边POI检索
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    [self stopLocation];
    _userLocation = userLocation.location.coordinate;
    [_mapView setCenterCoordinate: _userLocation];
    //[self onClickReverseGeocode];
    [self startPoiSearch];
    
}
#pragma mark -定位错误处理事件
- (void)didFailToLocateUserWithError:(NSError *)error
{
    NSLog(@"location error%@",error);
}

#pragma mark implement BMKSearchDelegate
#pragma mark -POI检索结束事件
/**
 *  POI检索完成后将结果放到_poiInfoList中
 */
- (void)onGetPoiResult:(BMKPoiSearch *)searcher result:(BMKPoiResult*)result errorCode:(BMKSearchErrorCode)error
{
    if (error == BMK_SEARCH_NO_ERROR) {
        _poiInfoList = result.poiInfoList;
        srandom(time(0));
        BMKPoiInfo *item = _poiInfoList[random()%(_poiInfoList.count)];
        _targetLocation = item.pt;
        //[self addPoint];
        [self onClickWalkSearch];
    } else if (error == BMK_SEARCH_AMBIGUOUS_ROURE_ADDR){
        NSLog(@"起始点有歧义");
    } else {
        // 各种情况的判断。。。
    }
}
#pragma mark BMKRouteSearchDelegate
#pragma mark -步行路径规划结果
/**
 *  步行路径规划，并在地图上显示规划路径
 */
- (void)onGetWalkingRouteResult:(BMKRouteSearch*)searcher
                         result:(BMKWalkingRouteResult*)result
                      errorCode:(BMKSearchErrorCode)error
{
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
    array = [NSArray arrayWithArray:_mapView.overlays];
    [_mapView removeOverlays:array];
    [self addPoint];
    if (error == BMK_SEARCH_NO_ERROR) {
        BMKWalkingRouteLine* plan = (BMKWalkingRouteLine*)[result.routes objectAtIndex:0];
        int size = [plan.steps count];
        _size = size;
        int planPointCounts = 0;
        //NSLog(@"%i",size);
        for (int i = 0; i < size; i++) {
            BMKWalkingStep* transitStep = [plan.steps objectAtIndex:i];
            if(i==0){
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = plan.starting.location;
                item.title = @"起点";
                item.type = 0;
                [_mapView addAnnotation:item]; // 添加起点标注
                
            }else if(i==size-1){
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = plan.terminal.location;
                item.title = @"终点";
                item.type = 1;
                [_mapView addAnnotation:item]; // 添加起点标注
                _targetAnnotation = item;
            }
            //添加annotation节点
            RouteAnnotation* item = [[RouteAnnotation alloc]init];
            item.coordinate = transitStep.entrace.location;
            item.title = transitStep.entraceInstruction;
            item.degree = transitStep.direction * 30;
            item.type = 4;
            [_mapView addAnnotation:item];
            
            //轨迹点总数累计
            planPointCounts += transitStep.pointsCount;
        }
        
        //轨迹点
        //BMKMapPoint * temppoints = new BMKMapPoint[planPointCounts];
        BMKMapPoint temppoints[planPointCounts];
        int i = 0;
        for (int j = 0; j < size; j++) {
            BMKWalkingStep* transitStep = [plan.steps objectAtIndex:j];
            int k=0;
            for(k=0;k<transitStep.pointsCount;k++) {
                temppoints[i].x = transitStep.points[k].x;
                temppoints[i].y = transitStep.points[k].y;
                i++;
            }
            
        }
        // 通过points构建BMKPolyline
        BMKPolyline* polyLine = [BMKPolyline polylineWithPoints:temppoints count:planPointCounts];
        [_mapView addOverlay:polyLine]; // 添加路线overlay
        //delete []temppoints;
        
        
        //
    }
    
}
#pragma mark BMKGeoCodeSearchDelegate
#pragma mark -geo反编码结果
/**
 *  将经纬度反编码结果存储到_geoReverseResult
 */
-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    if (error == 0) {
        _geoReverseResult = result;
    }
}




/**
 *  开始POI搜索
 */
-(void)startPoiSearch{
    //发起检索
    BMKNearbySearchOption *option = [[BMKNearbySearchOption alloc]init];
    option.pageIndex = 0;
    option.pageCapacity = 50;
    option.location = CLLocationCoordinate2DMake(_userLocation.latitude, _userLocation.longitude);
    option.radius = 900;
    option.keyword = @"场馆";
    BOOL flag = [_poisearch poiSearchNearBy:option];
    if(flag)
    {
        NSLog(@"周边检索发送成功");
    }
    else
    {
        NSLog(@"周边检索发送失败");
    }
    }

/**
 *   增加用户中心点和宝藏点
 *   根据用户当前位置和目标位置进行路径规划
 */
-(void)addPoint{
    //添加中心点
    BMKPointAnnotation *pointannotation = [[BMKPointAnnotation alloc] init];
    pointannotation.coordinate = _userLocation;
    pointannotation.title = @"寻宝起点";
    pointannotation.subtitle = @"开始寻宝!!";
    [_mapView addAnnotation:pointannotation];
    
    //添加poi点
    for (int i = 0; i < _poiInfoList.count; i++) {
        BMKPoiInfo *item = _poiInfoList[i];
        NSLog(@"%lf===%lf====%@======%@",item.pt.latitude,item.pt.longitude,item.address,item.city);
        treasureAnnotion *treasure = [[treasureAnnotion alloc] init];
        [treasure setCoordinate:item.pt];
        treasure.title = @"宝藏点";
        [_mapView addAnnotation:treasure];
    }
    //[self onClickWalkSearch];
}
/**
 *  路径规划
 */
-(void)onClickWalkSearch
{
    
    BMKPlanNode* start = [[BMKPlanNode alloc]init];
    start.pt = _userLocation;
    //start.name = _geoReverseResult.address;
    //start.cityName = _geoReverseResult.addressDetail.city;
    
    //BMKPoiInfo *item = _poiInfoList[[_poiInfoList count]-3];
    BMKPlanNode* end = [[BMKPlanNode alloc]init];
    //end.name = item.address;
    //end.cityName = item.city;
    //end.pt = item.pt;
    end.pt = _targetLocation;
    //NSLog(@"%@====%@",start.name,start.cityName);
    //NSLog(@"%@====%@",end.name,end.cityName);
    
    
    BMKWalkingRoutePlanOption *walkingRouteSearchOption = [[BMKWalkingRoutePlanOption alloc]init];
    walkingRouteSearchOption.from = start;
    walkingRouteSearchOption.to = end;
    BOOL flag = [_routesearch walkingSearch:walkingRouteSearchOption];
    if(flag)
    {
        NSLog(@"walk检索发送成功");
    }
    else
    {
        NSLog(@"walk检索发送失败");
    }
    
}

/**
 *  geo反查
 */
-(void)onClickReverseGeocode
{
    CLLocationCoordinate2D pt = CLLocationCoordinate2DMake(_userLocation.latitude, _userLocation.longitude);
    BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    reverseGeocodeSearchOption.reverseGeoPoint = pt;
    BOOL flag = [_geocodesearch reverseGeoCode:reverseGeocodeSearchOption];
    if(flag)
    {
        NSLog(@"反geo检索发送成功");
    }
    else
    {
        NSLog(@"反geo检索发送失败");
    }
    
}
/**
 *  生成routeAnnotation
 */
- (BMKAnnotationView*)getRouteAnnotationView:(BMKMapView *)mapview viewForAnnotation:(RouteAnnotation*)routeAnnotation
{
    BMKAnnotationView* view = nil;
    switch (routeAnnotation.type) {
        case 0:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"start_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"start_node"];
                view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_start.png"]];
                view.centerOffset = CGPointMake(0, -(view.frame.size.height * 0.5));
                view.canShowCallout = TRUE;
            }
            view.annotation = routeAnnotation;
        }
            break;
        case 1:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"end_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"end_node"];
                view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_end.png"]];
                view.centerOffset = CGPointMake(0, -(view.frame.size.height * 0.5));
                view.canShowCallout = TRUE;
            }
            view.annotation = routeAnnotation;
        }
            break;
        case 2:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"bus_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"bus_node"];
                view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_bus.png"]];
                view.canShowCallout = TRUE;
            }
            view.annotation = routeAnnotation;
        }
            break;
        case 3:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"rail_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"rail_node"];
                view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_rail.png"]];
                view.canShowCallout = TRUE;
            }
            view.annotation = routeAnnotation;
        }
            break;
        case 4:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"route_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"route_node"];
                view.canShowCallout = TRUE;
            } else {
                [view setNeedsDisplay];
            }
            
            UIImage* image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_direction.png"]];
            view.image = [image imageRotatedByDegrees:routeAnnotation.degree];
            view.annotation = routeAnnotation;
            
        }
            break;
        case 5:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"waypoint_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"waypoint_node"];
                view.canShowCallout = TRUE;
            } else {
                [view setNeedsDisplay];
            }
            
            UIImage* image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_waypoint.png"]];
            view.image = [image imageRotatedByDegrees:routeAnnotation.degree];
            view.annotation = routeAnnotation;
        }
            break;
        default:
            break;
    }
    
    return view;
}
#pragma 返回按钮
- (void) backPress{
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma 寻宝逻辑
-(void) btnStart{
    NSLog(@"btn start");
    [self treasureState2];
}
-(void) btnReset{
    NSLog(@"btn reset");
    srandom(time(0));
    BMKPoiInfo *item = _poiInfoList[random()%(_poiInfoList.count)];
    _targetLocation = item.pt;
    [self onClickWalkSearch];
    //[self addPoint];

}
-(void) btnEnd{
    NSLog(@"btn end");
    [self treasureState1];
}
-(void) btnFinish{
    NSLog(@"btn finish");
}
-(void) treasureState1{
    [self.view addSubview:_mapBtnStart];
    [self.view addSubview:_mapBtnReset];
    [_mapBtnEnd removeFromSuperview];
    [_mapBtnFinish removeFromSuperview];
}
-(void) treasureState2{
    [self.view addSubview:_mapBtnEnd];
    [self.view addSubview:_mapBtnFinish];
    [_mapBtnStart removeFromSuperview];
    [_mapBtnReset removeFromSuperview];
}

@end
