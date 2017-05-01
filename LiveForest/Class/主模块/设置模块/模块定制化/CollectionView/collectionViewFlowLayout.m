//
//  collectionViewFlowLayout.m
//  testCollectionView
//
//  Created by payne on 15/5/5.
//  Copyright (c) 2015年 payne. All rights reserved.
//

#import "collectionViewFlowLayout.h"

typedef NS_ENUM(NSInteger, ScrollDirction) {
    ScrollDirctionNone,
    ScrollDirctionLeft,
    ScrollDirctionRight,
    ScrollDirctionUp
};

@interface UIImageView (RACollectionViewReorderableTripletLayout)

//生成cell显示内容的图片
- (void)setCellCopiedImage:(UICollectionViewCell *)cell;

@end

@implementation UIImageView (RACollectionViewReorderableTripletLayout)

- (void)setCellCopiedImage:(UICollectionViewCell *)cell {
    UIGraphicsBeginImageContextWithOptions(cell.bounds.size, NO, 4.f);
    [cell.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.image = image;
}

@end

@interface collectionViewFlowLayout ()

@property (nonatomic, assign) BOOL isSetUpGesture;                     //是否初始化手势
@property (nonatomic, strong) NSIndexPath *choosedCellIndexPath;       //当前长按拖动的item的位置
@property (nonatomic, strong) UIView *cellFakeView;                    //长按item显示的虚拟小item,可随手势移动，移动到左右边界触发scrollView自动滚动,cellFakeView是在collectionView的父视图中添加的,与collectionView比较坐标时需要转换成targetCollectionView中的坐标
@property (nonatomic, strong) UICollectionView *targetCollectionView;  //目的collectionVIew,即cellFakeView中心点center所在的collectionView
@property (nonatomic, assign) CGRect frameOfCellFakeViewInTarget;      //cellFakeView在targetCollectionView里的frame
@property (nonatomic, assign) CGPoint cellFakeViewCenter;              //cellFakeView的中心点,控制cellFakeView移动的位置
@property (nonatomic, strong) CADisplayLink *displayLink;              //控制scrollView滚动的定时器
@property (nonatomic, assign) CGPoint panTranslation;                  //拖动item时手指在屏幕上划过的像素
@property (nonatomic, assign) UIEdgeInsets scrollTrigerEdgeInsets;     //触发scrollView滚动范围
@property (nonatomic, assign) ScrollDirction myScrollDirection;        //滚动方向（左、右）
//cellFakeView所在的前一个cell位置
@property (nonatomic, copy) NSIndexPath *atIndexPath;
//cellFakeView当前所在的cell位置
@property (nonatomic, strong) NSIndexPath *toIndexPath;

@end

@implementation collectionViewFlowLayout

CGFloat XOfCurrentItem = 10;   //item的x坐标
CGFloat YOfCurrentItem = 50;   //item的y坐标

- (id<targetViewDataSource>)datasource
{
    return (id<targetViewDataSource>)self.collectionView.dataSource;
}

- (void)prepareLayout {
    [super prepareLayout];
    //初始化手势
    [self setUpCollectionViewGesture];
    //设置自动滚动的临界坐标
    self.scrollTrigerEdgeInsets = UIEdgeInsetsMake(0.0f, 20.0f, 0.0f, 80.0f);
}

#pragma mark -
#pragma mark Custom Layout
- (CGSize)collectionViewContentSize {
    NSUInteger cellCount = [self.collectionView numberOfItemsInSection:0];
    NSUInteger contentWidth = cellCount * 120 ;
//    if (contentWidth==0) {
//        contentWidth = [UIApplication sharedApplication].keyWindow.bounds.size.width;
//        self.collectionView.backgroundColor=[UIColor redColor];
//    }
    return CGSizeMake(contentWidth, self.collectionView.frame.size.height);
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray *arrayWithNewAttributes = [NSMutableArray array];
    
    NSUInteger sectionCount = [self.collectionView numberOfSections];
    for (int i = 0; i < sectionCount; i++) {
        NSUInteger cellCountInSection = [self.collectionView numberOfItemsInSection:i];
        for (int j = 0; j < cellCountInSection; j++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:j inSection:i];
            UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:indexPath];
            [arrayWithNewAttributes addObject:attributes];
        }
    }

    return arrayWithNewAttributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {

    UICollectionViewLayoutAttributes *itemAttributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    //item宽度为100,每个item与前一个item间隔20，10为第一个item的x起始坐标
    XOfCurrentItem = 10 + 120 * indexPath.item;
    
    itemAttributes.frame = CGRectMake(XOfCurrentItem, YOfCurrentItem, 100, 180);
    
    UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:self.choosedCellIndexPath];
    if (cell != nil) {
        cell.alpha = 0.4f;
    }
    
    return itemAttributes;

}

