//
//  HSGroupDetailController.h
//  LiveForest
//
//  Created by 微光 on 15/5/13.
//  Copyright (c) 2015年 HOTeam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSConstLayout.h"
#import "HSCollectionViewSmallLayout.h"
#import "HSGroupDetailCollectionViewCell.h"
#import "HSGroupDetailView.h"
// 引用 IMKit 头文件。
#import <RongIMKit/RongIMKit.h>

@interface HSGroupDetailController : UIViewController<UICollectionViewDataSource, UICollectionViewDelegate,UIGestureRecognizerDelegate>{
    
    
    //4.11
    NSArray *visibleCells;
    UIScrollView *scrollView;
    UIPanGestureRecognizer *panGestureRecognizerScollView;
    NSIndexPath *currentCellIndexPath;
    
}
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *arrayWithEvent;//collectionViewData

@property (nonatomic) HSCollectionViewSmallLayout *smallLayout;

//@property (nonatomic ,strong)NSArray *visibleCellsArray ;


//@property (nonatomic, strong) UINavigationController *navCtrl;


@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIPanGestureRecognizer *panGestureRecognizerScollView;
@property (strong, nonatomic) NSIndexPath *currentCellIndexPath;


@property (strong, nonatomic) HSGroupDetailView *groupDetailView;



@end
