//
//  HSActivityOnlineController.m
//  LiveForest
//
//  Created by 余超 on 15/7/28.
//  Copyright © 2015年 HOTeam. All rights reserved.
//

#import "HSActivityOnlineController.h"
//#import "HSTabBarController.h"
#import "Macros.h"

#import "HSActivityCardView.h"
#import "HSActivityCardViewController.h"
#import "HSDisplayPicActivity.h"
#import "HSPicActivityInfo.h"
#import "HSShareInfo.h"

@interface HSActivityOnlineController ()

@property (nonatomic, strong) HSActivityCardViewController *cardViewController;
/**
 *  存放弹窗数组中的图片信息
 */
@property (nonatomic, strong) NSMutableArray *tmpPicImageArray;
/**
 *存放晒图活动详情信息
 */
@property (nonatomic, strong) NSMutableArray *picActivityInfoArray;

@end

@implementation HSActivityOnlineController
//@synthesize collectionView;
//@synthesize scrollView;
//4.11
static long n=4;
static NSString * const reuseIdentifier = @"Cell";
//@synthesize scrollView;
@synthesize panGestureRecognizerScollView;
@synthesize currentCellIndexPath;

@synthesize collectionView = _collectView;
//@synthesize arrayOfCells = _arrayOfCells;


@synthesize smallLayout = _smallLayout;

@synthesize activityView = _activityView;

@synthesize galleryImages = _galleryImages;
@synthesize slide = _slide;
@synthesize cardViewControllerArray;
@synthesize cardViewController;
@synthesize cardViewArray;

//- (NSMutableArray *)cardViewArray {
//    if (!cardViewArray) {
//        cardViewArray = [[NSMutableArray alloc]initWithCapacity:n];
//    }
//    return cardViewArray;
//}


