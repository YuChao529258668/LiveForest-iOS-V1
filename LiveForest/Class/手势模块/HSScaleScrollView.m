//
//  HSScaleScrollView.m
//  LiveForest
//
//  Created by 余超 on 15/8/6.
//  Copyright © 2015年 HOTeam. All rights reserved.
//

#import "HSScaleScrollView.h"
#import "HSCollectionViewSmallLayout.h"
#import "HSSuperCell.h"

@interface HSScaleScrollView()

//@property(nonatomic, strong) UICollectionView *collectionView;
@property(nonatomic) long cellCount;
@property (strong, nonatomic) NSIndexPath *currentCellIndexPath;

@property(nonatomic, strong) UIButton *footerView;
@property(nonatomic, strong) UIButton *headerView;

@property(nonatomic) BOOL isScaleLarge;
@property(nonatomic) BOOL shouldGetMoreData;//滑动到右边是否加载更多数据


@end


@implementation HSScaleScrollView

static float factor=0.45;
static float factorMax=2.222222;
static float factorMin=1;

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

#pragma mark - 初始化
//- (nonnull instancetype)initWithFrame:(CGRect)frame {
//    if (self = [super initWithFrame:frame]) {
//        [self initCollectionViewAndScrollView];
//    }
//    return self;
//}

//- (instancetype)initWithCellCount:(long)cellCount Delegate:(id<HSScaleScrollViewDelegate>)myDelegate{
//    if (self = [super init]) {
//        _cellCount = cellCount;
//        _myDelegate = myDelegate;
//        //        self.backgroundColor = [UIColor redColor];
//        [self initCollectionViewAndScrollView];
//        
//        //如果小卡片的个数为零，不给缩放手势
//        self.panGestureRecognizerScollView.enabled = (cellCount == 0?NO:YES);
//        
//    }
//    return self;
//}
- (instancetype)initWithCellCount:(long)cellCount Delegate:(id<HSScaleScrollViewDelegate>)myDelegate shouldGetMoreData:(BOOL)shouldGetMoreData {
    if (self = [super init]) {
        _cellCount = cellCount;
        _myDelegate = myDelegate;
        _shouldGetMoreData = shouldGetMoreData;
        //        self.backgroundColor = [UIColor redColor];
        [self initCollectionViewAndScrollView];
        
        //如果小卡片的个数为零，不给缩放手势
        self.panGestureRecognizerScollView.enabled = (cellCount == 0?NO:YES);
        
    }
    return self;
}