#pragma mark -
#pragma mark collectionView自动左右滚动定时器

//开启左右滚动定时器
- (void)setUpDisplayLink
{
    if (self.displayLink) {
        return;
    }
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(autoScroll)];
    [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}
//关闭左右滚动计时器
-  (void)invalidateDisplayLink
{
    [self.displayLink invalidate];
    self.displayLink = nil;
}

#pragma mark collectionView自动左右滚动
- (void)autoScroll {
    CGPoint contentOffSet = self.targetCollectionView.contentOffset;
    UIEdgeInsets contentInset = self.targetCollectionView.contentInset;
    CGSize contentSize = self.targetCollectionView.contentSize;
    CGSize boundsSize = self.collectionView.bounds.size;
    CGFloat increment = 0;          //scrollView 左右滚动的速度
    
    //计算左右滚动的速度
    if (self.myScrollDirection == ScrollDirctionRight) {
        CGFloat percentageOfScroll = (((CGRectGetMaxX(self.frameOfCellFakeViewInTarget) - contentOffSet.x) - (boundsSize.width - self.scrollTrigerEdgeInsets.right)) / self.scrollTrigerEdgeInsets.right);
        increment = percentageOfScroll * 15.0f;
        if (increment >= 15.0f) {
            increment = 15.0f;
        }
    } else if (self.myScrollDirection == ScrollDirctionLeft) {
        CGFloat percentageOfScroll = 1.0f - ((CGRectGetMinX(self.frameOfCellFakeViewInTarget) - contentOffSet.x) / self.scrollTrigerEdgeInsets.left);
        increment = percentageOfScroll * -15.0f;
        if (increment <= -15.0f) {
            increment = -15.0f;
        }
    }
    
    //如果已经到了targetCollectionView的最左边或者最右边，则不滚动且关闭定时器
    if (contentOffSet.x + increment <= -contentInset.left || contentOffSet.x + increment >= contentSize.width - boundsSize.width - contentInset.right) {
        [self invalidateDisplayLink];
    }
    
    [self.targetCollectionView performBatchUpdates:^{
        self.targetCollectionView.contentOffset = CGPointMake(contentOffSet.x + increment, contentOffSet.y);
    }completion:nil];
//    [self moveIfNeeded];
}

#pragma mark -
#pragma mark 初始化手势
- (void)setUpCollectionViewGesture {
    if (!self.isSetUpGesture) {
        _longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGesture:)];
        _panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
        _longPressGesture.delegate = self;
        _panGesture.delegate = self;
        for (UIGestureRecognizer *gestureRecognizer in self.collectionView.gestureRecognizers) {
            if ([gestureRecognizer isKindOfClass:[UILongPressGestureRecognizer class]]) {
                [gestureRecognizer requireGestureRecognizerToFail:_longPressGesture]; }}
        [self.collectionView addGestureRecognizer:_longPressGesture];
        [self.collectionView addGestureRecognizer:_panGesture];
        self.isSetUpGesture = true;
    }
}