- (void)test {
//    @property (nonatomic, copy) NSString *activity_id;
//    @property (nonatomic, copy) NSString *activity_name;
//    @property (nonatomic, copy) NSString *activity_summary;
//    /**
//     *  图片路径数组，展示第一张
//     */
//    @property (nonatomic, strong)NSArray *activity_img_path;
//    
//    @property (nonatomic, copy) NSString *activity_user_num;
//    @property (nonatomic, copy) NSString *attended_friend_num;

    HSDisplayPicActivity *act = [HSDisplayPicActivity new];
    act.activity_img_path = @[@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1493125014725&di=201748ecaef56b2ddcdef1d8c58e107b&imgtype=0&src=http%3A%2F%2Fm2.quanjing.com%2F2m%2Frubrf004%2Frubrfb12933c.jpg",
                              @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1493124909008&di=9d868e90cf987c79eb8cc5ba2cd454b4&imgtype=0&src=http%3A%2F%2Fi2.sinaimg.cn%2Ftravel%2F2015%2F0121%2FU9971P704DT20150121171152.jpg",
                              @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1493125065541&di=5c4b9ed3297995a3604220978f99a5e4&imgtype=0&src=http%3A%2F%2Fimg.sc115.com%2Fuploads%2Fshows%2F140218%2F20140218742.jpg"];
    act.activity_img_path = @[@"http://www.kuaihou.com/uploads/allimg/130130/1-1301300103061P.jpg",
      @"http://www.sznews.com/travel/images/attachement/jpg/site3/20150603/7427ea33bc7416d8b93b4c.jpg",
      @"http://img2.niutuku.com/desk/anime/1913/1913-7515.jpg",
      @"http://t1.niutuku.com/960/22/22-435778.jpg",
      @"http://g.hiphotos.baidu.com/zhidao/wh%3D450%2C600/sign=aef92f0b09f79052ef4a4f3a39c3fbfc/aa64034f78f0f736219e10190a55b319ebc41341.jpg",
      @"http://pic.wenwen.soso.com/p/20091004/20091004223808-749075817.jpg",
      @"http://dynamic-image.yesky.com/600x-/uploadImages/2012/229/62SW1O3LI8UQ.jpg",
      @"http://e.hiphotos.baidu.com/zhidao/pic/item/342ac65c103853431f0bcc079313b07ecb8088d4.jpg",
      @"http://s3.sinaimg.cn/orignal/4c42990eaf4e962a49782"];
    act.activity_name = @"活动名";
    act.activity_id = @"123";
    act.activity_summary = @"概述";
    act.activity_user_num = @"10";
    act.attended_friend_num = @"10";
    self.picActivityArray = @[act, act, act,act,act].mutableCopy;
//    self.picActivityArray = [HSDisplayPicActivity displayPicActivityWithArray:responseObject];
    
    


    for (HSDisplayPicActivity * picActivity in self.picActivityArray) {
        HSPicActivityInfo *picActivityInfo = [HSPicActivityInfo new];
        picActivityInfo.activity_name = @"活动名";
        picActivityInfo.activity_summary = @"概述";
        picActivityInfo.activity_img_path = picActivity.activity_img_path;
        picActivityInfo.shareList = nil;// 不可变数组

        [self.picActivityInfoArray addObject:picActivityInfo];
        int index = (int)[self.picActivityArray indexOfObject:picActivity];
        if (cardViewArray.count > 0) {
            HSActivityCardView *cardView = (HSActivityCardView *)cardViewArray[index > cardViewArray.count - 1?cardViewArray.count - 1:index ];
            cardView.picActivityInfo = picActivityInfo;
//                    cardView.shareInfoArray = [NSMutableArray arrayWithArray:picActivityInfo.shareList];
            [cardView.tableView reloadData];
        }
    }
    
        
        
        
    n = [self.picActivityArray count];
    
    [self.scrollView reloadDataWithArrayCount:self.picActivityArray.count];

}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init {
    self = [super init];
    cardViewArray = [[NSMutableArray alloc]initWithCapacity:n];
    
    if (self) {
        
        //请求数据
        self.requestDataCtrl = [[HSRequestDataController alloc] init];
        
        self.tmpPicImageArray = [[NSMutableArray alloc]init];
        
        self.picActivityArray = [[NSMutableArray alloc]init];
        
        self.picActivityInfoArray = [[NSMutableArray alloc]init];
        
//        _arrayOfCells = [[NSMutableArray alloc]init];
        
        _galleryImages = [[NSArray alloc]init];
        
        
        _activityView = [[HSActivityView alloc]init];
        //        _activityView.frame = CGRectMake(kScreenWidth, 0, kScreenWidth, kScreenHeight);
        _activityView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        
        arraySmall=[[NSMutableArray alloc]init];
        arrayLarge=[[NSMutableArray alloc]init];
        visibleCells=[[NSArray alloc]init];
        
        //初始化collection View和scroll View
//        [self initCollectionViewAndScrollView];
        HSCollectionViewSmallLayout *smallLayout = [[HSCollectionViewSmallLayout alloc] init];
        CGRect collectionViewFrame=CGRectMake(0, 0, kScreenWidth*n,kScreenHeight);
        self.collectionView = [[UICollectionView alloc] initWithFrame:collectionViewFrame collectionViewLayout:smallLayout];
        self.scrollView = [[HSScaleScrollView alloc]initWithCellCount:n Delegate:self shouldGetMoreData:NO];
        [self.view addSubview:self.scrollView];

        
        //7.21
        [self initCardViewController];
        
        
        [self addTopBtnClickToScaleObserver];
        
        
        //异步
        //1.获得全局的并发队列
        dispatch_queue_t queue =  dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        //2.添加任务到队列中，就可以执行任务
        //异步函数：具备开启新线程的能力
        dispatch_async(queue, ^{
            //请求数据
            NSLog(@"开始请求数据");
            //请求线上晒图活动
            [self getDisplayPicActivity];
            
        });
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
//    self.navigationBar.hidden = YES;
    
    if(_activityView){
        [self.view addSubview:_activityView];
        _activityView.createActivity.hidden = YES;
        _activityView.topImage.image = [UIImage imageNamed:@"activityHome.jpg"];
        _activityView.topImage.contentMode=UIViewContentModeScaleAspectFill;
        _activityView.topImage.clipsToBounds = YES;
        
        //点击topImage事件
        UITapGestureRecognizer *tapTopImage = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapTopImagePress:)];
        [_activityView.topImage addGestureRecognizer:tapTopImage];
        _activityView.topImage.userInteractionEnabled = YES;
        
        _activityView.reflectedImage.image = [UIImage imageNamed:@"activityHome.jpg"];
        _activityView.reflectedImage.contentMode=UIViewContentModeScaleAspectFill;
        _activityView.reflectedImage.transform = CGAffineTransformMakeScale(1.0, -1.0);
        _activityView.reflectedImage.clipsToBounds = YES;
        //渐隐
        CAGradientLayer *gradientReflected = [CAGradientLayer layer];
        CGRect rect = _activityView.reflectedImage.bounds;
        rect.size.width = [UIScreen mainScreen].bounds.size.width;
        gradientReflected.frame = rect;
        gradientReflected.colors = @[(id)[[UIColor colorWithRed:0 green:0 blue:0 alpha:1] CGColor],
                                     (id)[[UIColor colorWithWhite:0 alpha:0] CGColor]];
        [_activityView.reflectedImage.layer insertSublayer:gradientReflected atIndex:0];
        
        [_activityView.createActivity addTarget:self action:@selector(createActivity) forControlEvents:UIControlEventTouchUpInside];
        [_activityView.findActivity addTarget:self action:@selector(findActivity) forControlEvents:UIControlEventTouchUpInside];
        [_activityView.NotiBtn addTarget:self action:@selector(NotiBtn) forControlEvents:UIControlEventTouchUpInside];
        //        [_activityView.NotiBtn setImage:[UIImage imageNamed:@"notification.png"] forState:UIControlStateNormal];
        //         [_activityView.NotiBtn setBackgroundColor:[UIColor whiteColor] ];
        
        //shimmer
        _activityView.shimmeringView = [[FBShimmeringView alloc] initWithFrame:CGRectMake(10, 0, 150, 80)];
        [self.view addSubview:_activityView.shimmeringView];
        
        UILabel *loadingLabel = [[UILabel alloc] initWithFrame:_activityView.shimmeringView.bounds];
        loadingLabel.textAlignment = NSTextAlignmentLeft;
        
        loadingLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:25];
        loadingLabel.textColor = [UIColor whiteColor];
        loadingLabel.shadowColor = [UIColor colorWithWhite:0.3f alpha:0.8f];
        loadingLabel.text = NSLocalizedString(@"线上活动", nil);
        //        _indexView.shimmeringView.contentView = loadingLabel;
        _activityView.shimmeringView.contentView = loadingLabel;
        //        _activityView.shimmeringView.shimmeringDirection =
        // Start shimmering.
        _activityView.shimmeringView.shimmeringPauseDuration = 0.1;
        _activityView.shimmeringView.shimmeringAnimationOpacity = 0.3;
        _activityView.shimmeringView.shimmeringSpeed = 40;
        _activityView.shimmeringView.shimmeringHighlightLength = 1;
        //        _activityView.shimmeringView.shimmeringSpeed = 40;
        _activityView.shimmeringView.shimmering = YES;
    }
    
    //幻灯片
    //会获取 缓存的数据
    _slide = 0;
    
    // Loop gallery - fix loop:
    //异步
    //    //1.获得全局的并发队列
    //    dispatch_queue_t queue =  dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //    dispatch_async(queue, ^{
    NSTimer *timer = [NSTimer timerWithTimeInterval:6.0f target:self selector:@selector(changeSlide) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    //    });
    
    //重新加载数据
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadData) name:@"notificationHSReloadData" object:nil];
    
    
    
    [self test];
}
#pragma arrayInit

