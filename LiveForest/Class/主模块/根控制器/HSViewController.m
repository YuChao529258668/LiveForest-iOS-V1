//
//  HSViewController.m
//  LiveForest
//
//  Created by Swift on 15/4/28.
//  Copyright (c) 2015年 HOTeam. All rights reserved.
//


#import "HSViewController.h"
#import "HSIndexController.h"
#import "HSActivityController.h"
//#import "HSMineController.h"
#import "HSGroupController.h"
#import "HSRootCollectionViewCell.h"
#import "HSSettingViewController.h"
#import "HSActivityOnlineController.h"

#import "HSCommentViewController.h"
//todo
//#import "MJRefresh.h"

//推送模块
#import "HSInviteFriendsVC.h" //changed by qiang on 7.8

#import "HSScaleScrollView.h"
#import "HSGameRootViewController.h"

@interface HSViewController ()
@property (nonatomic,strong) HSIndexController *indexController;
@property (nonatomic,strong) HSActivityController *activityController;
@property (nonatomic,strong) HSActivityOnlineController *activityOnlineController;
//@property (nonatomic,strong) HSMineController *mineController;
@property (nonatomic,strong) HSGroupController *groupController;
//@property (nonatomic,strong) UICollectionView *collectionView;

@property (nonatomic, strong) HSInviteFriendsVC *inviteController;  //changed by qiang on 7.8

@property (nonatomic,strong) UIScrollView *scrollView;

@property (strong, nonatomic) UIPanGestureRecognizer *currentPanGestureRecognizerScollView;
@property (strong, nonatomic) UIPanGestureRecognizer *panGestureRecognizerScollViewIndex;
@property (strong, nonatomic) UIPanGestureRecognizer *panGestureRecognizerScollViewActivity;
@property (strong, nonatomic) UIPanGestureRecognizer *panGestureRecognizerScollViewMine;
@property (strong, nonatomic) UIPanGestureRecognizer *panGestureRecognizerScollViewGroup;

@property (nonatomic,strong) UIScrollView *currentScrollView;
@property (nonatomic,strong) UICollectionView *currentCollectionView;
@property (nonatomic,strong) NSIndexPath *currentIndexPath;
//@property (nonatomic,strong)
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (assign, nonatomic) int currentControllerTag;

@property (nonatomic,strong) UIPanGestureRecognizer *panGestureSlideDown;
@property (nonatomic,strong) HSSettingViewController *settingViewController;
@property (nonatomic,strong) UIView *settingView;
@property (nonatomic,strong) UIImageView *screenShotImageView;
@property (nonatomic,strong) UIButton *coverBtn;

@property (nonatomic, strong) HSCommentViewController *commentVC;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *rootCollectionViewFlowLayout;

@property (nonatomic, strong) HSGameRootViewController *gameRootViewController;
@end

@implementation HSViewController

@synthesize currentControllerTag;
//static int currentControllerTag=0;

@synthesize panGestureSlideDown;
@synthesize settingViewController;
@synthesize settingView;
@synthesize screenShotImageView;
@synthesize coverBtn;

@synthesize commentVC;




//7.6 模块化定制
@synthesize controllerNameArray;
@synthesize controllerArray;
@synthesize scrollViewArray;
@synthesize collectionViewArray;
@synthesize panGestureRecognizerArray;



static float factor=1;
static float factorMax=2.222222;
static float factorMin=1;

static NSString * const reuseIdentifier = @"Cell";
static NSString * const reuseIdentifierBottom = @"CellBottom";

#pragma mark
- (instancetype)init {
    self=[super init];
    if (self) {
        self=[[HSViewController alloc]initWithNibName:@"HSViewController" bundle:[NSBundle mainBundle]];
    }
    //    初始化融云聊天  changed by qiang on 7.7
    [self initRongCloud];
    
    //接收推送通知  changed by qiang on 7.8
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(pushInfoShow:) name:@"notificationHSInviteFriends" object:nil];
    
    
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(activityOnlineTapTopImageView:) name:@"线上活动点击topImage放大完毕" object:nil];

    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initArrays];
    
    //初始化控制器和视图
    [self initControllers];
    [self initRootCollectionViewAndBottomCollectionView];
    [self addScrollViews];
    [self addGesturesToScrollViews];
    [self setCurrentScrollViewAndCollectionViewAndPanGestureRecognizer];
    [self addObserver];
    
    //初始化pageControl
    [self initPageControl];
    
    [self initPanGestureSlideDown];
    //    [self initSettingView];
    [self initCoverBtn];
    
//    [self initCommentViewController];
    
    
    //6.19 新增请求个人数据
    
    //    self.view.maskView=[(UIImageView *)[UIImageView alloc]initWithFrame:self.view.frame];
    //    self.view.maskView=[[UIView alloc]initWithFrame:self.view.frame];
    //    self.view.maskView.backgroundColor=[UIColor blackColor];
    //    self.view.maskView.alpha=0.1;
    //    NSLog(@"%@",self.view.maskView);
    
    
    //6.19刷新
    //    [self addRefresh];
    //    //6.21  todo
    //    self.pageControl.hidden=YES;
    //    self.rootCollectionView.scrollEnabled=NO;
    
    self.rootCollectionViewFlowLayout.itemSize = [UIScreen mainScreen].bounds.size;
//    NSLog(@"%@",self.rootCollectionViewFlowLayout);

}

#pragma mark 初始化pageControl
- (void)initPageControl {
//    self.pageControl.numberOfPages=3;
    self.pageControl.numberOfPages=controllerArray.count;
    [self.pageControl addTarget:self action:@selector(pageControlClick) forControlEvents:UIControlEventTouchUpInside ];
    
//    CGRect frame=self.pageControl.frame;
//    frame.size=[self.pageControl sizeForNumberOfPages:3];
//    frame.size=CGSizeMake(30, 20);
//    self.pageControl.frame=frame;
//    self.pageControl.backgroundColor=[UIColor redColor];
    [self.view insertSubview:self.pageControl aboveSubview:self.rootCollectionView];

}

//#pragma mark 初始化各个模块的控制器
//- (void)initControllers {
//    self.indexController=[[HSIndexController alloc]init];
//    self.activityController=[[HSActivityController alloc]init];
////    self.mineController=[[HSMineController alloc]init];
//    self.groupController=[[HSGroupController alloc]init];
//}

