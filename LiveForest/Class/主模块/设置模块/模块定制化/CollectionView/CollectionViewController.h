//
//  CollectionViewController.h
//  testCollectionView
//
//  Created by payne on 15/5/5.
//  Copyright (c) 2015年 payne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CellTuple.h"

@interface CollectionViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

//arrayWithText1是collectionView1的数据源，arrayWithText2是collectionView2的数据源
@property (nonatomic, strong) NSMutableArray *arrayWithText1;
@property (nonatomic, strong) NSMutableArray *arrayWithText2;
//arrayWithInsertItem记录了哪些cell是插入的，用于控制新插入的cell的背景色，元素为元祖(collectionview.tag,indexPath),保证cell的唯一性
//@property (nonatomic, strong) NSMutableArray *arrayWithInsertItem;

//collectionView1在屏幕上半部分，collectionView2在屏幕下半部分
@property (nonatomic, strong) UICollectionView *collectionView1;
@property (nonatomic, strong) UICollectionView *collectionView2;

@property (nonatomic, strong) NSMutableArray *arrayWithImage1;
@property (nonatomic, strong) NSMutableArray *arrayWithImage2;
@end
