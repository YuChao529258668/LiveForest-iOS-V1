//
//  HSGroup.h
//  HotSNS
//
//  Created by 微光 on 15/4/6.
//  Copyright (c) 2015年 李长远. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSConstLayout.h"
#import "HSCollectionViewSmallLayout.h"
#import "HSGroupCollectionViewCell.h"

#import "HSChatView.h"

#import "HSGroupDetailController.h"

@interface HSGroupController : UIViewController<UICollectionViewDataSource, UICollectionViewDelegate,UIGestureRecognizerDelegate,UITableViewDataSource,UITableViewDelegate>{
   
    
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


@property (nonatomic, strong) UINavigationController *navCtrl;



//3.29
@property (nonatomic,strong) UIButton *btnMap;



//4.11
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIPanGestureRecognizer *panGestureRecognizerScollView;
@property (strong, nonatomic) NSIndexPath *currentCellIndexPath;

@property (strong, nonatomic) HSChatView *chatView;

@property (strong, nonatomic) HSGroupDetailController *groupDetail;

//幻灯片
@property (nonatomic, strong) NSMutableArray *galleryImages;
@property (nonatomic, assign) NSInteger slide;

@end