#pragma mark 初始化rootCollectionView和bottomCollectionView
- (void)initRootCollectionViewAndBottomCollectionView {
    
    //初始化rootCollectionView
    [self.rootCollectionView registerClass:[HSRootCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    self.rootCollectionView.backgroundColor=[UIColor clearColor];
    self.rootCollectionView.dataSource=self;
    self.rootCollectionView.delegate=self;
    self.rootCollectionView.pagingEnabled=YES;
    //    self.rootCollectionView.layer.zPosition=0;
    //    self.rootCollectionView.showsHorizontalScrollIndicator=NO;
    
//    //初始化bottomCollectionView
//    [self.bottomCollectionView registerClass:[HSBottomCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifierBottom];
//    self.bottomCollectionView.backgroundColor=[UIColor clearColor];
//    self.bottomCollectionView.dataSource=self;
//    self.bottomCollectionView.delegate=self;
//    self.bottomCollectionView.pagingEnabled=YES;
//    self.bottomCollectionView.clipsToBounds=NO;
//    self.bottomCollectionView.scrollEnabled=NO;
//    self.bottomCollectionView.showsHorizontalScrollIndicator=NO;
    
    //    self.bottomCollectionView.layer.zPosition=10;
    //    [self.view insertSubview:self.bottomCollectionView aboveSubview:self.rootCollectionView];
}

//#pragma mark 给各个scrollView添加缩放手势
//- (void)addGesturesToScrollViews {
//    //初始化pan手势
//    self.panGestureRecognizerScollViewIndex=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePanScollView:)];
//    self.panGestureRecognizerScollViewIndex.delegate=self;
//
//    //初始化pan手势
//    self.panGestureRecognizerScollViewActivity=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePanScollView:)];
//    self.panGestureRecognizerScollViewActivity.delegate=self;
//
//    //初始化pan手势
//    self.panGestureRecognizerScollViewMine=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePanScollView:)];
//    self.panGestureRecognizerScollViewMine.delegate=self;
//
//    //初始化pan手势
//    self.panGestureRecognizerScollViewGroup=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePanScollView:)];
//    self.panGestureRecognizerScollViewGroup.delegate=self;
//
//    [self.indexController.scrollView addGestureRecognizer:self.panGestureRecognizerScollViewIndex];
//    [self.activityController.scrollView addGestureRecognizer:self.panGestureRecognizerScollViewActivity];
////    [self.mineController.scrollView addGestureRecognizer:self.panGestureRecognizerScollViewMine];
//    [self.groupController.scrollView addGestureRecognizer:self.panGestureRecognizerScollViewGroup];
//
//}

#pragma mark pageControl的点击事件
- (void)pageControlClick {
    NSIndexPath *indexPath=[NSIndexPath indexPathForItem:self.pageControl.currentPage inSection:0];
    [self.rootCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    
    currentControllerTag=(int)self.pageControl.currentPage; //NSInteger *nn;nn
    [self calculatScrollViewsFrameWithTag:currentControllerTag];
}

//-(void)viewDidAppear:(BOOL)animated {
//    [self setCurrentScrollViewAndCurrentCollectionView];
//    [self.currentScrollView addGestureRecognizer:self.panGestureRecognizerScollView];
////    [self.view addGestureRecognizer:self.panGestureRecognizerScollView];
//
//}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    //    return 3;
    return controllerNameArray.count;
}

//- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
//    UICollectionViewCell *cell;
//    if (collectionView==self.rootCollectionView) {
//        cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
//        switch (indexPath.row) {
//            case 0:
//                self.indexController.indexView.frame=self.rootCollectionView.frame;
//                [cell.contentView addSubview:self.indexController.view];
//                break;
//            case 1:
//                self.activityController.activityView.frame=self.rootCollectionView.frame;
//                [cell.contentView addSubview:self.activityController.view];
//                break;
////            case 2:
////                self.mineController.mineView.frame=self.rootCollectionView.frame;
////                [cell.contentView addSubview:self.mineController.view];
////                break;
//            case 2:
//                self.groupController.chatView.frame=self.rootCollectionView.frame;
//                [cell.contentView addSubview:self.groupController.view];
//                break;
//            default:
//                break;
//        }
//    } else if(collectionView==self.bottomCollectionView){
////        UIScrollView *scrollView;
////        CGRect frame=self.indexController.scrollView.frame;
////        frame.origin.x=0;
////        frame.origin.y=0;
//
//        cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifierBottom forIndexPath:indexPath];
////        switch (indexPath.row) {
////            case 0:
////                scrollView=[self createScrollViewWithCollectionView:self.indexController.collectionView];
////                break;
////            case 1:
////                scrollView=[self createScrollViewWithCollectionView:self.activityController.collectionView];
////                break;
////            case 2:
////                scrollView=[self createScrollViewWithCollectionView:self.mineController.collectionView];
////                break;
////            case 3:
////                scrollView=[self createScrollViewWithCollectionView:self.groupController.collectionView];
////                break;
////            default:
////                break;
////        }
//////        NSLog(@"%@",scrollView);
////        [cell.contentView addSubview:scrollView];
//
////        CGRect frame=self.indexController.scrollView.frame;
////        frame.origin.x=0;
////        frame.origin.y=0;
////
////        switch (indexPath.row) {
////            case 0:
////                self.indexController.scrollView.frame=frame;
////                [cell.contentView addSubview:self.indexController.scrollView];
////                break;
////            case 1:
////                self.activityController.scrollView.frame=frame;
////                [cell.contentView addSubview:self.activityController.scrollView];
////                break;
////            case 2:
////                self.mineController.scrollView.frame=frame;
////                [cell.contentView addSubview:self.mineController.scrollView];
////                break;
////            case 3:
////                self.groupController.scrollView.frame=frame;
////                [cell.contentView addSubview:self.groupController.scrollView];
////                break;
////            default:
////                break;
////        }
//    }
//
//    return cell;
//}

#pragma mark <UICollectionViewDelegate>

/*
 // Uncomment this method to specify if the specified item should be highlighted during tracking
 - (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
 }
 */

/*
 // Uncomment this method to specify if the specified item should be selected
 - (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
 return YES;
 }
 */

/*
 // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
 - (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
 }
 
 - (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
 }
 
 - (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
 }
 */



#pragma mark UICollectionViewDelegateFlowLayout <UICollectionViewDelegate>
//@optional

//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath;
//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section;
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section;
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section;
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section;
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section;


#pragma mark
#pragma mark 《手势动画相关》
//#pragma mark <初始化collectionview和scrollView>
//-(UIScrollView *)createScrollViewWithCollectionView:(UICollectionView *)collectionView {
//
//    //cell、collectionView、 scrollView与屏幕同高。
//    //cell、scrollView和屏幕一样大，collectionView的宽度是cell的n倍。
//    //scrollView的contentSize是collectionView的frame。
//    //collectionView添加到scrollView后，scrollView缩小为0.45
//
//    //初始化scrollView
//    UIScrollView *scrollView;
//    float scrollViewHeight=kScreenHeight*0.45;
////    float scrollViewY=kScreenHeight-scrollViewHeight;
//    float scrollViewY=0;
//    CGRect scrollViewFrame=CGRectMake(0, scrollViewY, kScreenWidth, scrollViewHeight);
//    scrollView=[[UIScrollView alloc]initWithFrame:scrollViewFrame];
//
//    scrollView.contentSize=collectionView.frame.size;//设置滑动的范围
//    scrollView.pagingEnabled=NO;
//    scrollView.showsHorizontalScrollIndicator=YES;
//    scrollView.clipsToBounds=NO;//不裁剪越界的collectionView，这样就不用在手势过程中修改宽度了
//
//    //添加pan手势给scrollView
//    self.panGestureRecognizerScollView=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePanScollView:)];
//    self.panGestureRecognizerScollView.delegate=self;
//
//    [scrollView addGestureRecognizer:self.panGestureRecognizerScollView];
////    [scrollView addSubview:self.indexController.collectionView];
////    [self.view addSubview:self.scrollView];
//    [scrollView addSubview:collectionView];
//    return scrollView;
//    //缩小scrollView，摆正位置，把缩小后的scrollView的宽度增大到与屏幕同宽
//    //    factor=factorMin;
//    //    self.scrollView.transform=CGAffineTransformMakeScale(factor,factor);
//    //    scrollViewFrame.origin.x=0;
//    //    scrollViewFrame.origin.y=kScreenHeight-self.scrollView.frame.size.height;
//    //    scrollViewFrame.size.width=kScreenWidth;
//    //    self.scrollView.frame=scrollViewFrame;
//}

#pragma mark <pan手势是否开始>
//要设置手势的delegate=self
- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer {
    NSLog(@"HSViewController 判断手势是否开始");
    //评论视图什么的，通通收回去
    //    [[NSNotificationCenter defaultCenter]postNotificationName:@"狼来了" object:nil];
    
    //设置手势的delegate=self才会执行这个函数
    
    //cell放大状态时，self.view依然能捕捉到下滑手势。。。
    //cell是放大状态时，两个手势会同时开始。现在只能通过cell的状态来解决冲突了。
    //cell是缩小状态时，self.view不能捕捉到下滑手势，不会冲突。。。
    
    //    //判断scrollViews上面的手势是否开始
    //    if (gestureRecognizer!=self.panGestureSlideDown) {
    //        //手势滑动的距离
    //        CGPoint translation=[gestureRecognizer translationInView:self.view];
    //        translation.x=fabs(translation.x);
    //        translation.y=fabs(translation.y);
    ////        NSLog(@"panGestureRecognizerScollViewIndex");
    //
    //        //判断左右还是上下滑动多，上下滑动较多就开始缩放手势
    //        return translation.x>translation.y?NO:YES;
    //
    //    }
    //    //判断下拉手势是否开始，如果cell是放大状态就不开始。
    //    else if (gestureRecognizer==panGestureSlideDown) {
    ////        NSLog(@"panGestureSlideDown\n");
    //        if (factor==factorMin) {
    //            //手势滑动的距离
    //            CGPoint translation=[gestureRecognizer translationInView:self.view];
    //            translation.x=fabs(translation.x);
    //            translation.y=fabs(translation.y);
    //
    //            //判断左右还是上下滑动多，上下滑动较多就开始下滑手势
    //            return translation.x>translation.y?NO:YES;
    //
    //        } else {
    //            return NO;
    //        }
    //    }
    
//    NSLog(@"%@",gestureRecognizer.view.class);
//    NSLog(@"%@",gestureRecognizer.view.class);
//    NSLog(@"%d",gestureRecognizer==panGestureSlideDown);
    
    if ([self.indexController.scrollView isScaleScrollViewScaling]) {
        return NO;
    }
    if ([self.inviteController.scrollView isScaleScrollViewScaling]) {
        return NO;
    }
    if ([self.activityOnlineController.scrollView isScaleScrollViewScaling]) {
        return NO;
    }
    if ([self.gameRootViewController.scrollView isScaleScrollViewScaling]) {
        return NO;
    }

    
    if (self.rootCollectionView.isDragging == YES) {
        return NO;
    }
    
    //5.3
    if (gestureRecognizer==panGestureSlideDown) {
        //        NSLog(@"panGestureSlideDown\n");
        if (factor==factorMin) {
            //手势滑动的距离
            CGPoint translation=[gestureRecognizer translationInView:self.view];
            translation.x=fabs(translation.x);
            translation.y=fabs(translation.y);
            
            //判断左右还是上下滑动多，上下滑动较多就开始下滑手势
            return translation.x>translation.y?NO:YES;
            
        } else {
            return NO;
        }
    } else {
        //判断scrollViews上面的手势是否开始
        if (gestureRecognizer!=self.panGestureSlideDown) {
            //手势滑动的距离
            CGPoint translation=[gestureRecognizer translationInView:self.view];
            translation.x=fabs(translation.x);
            translation.y=fabs(translation.y);
            //        NSLog(@"panGestureRecognizerScollViewIndex");
            
            //判断左右还是上下滑动多，上下滑动较多就开始缩放手势
            return translation.x>translation.y?NO:YES;
            
        }
        
    }
    return NO;
}
//- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer {
//    NSLog(@"HSViewController 判断手势是否开始");
//    //评论视图什么的，通通收回去
//    //    [[NSNotificationCenter defaultCenter]postNotificationName:@"狼来了" object:nil];
//    
//    //设置手势的delegate=self才会执行这个函数
//    
//    //cell放大状态时，self.view依然能捕捉到下滑手势。。。
//    //cell是放大状态时，两个手势会同时开始。现在只能通过cell的状态来解决冲突了。
//    //cell是缩小状态时，self.view不能捕捉到下滑手势，不会冲突。。。
//    
//    //    //判断scrollViews上面的手势是否开始
//    //    if (gestureRecognizer!=self.panGestureSlideDown) {
//    //        //手势滑动的距离
//    //        CGPoint translation=[gestureRecognizer translationInView:self.view];
//    //        translation.x=fabs(translation.x);
//    //        translation.y=fabs(translation.y);
//    ////        NSLog(@"panGestureRecognizerScollViewIndex");
//    //
//    //        //判断左右还是上下滑动多，上下滑动较多就开始缩放手势
//    //        return translation.x>translation.y?NO:YES;
//    //
//    //    }
//    //    //判断下拉手势是否开始，如果cell是放大状态就不开始。
//    //    else if (gestureRecognizer==panGestureSlideDown) {
//    ////        NSLog(@"panGestureSlideDown\n");
//    //        if (factor==factorMin) {
//    //            //手势滑动的距离
//    //            CGPoint translation=[gestureRecognizer translationInView:self.view];
//    //            translation.x=fabs(translation.x);
//    //            translation.y=fabs(translation.y);
//    //
//    //            //判断左右还是上下滑动多，上下滑动较多就开始下滑手势
//    //            return translation.x>translation.y?NO:YES;
//    //
//    //        } else {
//    //            return NO;
//    //        }
//    //    }
//    
//    
//    if (self.rootCollectionView.isDragging == YES) {
//        return NO;
//    }
//    
//    //5.3
//    if (gestureRecognizer==panGestureSlideDown) {
//        //        NSLog(@"panGestureSlideDown\n");
//        if (factor==factorMin) {
//            //手势滑动的距离
//            CGPoint translation=[gestureRecognizer translationInView:self.view];
//            translation.x=fabs(translation.x);
//            translation.y=fabs(translation.y);
//            
//            //判断左右还是上下滑动多，上下滑动较多就开始下滑手势
//            return translation.x>translation.y?NO:YES;
//            
//        } else {
//            return NO;
//        }
//    } else {
//        //判断scrollViews上面的手势是否开始
//        if (gestureRecognizer!=self.panGestureSlideDown) {
//            //手势滑动的距离
//            CGPoint translation=[gestureRecognizer translationInView:self.view];
//            translation.x=fabs(translation.x);
//            translation.y=fabs(translation.y);
//            //        NSLog(@"panGestureRecognizerScollViewIndex");
//            
//            //判断左右还是上下滑动多，上下滑动较多就开始缩放手势
//            return translation.x>translation.y?NO:YES;
//            
//        }
//        
//    }
//    return YES;
//}

//#pragma mark 设置当前缩放的scollView
//- (void)setCurrentScrollViewAndCollectionViewAndPanGestureRecognizer {
////    UICollectionViewCell *cell=[self.bottomCollectionView visibleCells].firstObject;
////    self.currentIndexPath=[self.bottomCollectionView indexPathForCell:cell];
//
////    switch (self.currentIndexPath.row) {
//    switch (currentControllerTag) {
//        case 0:
//            self.currentScrollView=self.indexController.scrollView;
//            self.currentCollectionView=self.indexController.collectionView;
//            self.currentPanGestureRecognizerScollView=self.panGestureRecognizerScollViewIndex;
//            break;
//        case 1://请设置手势
//            self.currentScrollView=self.activityController.scrollView;
//            self.currentCollectionView=self.activityController.collectionView;
//            self.currentPanGestureRecognizerScollView=self.panGestureRecognizerScollViewActivity;
//            break;
////        case 2:
////            self.currentScrollView=self.mineController.scrollView;
////            self.currentCollectionView=self.mineController.collectionView;
////            self.currentPanGestureRecognizerScollView=self.panGestureRecognizerScollViewMine;
////            break;
//        case 2:
//            self.currentScrollView=self.groupController.scrollView;
//            self.currentCollectionView=self.groupController.collectionView;
//            self.currentPanGestureRecognizerScollView=self.panGestureRecognizerScollViewGroup;
//            break;
//
//        default:
//            break;
//    }
//    self.currentCollectionView.delegate=self;
//    self.currentScrollView.clipsToBounds=YES;
//
////    //重新初始化pan手势
////    self.panGestureRecognizerScollView=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePanScollView:)];
////    self.panGestureRecognizerScollView.delegate=self;
//
////    [self.currentScrollView addGestureRecognizer:self.panGestureRecognizerScollView];
//
//
//}

#pragma mark <pan手势处理ScollView>

- (void)handlePanScollView:(UIPanGestureRecognizer *)sender {
    
    //手势开始
    if ([sender state]==UIGestureRecognizerStateBegan) {
        self.rootCollectionView.userInteractionEnabled=NO;
        NSLog(@"缩放手势开始");
        //评论视图什么的，通通收回去
        [[NSNotificationCenter defaultCenter]postNotificationName:@"狼来了" object:nil];
        
        //获取放大的cell的index
        //        self.indexController.currentCellIndexPath=[self.indexController.collectionView indexPathForItemAtPoint:[sender locationInView:self.indexController.collectionView]];
        
        
        [self setCurrentScrollViewAndCollectionViewAndPanGestureRecognizer];
        self.currentScrollView.clipsToBounds=NO;
        
        self.currentIndexPath=[self.currentCollectionView indexPathForItemAtPoint:[sender locationInView:self.currentCollectionView]];
        
        //todo?
        self.indexController.currentCellTag=(int)self.currentIndexPath.row;
        
        //        NSLog(@"indexController.currentCellTag=%d",self.indexController.currentCellTag);
        //        self.activityController.currentCellTag=self.currentIndexPath.row;  todo
        //        NSLog(@"activityController=%d",self.indexController.currentCellTag);
        
        //        self.mineController.currentCellTag=(int)self.currentIndexPath.row;
        //        NSLog(@"mineController=%d",self.indexController.currentCellTag);
        //        self.indexController.currentCellTag=self.currentIndexPath.row;
        
        //        self.indexController.scrollView.clipsToBounds=NO;
        //        self.activityController.scrollView.clipsToBounds=NO;
        //        self.mineController.scrollView.clipsToBounds=NO;
        //        self.groupController.scrollView.clipsToBounds=NO;
        
        
        //设置position要用到
        CGRect oldFrame=self.currentScrollView.frame;
        
        //计算锚点的x
        float anchorPointX=([sender locationInView:self.view].x-self.currentScrollView.frame.origin.x)/self.currentScrollView.frame.size.width;
        
        //设置苗点
        self.currentScrollView.layer.anchorPoint=CGPointMake(anchorPointX, 1);
        
        //设置frame会自动根据锚点位置设置position
        self.currentScrollView.frame=oldFrame;
        
    }
    //手势改变
    else if ([sender state]==UIGestureRecognizerStateChanged) {
        
        //获取手势x、y轴移动的距离，用x、y表示
        CGPoint translation=[sender translationInView:self.view];
        
        //计算factor
        factor-=translation.y/100.0;
        factor=factor>factorMax*1.5?factorMax*1.5:factor;
        factor=factor<factorMin*0.6?factorMin*0.6:factor;
        
        //缩放
        self.currentScrollView.transform=CGAffineTransformMakeScale(factor,factor);
        
        //设置可视cell的透明度
        [self setAllVisibleCellsSubviewsAlpha];//先自动获取可视cell再设置透明度
        //        self.rootCollectionView.alpha=2-factor;
        
        //让collectionView在scollView上左右滑动
        CGPoint pp=self.currentScrollView.contentOffset;
        pp.x-=translation.x/factor;
        self.currentScrollView.contentOffset=pp;
        
        //        CGPoint newPosition=self.currentCollectionView.layer.position;
        //        newPosition.x+=translation.x/factor;
        //        self.currentCollectionView.layer.position=newPosition;
        
        
        //尝试修复左右bug
        CGPoint anchorPointNew = self.currentScrollView.layer.anchorPoint;
        CGPoint positionNew = self.currentScrollView.layer.position;
        anchorPointNew.x+=translation.x/self.currentScrollView.frame.size.width;
        positionNew.x+=translation.x;
        self.currentScrollView.layer.anchorPoint=anchorPointNew;
        self.currentScrollView.layer.position=positionNew;
        
        
        
        //清除上次的位移，因为是累加的。
        [sender setTranslation:CGPointMake(0, 0) inView:self.view];
//        [self.view setNeedsDisplay];
        
    }
    //手势结束
    else if ([sender state]==UIGestureRecognizerStateEnded) {
        
        //判断要放大还是缩小
//        factor=factor >= (factorMax+factorMin)/2?factorMax:factorMin;
        CGPoint velocity=[sender velocityInView:self.view];
        if (velocity.y<0) {
            factor = (factor >= factorMin*1.1)? factorMax:factorMin;
        } else {
            factor = (factor <= factorMax*0.9)? factorMin:factorMax;
        }
        
        [UIView animateWithDuration:0.2 animations:^{
            //缩放
            self.currentScrollView.transform=CGAffineTransformMakeScale(factor,factor);
            //获取然后设置透明度
            [self setAllVisibleCellsSubviewsAlpha];
            
            //放大
            if (factor == factorMax) {
                self.currentScrollView.pagingEnabled=YES;//翻页功能
                
                //                UIPanGestureRecognizer *p=(UIPanGestureRecognizer *)sender;
                //
                //                NSLog(@"location.x = % f",[p locationInView:self.currentScrollView].x);
                //                NSLog(@"width = % f",self.currentCollectionView.frame.size.width);
                
                //如果放大的是footerView。。。
                if ([sender locationInView:self.currentScrollView].x > self.currentCollectionView.frame.size.width) {
                    CGPoint newContentOffset=CGPointZero;
                    newContentOffset.x=self.currentCollectionView.frame.size.width+1;
                    self.currentScrollView.contentOffset=newContentOffset;
                } else {
                    //如果放大的是cell
                    //让scrollView滚动到当前的cell
                    CGPoint pp=self.currentScrollView.contentOffset;
                    pp.x=self.view.frame.size.width * self.currentIndexPath.row/factorMax;
//                    NSLog(@"%ld",self.currentIndexPath.row);
//                    NSLog(@"%@",NSStringFromCGSize(self.currentScrollView.contentSize));
                    self.currentScrollView.contentOffset=pp;
                }
                
            }
            //缩小
            if (factor ==factorMin ) {
                self.currentScrollView.pagingEnabled=NO;//翻页功能
                
                //让scrollView滚动scrollView平移的相反距离
                CGPoint pp=self.currentScrollView.contentOffset;
                pp.x-=self.currentScrollView.frame.origin.x/factorMin;//缩小到了factorMin。先滚动再平移。。。
                self.currentScrollView.contentOffset=pp;
                
                
                
#pragma mark 缩小后让群组的tableView可以滑动
                //                [[NSNotificationCenter defaultCenter ]postNotificationName:@"手势缩小结束" object:self.currentIndexPath];
                
                
            }
            
            //放缩结束，scrollView都与屏幕同宽，摆正位置
            CGRect frame=self.currentScrollView.frame;
            frame.origin.x=0;
            frame.size.width=self.view.frame.size.width;
            self.currentScrollView.frame=frame;
            
        }completion:^(BOOL finished) {
            self.currentScrollView.clipsToBounds=YES;
            self.rootCollectionView.userInteractionEnabled=YES;
            
        }];
        
    }
}

-(void)viewWillDisappear:(BOOL)animated {
    NSLog(@"rootview WillDisappear");
}

- (void)viewWillAppear:(BOOL)animated{
    NSLog(@"root view  will appear");
    
    // changed by qiang
    //    NSString *message =  [[NSUserDefaults standardUserDefaults] objectForKey:@"pushMessageLanuchApp"];
    //    NSLog(@"message:%@",message);
    //
    //    ShowHud([[NSString alloc]initWithFormat:@"will:%@",message], NO);
    //    if(message)
    //    {
    //        [self pushInfoShowWithAppClosed:message];
    //
    //    }
    //应用第一次启动，需要进入ugc，如果是通知，则直接进入别的  && ![[NSUserDefaults standardUserDefaults] objectForKey:@"pushMessageLanuchApp"]
//    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"appFinishedLanunch"] isEqualToString:@"1"] ){
//        
//        NSIndexPath *indexPath=[NSIndexPath indexPathForItem:1 inSection:0];
//        [self.rootCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
//        
//        
//        
//        currentControllerTag=1; //NSInteger *nn;nn
//        [self calculatScrollViewsFrameWithTag:currentControllerTag];
//        self.pageControl.currentPage = currentControllerTag ;
////
//       
//    }
    
}

- (void)viewDidAppear:(BOOL)animated{
    NSLog(@"root view did appear");
    
    // changed by qiang
    NSString *message =  [[NSUserDefaults standardUserDefaults] objectForKey:@"pushMessageLanuchApp"];
    //    NSLog(@"message:%@",message);
    //    ShowHud([[NSString alloc]initWithFormat:@"did:%@",message], NO);
    
    if(message)
    {
        [self pushInfoShowWithAppClosed:message];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"pushMessageLanuchApp"];
    }
    
    
    //7.24 跳转到中间的内容
//    [self scrollToUGC];
}

- (void)viewDidDisappear:(BOOL)animated{
    NSLog(@"root view did disappear");
}

#pragma mark <点击一个cell>
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    if (collectionView==self.rootCollectionView) {
//        return;
//    }
//    NSLog(@"点击了一个cell");
//    //评论视图什么的，通通收回去
//    [[NSNotificationCenter defaultCenter]postNotificationName:@"狼来了" object:nil];
//    
//    //    NSLog(@"\n手势所在View的frame %@\n",NSStringFromCGRect(self.panGestureRecognizerScollView.view.frame));
//    
//    //如果是缩小的
//    if(factor==factorMin) {
//        //保存放大后要滚动显示的那个cell的index
//        self.currentIndexPath=indexPath;
//        
//        [self setCurrentScrollViewAndCollectionViewAndPanGestureRecognizer];
//        
//        self.currentIndexPath=[self.currentCollectionView indexPathForItemAtPoint:[self.currentPanGestureRecognizerScollView locationInView:self.currentCollectionView]];
//        
//        self.indexController.currentCellTag=(int)self.currentIndexPath.row;
//        
//        //        NSLog(@"indexController.currentCellTag=%d",self.indexController.currentCellTag);
//        //        self.activityController.currentCellTag=self.currentIndexPath.row;  todo
//        //NSLog(@"activityController=%d",self.indexController.currentCellTag);
//        
//        //        self.mineController.currentCellTag=(int)self.currentIndexPath.row;
//        //        NSLog(@"mineController=%d",self.indexController.currentCellTag);
//        
//        //用来设置position
//        CGRect oldFrame=self.currentScrollView.frame;
//        
//        //        //计算锚点的x
//        float anchorPointX=[self.currentPanGestureRecognizerScollView locationInView:self.view].x/self.view.frame.size.width;
//        
//        //设置锚点
//        self.currentScrollView.layer.anchorPoint=CGPointMake(anchorPointX, factorMin);
//        
//        //设置frame会自动根据锚点位置设置position
//        self.currentScrollView.frame=oldFrame;
//        
//        //放大动画
//        factor=factorMax;
//        [UIView animateWithDuration:0.2 animations:^{
//            //缩放
//            self.currentScrollView.transform=CGAffineTransformMakeScale(factor,factor);
//            
//            //获取然后设置透明度
//            [self setAllVisibleCellsSubviewsAlpha];
//            
//            if(factor == factorMax) {
//                self.currentScrollView.pagingEnabled=YES;
//                
//                //让scrollView滚动到当前的cell
//                CGPoint pp=self.currentScrollView.contentOffset;
//                pp.x=self.view.frame.size.width*self.currentIndexPath.row/factorMax;
//                self.currentScrollView.contentOffset=pp;
//                
//                //放缩结束，scrollView都与屏幕同宽，摆正位置
//                CGRect frame=self.currentScrollView.frame;
//                frame.origin.x=0;
//                frame.size.width=self.view.frame.size.width;
//                self.currentScrollView.frame=frame;
//            }
//        }];
//    }
}

#pragma mark <设置所有可视cell的子视图>
-(void)setAllVisibleCellsSubviewsAlpha {
    NSArray *array=[self.currentCollectionView visibleCells];
    //    [array makeObjectsPerformSelector:@selector(setSubviewsAlphaWithFactor:)];
    //    [array makeObjectsPerformSelector:@selector(setSubviewsAlphaWithFactor:) withObject: [NSNumber numberWithFloat:factor]];
    [array makeObjectsPerformSelector:@selector(setSubviewsAlphaWithNSNumberFactor:) withObject: [NSNumber numberWithFloat:factor]];
    //    for (HSActivityCollectionViewCell *cell in visibleCells) {
    //        [cell setSubviewsAlphaWithFactor:factor];
    //    }
}
#pragma mark 《手势动画结束》
#pragma mark

//scrollView滚动时，就调用该方法。任何offset值改变都调用该方法。即滚动过程中，调用多次
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//
////    NSLog(@"scrollViewDidScroll");
////    CGPoint point=scrollView.contentOffset;
////    NSLog(@"%f,%f",point.x,point.y);
//    // 从中可以读取contentOffset属性以确定其滚动到的位置。
//
//    // 注意：当ContentSize属性小于Frame时，将不会出发滚动
//
//
//}


// 当scrollView缩放时，调用该方法。在缩放过程中，回多次调用
//- (void)scrollViewDidZoom:(UIScrollView *)scrollView{
//
////    NSLog(@"scrollViewDidZoom");
////    float value=scrollView.zoomScale;
////    NSLog(@"%f",value);
//
//}

// 当开始滚动视图时，执行该方法。一次有效滑动（开始滑动，滑动一小段距离，只要手指不松开，只算一次滑动），只执行一次。
//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
//
////    NSLog(@"scrollViewWillBeginDragging");
//
//}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    //    self.currentScrollView.userInteractionEnabled=NO;
    //    self.currentCollectionView.userInteractionEnabled=NO;
    //    self.currentPanGestureRecognizerScollView
    //    self.indexController.scrollView.userInteractionEnabled=NO;
    //    self.activityController.scrollView.userInteractionEnabled=NO;
    //    self.mineController.scrollView.userInteractionEnabled=NO;
    //    self.groupController.scrollView.userInteractionEnabled=NO;
    //
    //    self.panGestureRecognizerScollViewIndex.enabled=NO;
    //    self.panGestureRecognizerScollViewMine.enabled=NO;
    //    self.panGestureRecognizerScollViewGroup.enabled=NO;
    //    self.panGestureRecognizerScollViewActivity.enabled=NO;
}
#pragma mark 判断要展示哪个 滑动scrollView时手指离开瞬间
// 滑动scrollView，并且手指离开时执行。一次有效滑动，只执行一次。
// 当pagingEnabled属性为YES时，不调用，该方法
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    
    //    NSLog(@"scrollViewWillEndDragging");
    //    CGPoint v=[scrollView.panGestureRecognizer velocityInView:scrollView];
    //    NSLog(@"v = %@",NSStringFromCGPoint(v));
    
    //    NSLog(@"targetContentOffset = %@",NSStringFromCGPoint(*targetContentOffset));
    //    NSLog(@"contentOffset = %@",NSStringFromCGPoint(scrollView.contentOffset));
    
    
    int n=(*targetContentOffset).x/kScreenWidth;
