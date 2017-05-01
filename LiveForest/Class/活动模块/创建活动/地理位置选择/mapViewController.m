//
//  mapViewController.m
//  LiveForest
//
//  Created by 傲男 on 15/6/18.
//  Copyright (c) 2015年 HOTeam. All rights reserved.
//

#import "mapViewController.h"

@interface mapViewController ()

@end

@implementation mapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _textField = [[UITextField alloc] initWithFrame:CGRectMake(60, 20, 150, 50)];
    _textField.layer.borderWidth = 1.0f;
    _textField.placeholder = @"搜索...";
    _textField.returnKeyType = UIReturnKeyDone;
    _textField.delegate = self;
    _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _textField.backgroundColor = [UIColor whiteColor];
    
    _searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _searchBtn.frame = CGRectMake(CGRectGetMaxX(_textField.frame) + 10, _textField.frame.origin.y, 100, 50);
    _searchBtn.layer.borderWidth = 1.0f;
    _searchBtn.tag = 0;//0是完成，1是搜索
    [_searchBtn setTitle:@"完成" forState:UIControlStateNormal];
    [_searchBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _searchBtn.backgroundColor = [UIColor greenColor];
    [_searchBtn addTarget:self action:@selector(searchBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    _cancerBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _cancerBtn.tag = 0;   //0为返回，1为取消
    _cancerBtn.frame = CGRectMake(5, 20, 50, 50);
    _cancerBtn.layer.borderWidth = 1.0f;
    [_cancerBtn setTitle:@"返回" forState:UIControlStateNormal];
    [_cancerBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _cancerBtn.backgroundColor = [UIColor yellowColor];
    [_cancerBtn addTarget:self action:@selector(cancerBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    _myLocationBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _myLocationBtn.frame = CGRectMake(5, self.view.frame.size.height - 50, 100, 50);
    _myLocationBtn.layer.borderWidth = 1.0f;
    [_myLocationBtn setTitle:@"我的位置" forState:UIControlStateNormal];
    [_myLocationBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_myLocationBtn addTarget:self action:@selector(getLocation:) forControlEvents:UIControlEventTouchUpInside];
    
    self.mapView = [[BMKMapView alloc] initWithFrame:self.view.frame];
    //缩放级别:3-19
    self.mapView.zoomLevel = 15;
    
    self.locService = [[BMKLocationService alloc] init];
    
    //在线建议查询
    _suggestionSearch = [[BMKSuggestionSearch alloc] init];
    _suggestionSearch.delegate = self;
    _searchOption = [[BMKSuggestionSearchOption alloc] init];
    _suggestionResult = [NSMutableArray array];
    
    //编码查询
    _geoCodeSearch = [[BMKGeoCodeSearch alloc] init];
    _geoCodeSearch.delegate = self;
    _geoSearchOption = [[BMKGeoCodeSearchOption alloc] init];
    _reverseSearchOption = [[BMKReverseGeoCodeOption alloc] init];
    
    //活动地址
    _activityCoordinate = CLLocationCoordinate2DMake(0, 0);
    
    _plainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_textField.frame), self.view.frame.size.width, CGRectGetHeight(self.view.frame) - CGRectGetMaxY(_textField.frame)) style:UITableViewStylePlain];
    _plainTableView.center = CGPointMake(_plainTableView.center.x, _plainTableView.center.y + _plainTableView.frame.size.height);
    _plainTableView.dataSource = self;
    _plainTableView.delegate = self;
    _plainTableView.showsVerticalScrollIndicator = NO;
    
    [self.view addSubview:self.mapView];
    [self.view addSubview:_textField];
    [self.view addSubview:_searchBtn];
    [self.view addSubview:_cancerBtn];
    [self.view addSubview:_myLocationBtn];
    [self.view addSubview:_plainTableView];
    
    [self startLocation];
    
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(textFieldDidChangeCharacters) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)cancerBtn:(id)sender {
    UIButton *button = (UIButton *)sender;
    if (button.tag == 0) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else if (button.tag == 1) {
        [_cancerBtn setTitle:@"返回" forState:UIControlStateNormal];
        _cancerBtn.tag = 0;
        [_searchBtn setTitle:@"完成" forState:UIControlStateNormal];
        _searchBtn.tag = 0;
        _textField.text = @"";
        [_textField resignFirstResponder];
        _plainTableView.center = CGPointMake(_plainTableView.center.x, _plainTableView.center.y + CGRectGetHeight(_plainTableView.frame));
    }
}

- (void)searchBtn:(id)sender {
    UIButton *button = (UIButton *)sender;
    if (button.tag == 0) {
        _reverseSearchOption.reverseGeoPoint = _activityCoordinate;
        BOOL flag = [_geoCodeSearch reverseGeoCode:_reverseSearchOption];
        if (NO == flag) {
            NSLog(@"fail to reverse geo code");
        }
    } else if (button.tag == 1)
    [self searchWithAddress:_textField.text city:@""];
}

- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error {
    if(result){
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
    
    //返回结果
    //todo
//    写一个类建立数据模型
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
    }
    else{
        ShowHud(@"获取位置失败，请重试", NO);
        NSLog(@"获取位置失败,error:%u",error);
    }
}

- (void)getLocation:(id)sender {
    _textField.text = @"";
    [self startLocation];
}

- (void)searchWithAddress:(NSString *)address city:(NSString *)city {
    [_textField resignFirstResponder];
    [_cancerBtn setTitle:@"返回" forState:UIControlStateNormal];
    _cancerBtn.tag = 0;
    [_searchBtn setTitle:@"完成" forState:UIControlStateNormal];
    _searchBtn.tag = 0;
    _geoSearchOption.address = address;
    _geoSearchOption.city = city;
    BOOL flag = [_geoCodeSearch geoCode:_geoSearchOption];
    if (NO == flag) {
        NSLog(@"geoCodeSearch failed");
    }
    
    [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionTransitionCurlDown animations:^{
        _plainTableView.center = CGPointMake(_plainTableView.center.x, _plainTableView.center.y + _plainTableView.frame.size.height);
    }completion:nil];
    
    [self stopLocation];
}

- (void)onGetSuggestionResult:(BMKSuggestionSearch *)searcher result:(BMKSuggestionResult *)result errorCode:(BMKSearchErrorCode)error {
    [_suggestionResult removeAllObjects];
    for (int i = 0; i < result.districtList.count; i++) {
        NSMutableString *resultStr = [NSMutableString string];
        if ([result.cityList[i] length] > 0) {
            [resultStr appendFormat:@"%@",result.cityList[i]];
        }
        if ([result.districtList[i] length] > 0) {
            if ([result.cityList[i] length] > 0) {
                [resultStr appendFormat:@"--"];
            }
            [resultStr appendFormat:@"%@",result.districtList[i]];
        }
        if ([result.keyList[i] length] > 0) {
            if ([result.districtList[i] length] > 0) {
                [resultStr appendFormat:@"--"];
            }
            [resultStr appendFormat:@"%@",result.keyList[i]];
        }
        
        [_suggestionResult addObject:resultStr];
    }
    [_plainTableView reloadData];
}

#pragma mark -
#pragma mark UITextField
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [_cancerBtn setTitle:@"取消" forState:UIControlStateNormal];
    _cancerBtn.tag = 1;
    [_searchBtn setTitle:@"搜索" forState:UIControlStateNormal];
    _searchBtn.tag = 1;
    if ([textField.text length] < 1) {
        [_suggestionResult removeAllObjects];
        [_plainTableView reloadData];
    }
    
    [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionTransitionCurlUp animations:^{
        _plainTableView.center = CGPointMake(_plainTableView.center.x, CGRectGetMaxY(_textField.frame) + _plainTableView.frame.size.height / 2);
    }completion:nil];
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    return YES;
}

- (void) textFieldDidChangeCharacters {
    _searchOption.keyword = _textField.text;
    BOOL flag = [_suggestionSearch suggestionSearch:_searchOption];
    if (NO == flag) {
        [_suggestionResult removeAllObjects];
        [_plainTableView reloadData];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.mapView viewWillAppear];
    self.mapView.delegate = self;
    self.locService.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.mapView viewWillDisappear];
    self.mapView.delegate = nil;
    self.locService.delegate = nil;
}