- (HSActivityCollectionViewCell *)arrayInit:(HSActivityCollectionViewCell *)cell{
    [arrayLarge removeAllObjects];
    [arraySmall removeAllObjects];
    
    arraySmall=[[NSMutableArray alloc]init];
    arrayLarge=[[NSMutableArray alloc]init];
    
    for (int i=1; i<8; i++) {
        [arraySmall addObject:[cell.contentView viewWithTag:i]];
    }
    
    for (int i=8; i<15; i++) {
        [arrayLarge addObject:[cell.contentView viewWithTag:i]];
    }
    
    int k=0;
    cell.backgroundImgSmall=arraySmall[k++];
    cell.avtivityNameSmall=arraySmall[k++];
    cell.publishTimeSmall=arraySmall[k++];
    cell.activityDescriptionSmall=arraySmall[k++];
    cell.activityTimeTagSmall=arraySmall[k++];
    cell.activityTimeSmall=arraySmall[k++];
    cell.activityJoinCountSmall=arraySmall[k++];
    
    k=0;
    cell.backgroundImgLarge=arrayLarge[k++];
    cell.avtivityNameLarge=arrayLarge[k++];
    cell.publishTimeLarge=arrayLarge[k++];
    cell.activityDescriptionLarge=arrayLarge[k++];
    cell.activityTimeTagLarge=arrayLarge[k++];
    cell.activityTimeLarge=arrayLarge[k++];
    cell.mapViewLarge=arrayLarge[k++];
    
    
    return cell;
}

- (void)setSmallAlpha:(HSActivityCollectionViewCell*)cell andwithSec:(float)progress{
    cell.backgroundImgSmall.alpha = progress;
    cell.avtivityNameSmall.alpha = progress;
    cell.publishTimeSmall.alpha = progress;
    cell.activityDescriptionSmall.alpha = progress;
    cell.activityTimeTagSmall.alpha = progress;
    cell.activityTimeSmall.alpha = progress;
    cell.activityJoinCountSmall.alpha = progress;
}
- (void)setLargeAlpha:(HSActivityCollectionViewCell*)cell andwithSec:(float)progress{
    //    cell.avataImgBtnLarge.alpha = progress;
    cell.backgroundImgLarge.alpha = progress;
    cell.avtivityNameLarge.alpha = progress;
    cell.publishTimeLarge.alpha = progress;
    cell.activityDescriptionLarge.alpha = progress;
    cell.activityTimeTagLarge.alpha = progress;
    cell.activityTimeLarge.alpha = progress;
    cell.mapViewLarge.alpha = progress;
}

#pragma collectionView controller
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return self.picActivityArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    //7.21
    static NSString *reuseString=@"HSActivityCardView";
    [collectionView registerClass:[HSActivityCardView class] forCellWithReuseIdentifier:reuseString];
    
    //    HSActivityCardView *cardView=[[HSActivityCardView alloc]init];
    HSActivityCardView *cardView=[collectionView dequeueReusableCellWithReuseIdentifier:reuseString forIndexPath:indexPath];
    cardView.tag=indexPath.row;
    cardView.tableView.tag=cardView.tag;
