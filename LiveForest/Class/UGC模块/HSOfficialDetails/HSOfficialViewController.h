//
//  HSOfficialViewController.h
//  LiveForest
//
//  Created by 微光 on 15/4/27.
//  Copyright (c) 2015年 HOTeam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSOfficialView.h"
#import "HSConstLayout.h"

//请求数据ByQiang
#import <JSONKit-NoWarning/JSONKit.h>
#import <AFNetworking/AFNetworking.h>
#import <AFNetworking/UIImageView+AFNetworking.h>//七牛图片下载

#import <YLMoment.h>


//sdwebImageView ByQ on 6.6
#import <SDWebImage/UIImageView+WebCache.h>

#import "SingletonForRootViewCtrl.h"

//图片效果byQ  on 6.20
#import "SDPhotoGroup.h"

#import "HSRequestDataController.h"

#import "HSDataFormatHandle.h"

//点击进入好友主页
#import "HSVisitMineController.h"

@interface HSOfficialViewController : UIViewController<UIGestureRecognizerDelegate>{
    NSString *imgUrl;
}


@property (nonatomic, strong) HSOfficialView *offView;

@property (nonatomic, strong) NSDictionary *dic;

@property (nonatomic, strong) AFHTTPRequestOperationManager *manager;

@property (nonatomic, strong) HSRequestDataController *requestDataCtrl;

#pragma mark 对象赋值，直接初始化dic
- (void)getShareInfoWithDic:(NSDictionary*)dic;

#pragma mrak 获取dic用 shareid
- (void)getShareInfoWithShareID:(NSString *)shareID;

@property (nonatomic, strong) HSVisitMineController *visitMineVC;

- (void)show;

@end