//    NSLog(@"n = %d",n);
    NSIndexPath *indexPath=[NSIndexPath indexPathForItem:n inSection:0];
//    [UIView animateWithDuration:0.1 animations:^{
//        [self.bottomCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
//    } completion:^(BOOL finished) {
//    }];
    //    NSLog(@"contentOffset = %@",NSStringFromCGPoint(self.view.frame.origin));
    
    currentControllerTag=(*targetContentOffset).x/kScreenWidth;
    [self calculatScrollViewsFrameWithTag:n];
    [self setCurrentScrollViewAndCollectionViewAndPanGestureRecognizer];
    self.pageControl.currentPage=n;
    
    //todo
    self.currentScrollView.userInteractionEnabled=YES;
    
}

//- scro
// 滑动视图，当手指离开屏幕那一霎那，调用该方法。一次有效滑动，只执行一次。
// decelerate,指代，当我们手指离开那一瞬后，视图是否还将继续向前滚动（一段距离），经过测试，decelerate=YES
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    //    self.currentScrollView.userInteractionEnabled=YES;
    //    self.currentCollectionView.userInteractionEnabled=YES;
    //    NSLog(@"scrollViewDidEndDragging");
    //    if (decelerate) {
    //        NSLog(@"scrollViewDidEndDragging decelerate");
    //    }else{
    //        NSLog(@"scrollViewDidEndDragging no decelerate");
    //
    //    }
    
    //    CGPoint point=scrollView.contentOffset;
    //    NSLog(@"%f,%f",point.x,point.y);
    
    self.indexController.scrollView.userInteractionEnabled=YES;
    self.activityController.scrollView.userInteractionEnabled=YES;
    //    self.mineController.scrollView.userInteractionEnabled=YES;
    self.groupController.scrollView.userInteractionEnabled=YES;
    
    self.panGestureRecognizerScollViewIndex.enabled=YES;
    self.panGestureRecognizerScollViewMine.enabled=YES;
    self.panGestureRecognizerScollViewGroup.enabled=YES;
    self.panGestureRecognizerScollViewActivity.enabled=YES;
}