//    cardView.tableView.delegate = cardViewController;
//    cardView.tableView.dataSource = cardViewController;
    [cardViewArray addObject:cardView];
    
    //官方晒图活动
    [self setValueForCell:cardView withModel:self.picActivityArray[indexPath.row]];
    
    //cell屏幕适配 7.3
    static int width;
    static float factorWidth;
    static float factorHeight;
    static CGAffineTransform transform;
    
    width=[UIScreen mainScreen].bounds.size.width;
    switch (width) {
        case 320:
            factorWidth = 1;
            factorHeight = 1;
            break;
        case 375:
            factorWidth = 1.17;
            factorHeight = 1.174;
            break;
        case 414:
            factorWidth = 1.29;
            factorHeight = 1.296;
            break;
        default:
            factorWidth = 1.17;
            factorHeight = 1.174;
            break;
    }
    transform=CGAffineTransformMakeScale(factorWidth, factorHeight);
    
    CGPoint oldOrigin=cardView.frame.origin;
    float oldWidth=cardView.frame.size.width;
    cardView.transform=transform;
    CGRect newFrame=cardView.frame;
    newFrame.origin=oldOrigin;
    newFrame.size.width=oldWidth;
    cardView.frame=newFrame;
    
    return cardView;
    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

//#pragma mark
//#pragma mark 《手势动画相关》
//#pragma mark <初始化collectionview和scrollView>
//-(void)initCollectionViewAndScrollView {
//    
//    //cell、collectionView、 scrollView与屏幕同高。
//    //cell、scrollView和屏幕一样大，collectionView的宽度是cell的n倍。
//    //scrollView的contentSize是collectionView的frame。
//    //collectionView添加到scrollView后，scrollView缩小为0.45
//    
//    //初始化collectionview
//    HSCollectionViewSmallLayout *smallLayout = [[HSCollectionViewSmallLayout alloc] init];
//    CGRect collectionViewFrame=CGRectMake(0, 0, kScreenWidth*n,kScreenHeight);
//    _collectView = [[UICollectionView alloc] initWithFrame:collectionViewFrame collectionViewLayout:smallLayout];
//    
//    [self.collectionView registerClass:[HSActivityCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
//    self.collectionView.delegate = self;
//    self.collectionView.dataSource = self;
//    self.collectionView.contentInset = UIEdgeInsetsMake(0, 1, 0, 0);//内容的左边距
//    self.collectionView.backgroundColor = [UIColor clearColor];
//    self.collectionView.scrollEnabled=NO;//collectionView不滚动
//    
//    //缩小collectionView，修正位置
//    factor=factorMin;
//    self.collectionView.transform=CGAffineTransformMakeScale(0.45,0.45);
//    collectionViewFrame=self.collectionView.frame;
//    collectionViewFrame.origin.x=0;
//    collectionViewFrame.origin.y=0;
//    self.collectionView.frame=collectionViewFrame;
//    
//    //初始化scrollView
//    float scrollViewHeight=kScreenHeight*0.45;
//    float scrollViewY=kScreenHeight-scrollViewHeight;
//    CGRect scrollViewFrame=CGRectMake(0, scrollViewY, kScreenWidth, scrollViewHeight);
//    self.scrollView=[[UIScrollView alloc]initWithFrame:scrollViewFrame];
//    
//    self.scrollView.contentSize=self.collectionView.frame.size;//设置滑动的范围
//    self.scrollView.pagingEnabled=NO;
//    self.scrollView.showsHorizontalScrollIndicator=YES;
//    self.scrollView.clipsToBounds=NO;//不裁剪越界的collectionView，这样就不用在手势过程中修改宽度了
//    
//    //添加pan手势给scrollView
//    self.panGestureRecognizerScollView=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePanScollView:)];
//    self.panGestureRecognizerScollView.delegate=self;
//    
//    //    [self.scrollView addGestureRecognizer:self.panGestureRecognizerScollView];
//    [self.scrollView addSubview:self.collectionView];
//    //    [self.view addSubview:self.scrollView];
//    
//    //缩小scrollView，摆正位置，把缩小后的scrollView的宽度增大到与屏幕同宽
//    //    factor=factorMin;
//    //    self.scrollView.transform=CGAffineTransformMakeScale(factor,factor);
//    //    scrollViewFrame.origin.x=0;
//    //    scrollViewFrame.origin.y=kScreenHeight-self.scrollView.frame.size.height;
//    //    scrollViewFrame.size.width=kScreenWidth;
//    //    self.scrollView.frame=scrollViewFrame;
//}
//
//#pragma mark <pan手势是否开始>
////要设置手势的delegate=self
//- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer {
//    
//    //手势滑动的距离
//    CGPoint translation=[gestureRecognizer translationInView:self.view];
//    
//    if (translation.x<0)
//        translation.x=-translation.x;
//    if (translation.y<0)
//        translation.y=-translation.y;
//    
//    //判断左右还是上下滑动多，上下滑动较多就开始缩放手势
//    return translation.x>translation.y?NO:YES;
//}
//
//#pragma mark <pan手势处理ScollView>
//- (void)handlePanScollView:(id)sender {
//    //手势开始
//    if ([sender state]==UIGestureRecognizerStateBegan) {
//        //获取放大的cell的index
//        self.currentCellIndexPath=[self.collectionView indexPathForItemAtPoint:[sender locationInView:self.collectionView]];
//        
//        //设置position要用到
//        CGRect oldFrame=self.scrollView.frame;
//        
//        //计算锚点的x
//        float anchorPointX=([sender locationInView:self.view].x-self.scrollView.frame.origin.x)/self.scrollView.frame.size.width;
//        
//        //设置苗点
//        //        self.scrollView.layer.anchorPoint=CGPointMake(anchorPointX, 0.45);
//        self.scrollView.layer.anchorPoint=CGPointMake(anchorPointX, 1);
//        
//        //设置frame会自动根据锚点位置设置position
//        self.scrollView.frame=oldFrame;
//        
//    }
//    //手势改变
//    else if ([sender state]==UIGestureRecognizerStateChanged) {
//        
//        //获取手势x、y轴移动的距离，用x、y表示
//        CGPoint translation=[sender translationInView:self.view];
//        
//        //计算factor
//        factor-=translation.y/100.0;
//        factor=factor>factorMax*1.2?factorMax*1.2:factor;
//        factor=factor<factorMin*0.8?factorMin*0.8:factor;
//        
//        //缩放
//        self.scrollView.transform=CGAffineTransformMakeScale(factor,factor);
//        
//        //设置可视cell的透明度
//        [self setAllVisibleCellsSubviewsAlpha];//先自动获取可视cell再设置透明度
//        
//        //让collectionView在scollView上左右滑动
//        CGPoint pp=self.scrollView.contentOffset;
//        pp.x-=translation.x/factor;
//        self.scrollView.contentOffset=pp;
//        
//        //清除上次的位移，因为是累加的。
//        UIPanGestureRecognizer *p=(UIPanGestureRecognizer *)sender;
//        [p setTranslation:CGPointMake(0, 0) inView:self.view];
//        
//    }
//    //手势结束
//    else if ([sender state]==UIGestureRecognizerStateEnded) {
//        
//        //判断要放大还是缩小
//        factor=factor >= (factorMax+factorMin)/2?factorMax:factorMin;
//        
//        [UIView animateWithDuration:0.2 animations:^{
//            //缩放
//            self.scrollView.transform=CGAffineTransformMakeScale(factor,factor);
//            //获取然后设置透明度
//            [self setAllVisibleCellsSubviewsAlpha];
//            
//            //放大
//            if (factor == factorMax) {
//                self.scrollView.pagingEnabled=YES;//翻页功能
//                
//                //让scrollView滚动到当前的cell
//                CGPoint pp=self.scrollView.contentOffset;
//                pp.x=self.view.frame.size.width * self.currentCellIndexPath.row/factorMax;
//                self.scrollView.contentOffset=pp;
//            }
//            //缩小
//            if (factor ==factorMin ) {
//                self.scrollView.pagingEnabled=NO;//翻页功能
//                
//                //让scrollView滚动scrollView平移的相反距离
//                CGPoint pp=self.scrollView.contentOffset;
//                pp.x-=self.scrollView.frame.origin.x/factorMin;//缩小到了factorMin。先滚动再平移。。。
//                self.scrollView.contentOffset=pp;
//            }
//            
//            //放缩结束，scrollView都与屏幕同宽，摆正位置
//            CGRect frame=self.scrollView.frame;
//            frame.origin.x=0;
//            frame.size.width=self.view.frame.size.width;
//            self.scrollView.frame=frame;
//        }];
//    }
//}
//
//#pragma mark <点击一个cell>
//- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    //如果是缩小的
//    if(factor==factorMin) {
//        //保存放大后要滚动显示的那个cell的index
//        self.currentCellIndexPath=indexPath;
//        //用来设置position
//        CGRect oldFrame=self.scrollView.frame;
//        
//        //计算锚点
//        float anchorPointX=[self.panGestureRecognizerScollView locationInView:self.view].x/self.view.frame.size.width;
//        //设置锚点
//        self.scrollView.layer.anchorPoint=CGPointMake(anchorPointX, factorMin);
//        
//        //设置frame会自动根据锚点位置设置position
//        self.scrollView.frame=oldFrame;
//        
//        //放大动画
//        factor=factorMax;
//        [UIView animateWithDuration:0.2 animations:^{
//            //缩放
//            self.scrollView.transform=CGAffineTransformMakeScale(factor,factor);
//            
//            //获取然后设置透明度
//            [self setAllVisibleCellsSubviewsAlpha];
//            
//            if(factor == factorMax) {
//                self.scrollView.pagingEnabled=YES;
//                
//                //让scrollView滚动到当前的cell
//                CGPoint pp=self.scrollView.contentOffset;
//                pp.x=self.view.frame.size.width*self.currentCellIndexPath.row/factorMax;
//                self.scrollView.contentOffset=pp;
//                
//                //放缩结束，scrollView都与屏幕同宽，摆正位置
//                CGRect frame=self.scrollView.frame;
//                frame.origin.x=0;
//                frame.size.width=self.view.frame.size.width;
//                self.scrollView.frame=frame;
//            }
//        }];
//    }
//}
//#pragma mark 《手势动画结束》
//#pragma mark
//
//#pragma mark <设置所有可视cell的子视图>
//-(void)setAllVisibleCellsSubviewsAlpha {
//    visibleCells=[self.collectionView visibleCells];
//    for (HSActivityCollectionViewCell *cell in visibleCells) {
//        [cell setSubviewsAlphaWithFactor:factor];
//    }
//}