-(void)initCollectionViewAndScrollView {
    
    //cell、collectionView与屏幕同高,scrollView是屏幕高度的0.45倍。
    //cell、scrollView和屏幕一样大，collectionView的宽度是cell的n倍。
    //scrollView的contentSize是collectionView的frame。
    
    //初始化collectionview
    HSCollectionViewSmallLayout *smallLayout = [[HSCollectionViewSmallLayout alloc] init];
    CGRect collectionViewFrame=CGRectMake(0, 0, kScreenWidth*_cellCount,kScreenHeight);
    _collectionView = [[UICollectionView alloc] initWithFrame:collectionViewFrame collectionViewLayout:smallLayout];
    
    //    [_collectionView registerClass:[HSIndexViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    [_myDelegate registerClassForCollectionView:_collectionView];
    __weak HSScaleScrollView *weakSelf;
    _collectionView.delegate = weakSelf;
    //    _collectionView.dataSource = self;
    [_myDelegate setDataSourceForCollectionView:_collectionView];
    
    _collectionView.contentInset = UIEdgeInsetsMake(0, 1, 0, 0);//内容的左边距
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.scrollEnabled=NO;//collectionView不滚动
    
    //缩小collectionView，修正位置
    factor=factorMin;
//    _collectionView.transform=CGAffineTransformMakeScale(factorMin,factorMin);
    _collectionView.transform=CGAffineTransformMakeScale(0.45,0.45);
    collectionViewFrame=_collectionView.frame;
    collectionViewFrame.origin.x=0;
    collectionViewFrame.origin.y=0;
    _collectionView.frame=collectionViewFrame;
    
    
    
    
    
    //初始化scrollView
    float scrollViewHeight=kScreenHeight*0.45;
    float scrollViewY=kScreenHeight-scrollViewHeight;
    CGRect scrollViewFrame=CGRectMake(0, scrollViewY, kScreenWidth, scrollViewHeight);
    //    self=[[UIScrollView alloc]initWithFrame:scrollViewFrame];
    self.frame = scrollViewFrame;
    
    self.contentSize=_collectionView.frame.size;//设置滑动的范围
    self.pagingEnabled=NO;
    self.showsHorizontalScrollIndicator=YES;
    self.clipsToBounds=NO;//不裁剪越界的collectionView，这样就不用在手势过程中修改宽度了
    self.delegate=self;
    self.alwaysBounceHorizontal = YES;
    
    
    
    
    
    
    //添加pan手势给scrollView
    _panGestureRecognizerScollView=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePanScollView:)];
    _panGestureRecognizerScollView.delegate=self;
    
    [self addGestureRecognizer:_panGestureRecognizerScollView];
    [self addSubview:_collectionView];
    //    [_view addSubview:_scrollView];
    
    //缩小scrollView，摆正位置，把缩小后的scrollView的宽度增大到与屏幕同宽
    //    factor=factorMin;
    //    _scrollView.transform=CGAffineTransformMakeScale(factor,factor);
    //    scrollViewFrame.origin.x=0;
    //    scrollViewFrame.origin.y=kScreenHeight-_scrollView.frame.size.height;
    //    scrollViewFrame.size.width=kScreenWidth;
    //    _scrollView.frame=scrollViewFrame;
    
    //    在collectionview上放置刷新按钮
    //    UIButton *freshBtn = [[UIButton alloc]initWithFrame:CGRectMake(5, kScreenHeight/3*2, 100, 60)];
    //    [freshBtn setImage:[UIImage imageNamed:@"分享刷新.jpg"] forState:UIControlStateNormal];
    //    freshBtn.contentMode = UIViewContentModeScaleAspectFit;
    ////    [_collectionView addSubview:freshBtn];
    //    UIWindow *window = [[UIApplication sharedApplication]keyWindow];
    //    [window.rootViewController.view insertSubview:freshBtn aboveSubview:_collectionView];
    //    [freshBtn addTarget:self action:@selector(updateData) forControlEvents:UIControlEventTouchUpInside];
    
    _isScaleLarge = NO;
}

- (NSMutableArray *)didScaleToSmallHandlerArray {
    if (!_didScaleToSmallHandlerArray) {
        _didScaleToSmallHandlerArray = [NSMutableArray array];
    }
    return _didScaleToSmallHandlerArray;
}

- (NSMutableArray *)didScaleToLargeHandlerArray {
    if (!_didScaleToLargeHandlerArray) {
        _didScaleToLargeHandlerArray = [NSMutableArray array];
    }
    return _didScaleToLargeHandlerArray;
}