// 滑动减速时调用该方法。
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    
    //    NSLog(@"scrollViewWillBeginDecelerating");
    // 该方法在scrollViewDidEndDragging方法之后。
    
    
}

//#pragma mark 啪啪啪
//- (void)addScrollViews {
//    [self.view addSubview: self.indexController.scrollView];
//    [self.view addSubview: self.activityController.scrollView];
////    [self.view addSubview: self.mineController.scrollView];
//    [self.view addSubview: self.groupController.scrollView];
////    [self.bottomCollectionView removeFromSuperview];
////    [self calculatScrollViewsFrameWithTag:0];
//    [self calculatFramesWithoutAnimation];
//}

#pragma mark 计算各个控制器的frame
//- (void)calculatScrollViewsFrameWithTag:(int)n {
//
//    [UIView animateWithDuration:0.2 animations:^{
//        CGRect f=self.indexController.scrollView.frame;
//
//        f.origin.x=-n*kScreenWidth;
//        self.indexController.scrollView.frame=f;
//
//        f.origin.x+=kScreenWidth;
//        self.activityController.scrollView.frame=f;
//
////        f.origin.x+=kScreenWidth;
////        self.mineController.scrollView.frame=f;
//
//        f.origin.x+=kScreenWidth;
//        self.groupController.scrollView.frame=f;
//
//    }];
//}