#pragma mark - Change slider
- (void)changeSlide
{
    if([_galleryImages count]>0){
        if(_slide > _galleryImages.count-1) _slide = 0;
        //     _activityView.topImage.image = [UIImage imageNamed:@"Index.jpg"];
        NSDictionary *dic = [_galleryImages objectAtIndex:_slide];
        UIImage *toImage = [dic objectForKey:@"img"];
        //    :@"img",@"activity_name",@"activity_summary"
        NSString *activity_name = [dic objectForKey:@"activity_name"];
        NSString *activity_summary = [dic objectForKey:@"activity_summary"];
        [UIView transitionWithView:self.view
                          duration:0.4
                           options:UIViewAnimationOptionTransitionCrossDissolve | UIViewAnimationCurveEaseInOut |
         UIViewAnimationOptionAllowUserInteraction
                        animations:^{
                            _activityView.topImage.image = toImage;
                            _activityView.reflectedImage.image = toImage;
                            [_activityView.activityName setText:activity_name];
                            [_activityView.locationDescription setText:activity_summary];
                        } completion:nil];
        _slide++;
    }
}



#pragma mark - wf 官方晒图活动模块
#pragma mark  获取系统晒图活动
/**
 *  获取系统晒图活动
 */
- (void)getDisplayPicActivity
{
    //获取用户token
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSString * user_token = [userDefaults objectForKey:@"user_token"];
    if(!user_token){
        NSLog(@"%s,user_token为空",__func__);
        return;
    }
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:user_token,@"user_token",nil];
    NSDictionary *requestData = [[NSDictionary alloc] initWithObjectsAndKeys:[dic JSONString],@"requestData", nil];
    [self.requestDataCtrl getDisplayPicActivityList:requestData andRequestCB:^(BOOL code, NSArray *responseObject, NSString * error) {
        if (code) {
            if (responseObject != nil) {
                self.picActivityArray = [HSDisplayPicActivity displayPicActivityWithArray:responseObject];
                n = [self.picActivityArray count];
                
//                //修改collectionView的大小
//                CGRect frame = _collectView.frame;
//                if (factor==factorMax) {
//                    frame.size.width =kScreenWidth*[self.picActivityArray count];
//                } else {
//                    frame.size.width =kScreenWidth*[self.picActivityArray count]*0.45;
//                }
//                self.scrollView.contentSize = frame.size;
//                _collectView.frame = frame;
//                [self.collectionView reloadData];
                
                [self.scrollView reloadDataWithArrayCount:self.picActivityArray.count];
                
                
                //加载详细信息
                [self getDisplayPicActivityInfo];
                
            }else{
                NSLog(@"晒图官方数据为空");
            }
        }else{
            NSLog(@"%s,code不为0，%@",__func__,error);
        }
    }];
}