#pragma mark -
#pragma mark mapView
- (void)startLocation {
    NSLog(@"进入定位状态");
    [self.locService startUserLocationService];
    self.mapView.showsUserLocation = NO;//先关闭显示的定位图层
    self.mapView.userTrackingMode = BMKUserTrackingModeFollow;//设置定位的状态
    self.mapView.showsUserLocation = YES;//显示定位图层
}

- (void)stopLocation {
    [_locService stopUserLocationService];
    _mapView.userTrackingMode = BMKUserTrackingModeNone;
    _mapView.showsUserLocation = NO;
}

//添加标注
- (void)addPointAnnotationWithCoordinate:(CLLocationCoordinate2D)coordinate
{
    if (_pointAnnotation == nil) {
        _pointAnnotation = [[BMKPointAnnotation alloc]init];
    }
    _pointAnnotation.coordinate = coordinate;
    _pointAnnotation.title = @"test";
    _pointAnnotation.subtitle = [NSString stringWithFormat:@"纬度:%f 经度:%f",coordinate.latitude,coordinate.longitude];
    
    [_mapView addAnnotation:_pointAnnotation];
}

//设置标注效果
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation {
    if (annotation == _pointAnnotation) {
        static NSString *annotationID = @"reuseID";
        BMKPinAnnotationView *annotationView = (BMKPinAnnotationView *)[_mapView dequeueReusableAnnotationViewWithIdentifier:annotationID];
        if (annotationView == nil) {
            annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:annotationID];
            // 设置颜色
            annotationView.pinColor = BMKPinAnnotationColorPurple;
            // 从天上掉下效果
            annotationView.animatesDrop = YES;
        }
        return annotationView;
    }
    return nil;
}

#pragma mark mapViewDelegate
//用户方向改变后自动调用这个函数，更新地图
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    [self.mapView updateLocationData:userLocation];
}

//用户位置改变后自动调用这个函数，更新地图
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    [self.mapView updateLocationData:userLocation];
    _activityCoordinate = userLocation.location.coordinate;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _suggestionResult.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellWithIdentifier = @"cellWithIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellWithIdentifier];
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellWithIdentifier];
    }
    cell.textLabel.text = [_suggestionResult objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    _textField.text = cell.textLabel.text;
    //    NSString *location = [_suggestionResult objectAtIndex:indexPath.row];
    //    NSArray *array = [location componentsSeparatedByString:@"--"];
    
    [self searchWithAddress:[_suggestionResult objectAtIndex:indexPath.row] city:@""];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == _plainTableView) {
        [_textField resignFirstResponder];
    }
}

#pragma mark -
#pragma mark geoSearch
- (void)onGetGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error {
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(result.location.latitude, result.location.longitude);
    _activityCoordinate = coordinate;
    [_mapView setCenterCoordinate:coordinate animated:YES];
    [self addPointAnnotationWithCoordinate:coordinate];
}


@end