//- (void)calculatFramesWithoutAnimation {
//
//    CGRect f=self.indexController.scrollView.frame;
//
//    f.origin.x=0;
//    self.indexController.scrollView.frame=f;
//
//    f.origin.x+=kScreenWidth;
//    self.activityController.scrollView.frame=f;
//
////    f.origin.x+=kScreenWidth;
////    self.mineController.scrollView.frame=f;
//
//    f.origin.x+=kScreenWidth;
//    self.groupController.scrollView.frame=f;
//}

// 滚动视图减速完成，滚动将停止时，调用该方法。一次有效滑动，只执行一次。
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    //    NSLog(@"scrollViewDidEndDecelerating");
    
    //    NSLog(@"contentOffset = %@",NSStringFromCGPoint(self.indexController.indexView.frame.origin));
    //    NSLog(@"contentOffset = %@",NSStringFromCGPoint(self.activityController.activityView.frame.origin));
    //    NSLog(@"contentOffset = %@",NSStringFromCGPoint(self.mineController.mineView.frame.origin));
    //    NSLog(@"contentOffset = %@",NSStringFromCGPoint(self.groupController.chatView.frame.origin));
    
    //    [_scrollView setContentOffset:CGPointMake(0, 500) animated:YES];
    
}

// 当滚动视图动画完成后，调用该方法，如果没有动画，那么该方法将不被调用
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    
    //    NSLog(@"scrollViewDidEndScrollingAnimation");
    // 有效的动画方法为：
    //    - (void)setContentOffset:(CGPoint)contentOffset animated:(BOOL)animated 方法
    //    - (void)scrollRectToVisible:(CGRect)rect animated:(BOOL)animated 方法
    
    
}



// 返回将要缩放的UIView对象。要执行多次
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    
    NSLog(@"viewForZoomingInScrollView");
    return  self.view;
    
}

// 当将要开始缩放时，执行该方法。一次有效缩放，就只执行一次。
- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view{
    
    NSLog(@"scrollViewWillBeginZooming");
    
}