#pragma mark wf官方线上晒图活动collectionViewcell赋值
- (void) setValueForCell:(HSActivityCardView *)cell withModel:(HSDisplayPicActivity *)displayPicActivity
{
    //线上活动名称
    [cell.activityNameSmall setText:displayPicActivity.activity_name];
    
    [cell.activityDescriptionSmall setText:displayPicActivity.activity_summary];
    
    NSString *activity_user_num = displayPicActivity.activity_user_num;
    NSString *activityJoinCount = [NSString stringWithFormat:@"已有 %@ 人参加",activity_user_num];
    [cell.activityJoinCountSmall setText:activityJoinCount];
    
    //七牛图片获取
    if([displayPicActivity.activity_img_path count]>0){
        //默认取第一张
//        NSString *imaUrl = [[NSString alloc] initWithFormat:@"%@%s",displayPicActivity.activity_img_path[0] ,QiNiuImageYaSuo];
        
//        NSURL * url = [NSURL URLWithString:[imaUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];//网络图片url
        
        //todo 不能保证顺序
//        [cell.backgroundImgSmall sd_setImageWithURL:url
//                                   placeholderImage:[UIImage imageNamed:@"activity_1.jpg"]
//                                          completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//                                              if (image) {
//                                                  [self.tmpPicImageArray addObject:image];
//                                                  
//                                              }else{
//                                                  [self.tmpPicImageArray addObject:[UIImage imageNamed:@"activity_1.jpg"]];
//                                              }
//                                              //加载轮播图片信息
//                                              if ([self.tmpPicImageArray count] == self.picActivityArray.count) {
//                                                  [self reloadPicGalleryImage];
//                                              }
//                                              
//                                          }];
        //todo 不能保证顺序
        [HSDataFormatHandle getImageWithUri:displayPicActivity.activity_img_path[0] isYaSuo:true imageTarget:cell.backgroundImgSmall defaultImage:[UIImage imageNamed:@"activity_1.jpg"] andRequestCB:^(UIImage *image) {
            if (image) {
                [self.tmpPicImageArray addObject:image];
                
            }else{
                [self.tmpPicImageArray addObject:[UIImage imageNamed:@"activity_1.jpg"]];
            }
            //加载轮播图片信息
            if ([self.tmpPicImageArray count] == self.picActivityArray.count) {
                [self reloadPicGalleryImage];
            }
        }];
        
    }
    else{
        //使用默认的图片
        NSLog(@"返回的图片为空");
        [cell.backgroundImgSmall setImage:[UIImage imageNamed:@"activity_1.jpg"]];
        
    }
    //
}
#pragma mark 加载晒图图片循环播放信息，在数据请求完后调用
-(void)reloadPicGalleryImage
{
    NSMutableArray *picImg = [[NSMutableArray alloc]init];
    
    for(int i=0;i<[self.picActivityArray count];i++){
        HSDisplayPicActivity *displayPicActivity = [self.picActivityArray objectAtIndex:i];
        
        NSString *activity_name = [[NSString alloc]init];
        if(displayPicActivity.activity_name != nil){
            activity_name = displayPicActivity.activity_name;
        }
        else{
            activity_name = @"LiveForest";
        }
        
        NSString *activity_summary = [[NSString alloc]init];
        if(displayPicActivity.activity_summary != nil){
            activity_summary = displayPicActivity.activity_summary;
        }
        else{
            activity_summary = @"活动测试ByLiveForest";
        }
        NSDictionary *dicForMP = [NSDictionary  dictionaryWithObjects:[NSArray arrayWithObjects:displayPicActivity.activity_id,self.tmpPicImageArray[i],activity_name,activity_summary, nil] forKeys:[NSArray arrayWithObjects:@"activity_id",@"img",@"activity_name",@"activity_summary", nil]];
        [picImg addObject:dicForMP];
        
    }
    
    _galleryImages = picImg;
    [self changeSlide];
    
}

