//
//  HSIndexController.h
//  HotSNS
//
//  Created by 陈秋寒 on 15/3/19.
//  Copyright (c) 2015年 李长远. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSConstLayout.h"
#import "HSCollectionViewSmallLayout.h"
#import "HSIndexViewCell.h"
#import "HSShareActivityViewController.h"
#import "HSIndexView.h"

//请求数据ByQiang
#import <JSONKit.h>
#import <AFNetworking/AFNetworking.h>

//sdwebImageView ByQ on 6.6
#import <SDWebImage/UIImageView+WebCache.h>

#import "HSOfficialViewController.h"

//通知
#import "HSNotificationViewController.h"

#import <ShareSDK/ShareSDK.h>
#import "Macros.h"

//#import <FMDatabase.h>
#import "HSFMDBSqlite.h"

//shimmer
#import <FBShimmeringView.h>

//cordova for  map game
#import <Cordova/CDVViewController.h>

#import "HSRequestDataController.h"

//图片效果byQ  on 6.20
#import "SDPhotoGroup.h"

#import "HSDataFormatHandle.h"

//游戏需要地图定位,HSIndexController加入BMKLocationServiceDelegate
#import <BMapKit.h>

#import "HSScaleScrollView.h"

@interface HSIndexController : UINavigationController <UICollectionViewDataSource, UICollectionViewDelegate,UIGestureRecognizerDelegate,UIScrollViewDelegate,BMKLocationServiceDelegate,HSScaleScrollViewDelegate>{
    
    //4.11
    NSMutableArray *arraySmall;
    NSMutableArray *arrayLarge;
    NSArray *visibleCells;
    UIScrollView *scrollView;
    UIPanGestureRecognizer *panGestureRecognizerScollView;
    NSIndexPath *currentCellIndexPath;
    
    
}
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *arrayOfCells;

//定义imageView，作为scrollView的主页
//@property (nonatomic, strong) UIImageView *topImage;
//@property (nonatomic, strong) UIImageView *reflected;
//tableview 个数   numberOfRowsInSection函数值
//@property (nonatomic) NSMutableArray *recipes;//tableViewData

//@property (nonatomic, strong) UINavigationController *navCtrl;

//3.29
//@property (nonatomic,strong) UIButton *btnMap;

//4.7
//@property (nonatomic,strong) UIButton *btnTuSDK;

//4.11
//@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) HSScaleScrollView *scrollView;
@property (strong, nonatomic) UIPanGestureRecognizer *panGestureRecognizerScollView;
@property (strong, nonatomic) NSIndexPath *currentCellIndexPath;

@property (nonatomic ,strong) UIButton *notiBtn;

//4.20
@property (nonatomic, strong) AFHTTPRequestOperationManager *manager;

@property (nonatomic, strong) HSIndexView* indexView;

//幻灯片
@property (nonatomic, strong) NSArray *galleryImages;
@property (nonatomic, assign) NSInteger slide;

@property(nonatomic, strong) HSOfficialViewController *offView;
@property(nonatomic, strong) HSNotificationViewController *noti;

//4.28 官方推荐数组
@property (nonatomic, strong) NSMutableArray *officialArray;
@property int currentCellTag;

-(void)praiseBtnClick:(HSIndexViewCell*)cell;
@property (nonatomic,strong) HSShareActivityViewController *shareActivityVC;

//存储本地数据库
@property (nonatomic, strong) HSFMDBSqlite *sqlDB;
@property (nonatomic, strong) CDVViewController *mapGameCV;

@property (nonatomic, strong) HSRequestDataController *requestDataCtrl;

//7.1-warjiang
@property (nonatomic, strong) BMKLocationService *locService;
@property (nonatomic, strong) BMKUserLocation* userLocation1;
@property (nonatomic, strong) BMKUserLocation* userLocation2;
@property (nonatomic, assign) int flagCount;

@end
