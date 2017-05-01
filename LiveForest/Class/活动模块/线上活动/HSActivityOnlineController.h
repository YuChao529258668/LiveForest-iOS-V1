//
//  HSActivityOnlineController.h
//  LiveForest
//
//  Created by 余超 on 15/7/28.
//  Copyright © 2015年 HOTeam. All rights reserved.
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

#import "HSScaleScrollView.h"

@interface HSActivityOnlineController : UIViewController<UICollectionViewDataSource, UICollectionViewDelegate,UIGestureRecognizerDelegate,HSScaleScrollViewDelegate>
{
//4.11
    NSMutableArray *arraySmall;
    NSMutableArray *arrayLarge;
    NSArray *visibleCells;
//    UIScrollView *scrollView;
    UIPanGestureRecognizer *panGestureRecognizerScollView;
    NSIndexPath *currentCellIndexPath;
}

@property(nonatomic, strong) UICollectionView *collectionView;
//@property (nonatomic, strong) NSMutableArray *arrayOfCells;//collectionViewData

@property (nonatomic) HSCollectionViewSmallLayout *smallLayout;


//4.11
//@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) HSScaleScrollView *scrollView;
@property (strong, nonatomic) UIPanGestureRecognizer *panGestureRecognizerScollView;
@property (strong, nonatomic) NSIndexPath *currentCellIndexPath;

@property (nonatomic, strong) HSActivityView *activityView;

@property (nonatomic, strong) NSMutableArray *picActivityArray;//晒图活动

//幻灯片
@property (nonatomic, strong) NSArray *galleryImages;
@property (nonatomic, assign) NSInteger slide;

@property (nonatomic, strong) HSRequestDataController *requestDataCtrl;


//7.21 线上活动
@property (nonatomic, strong) NSMutableArray *cardViewArray;
@property (nonatomic, strong) NSMutableArray *cardViewControllerArray;

@end