#pragma mark 线上活动
- (void)initCardViewController {
    cardViewController=[[HSActivityCardViewController alloc]init];
}
- (void)initCardViewControllers {
    cardViewControllerArray = [[NSMutableArray alloc]init];
    for (int i=0; i<n; i++) {
        HSActivityCardViewController *c=[[HSActivityCardViewController alloc]init];
        [cardViewControllerArray addObject:c];
    }
}

- (HSActivityCardViewController *)cardViewController {
    if (!cardViewController) {
        cardViewController = [[HSActivityCardViewController alloc]init];
    }
    return cardViewController;
}
#pragma mark - 返回官方主题晒图活动详情
- (void)getDisplayPicActivityInfo
{
    NSString *user_token = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_token"];
    if (!user_token) {
        NSLog(@"%s,user_token为空",__func__);
        return;
    }
    if (self.picActivityArray.count > 0) {
        for (HSDisplayPicActivity * picActivity in self.picActivityArray) {
            NSString *activityID = picActivity.activity_id;
            NSDictionary *dict = [[NSDictionary alloc]initWithObjectsAndKeys:user_token,@"user_token",activityID,@"activity_id", nil];
            NSDictionary *requestData = [[NSDictionary alloc]initWithObjectsAndKeys:[dict JSONString],@"requestData", nil];
            [self.requestDataCtrl getDisplayPicActivityInfo:requestData andRequestCB:^(BOOL code, id responseObject, NSString *error) {
                if (code) {
                    HSPicActivityInfo *picActivityInfo = [HSPicActivityInfo picActivityInfoWithDic:responseObject];
                    [self.picActivityInfoArray addObject:picActivityInfo];
//                    NSLog(@"controller  !!!!!!");
//                    NSLog(@"%@",picActivityInfo);
//                    NSLog(@"%@",picActivityInfo.activity_name);
//                    NSLog(@"controller  end !!!!!!");

                    int index = (int)[self.picActivityArray indexOfObject:picActivity];
                    if (cardViewArray.count > 0) {
                        HSActivityCardView *cardView = (HSActivityCardView *)cardViewArray[index > cardViewArray.count - 1?cardViewArray.count - 1:index ];
                        cardView.picActivityInfo = picActivityInfo;
                        //                    cardView.shareInfoArray = [NSMutableArray arrayWithArray:picActivityInfo.shareList];
                        [cardView.tableView reloadData];
                    }
                }else {
                    NSLog(@"%s,%@",__func__,error);
                }
            }];
        }
    }
}
/**
 *  联网后从新加载数据
 */
- (void)reloadData{
    //异步
    //1.获得全局的并发队列
    dispatch_queue_t queue =  dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //2.添加任务到队列中，就可以执行任务
    //异步函数：具备开启新线程的能力
    dispatch_async(queue, ^{
        //请求数据
        NSLog(@"开始请求数据");
        
        [self getDisplayPicActivity];
    });
    
}