#pragma mark - 手势处理
- (void)handlePanScollView:(UIPanGestureRecognizer *)gesture {
    //手势开始
    if ([gesture state]==UIGestureRecognizerStateBegan) {
        NSLog(@"HSScaleScrollView缩放");
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"狼来了" object:nil];

//        isScaleScrollViewScaling = YES;
        
        self.clipsToBounds = NO;
        self.headerView.hidden = YES;
        
        //获取放大的cell的index
        self.currentCellIndexPath=[self.collectionView indexPathForItemAtPoint:[gesture locationInView:self.collectionView]];
        
        //设置position要用到
        CGRect oldFrame=self.frame;
        
        //计算锚点的x
        float anchorPointX=([gesture locationInView:self.superview].x-self.frame.origin.x)/kScreenWidth;
        
        //设置苗点
        //        self.scrollView.layer.anchorPoint=CGPointMake(anchorPointX, 0.45);
        self.layer.anchorPoint=CGPointMake(anchorPointX, 1);
        
        //设置frame会自动根据锚点位置设置position
        self.frame=oldFrame;
        
    }
    //手势改变
    else if ([gesture state]==UIGestureRecognizerStateChanged) {
        
        //获取手势x、y轴移动的距离，用x、y表示
        CGPoint translation=[gesture translationInView:self.superview];
        
        //计算factor
        factor-=translation.y/200.0;
        factor=factor>factorMax*1.2?factorMax*1.2:factor;
        factor=factor<factorMin*0.7?factorMin*0.7:factor;
//        NSLog(@"%f",factor);
//        NSLog(@"%f",factorMax);
//        NSLog(@"%f",factorMin);
        //缩放
        self.transform=CGAffineTransformMakeScale(factor,factor);
        
        //设置可视cell的透明度
//        [self setAllVisibleCellsSubviewsAlpha];//先自动获取可视cell再设置透明度
        [self setCellsAlpha];
        
        //让collectionView在scollView上左右滑动
        CGPoint pp=self.contentOffset;
        pp.x-=translation.x/factor;
        self.contentOffset=pp;
        
        
        //尝试修复左右bug
        CGPoint anchorPointNew = self.layer.anchorPoint;
        CGPoint positionNew = self.layer.position;
        anchorPointNew.x+=translation.x/self.frame.size.width;
        positionNew.x+=translation.x;
        self.layer.anchorPoint=anchorPointNew;
        self.layer.position=positionNew;
        
        
        //清除上次的位移，因为是累加的。
        [gesture setTranslation:CGPointMake(0, 0) inView:self.superview];
        
    }
    //手势结束
    else if ([gesture state]==UIGestureRecognizerStateEnded) {
        
        //判断要放大还是缩小
//        factor=factor >= (factorMax+factorMin)/2?factorMax:factorMin;
//        factor=factor >= factorMin*1.2?factorMax:factorMin;
        CGPoint velocity=[gesture velocityInView:self.superview];
        if (velocity.y<0) {
            factor = (factor >= factorMin*1.1)? factorMax:factorMin;
        } else {
            factor = (factor <= factorMax*0.9)? factorMin:factorMax;
        }
        /*
        [UIView animateWithDuration:0.2 animations:^{
            //缩放
            self.transform=CGAffineTransformMakeScale(factor,factor);
            //获取然后设置透明度
//            [self setAllVisibleCellsSubviewsAlpha];
            [self setCellsAlpha];

            //放大
            if (factor == factorMax) {
                NSLog(@"isScaleScrollViewScaling = %@",self.isScaleScrollViewScaling?@"YES":@"NO");
                self.isScaleLarge = YES;
                NSLog(@"isScaleScrollViewScaling = %@",self.isScaleScrollViewScaling?@"YES":@"NO");
                
                self.pagingEnabled=YES;//翻页功能
                
                //让scrollView滚动到当前的cell
                CGPoint pp=self.contentOffset;
                pp.x=kScreenWidth * self.currentCellIndexPath.row/factorMax;
                self.contentOffset=pp;
            }
            //缩小
            if (factor ==factorMin ) {
                NSLog(@"isScaleScrollViewScaling = %@",self.isScaleScrollViewScaling?@"YES":@"NO");
                self.isScaleLarge = NO;
                NSLog(@"isScaleScrollViewScaling = %@",self.isScaleScrollViewScaling?@"YES":@"NO");

                self.headerView.hidden = NO;
                self.pagingEnabled=NO;//翻页功能
                
                //让scrollView滚动scrollView平移的相反距离
                CGPoint pp=self.contentOffset;
                pp.x-=self.frame.origin.x/factorMin;//缩小到了factorMin。先滚动再平移。。。
                self.contentOffset=pp;
            }
            
            //放缩结束，scrollView都与屏幕同宽，摆正位置
            CGRect frame=self.frame;
            frame.origin.x=0;
            frame.size.width=kScreenWidth;
            self.frame=frame;
            
        } completion:^(BOOL finished) {
            self.clipsToBounds = YES;
//            [[UIApplication sharedApplication].keyWindow addSubview:self.collectionView.subviews[0]];

//            for (UIView *iv in self.collectionView.subviews) {
//                if ([iv isKindOfClass:[UIImageView class]]) {
//                    [[UIApplication sharedApplication].keyWindow addSubview:iv];
//                }
//            }
        }];*/
        
        
        [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:1 options:UIViewAnimationOptionAllowAnimatedContent animations:^{
            //缩放
            self.transform=CGAffineTransformMakeScale(factor,factor);
            //获取然后设置透明度
            //            [self setAllVisibleCellsSubviewsAlpha];
            [self setCellsAlpha];
            
            //放大
            if (factor == factorMax) {
                NSLog(@"isScaleScrollViewScaling = %@",self.isScaleScrollViewScaling?@"YES":@"NO");
                self.isScaleLarge = YES;
                NSLog(@"isScaleScrollViewScaling = %@",self.isScaleScrollViewScaling?@"YES":@"NO");
                
                self.pagingEnabled=YES;//翻页功能
                
                //让scrollView滚动到当前的cell
                CGPoint pp=self.contentOffset;
                pp.x=kScreenWidth * self.currentCellIndexPath.row/factorMax;
                self.contentOffset=pp;
                
                
                if ([self.myDelegate respondsToSelector:@selector(didScaleToLargeWithScrollView:)]) {
                    [self.myDelegate didScaleToLargeWithScrollView:self];
                }
            }
            //缩小
            if (factor ==factorMin ) {
                NSLog(@"isScaleScrollViewScaling = %@",self.isScaleScrollViewScaling?@"YES":@"NO");
                self.isScaleLarge = NO;
                NSLog(@"isScaleScrollViewScaling = %@",self.isScaleScrollViewScaling?@"YES":@"NO");
                
                self.headerView.hidden = NO;
                self.pagingEnabled=NO;//翻页功能
                
                //让scrollView滚动scrollView平移的相反距离
                CGPoint pp=self.contentOffset;
                pp.x-=self.frame.origin.x/factorMin;//缩小到了factorMin。先滚动再平移。。。
                self.contentOffset=pp;
                
                
                if ([self.myDelegate respondsToSelector:@selector(didScaleToSmallWithScrollView:)]) {
                    [self.myDelegate didScaleToSmallWithScrollView:self];
                }

            }
            
            //放缩结束，scrollView都与屏幕同宽，摆正位置
            CGRect frame=self.frame;
            frame.origin.x=0;
            frame.size.width=kScreenWidth;
            self.frame=frame;

        } completion:^(BOOL finished) {
            self.clipsToBounds = YES;
            
            //执行回调函数
            if (factor == factorMax) {
                [self performDidScaleToLargeHandlers];
            } else if (factor == factorMin) {
                [self performDidScaleToSmallHandlers];
            }
        }];
        
    }
}

