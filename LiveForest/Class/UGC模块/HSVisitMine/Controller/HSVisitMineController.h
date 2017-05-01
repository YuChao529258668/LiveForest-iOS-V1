//
//  HSVisitMineController.h
//  HotSNS
//
//  Created by 微光 on 15/3/25.
//  Copyright (c) 2015年 李长远. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSConstLayout.h"
#import "HSCollectionViewSmallLayout.h"
//#import "HSIndexViewCell.h"
//#import "PaperBuble.h"
#import "HSVisitMineView.h"

//请求数据ByQiang
#import <JSONKit-NoWarning/JSONKit.h>
#import <AFNetworking/AFNetworking.h>
#import <AFNetworking/UIImageView+AFNetworking.h>//七牛图片下载

#import <YLMoment.h>

#import "Macros.h"
#import "HSConstantURL.h"

#import <ShareSDK/ShareSDK.h>
//sdwebImageView ByQ on 6.6
#import <SDWebImage/UIImageView+WebCache.h>

//sdwebImageView ByQ on 6.6
#import <SDWebImage/UIImageView+WebCache.h>

#import "HSUtilsVC.h"
//图片效果byQ  on 6.20
#import "SDPhotoGroup.h"

#import "HSRequestDataController.h"

#import "HSDataFormatHandle.h"

#import "UtilsHeader.h"

#import "HSFriendListViewController.h"

#import "HSScaleScrollView.h"

@interface HSVisitMineController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate,UIGestureRecognizerDelegate,HSScaleScrollViewDelegate>
{
    //定义右上角3个按钮
    BOOL toogle;
//    PaperBuble *bubble;
//    UIImageView *addfrd,*noti,*msg;

    //4.11
    NSMutableArray *arraySmall;
    NSMutableArray *arrayLarge;
    NSArray *visibleCells;
//    UIScrollView *scrollView;
    UIPanGestureRecognizer *panGestureRecognizerScollView;
    NSIndexPath *currentCellIndexPath;
}
//@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *arrayOfCells;//collectionViewData
//定义imageView，作为scrollView的主页
//@property (nonatomic, strong) UIImageView *topImage;
//@property (nonatomic, strong) UIImageView *reflected;

//tableview 个数   numberOfRowsInSection函数值
@property (nonatomic) NSMutableArray *recipes;//tableViewData
@property (nonatomic) HSCollectionViewSmallLayout *smallLayout;

//@property (nonatomic, strong) UIButton *backIcon;

//yc
//4.11
//@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) HSScaleScrollView *scrollView;
@property (strong, nonatomic) UIPanGestureRecognizer *panGestureRecognizerScollView;
@property (strong, nonatomic) NSIndexPath *currentCellIndexPath;
@property (strong, nonatomic) HSVisitMineView* visitMineView;

@property (nonatomic, strong) AFHTTPRequestOperationManager *manager;

@property (strong, nonatomic) NSString *userId;
@property (strong, nonatomic) NSDictionary *userInfo;

@property (strong, nonatomic) HSUtilsVC *utils;

@property (nonatomic, strong) HSRequestDataController *requestDataCtrl;

//#pragma mark 接收到userid后，进行请求个人信息
- (void)requestPersonalInfoWithUserID:(NSString *)userID;
@end
