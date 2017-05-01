//
//  HSMineController.h
//  HotSNS
//
//  Created by 陈秋寒 on 15/3/19.
//  Copyright (c) 2015年 李长远. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSConstLayout.h"
#import "HSCollectionViewSmallLayout.h"
#import "HSMineViewCell.h"
//#import "PaperBuble.h"
#import "HSMineView.h"

//请求数据ByQiang
#import <JSONKit-NoWarning/JSONKit.h>
#import <AFNetworking/AFNetworking.h>
#import <AFNetworking/UIImageView+AFNetworking.h>//七牛图片下载

#import "HSConstantURL.h"

#import <ShareSDK/ShareSDK.h>
#import "Macros.h"
//sdwebImageView ByQ on 6.6
#import <SDWebImage/UIImageView+WebCache.h>

//使用高斯模糊
#import "HSUtilsVC.h"

//图片效果byQ  on 6.20
#import "SDPhotoGroup.h"

//个人资料获取
#import "HSUserInfoHandler.h"

#import "HSRequestDataController.h"

#import "HSDataFormatHandle.h"

#import "HSFriendListViewController.h"

@interface HSMineController : UINavigationController <UICollectionViewDataSource, UICollectionViewDelegate,UIGestureRecognizerDelegate,UIScrollViewDelegate>
{
    //定义右上角3个按钮
    BOOL toogle;
//    PaperBuble *bubble;
//    UIImageView *addfrd,*noti,*msg;
    
    
    
    //4.11
    NSMutableArray *arraySmall;
    NSMutableArray *arrayLarge;
    NSArray *visibleCells;
    UIScrollView *scrollView;
    UIPanGestureRecognizer *panGestureRecognizerScollView;
    NSIndexPath *currentCellIndexPath;
}
@property (nonatomic, strong) UICollectionView *collectView;
@property (nonatomic, strong) NSMutableArray *arrayOfCells;//collectionViewData
//定义imageView，作为scrollView的主页
//tableview 个数   numberOfRowsInSection函数值
@property (nonatomic) NSMutableArray *recipes;//tableViewData
@property (nonatomic) HSCollectionViewSmallLayout *smallLayout;

//4.11
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIPanGestureRecognizer *panGestureRecognizerScollView;
@property (strong, nonatomic) NSIndexPath *currentCellIndexPath;


@property (nonatomic, strong) AFHTTPRequestOperationManager *manager;

@property (nonatomic, strong) HSMineView *mineView;
@property (nonatomic, assign) int currentCellTag;

@property (nonatomic, strong) NSDictionary *userInfo;

@property (strong, nonatomic) HSUtilsVC *utils;

@property (nonatomic, strong) HSUserInfoHandler *userInfoControl;

@property (nonatomic, strong) HSRequestDataController *requestDataCtrl;

@end