//要设置手势的delegate=self
- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer {
    
    //如果是自定义的缩放手势
    if (gestureRecognizer==self.panGestureRecognizerScollView) {
        //手势滑动的距离
        CGPoint translation=[gestureRecognizer translationInView:self.superview];
        translation.x=fabs(translation.x);
        translation.y=fabs(translation.y);
        
        //上下滑动较多就开始缩放手势
        BOOL girl = translation.y>translation.x? YES:NO;
        //委托的控制器是否允许开始缩放手势
        BOOL boy  = [self.myDelegate shouldMyPanGestureRecognizerBebgin];
        
        return boy && girl;
        
    } else {
        //系统手势都允许开始
        return YES;
    }
    
}
- (void)setCellsAlpha {
    //    NSLog(@"%@",self.collectionView.subviews);
    
    for (HSSuperCell *cell in self.collectionView.visibleCells) {
        if ([cell isKindOfClass:[UICollectionViewCell class]]) {
            //            [[UIApplication sharedApplication].keyWindow addSubview:iv];
            [cell performSelector:@selector(setSubviewsAlphaWithNSNumberFactor:) withObject:[NSNumber numberWithFloat:factor]];
        }
    }
    
}

- (void)performDidScaleToLargeHandlers {
    for (void (^block)() in self.didScaleToLargeHandlerArray) {
        block();
    }
}
- (void)performDidScaleToSmallHandlers {
    for (void (^block)() in self.didScaleToSmallHandlerArray) {
        block();
    }
}

#pragma mark - 刷新
- (void)reloadDataWithArrayCount:(long)arrayCount {
    //如果小卡片的个数为零，不给缩放手势
    self.panGestureRecognizerScollView.enabled = (arrayCount == 0?NO:YES);
    
    self.cellCount = arrayCount;
    
    [self.collectionView reloadData];

    [self updateCollectionViewWidthAndScrollViewContentSizeWithCount:arrayCount];
    
    [self performSelector:@selector(removeFooterFromScrollView) withObject:nil afterDelay:2     ];
}