// 当缩放结束后，并且缩放大小回到minimumZoomScale与maximumZoomScale之间后（我们也许会超出缩放范围），调用该方法。
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(double)scale{
    
    NSLog(@"scrollViewDidEndZooming");
    
}

// 指示当用户点击状态栏后，滚动视图是否能够滚动到顶部。需要设置滚动视图的属性：_scrollView.scrollsToTop=YES;
- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView{
    NSLog(@"scrollViewShouldScrollToTop");
    
    return YES;
}

// 当滚动视图滚动到最顶端后，执行该方法
- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView{
    
    NSLog(@"scrollViewDidScrollToTop");
}

#pragma mark 注册通知
- (void)addObserver {
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(backBtnClick) name:@"backBtnClick" object:nil];
    
    //    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(shareActivityBtnClick) name:@"shareActivityBtnClick" object:nil];
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(slideDownTheGroupChapTableView:) name:@"slideDownTheGroupChapTableView" object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(footerViewClick) name:@"footerViewClick" object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(headerViewClick) name:@"headerViewClick" object:nil];
    
    
}

#pragma mark 聊天界面的返回按钮
- (void)backBtnClick {
    NSLog(@"backIconPressed");
    if(factor==factorMax) {
        
        CGRect oldFrame=self.currentScrollView.frame;
        
        //设置锚点
        self.currentScrollView.layer.anchorPoint=CGPointMake(0.5, 1);
        
        //设置frame会自动根据锚点位置设置position
        self.currentScrollView.frame=oldFrame;
        
        //放大动画
        factor=factorMin;
        [UIView animateWithDuration:0.2 animations:^{
            //缩放
            self.currentScrollView.transform=CGAffineTransformMakeScale(factor, factor);
            //设置透明度
            [self setAllVisibleCellsSubviewsAlpha];
            
            //缩小
            if (factor ==factorMin ) {
                self.currentScrollView.pagingEnabled=NO;//翻页功能
                
                //让scrollView滚动scrollView平移的相反距离
                CGPoint pp=self.currentScrollView.contentOffset;
                pp.x-=self.currentScrollView.frame.origin.x/factorMin;//缩小到0.45。先滚动再平移。。。
                self.currentScrollView.contentOffset=pp;
            }
            
            //放缩结束，scrollView都与屏幕同宽，摆正位置
            CGRect frame=self.currentScrollView.frame;
            frame.origin.x=0;
            frame.size.width=self.view.frame.size.width;
            self.currentScrollView.frame=frame;
            
        }];
    }
}

//- (void)shareActivityBtnClick {
//    self presentViewController:self. animated:<#(BOOL)#> completion:^{
//    <#code#>
//}

//    [self.view addSubview:self.indexController.shareActivityVC.view];
//    self.indexController.shareActivityVC.view.alpha=1;
//}

#pragma mark
#pragma mark 初始化下滑手势
-(void)initPanGestureSlideDown {
    panGestureSlideDown=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePanGestureSlideDown:)];
    panGestureSlideDown.delegate=self;
    [self.view addGestureRecognizer:panGestureSlideDown];
    
//    [self.panGestureSlideDown requireGestureRecognizerToFail:self.scrollView.panGestureRecognizerScollView];//修复缩放和下滑消失的手势冲突

}

#pragma mark 初始化覆盖Btn
-(void)initCoverBtn {
    coverBtn=[[UIButton alloc]initWithFrame:self.view.frame];
    [coverBtn addTarget:self
                 action:@selector(slideDownCompleteClickToSlideUp:)
       forControlEvents:UIControlEventTouchUpInside];
    //    coverBtn.userInteractionEnabled=NO;
    //    [self.view addSubview:coverBtn];
    
}
//初始化另一个View

#pragma mark 初始化设置视图
-(void)initSettingView {
    if (settingView) {
        return;
    }
    
    settingViewController =[[HSSettingViewController alloc]init];
    settingView=settingViewController.view;
    //    settingView=[[UIView alloc]initWithFrame:self.view.frame];
    //    settingView.backgroundColor=[UIColor whiteColor];
    settingView.alpha=0;
//    [UIApplication sharedApplication].keyWindow.backgroundColor=[UIColor blackColor];
    [[UIApplication sharedApplication].keyWindow insertSubview:settingView belowSubview:self.view];
}
////初始化设置视图 屏幕截图版
//-(void)initSettingView2 {
//    settingView=[[UIView alloc]initWithFrame:self.view.frame];
//    settingView.backgroundColor=[UIColor redColor];
//    //    NSLog(@"%@",settingView);
//
//    screenShotImageView=[[UIImageView alloc]initWithFrame:self.view.frame];
//    screenShotImageView.image=[self getScreenShoot];
//    //    NSLog(@"%@",screenShotImageView);
//
//    //    NSLog(@"%@",screenShotImageView.image);
//    [settingView addSubview:screenShotImageView];
//
//    [self.view addSubview:settingView];
//    //    [self.view bringSubviewToFront:settingView];
//}

#pragma mark 处理下滑手势

-(void)handlePanGestureSlideDown :(UIPanGestureRecognizer *)gesture {
    
    static BOOL settingViewOnScreen=NO;//设置视图是否显示
    
    if (gesture.state==UIGestureRecognizerStateBegan) {
        
        NSLog(@"下滑手势开始");
        //评论视图什么的，通通收回去
        [[NSNotificationCenter defaultCenter]postNotificationName:@"狼来了" object:nil];
        
        //        if (settingViewOnScreen==NO) {
        //            //初始化设置视图，然后插入到keyWindow上面，self.view下面
        //            [self initSettingView];
        //
        //        } else if (settingViewOnScreen==YES) {
        //
        //        }
        //初始化设置视图，然后插入到keyWindow上面，self.view下面
        [self initSettingView];
        
        
    } else if (gesture.state==UIGestureRecognizerStateChanged){
        //获取手势的位移
        CGPoint translation=[gesture translationInView:self.view];
        CGRect frame=self.view.frame;
        
        //上下平移
        frame.origin.y+=translation.y;
        //上部不能上移超出屏幕，比如登录进来就往上滑
        if (frame.origin.y<0) {
            frame.origin.y=0;
        }
        self.view.frame=frame;
        
        //设置透明度
        settingView.alpha=self.view.frame.origin.y/self.view.frame.size.height;
        
        //清空手势的位移，因为位移是累加的。
        [gesture setTranslation:CGPointMake(0, 0) inView:self.view];
        
    } else if (gesture.state==UIGestureRecognizerStateEnded) {
        
        //判断是否要显示设置视图
        //速度velocity.y>0是往下平移
        if ([panGestureSlideDown velocityInView:self.view].y>0) {
            settingViewOnScreen=NO;//==NO表示没有显示设置视图，要把它显示出来
        } else {
            settingViewOnScreen=YES;
        }
        
        //==NO表示没有显示设置视图，要把它显示出来
        if (settingViewOnScreen==NO) {
            
            settingViewOnScreen=YES;
            
            [UIView animateWithDuration:0.3 animations:^{
                CGRect frame=self.view.frame;
                //                frame.origin.y=[UIScreen mainScreen].bounds.size.height*0.8;
                frame.origin.y=self.settingViewController.getSettingViewHeight;
                self.view.frame=frame;
                
                settingView.alpha = 1;
                
            }completion:^(BOOL finished) {
                
                //                coverBtn.userInteractionEnabled=YES;
                [self.view addSubview:coverBtn];
                [[UIApplication sharedApplication].keyWindow bringSubviewToFront:self.view];
                [[UIApplication sharedApplication].keyWindow insertSubview:self.view aboveSubview:settingView];
                
            }];
            
        }
        //==YES表示已经显示设置视图，要把它隐藏出来
        else if (settingViewOnScreen==YES) {
            
            settingViewOnScreen=NO;
            
            [UIView animateWithDuration:0.3 animations:^{
                CGRect frame=self.view.frame;
                frame.origin.y=0;
                self.view.frame=frame;
                
                settingView.alpha = 0;
                
            }completion:^(BOOL finished) {
                [settingView removeFromSuperview];
                settingView=nil;
                settingViewController=nil;
                //                coverBtn.userInteractionEnabled=NO;
                [coverBtn removeFromSuperview];
                [[UIApplication sharedApplication].keyWindow bringSubviewToFront:self.view];
                [[UIApplication sharedApplication].keyWindow insertSubview:self.view aboveSubview:settingView];
                
            }];
        }
//        NSLog(@"self.view.frame = %@",NSStringFromCGRect(self.view.frame));
    }//end of gesture.state==UIGestureRecognizerStateEnded
    else if (gesture.state==UIGestureRecognizerStateCancelled) {
//        NSLog(@"handlePanGestureSlideDown cancel");
        settingViewOnScreen=YES;
        
        [UIView animateWithDuration:0.3 animations:^{
            CGRect frame=self.view.frame;
            //                frame.origin.y=[UIScreen mainScreen].bounds.size.height*0.8;
            frame.origin.y=self.settingViewController.getSettingViewHeight;
            self.view.frame=frame;
            
            settingView.alpha = 1;
            
        }completion:^(BOOL finished) {
            
            //                coverBtn.userInteractionEnabled=YES;
            [self.view addSubview:coverBtn];
        }];
    }
}

