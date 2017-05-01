//
//  collectionViewFlowLayout.h
//  testCollectionView
//
//  Created by payne on 15/5/5.
//  Copyright (c) 2015年 payne. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol targetViewDataSource <UICollectionViewDataSource>

@required

//插入cell
- (void)collectionView:(UICollectionView *)fromCollectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath didInsertToCollectionView:(UICollectionView *)toCollectionView IndexPath:(NSIndexPath *)toIndexPath;
//交换位置
- (void)collectionView:(UICollectionView *)collectionView moveItemFromIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath;

@end

@interface collectionViewFlowLayout : UICollectionViewLayout<UIGestureRecognizerDelegate>

@property (nonatomic, assign) id<targetViewDataSource> datasource;
@property (nonatomic, strong) UILongPressGestureRecognizer *longPressGesture;
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;
@property (nonatomic, strong) NSArray *arrayWithItemText;

@end