- (void)reloadData {
    [self.collectionView reloadData];
//    [self removeFooterFromScrollView];
    [self performSelector:@selector(removeFooterFromScrollView) withObject:nil afterDelay:2];

}

- (void)updateCollectionViewWidthAndScrollViewContentSizeWithCount:(long)count {
    CGRect frame = self.collectionView.frame;
    if (factor==factorMax) {
        frame.size.width =kScreenWidth*count;
    } else {
        frame.size.width =kScreenWidth*count*0.45;
    }
    self.contentSize = frame.size;
    self.collectionView.frame = frame;
}



#pragma mark - Footer View
- (void)addFooterToScrollView {
    
    if (!self.footerView) {
        
        //修改scrollView的contentSize，footer放在collectionView后面
        
        //求缩放的factor，计算footerFrame的时候要用到
        //        factor =scrollView.frame.size.height/scrollView.bounds.size.height;
        factor =self.collectionView.bounds.size.height/self.collectionView.frame.size.height;
        
        //计算footerFrame
        CGRect footerFrame=self.collectionView.frame;
        footerFrame.origin.x=self.contentSize.width+1;
        footerFrame.size.width=[[UIScreen mainScreen]bounds].size.width/factor;
        
        //创建菊花
        UIActivityIndicatorView *juHua=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        juHua.center=CGPointMake(footerFrame.size.width/2, footerFrame.size.height/2);
        //        juHua.tintColor=[UIColor redColor];
        //        juHua.backgroundColor=[UIColor blueColor];
        [juHua startAnimating];
        
        //创建footerView
        self.footerView=[[UIButton alloc]initWithFrame:footerFrame];
        self.footerView.backgroundColor=[UIColor whiteColor];
//        [self.footerView addTarget:self action:@selector(footerViewClick) forControlEvents:UIControlEventTouchUpInside];
        [self.footerView addSubview:juHua];
        [self addSubview:self.footerView];
        //        [scrollView insertSubview:footerView aboveSubview:collectionView];
        
        //修改contentSize
        CGSize newContentSize=self.contentSize;
        newContentSize.width+=self.footerView.frame.size.width+2;
        self.contentSize=newContentSize;
        
    }
    
}

- (void)removeFooterFromScrollView {
    if (self.footerView) {
        [UIView animateWithDuration:0.5 animations:^{
            self.contentSize=self.collectionView.frame.size;
        } completion:^(BOOL finished) {
            [self.footerView removeFromSuperview];
            self.footerView=nil;
        }];
    }
}

#pragma mark - Header View
- (void)addHeaderViewWithCount:(long)count {
    if (!self.headerView) {
        CGRect frame = CGRectMake(0, 0, 38, 30);
        frame.size.height = self.frame.size.height*0.2;
        frame.size.width = self.frame.size.width*0.2;
        frame.origin.y = self.frame.size.height/2 - frame.size.height;
//        frame.origin.y = self.frame.size.height/2 - frame.size.height + self.frame.origin.y;
        
        self.headerView = [[UIButton alloc]initWithFrame:frame];
        self.headerView.titleLabel.textAlignment = NSTextAlignmentCenter;

        [self.headerView setTitle:[NSString stringWithFormat:@"%@",@"测试"]
                         forState:UIControlStateNormal];
        [self.headerView setTitleColor:[UIColor grayColor]
                              forState:UIControlStateNormal];
        [self.headerView setBackgroundImage:[UIImage imageNamed:@"刷新小气泡"]
                                   forState:UIControlStateNormal];
        [self.headerView addTarget:self action:@selector(headerViewClick:)
                  forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:self.headerView];
//        [[UIApplication sharedApplication].keyWindow addSubview:self.headerView];
//        [self.superview addSubview:self.headerView];
    }
}

- (void)removeHeaderView {
    if (self.headerView) {
        [self.headerView removeFromSuperview];
        self.headerView = nil;
    }
}

- (void)headerViewClick:(UIButton *)btn {
    [UIView animateWithDuration:0.1 animations:^{
        self.contentOffset = CGPointZero;
    }];
    [self.myDelegate getNewDataForScaleScrollView];
    [self removeHeaderView];
}