#pragma mark 长按手势响应操作
- (void)handleLongPressGesture:(UILongPressGestureRecognizer *)longPressGesture {
    switch (longPressGesture.state) {
        case UIGestureRecognizerStateBegan:{
            //当前长按的item的indexPath，即需要插入到上面的collectionView的item的indexPath
            self.choosedCellIndexPath = [self.collectionView indexPathForItemAtPoint:[longPressGesture locationInView:self.collectionView]];
            self.atIndexPath = self.choosedCellIndexPath;
            self.toIndexPath = self.choosedCellIndexPath;
            self.targetCollectionView = self.collectionView;
            //生成可拖动的虚拟cell
            UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:self.choosedCellIndexPath];
            CGPoint cellCenterInSuperView = [self.collectionView convertPoint:cell.center toView:self.collectionView.superview];
            self.cellFakeView = [[UIView alloc] initWithFrame:CGRectMake(cellCenterInSuperView.x - cell.bounds.size.width / 2, cellCenterInSuperView.y - cell.bounds.size.height / 2, cell.bounds.size.width, cell.bounds.size.height)];
            self.cellFakeView.layer.shadowColor = [UIColor blackColor].CGColor;
            self.cellFakeView.layer.shadowOffset = CGSizeMake(0, 0);
            self.cellFakeView.layer.shadowOpacity = .5f;
            self.cellFakeView.layer.shadowRadius = 3.f;
            //cellFakeView上显示的内容
            UIImageView *cellFakeImageView = [[UIImageView alloc] initWithFrame:cell.bounds];
            UIImageView *highlightedImageView = [[UIImageView alloc] initWithFrame:cell.bounds];
            cellFakeImageView.contentMode = UIViewContentModeScaleAspectFill;
            highlightedImageView.contentMode = UIViewContentModeScaleAspectFill;
            cellFakeImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
            highlightedImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
            cell.highlighted = YES;
            [highlightedImageView setCellCopiedImage:cell];
            cell.highlighted = NO;
            [cellFakeImageView setCellCopiedImage:cell];
            
            [self.collectionView.superview addSubview:self.cellFakeView];
            [self.cellFakeView addSubview:cellFakeImageView];
            [self.cellFakeView addSubview:highlightedImageView];
            //设置center
            self.cellFakeViewCenter = self.cellFakeView.center;
            [self invalidateLayout];
            //动画,放大选中item,放大结束后移除highlightedImageView
            [UIView animateKeyframesWithDuration:0.3f delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:^{
                self.cellFakeView.center = [self.collectionView convertPoint:cell.center toView:self.collectionView.superview];
                self.cellFakeView.transform = CGAffineTransformMakeScale(1.1, 1.1 );
                cell.alpha = 0.4f;
                highlightedImageView.alpha = 0;
            }completion:^(BOOL finished){
                [highlightedImageView removeFromSuperview];
            }];
        }
            break;
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded: {
            //停止左右自动滚动
            [self invalidateDisplayLink];
            UICollectionViewCell *cellAfterInsertIndexPath;
            UICollectionViewLayoutAttributes *attributes;
            CGPoint centerOfCurrentCell;
            if (self.targetCollectionView == self.collectionView || self.toIndexPath == nil) {
                if (self.toIndexPath == nil) {
                    self.toIndexPath = self.atIndexPath;
                } else {
                    //交换item位置
                    [self.collectionView performBatchUpdates:^{
                        if ([self.datasource respondsToSelector:@selector(collectionView:moveItemFromIndexPath:toIndexPath:)]) {
                            [self.datasource collectionView:self.collectionView moveItemFromIndexPath:self.choosedCellIndexPath toIndexPath:self.toIndexPath];
                        }
                        [self.collectionView moveItemAtIndexPath:self.choosedCellIndexPath toIndexPath:self.toIndexPath];
                    }completion:nil];
                }
                cellAfterInsertIndexPath = [self.collectionView cellForItemAtIndexPath:self.toIndexPath];
                attributes = [self.collectionView.collectionViewLayout layoutAttributesForItemAtIndexPath:self.toIndexPath];
                centerOfCurrentCell = [self.collectionView convertPoint:attributes.center toView:self.collectionView.superview];
            } else {
                cellAfterInsertIndexPath = [self.targetCollectionView cellForItemAtIndexPath:self.toIndexPath];
                attributes = [self.targetCollectionView.collectionViewLayout layoutAttributesForItemAtIndexPath:self.toIndexPath];
                centerOfCurrentCell = [self.targetCollectionView convertPoint:attributes.center toView:self.collectionView.superview];
                if (self.cellFakeView.center.x > centerOfCurrentCell.x) {
                    self.toIndexPath = [NSIndexPath indexPathForItem:self.toIndexPath.item+1 inSection:self.toIndexPath.section];
                }
                //插入新cell
                [self.targetCollectionView performBatchUpdates:^{
                    if ([self.datasource respondsToSelector:@selector(collectionView:itemAtIndexPath:didInsertToCollectionView: IndexPath:)]) {
                        [self.datasource collectionView:self.collectionView itemAtIndexPath:self.choosedCellIndexPath didInsertToCollectionView:self.targetCollectionView IndexPath:self.toIndexPath];
                    }
                    [self.targetCollectionView insertItemsAtIndexPaths:@[self.toIndexPath]];
                    [self.collectionView deleteItemsAtIndexPaths:@[self.choosedCellIndexPath]];

                }completion:nil];
            }
            [UIView animateKeyframesWithDuration:0.3f delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut
                                      animations:^{
                                          cellAfterInsertIndexPath.transform = CGAffineTransformMakeScale(1,1);
                                          //移除cellFakeView
                                          self.cellFakeView.transform = CGAffineTransformIdentity;
                                          self.cellFakeView.frame = CGRectMake(centerOfCurrentCell.x - attributes.frame.size.width / 2, centerOfCurrentCell.y - attributes.frame.size.height / 2, attributes.frame.size.width, attributes.frame.size.height);
                                      }completion:^(BOOL finished){
                                          //取消选中的cell的选中效果
                                          UICollectionViewCell *choosedCell = [self.collectionView cellForItemAtIndexPath:self.choosedCellIndexPath];
                                          choosedCell.alpha = 1.0f;
                                          [self.cellFakeView removeFromSuperview];
                                          self.cellFakeView = nil;
                                          self.choosedCellIndexPath = nil;
                                          [self invalidateLayout];
                                      }];
        }
            break;
        default:
            break;
    }
}