#pragma mark 点击让self.view上滑
- (void)slideDownCompleteClickToSlideUp:(UIButton *)btn {
    
    [UIView animateWithDuration:0.2 animations:^{
        CGRect frame=self.view.frame;
        frame.origin.y=0;
        self.view.frame=frame;
        
        settingView.alpha = 0;
        
    }completion:^(BOOL finished) {
        [coverBtn removeFromSuperview];
    }];
}

#pragma mark 获取屏幕截图
- (UIImage *)getScreenShoot {
    UIGraphicsBeginImageContext(self.view.frame.size);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

#pragma mark
- (void)slideDownTheGroupChapTableView:(NSNotification *)notification {
    factor=factorMin;
    [UIView animateWithDuration:0.2 animations:^{
        //缩放
        self.currentScrollView.transform=CGAffineTransformMakeScale(factor,factor);
        //获取然后设置透明度
        [self setAllVisibleCellsSubviewsAlpha];
        
        //缩小
        if (factor ==factorMin ) {
            self.currentScrollView.pagingEnabled=NO;//翻页功能
            
            //让scrollView滚动scrollView平移的相反距离
            CGPoint pp=self.currentScrollView.contentOffset;
            pp.x-=self.currentScrollView.frame.origin.x/factorMin;//缩小到了factorMin。先滚动再平移。。。
            self.currentScrollView.contentOffset=pp;
        }
        
        //放缩结束，scrollView都与屏幕同宽，摆正位置
        CGRect frame=self.currentScrollView.frame;
        frame.origin.x=0;
        frame.size.width=self.view.frame.size.width;
        self.currentScrollView.frame=frame;
    }completion:^(BOOL finished) {
        self.currentScrollView.clipsToBounds=YES;
        
        //            self.indexController.scrollView.clipsToBounds=YES;
        //            self.activityController.scrollView.clipsToBounds=YES;
        //            self.mineController.scrollView.clipsToBounds=YES;
        //            self.groupController.scrollView.clipsToBounds=YES;
    }];
}

#pragma mark 点击放大footerView
- (void)footerViewClick {
    NSLog(@"点击了footerView");
    //    NSLog(@"\n手势所在View的frame %@\n",NSStringFromCGRect(self.panGestureRecognizerScollView.view.frame));
    
    //如果是缩小的
    if(factor==factorMin) {
        
        //用来设置position
        CGRect oldFrame=self.currentScrollView.frame;
        
        //        //计算锚点的x
        float anchorPointX=[self.currentPanGestureRecognizerScollView locationInView:self.view].x/self.view.frame.size.width;
        
        //设置锚点
        self.currentScrollView.layer.anchorPoint=CGPointMake(anchorPointX, factorMin);
        
        //设置frame会自动根据锚点位置设置position
        self.currentScrollView.frame=oldFrame;
        
        //放大动画
        factor=factorMax;
        [UIView animateWithDuration:0.2 animations:^{
            //缩放
            self.currentScrollView.transform=CGAffineTransformMakeScale(factor,factor);
            
            //获取然后设置透明度
            [self setAllVisibleCellsSubviewsAlpha];
            
            if(factor == factorMax) {
                self.currentScrollView.pagingEnabled=YES;
                
                CGPoint newContentOffset=CGPointZero;
                newContentOffset.x=self.currentCollectionView.frame.size.width+1;
                self.currentScrollView.contentOffset=newContentOffset;
                
                //放缩结束，scrollView都与屏幕同宽，摆正位置
                CGRect frame=self.currentScrollView.frame;
                frame.origin.x=0;
                frame.size.width=self.view.frame.size.width;
                self.currentScrollView.frame=frame;
            }
        }];
    }
}

#pragma mark 点击放大headerView
- (void)headerViewClick {
    NSLog(@"点击了headerView");
    //    NSLog(@"\n手势所在View的frame %@\n",NSStringFromCGRect(self.panGestureRecognizerScollView.view.frame));
    
    //如果是缩小的
    if(factor==factorMin) {
        
        //用来设置position
        CGRect oldFrame=self.currentScrollView.frame;
        
        //        //计算锚点的x
        float anchorPointX=[self.currentPanGestureRecognizerScollView locationInView:self.view].x/self.view.frame.size.width;
        
        //设置锚点
        self.currentScrollView.layer.anchorPoint=CGPointMake(anchorPointX, factorMin);
        
        //设置frame会自动根据锚点位置设置position
        self.currentScrollView.frame=oldFrame;
        
        //放大动画
        factor=factorMax;
        [UIView animateWithDuration:0.2 animations:^{
            //缩放
            self.currentScrollView.transform=CGAffineTransformMakeScale(factor,factor);
            
            //获取然后设置透明度
            [self setAllVisibleCellsSubviewsAlpha];
            
            if(factor == factorMax) {
                self.currentScrollView.pagingEnabled=YES;
                
                CGPoint newContentOffset=CGPointZero;
                newContentOffset.x=self.currentCollectionView.frame.size.width+1;
                self.currentScrollView.contentOffset=newContentOffset;
                
                //放缩结束，scrollView都与屏幕同宽，摆正位置
                CGRect frame=self.currentScrollView.frame;
                frame.origin.x=0;
                frame.size.width=self.view.frame.size.width;
                self.currentScrollView.frame=frame;
            }
        }];
    }
}

//- (void)initCommentViewController {
//    commentVC =[[HSCommentViewController alloc]init];
//}


#pragma mark 刷新
#pragma mark 上下拉刷新
- (void)addRefresh {
    //todo;
    //    //添加第三方的刷新动画
    //    [self.indexController.scrollView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(getDataAndRemoveOldData)];
    //    [self.indexController.scrollView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(getData)];
}

- (void)endRefresh {
    //停止tableview的刷新动画
    //    [self.indexController.scrollView.header endRefreshing];
    //    [self.indexController.scrollView.footer endRefreshing];
    
}

- (void)getDataAndRemoveOldData {
    //    [FindDataArray removeAllObjects];
    //    [self getData];
    
    [self performSelector:@selector(endRefresh) withObject:nil afterDelay:2.0];
}

- (void)getData {
    [self performSelector:@selector(endRefresh) withObject:nil afterDelay:2.0];
    
}


#pragma mark

//7.6 模块化定制
#pragma mark 模块化定制
- (void)initArrays {
    controllerNameArray = [[NSMutableArray alloc]init];
    controllerArray = [[NSMutableArray alloc]init];
    scrollViewArray = [[NSMutableArray alloc]init];
    collectionViewArray = [[NSMutableArray alloc]init];
    panGestureRecognizerArray = [[NSMutableArray alloc]init];
    
    
    [controllerNameArray addObject:@"HSGameRootViewController"];
    [controllerNameArray addObject:@"HSInviteFriendsVC"];  //changed by qiang on 7.8
    [controllerNameArray addObject:@"HSIndexController"];
    //    [controllerNameArray addObject:@"HSActivityController"];
    //    [controllerNameArray addObject:@"HSGroupController"];
    [controllerNameArray addObject:@"HSActivityOnlineController"];
}

#pragma mark 啪啪啪
- (void)addScrollViews {
    
    for (UIScrollView *sv in scrollViewArray) {
        [self.view addSubview:sv];
    }
    [self calculatFramesWithoutAnimation];
//    [self calculatScrollViewsFrameWithTag:1];
}

#pragma mark 计算各个控制器的scrollview的frame
- (void)calculatScrollViewsFrameWithTag:(int)n {
    
    [UIView animateWithDuration:0.2 animations:^{
        UIScrollView *sv;
        CGRect f;
        
        for (int i=0; i<scrollViewArray.count; i++) {
            sv=(UIScrollView *)scrollViewArray[i];
            f=sv.frame;
            
            f.origin.x=(-n+i)*kScreenWidth;
            sv.frame=f;
        }
    }];
}
- (void)calculatFramesWithoutAnimation {
    UIScrollView *sv;
    CGRect f;
    
    for (int i=0; i<scrollViewArray.count; i++) {
        sv=(UIScrollView *)scrollViewArray[i];
        f=sv.frame;
        
        f.origin.x=i*kScreenWidth;
        sv.frame=f;
    }
}

#pragma mark 初始化各个模块的控制器
- (void)initControllers {
    
    self.pageControl.numberOfPages=controllerArray.count;
    
    [controllerArray removeAllObjects];
    [scrollViewArray removeAllObjects];
    [collectionViewArray removeAllObjects];
    [panGestureRecognizerArray removeAllObjects];
    
    for (NSString *name in controllerNameArray) {
        if ([name isEqualToString:@"HSIndexController"]) {
            self.indexController=[[HSIndexController alloc]init];
            [controllerArray addObject:self.indexController];
            [scrollViewArray addObject:self.indexController.scrollView];
            [collectionViewArray addObject:self.indexController.collectionView];
            
        } else if ([name isEqualToString:@"HSActivityController"]) {
            self.activityController=[[HSActivityController alloc]init];
            [controllerArray addObject:self.activityController];
            [scrollViewArray addObject:self.activityController.scrollView];
            [collectionViewArray addObject:self.activityController.collectionView];
            
        } else if ([name isEqualToString:@"HSGroupController"]) {
            self.groupController=[[HSGroupController alloc]init];
            [controllerArray addObject:self.groupController];
            [scrollViewArray addObject:self.groupController.scrollView];
            [collectionViewArray addObject:self.groupController.collectionView];
            
        } else if([name isEqualToString:@"HSInviteFriendsVC"]){  //changed by qinag on 7.8
            self.inviteController = [[HSInviteFriendsVC alloc] init];
            [controllerArray addObject:self.inviteController];
            [scrollViewArray addObject:self.inviteController.scrollView];
            [collectionViewArray addObject:self.inviteController.collectionView];
        } else if([name isEqualToString:@"HSActivityOnlineController"]){  //changed by qinag on 7.8
            self.activityOnlineController= [[HSActivityOnlineController alloc] init];
            [controllerArray addObject:self.activityOnlineController];
            [scrollViewArray addObject:self.activityOnlineController.scrollView];
//            NSLog(@" %@",self.activityOnlineController.collectionView);

            [collectionViewArray addObject:self.activityOnlineController.collectionView];
            
//            NSLog(@"controllerArray %@",controllerArray);
//            NSLog(@"scrollViewArray %@",scrollViewArray);
//            NSLog(@"collectionViewArray %@",collectionViewArray);
        } else if ([name isEqualToString:@"HSGameRootViewController"]) {
            self.gameRootViewController  = [[HSGameRootViewController alloc]init];
            [controllerArray addObject:self.gameRootViewController];
            
            [scrollViewArray addObject:self.gameRootViewController.scrollView];
            [collectionViewArray addObject:self.gameRootViewController.scrollView.collectionView];

        }
        else {
            
        }
    }
    for (UIView *view in scrollViewArray) {
        view.clipsToBounds = YES;
    }
    
    //尝试修复detached的警告
    [self addChildViewController:self.inviteController];
    [self addChildViewController:self.indexController];
    [self addChildViewController:self.activityOnlineController];
}

#pragma mark 给各个scrollView添加缩放手势
- (void)addGesturesToScrollViews {
    
    long count=controllerNameArray.count;
    [panGestureRecognizerArray removeAllObjects];
    
    for (int i=0; i<count; i++) {
        UIPanGestureRecognizer *pan=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePanScollView:)];
        pan.delegate=self;
        [panGestureRecognizerArray addObject:pan];
    }
    
    
    
    UIScrollView *sv;
    UIGestureRecognizer *pan;
    
    for (int i=0; i<count; i++) {
        pan=(UIPanGestureRecognizer *)panGestureRecognizerArray[i];
        sv=(UIScrollView *)scrollViewArray[i];
        
        if (i!=2) {
            continue;
        }
//        [sv addGestureRecognizer:pan];
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell;
    
    if (collectionView==self.rootCollectionView) {
        
        UIViewController *vc=(UIViewController *)controllerArray[indexPath.row];
        vc.view.frame=[UIApplication sharedApplication].keyWindow.bounds;
        
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
        
        //changed by qiang on 7-9
        //        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        //        [cell.contentView addSubview:nav.view];
        
        [cell.contentView addSubview:vc.view];
    }
    
//    if(collectionView==self.bottomCollectionView){
//        
//        cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifierBottom forIndexPath:indexPath];
//    }
    
    return cell;
}

