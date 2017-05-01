//
//  HSScaleScrollView.h
//  LiveForest
//
//  Created by 余超 on 15/8/6.
//  Copyright © 2015年 HOTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HSScaleScrollViewDelegate;

//static BOOL isScaleScrollViewScaling;
@interface HSScaleScrollView : UIScrollView<UIGestureRecognizerDelegate,UICollectionViewDelegate>
@property(nonatomic, strong) UICollectionView *collectionView;

@property(nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizerScollView;

@property(nonatomic, weak) id<HSScaleScrollViewDelegate> myDelegate;

//存放所有的回调block,比如4个不同的界面在放大和缩小后对子视图的处理不一样
@property(nonatomic, strong) NSMutableArray *didScaleToSmallHandlerArray;
@property(nonatomic, strong) NSMutableArray *didScaleToLargeHandlerArray;


//collectionView有几个cell，谁实现协议HSScaleScrollViewDelegate的委托,是否加载更多数据
//- (instancetype)initWithCellCount:(long)cellCount Delegate:(id<HSScaleScrollViewDelegate>)myDelegate;
- (instancetype)initWithCellCount:(long)cellCount Delegate:(id<HSScaleScrollViewDelegate>)myDelegate shouldGetMoreData:(BOOL)shouldGetMoreData;

//添加提示气泡，气泡显示有几条新数据
- (void)addHeaderViewWithCount:(long)count;
//移除提示气泡
- (void)removeHeaderView;
//collectionView重载数据，数据源长度变化的时候调用
- (void)reloadDataWithArrayCount:(long)arrayCount;
//collectionView重载数据
- (void)reloadData;
//删除collectionView的某个cell
- (void)deleteItemAtIndexPath:(NSIndexPath *)indexPath;
//是否有本类的对象放大了，用于判断其他手势是否开始，解决手势冲突
- (BOOL)isScaleScrollViewScaling;
- (void)scaleFromCell:(UICollectionViewCell *)cell;
- (void)scaleFromIndexPath:(NSIndexPath *)indexPath;
//- (void)scaleFromIndexPath:(NSIndexPath *)indexPath didScaleToLargeHandler:(void(^)())largeHandler didScaleToSmallHandler:(void (^)())smallHandler;
- (float)scaleFactor;
//- (void)insertItemsAtIndexPaths:(NSArray *)indexPaths;
- (void)insertItemsAtRightWithDataSourceArrayCount:(long)count;
@end



@protocol HSScaleScrollViewDelegate <NSObject>

@optional

- (void)didScaleToSmallWithScrollView:(HSScaleScrollView *)scrollView;
- (void)didScaleToLargeWithScrollView:(HSScaleScrollView *)scrollView;

@required
//collectionView的cell注册
- (void)registerClassForCollectionView:(UICollectionView *)cv;
//设置collectionView的数据源
- (void)setDataSourceForCollectionView:(UICollectionView *)cv;
//向左滑动到尾部时会让委托去获取更多的数据
- (void)getMoreDataForScaleScrollView;
//让委托去获取新的数据
- (void)getNewDataForScaleScrollView;
//告诉委托我正在缩放，你可以做爱做的事，参数是缩放因子
- (void)gestureRecognizerStateChangedWithScaleFactor:(float)factor;
//询问委托，本类的手势是否应该开始
- (BOOL)shouldMyPanGestureRecognizerBebgin;


@end