#pragma mark 拖动手势响应操作
- (void)handlePanGesture:(UIPanGestureRecognizer *)panGesture {
    switch (panGesture.state) {
        case UIGestureRecognizerStateChanged: {
            self.panTranslation = [panGesture translationInView:self.collectionView.superview];
            self.cellFakeView.center = CGPointMake(self.cellFakeViewCenter.x + self.panTranslation.x, self.cellFakeViewCenter.y + self.panTranslation.y);
            //确定targetCollectionView
            for (UICollectionView *view in [self.collectionView.superview subviews]) {
                //111表示collectionView1,222表示collectionView2
                if (view.tag == 111 || view.tag == 222) {
                    CGPoint pointInColelctionView = [view convertPoint:self.cellFakeView.center fromView:self.collectionView.superview];
                    NSIndexPath *indexPath = [view indexPathForItemAtPoint:pointInColelctionView];
                    if (indexPath != nil) {
                        self.targetCollectionView = view;
                        //设置cellFakeView在targetView中的frame
                        CGPoint pointInTargetCollectionView = [self.targetCollectionView convertPoint:self.cellFakeView.center fromView:self.collectionView.superview];
                        self.frameOfCellFakeViewInTarget = CGRectMake(pointInTargetCollectionView.x - self.cellFakeView.frame.size.width, pointInTargetCollectionView.y - self.cellFakeView.frame.size.height, CGRectGetWidth(self.cellFakeView.frame), CGRectGetHeight(self.cellFakeView.frame));
                        break;
                    }
                }
            }
            //移动item
            [self moveIfNeeded];
            //判断scroll的方向
            //scroll方向向右、向左、不滚动
            if (CGRectGetMaxX(self.frameOfCellFakeViewInTarget) >= self.targetCollectionView.contentOffset.x + self.targetCollectionView.bounds.size.width - self.scrollTrigerEdgeInsets.right) {
                if (ceilf(self.targetCollectionView.contentOffset.x) < self.targetCollectionView.contentSize.width - self.targetCollectionView.bounds.size.width) {
                    self.myScrollDirection = ScrollDirctionRight;
                    [self setUpDisplayLink];
                }
            } else if (CGRectGetMinX(self.frameOfCellFakeViewInTarget) <= self.targetCollectionView.contentOffset.x + self.scrollTrigerEdgeInsets.left) {
                if (self.targetCollectionView.contentOffset.x > -self.targetCollectionView.contentInset.left) {
                    self.myScrollDirection = ScrollDirctionLeft;
                    [self setUpDisplayLink];
                }
            } else {
                self.myScrollDirection = ScrollDirctionNone;
                [self invalidateDisplayLink];
            }
        }
            break;
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded: {
            [self invalidateDisplayLink];
        }
            break;
            
        default:
            break;
    }
}