#pragma mark 点击topImage
- (void)tapTopImagePress:(UITapGestureRecognizer *)tap{
    
    int index = (int)_slide-1;
    index=index<0?0:index;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
    [self.scrollView scaleFromIndexPath:indexPath];
}
//- (void)tapTopImagePress:(UITapGestureRecognizer *)tap{
//    //    if([_galleryImages count]>0){
//    //        if([[[_officialArray objectAtIndex:0] class] isKindOfClass:[NSDictionary class]]){
//    //
//    //            if(_slide == 0){
//    //                [offView getShareInfoWithDic:[_officialArray objectAtIndex:[_officialArray count]-1]];
//    //            }
//    //            else{
//    //                [offView getShareInfoWithDic:[_officialArray objectAtIndex:_slide-1]];
//    //            }
//    //            UIWindow *appWindow = [[UIApplication sharedApplication] keyWindow];
//    //            //            [appWindow insertSubview:offView.view aboveSubview:appWindow.rootViewController.view];
//    //
//    //            CGRect frame=self.view.frame;
//    //            frame.origin.y=kScreenHeight;
//    //            offView.view.frame=frame;
//    //
//    //            [UIView animateWithDuration:0.3 animations:^{
//    //                [appWindow insertSubview:offView.view aboveSubview:appWindow.rootViewController.view];
//    //                CGRect frame=self.view.frame;
//    //                frame.origin.y=0;
//    //                offView.view.frame=frame;
//    //
//    //            }completion:^(BOOL finished) {
//    //            }];
//    //            //            [self.view insertSubview:offView.view aboveSubview:self.scrollView];
//    //            //            [self presentViewController:offView animated:YES completion:nil];
//    //        }
//    //        else{
//    //            ShowHud(@"数据异常", NO);
//    //        }
//    //    }
//    //    else{
//    //        ShowHud(@"数据异常", NO);
//    //        //构造静态数据等处理
//    //
//    //    }
//    
//    int index = (int)_slide-1;
//    index=index<0?0:index;
//    
//    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
//    //保存放大后要滚动显示的那个cell的index
//    self.currentCellIndexPath=indexPath;
//    //用来设置position
//    CGRect oldFrame=self.scrollView.frame;
//    
//    //计算锚点
//    float anchorPointX=[self.panGestureRecognizerScollView locationInView:self.view].x/self.view.frame.size.width;
//    //设置锚点
//    self.scrollView.layer.anchorPoint=CGPointMake(anchorPointX, factorMin);
//    self.scrollView.layer.anchorPoint=CGPointMake(0.5, factorMin);
//    
//    //设置frame会自动根据锚点位置设置position
//    self.scrollView.frame=oldFrame;
//    
//    //放大动画
//    factor=factorMax;
//    [UIView animateWithDuration:0.2 animations:^{
//        //缩放
//        self.scrollView.transform=CGAffineTransformMakeScale(factor,factor);
//        
//        //获取然后设置透明度
//        [self setAllVisibleCellsSubviewsAlpha];
//        
//        if(factor == factorMax) {
//            self.scrollView.pagingEnabled=YES;
//            
//            //让scrollView滚动到当前的cell
//            CGPoint pp=self.scrollView.contentOffset;
//            pp.x=self.view.frame.size.width*self.currentCellIndexPath.row/factorMax;
//            self.scrollView.contentOffset=pp;
//            
//            //放缩结束，scrollView都与屏幕同宽，摆正位置
//            CGRect frame=self.scrollView.frame;
//            frame.origin.x=0;
//            frame.size.width=self.view.frame.size.width;
//            self.scrollView.frame=frame;
//        }
//    }];
//    
//    [[NSNotificationCenter defaultCenter]postNotificationName:@"线上活动点击topImage放大完毕" object:nil];
//}


#pragma mark - HSScaleScrollViewDelegate 协议
- (void)registerClassForCollectionView:(UICollectionView *)cv {
    [cv registerClass:[HSActivityCardView class] forCellWithReuseIdentifier:reuseIdentifier];
}

- (void)setDataSourceForCollectionView:(UICollectionView *)cv {
    cv.dataSource = self;
}

- (void)getMoreDataForScaleScrollView {
//    NSString *share_id = [[_arrayOfCells objectAtIndex:[_arrayOfCells count]-1 ] objectForKey:@"share_id"];
//    [self postRequestComplete:share_id andRequestNum:@"6"];
}

- (void)getNewDataForScaleScrollView {
    
}

- (void)gestureRecognizerStateChangedWithScaleFactor:(float)factor {
    
}

- (BOOL)shouldMyPanGestureRecognizerBebgin {
    return YES;
}

#pragma mark
- (void)viewWillAppear:(BOOL)animated {
    NSLog(@"HSActivityOnlineController viewWillAppear");
}

- (void)viewDidAppear:(BOOL)animated {
    NSLog(@"HSActivityOnlineController viewDidAppear");
}

- (void)viewWillDisappear:(BOOL)animated{
    NSLog(@"HSActivityOnlineController viewWillDisappear");
}
- (void)viewDidDisappear:(BOOL)animated{
    NSLog(@"HSActivityOnlineController viewDidDisappear");
}

#pragma mark - 点击小卡片上面的按钮
//放大小卡片
- (void)topBtnClickToScale:(NSNotification *)notification {
    NSIndexPath *indexPath = (NSIndexPath *)notification.object;
    [self.scrollView scaleFromIndexPath:indexPath];
}
//注册通知
- (void)addTopBtnClickToScaleObserver {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(topBtnClickToScale:) name:@"topBtnClickToScale" object:nil];
}


@end