- (void)keepHeaderViewOnSide {
    CGRect frame = self.headerView.frame;
    frame.origin.x = self.contentOffset.x;
    self.headerView.frame = frame;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    //如果是缩小的
    if(factor==factorMin) {
        //保存放大后要滚动显示的那个cell的index
        self.currentCellIndexPath=indexPath;
        //用来设置position
        CGRect oldFrame=self.frame;
        
        //计算锚点
        float anchorPointX=[self.panGestureRecognizerScollView locationInView:self].x/kScreenWidth;
        //设置锚点
        self.layer.anchorPoint=CGPointMake(anchorPointX, factorMin);
        
        //设置frame会自动根据锚点位置设置position
        self.frame=oldFrame;
        
        //放大动画
        factor=factorMax;
        [UIView animateWithDuration:0.2 animations:^{
            //缩放
            self.transform=CGAffineTransformMakeScale(factor,factor);
            
            //获取然后设置透明度
            //            [self setAllVisibleCellsSubviewsAlpha];
            
            if(factor == factorMax) {
                self.pagingEnabled=YES;
                
                //让scrollView滚动到当前的cell
                CGPoint pp=self.contentOffset;
                pp.x=kScreenWidth*self.currentCellIndexPath.row/factorMax;
                self.contentOffset=pp;
                
                //放缩结束，scrollView都与屏幕同宽，摆正位置
                CGRect frame=self.frame;
                frame.origin.x=0;
                frame.size.width=kScreenWidth;
                self.frame=frame;
            }
        }];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(nonnull UIScrollView *)scrollView {
    if (!self.isScaleScrollViewScaling) {
        [self keepHeaderViewOnSide];
    } else {
        self.headerView.hidden = YES;
        [self.headerView removeFromSuperview];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [[NSNotificationCenter defaultCenter]postNotificationName:@"狼来了" object:nil];
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    
    //    if (targetContentOffset->x > self.collectionView.frame.size.width * 0.8 *factor) {
    if (targetContentOffset->x + self.frame.size.width > self.contentSize.width * 0.8) {
        if (self.shouldGetMoreData) {
            [self addFooterToScrollView];
            [self.myDelegate getMoreDataForScaleScrollView];
        }
    } else {
//        [self addHeaderViewWithCount:5];
    }
    //    NSLog(@"targetContentOffset->x + self.frame.size.width = %f",targetContentOffset->x + self.frame.size.width);
    //    NSLog(@"self.contentSize.width * 0.8 = %f",self.contentSize.width * 0.8);
    //    NSLog(@"self.collectionView.frame.size.width* 0.8 *factor = %f",self.collectionView.frame.size.width* 0.8 *factor);
    //    NSLog(@"factor = %f",factor);
}

#pragma mark - Public
- (float)scaleFactor {
    //    NSLog(@"手势模块 factor = %f",factor);
    if (self.isScaleLarge)
        return factorMax;
    else
        return factorMin;
    //    return factor;
}


- (BOOL)isScaleScrollViewScaling {
    return self.isScaleLarge;
}

- (void)scaleFromCell:(UICollectionViewCell *)cell {
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    [self scaleFromIndexPath:indexPath];
}

- (void)scaleFromIndexPath:(NSIndexPath *)indexPath {
    //如果是缩小的
//    if(factor==factorMin) {
        //保存放大后要滚动显示的那个cell的index
        self.currentCellIndexPath=indexPath;
        //用来设置position
        CGRect oldFrame=self.frame;
        
        //计算锚点
        float anchorPointX=[self.panGestureRecognizerScollView locationInView:self].x/kScreenWidth;
        //设置锚点
        self.layer.anchorPoint=CGPointMake(anchorPointX, factorMin);
        
        //设置frame会自动根据锚点位置设置position
        self.frame=oldFrame;
        
        //放大动画
        factor=factorMax;
    
//        [UIView animateWithDuration:0.2 animations:^{
//            //缩放
//            self.transform=CGAffineTransformMakeScale(factor,factor);
//            
//            //获取然后设置透明度
//            //            [self setAllVisibleCellsSubviewsAlpha];
//            [self setCellsAlpha];
//            
//            if(factor == factorMax) {
//                
//                self.isScaleLarge = YES;
//                
//                self.pagingEnabled=YES;
//                
//                //让scrollView滚动到当前的cell
//                CGPoint pp=self.contentOffset;
//                pp.x=kScreenWidth*self.currentCellIndexPath.row/factorMax;
//                self.contentOffset=pp;
//                
//                //放缩结束，scrollView都与屏幕同宽，摆正位置
//                CGRect frame=self.frame;
//                frame.origin.x=0;
//                frame.size.width=kScreenWidth;
//                self.frame=frame;
//            }
//        }];
    
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:1 options:UIViewAnimationOptionAllowAnimatedContent animations:^{
        //缩放
        self.transform=CGAffineTransformMakeScale(factor,factor);
        
        //获取然后设置透明度
        //            [self setAllVisibleCellsSubviewsAlpha];
        [self setCellsAlpha];
        
        self.isScaleLarge = YES;
        
        self.pagingEnabled=YES;
        
        //让scrollView滚动到当前的cell
        CGPoint pp=self.contentOffset;
        pp.x=kScreenWidth*self.currentCellIndexPath.row/factorMax;
        self.contentOffset=pp;
        
        //放缩结束，scrollView都与屏幕同宽，摆正位置
        CGRect frame=self.frame;
        frame.origin.x=0;
        frame.size.width=kScreenWidth;
        self.frame=frame;
        
    } completion:^(BOOL finished) {
        [self performDidScaleToLargeHandlers];
    }];
    
    
//    }
}

//- (void)scaleFromIndexPath:(NSIndexPath *)indexPath didScaleToLargeHandler:(void(^)())largeHandler didScaleToSmallHandler:(void (^)())smallHandler {
//    [self scaleFromIndexPath:indexPath];
//    [self.didScaleToLargeHandlerArray addObject:largeHandler];
//    [self.didScaleToSmallHandlerArray addObject:smallHandler];
//}


- (void)deleteItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"\n deleteItemAtIndexPath 开始");
    NSArray *indexPathArray = [[NSArray alloc]initWithObjects:indexPath, nil];
    [self.collectionView deleteItemsAtIndexPaths:indexPathArray];
    self.cellCount--;
    [self updateCollectionViewWidthAndScrollViewContentSizeWithCount:self.cellCount];
    [self removeFooterFromScrollView];
    NSLog(@"\n deleteItemAtIndexPath 结束");
    
}

