//
//  HSActivityController.h
//  HotSNS
//
//  Created by 陈秋寒 on 15/3/19.
//  Copyright (c) 2015年 李长远. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSConstLayout.h"
#import "HSCollectionViewSmallLayout.h"
#import "HSActivityCollectionViewCell.h"
#import "HSVisitMineController.h"
#import "HSCreatActivityViewController.h"

//请求数据ByQiang
#import <JSONKit-NoWarning/JSONKit.h>
//#import <AFNetworking/AFNetworking.h>
#import <AFNetworking/UIImageView+AFNetworking.h>//七牛图片下载

#import "HSActivityView.h"

//5.11
#import "HSGroupDetailController.h"

#import "HSRequestDataController.h"

#import "HSDataFormatHandle.h"


@interface HSActivityController : UINavigationController <UICollectionViewDataSource, UICollectionViewDelegate,UIGestureRecognizerDelegate>
{

    //4.11
    NSMutableArray *arraySmall;
    NSMutableArray *arrayLarge;
    NSArray *visibleCells;
    UIScrollView *scrollView;
    UIPanGestureRecognizer *panGestureRecognizerScollView;
    NSIndexPath *currentCellIndexPath;
    
   
}

@property(nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *arrayOfCells;//collectionViewData

@property (nonatomic) HSCollectionViewSmallLayout *smallLayout;


//4.11
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIPanGestureRecognizer *panGestureRecognizerScollView;
@property (strong, nonatomic) NSIndexPath *currentCellIndexPath;

@property (nonatomic, strong) AFHTTPRequestOperationManager *manager;

@property (nonatomic, strong) HSActivityView *activityView;

@property (nonatomic, strong) HSCreatActivityViewController *createActivityVC;//声明全局变量，否则会被arc销毁

@property (nonatomic, strong) NSMutableArray *officialArray;

@property (nonatomic, strong) NSMutableArray *picActivityArray;

//幻灯片
@property (nonatomic, strong) NSArray *galleryImages;
@property (nonatomic, assign) NSInteger slide;

@property (nonatomic, strong) HSGroupDetailController *groupDetail;

@property (nonatomic, strong) HSRequestDataController *requestDataCtrl;


//7.21 线上活动
@property (nonatomic, strong) NSMutableArray *cardViewControllerArray;

@property (nonatomic, strong) UIImageView *tmpImageView;

@end
