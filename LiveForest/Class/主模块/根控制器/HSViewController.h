//
//  HSViewController.h
//  LiveForest
//
//  Created by Swift on 15/4/28.
//  Copyright (c) 2015年 HOTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

//用户个人信息获取（for 融云聊天id）
#import "HSUserInfoHandler.h"

//#import "HSScaleScrollView.h"

//#import "AppDelegate.h"//单例传值  强 on 7.8

@interface HSViewController : UIViewController <UICollectionViewDataSource,UICollectionViewDelegate,UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *rootCollectionView;
//@property (weak, nonatomic) IBOutlet UICollectionView *bottomCollectionView;



//7.6 模块化定制
@property (strong, nonatomic) NSMutableArray *controllerNameArray;
@property (strong, nonatomic) NSMutableArray *controllerArray;
@property (strong, nonatomic) NSMutableArray *scrollViewArray;
@property (strong, nonatomic) NSMutableArray *collectionViewArray;
@property (strong, nonatomic) NSMutableArray *panGestureRecognizerArray;

//用户个人信息
@property (nonatomic, strong) HSUserInfoHandler *userInfoControl;

@end