//- (void)insertItemsAtIndexPaths:(NSArray *)indexPaths {
//    self.cellCount += indexPaths.count;
//    
//    [self.collectionView insertItemsAtIndexPaths:indexPaths];
//    [self updateCollectionViewWidthAndScrollViewContentSizeWithCount:self.cellCount];
//    [self removeFooterFromScrollView];
//
//}

//- (void)insertItemsAtRightWithDataSourceArrayCountID:(NSNumber *)countN {
//    long count = [countN longLongValue];
//    [self insertItemsAtRightWithDataSourceArrayCount:count];
//}

- (void)insertItemsAtRightWithDataSourceArrayCount:(long)count {
    NSLog(@"insertItemsAtRightWithDataSourceArrayCount");
    //因为第一次获取数据和获取数据都是调用别人的同一个函数
    //第一次获取数据的时候，scroll View还没有显示在屏幕上
    //这时候插入Cell就会出异常，必须在scroll View显示到屏幕后获取新的数据时才能插入cell
    //注意注意
    static BOOL isFirstTime = YES;
    if (isFirstTime) {
//        isFirstTime = NO;
        [self reloadDataWithArrayCount:count];
    } else {
        NSMutableArray *indexPaths = [NSMutableArray array];
        
        for (long i = self.cellCount; i<count - self.cellCount; i++) {
//        for (long i = self.cellCount; i<count; i++) {
            NSLog(@"i = %ld",i);
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
            [indexPaths addObject:indexPath];
        }
        
        NSLog(@"self.cellCount = %ld",self.cellCount);
        NSLog(@"count = %ld",count);
        self.cellCount = count;
        
        
        NSLog(@"visibleCells.count = %ld",self.collectionView.visibleCells.count);
        NSLog(@"indexPaths.count = %ld",indexPaths.count);
        [self.collectionView insertItemsAtIndexPaths:indexPaths];
        
        [self updateCollectionViewWidthAndScrollViewContentSizeWithCount:self.cellCount];
//        [self removeFooterFromScrollView];
        [self performSelector:@selector(removeFooterFromScrollView) withObject:nil afterDelay:2];

    }
    
    
}

@end