- (void)moveIfNeeded {
    CGPoint centerInTargetView = [self.targetCollectionView convertPoint:self.cellFakeView.center fromView:self.collectionView.superview];
    self.toIndexPath = [self.targetCollectionView indexPathForItemAtPoint:centerInTargetView];

    if (self.toIndexPath == nil || (self.collectionView == self.targetCollectionView && self.toIndexPath.item == self.atIndexPath.item)) {
        [UIView animateWithDuration:0.4f delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             if (self.toIndexPath.item != self.atIndexPath.item || self.toIndexPath == nil) {
                                 UICollectionViewCell *cellAtIndexPath = [self.targetCollectionView cellForItemAtIndexPath:self.atIndexPath];
                                 cellAtIndexPath.transform = CGAffineTransformMakeScale(1, 1);
                             }
                         } completion:^(BOOL finished){
                             if (self.toIndexPath != nil) {
                                 self.atIndexPath = self.toIndexPath;
                             }
                         }];
        return;
    }
    
    //放大交换item位置的cell
    if (self.targetCollectionView == self.collectionView) {
        [UIView animateWithDuration:0.4f delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             UICollectionViewCell *celltoIndexPath = [self.targetCollectionView cellForItemAtIndexPath:self.toIndexPath];
                             UICollectionViewCell *cellatIndexPath = [self.targetCollectionView cellForItemAtIndexPath:self.atIndexPath];
                             celltoIndexPath.transform = CGAffineTransformMakeScale(1.1, 1.1);
                             cellatIndexPath.transform = CGAffineTransformMakeScale(1, 1);
                         } completion:^(BOOL finished){
                             if (self.toIndexPath != nil) {
                                 self.atIndexPath = self.toIndexPath;
                             }
                         }];
        return;
    }
    
    //插入item
    //cellAfterInsertIndexPath是新插入的cell后一个cell的位置,放大此cell;cellBeforeInsertIndexPath是cellFakeView前一个位置，取消其cell放大
    UICollectionViewCell *cellBeforeInsertIndexPath = [self.targetCollectionView cellForItemAtIndexPath:self.atIndexPath];
    UICollectionViewCell *cellAfterInsertIndexPath = [self.targetCollectionView cellForItemAtIndexPath:self.toIndexPath];
    [UIView animateWithDuration:0.4f delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         cellAfterInsertIndexPath.transform = CGAffineTransformMakeScale(1.1, 1.1);
                         if (self.atIndexPath != self.toIndexPath) {
                             cellBeforeInsertIndexPath.transform = CGAffineTransformMakeScale(1, 1);
                         }
                     } completion:^(BOOL finished){
                         self.atIndexPath = self.toIndexPath;
                     }];
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    
    if ([_panGesture isEqual:gestureRecognizer]) {
        if (_longPressGesture.state == 0 || _longPressGesture.state == 5) {
            return NO;
        }
    }else if ([_longPressGesture isEqual:gestureRecognizer]) {
        
        //修复模块定制，没有cell的时候无法放上去。限制它只有一个cell的时候，不给手势开始就行了。yc，7.13
        NSUInteger cellCount = [self.collectionView numberOfItemsInSection:0];
        if (cellCount==1) {
            return NO;
        }
        
        if (self.collectionView.panGestureRecognizer.state != 0 && self.collectionView.panGestureRecognizer.state != 5) {
            return NO;
        }
    }
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if ([_panGesture isEqual:gestureRecognizer]) {
        if (_longPressGesture.state != 0 && _longPressGesture.state != 5) {
            if ([_longPressGesture isEqual:otherGestureRecognizer]) {
                return YES;
            }
            return NO;
        }
    }else if ([_longPressGesture isEqual:gestureRecognizer]) {
        if ([_panGesture isEqual:otherGestureRecognizer]) {
            return YES;
        }
    }else if ([self.collectionView.panGestureRecognizer isEqual:gestureRecognizer]) {
        if (_longPressGesture.state == 0 || _longPressGesture.state == 5) {
            return NO;
        }
    }
    return YES;
}

@end