#pragma mark 设置当前缩放的scollView
- (void)setCurrentScrollViewAndCollectionViewAndPanGestureRecognizer {
    
    self.currentScrollView=scrollViewArray[currentControllerTag];
    self.currentCollectionView=collectionViewArray[currentControllerTag];
    self.currentPanGestureRecognizerScollView=panGestureRecognizerArray[currentControllerTag];
    
    self.currentCollectionView.delegate=self;
    self.currentScrollView.clipsToBounds=YES;
    
}

- (void)initRongCloud{
    //用户个人信息
    //获取个人信息
    self.userInfoControl = [[HSUserInfoHandler alloc]init];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    //RCIM
    if([userDefaults objectForKey:@"user_id"]){
        [self initRCIM:[userDefaults objectForKey:@"user_id"]];
    }else{
        [self.userInfoControl getUserInfoAndSaveHandler:^(BOOL completion){
            
            if(completion){
                if([userDefaults objectForKey:@"user_id"]){
                    [self initRCIM:[userDefaults objectForKey:@"user_id"]];
                }else{
                    NSLog(@"获取融云聊天id失败");
                    ShowHud(@"聊天初始化失败", NO);
                }
            }
        }];
    }
}

#pragma mark RCIM
- (void)initRCIM:(NSString*)token{
    
    // 初始化 SDK，传入 App Key，deviceToken 暂时为空，等待获取权限。
    //    [RCIM initWithAppKey:@"x18ywvqf8dhwc" deviceToken:nil];
    [[RCIM sharedKit] initWithAppKey:@"cpj2xarljqobn" deviceToken:nil];    //开发环境
    
    //需要向后台请求token
    // 快速集成第二步，连接融云服务器
    //    NSString *token = @"pSuSfyWLL15qDs6NGg6FItGtQfYVwcTOdszM2MN6Wo1IdkOcb4CGiyYtVhRYzuXxHw+jEogwPCc=";
    [[RCIM sharedKit] connectWithToken:token success:^(NSString *userId) {
        // Connect 成功
        //        ShowHud(@"聊天初始化成功", NO);
    } error:^(RCConnectErrorCode status) {
        // Connect失败
    }];
}

#pragma mark  获取到了推送的通知  强 on 7.8
//        滑到约伴页面
- (void) pushInfoShow:(NSNotification *)noti{
    //    self.inviteController = [[HSInviteFriendsVC alloc] init];//todo
    if(noti.object){
        [[NSNotificationCenter defaultCenter]postNotificationName:@"notificationHSInviteFriendsView" object:noti.object];
        //        [self presentViewController:self.inviteController animated:YES completion:nil];
        //        滑到推送页面
        NSIndexPath *indexPath=[NSIndexPath indexPathForItem:0 inSection:0];
        [self.rootCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        
        currentControllerTag=(int)self.pageControl.currentPage; //NSInteger *nn;nn
        [self calculatScrollViewsFrameWithTag:currentControllerTag-1];
        
        self.pageControl.currentPage -- ;
    }
}

#pragma mark  应用关闭时获取到了推送的通知  强 on 7.8
-(void) pushInfoShowWithAppClosed:(NSString *)message{
    self.inviteController = [[HSInviteFriendsVC alloc] init];//todo
    if(message){
        [[NSNotificationCenter defaultCenter]postNotificationName:@"notificationHSInviteFriendsView" object:message];
        [self presentViewController:self.inviteController animated:YES completion:nil];
        //        滑到推送页面
        NSIndexPath *indexPath=[NSIndexPath indexPathForItem:0 inSection:0];
        [self.rootCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        
        currentControllerTag=(int)self.pageControl.currentPage; //NSInteger *nn;nn
        [self calculatScrollViewsFrameWithTag:currentControllerTag-1];
        self.pageControl.currentPage -- ;
        
    }
}
#pragma mark 滚动到ugc界面
- (void)scrollToUGC {
    //1、获取ugc下标
    int indexOfHSIndexController = 0; //ugc模块的下标
    for (NSString *string in controllerNameArray) {
        if ([string isEqualToString:@"HSIndexController"]) {
            indexOfHSIndexController = (int)[controllerNameArray indexOfObject:string];
            break;
        }
    }
    
    //2、滚动到ugc模块
    NSIndexPath *indexpath = [NSIndexPath indexPathForItem:indexOfHSIndexController inSection:0];
    [self.rootCollectionView scrollToItemAtIndexPath:indexpath
                                    atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
                                            animated:NO];
    self.currentControllerTag=indexOfHSIndexController;
    [self calculatScrollViewsFrameWithTag:indexOfHSIndexController];
    self.pageControl.currentPage=indexOfHSIndexController;
}

//- (void)activityOnlineTapTopImageView :(NSNotification *)notifi {
//    factor = factorMax;
//}

@end
