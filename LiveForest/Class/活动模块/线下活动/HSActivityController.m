//
//  HSActivityController.m
//  HotSNS
//
//  Created by 陈秋寒 on 15/3/19.
//  Copyright (c) 2015年 李长远. All rights reserved.
//

#import "HSActivityController.h"
//#import "HSTabBarController.h"
#import "Macros.h"

#import "HSActivityCardView.h"
#import "HSActivityCardViewController.h"
#import "HSDisplayPicActivity.h"
#import "HSPicActivityInfo.h"

@interface HSActivityController()
@property (nonatomic, strong) HSActivityCardViewController *cardViewController;
@end

@implementation HSActivityController

//4.11
static long n=4;
static float factor=0.45;
static float factorMax=2.222222;
static float factorMin=1;
static NSString * const reuseIdentifier = @"Cell";
@synthesize scrollView;
@synthesize panGestureRecognizerScollView;
@synthesize currentCellIndexPath;

@synthesize collectionView = _collectView;
@synthesize arrayOfCells = _arrayOfCells;


@synthesize smallLayout = _smallLayout;

@synthesize activityView = _activityView;
@synthesize createActivityVC = _createActivityVC;

@synthesize officialArray = _officialArray;

@synthesize galleryImages = _galleryImages;
@synthesize slide = _slide;
@synthesize groupDetail = _groupDetail;
@synthesize cardViewControllerArray;
@synthesize cardViewController;

- (instancetype)init {
    self = [super init];
    if (self) {
        
        //请求数据
        self.requestDataCtrl = [[HSRequestDataController alloc] init];
        
        //officialArray
        _officialArray = [[NSMutableArray alloc]init];
        
        _arrayOfCells = [[NSMutableArray alloc]init];
        
        _galleryImages = [[NSArray alloc]init];
        
        
        _activityView = [[HSActivityView alloc]init];
//        _activityView.frame = CGRectMake(kScreenWidth, 0, kScreenWidth, kScreenHeight);
        _activityView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);

        arraySmall=[[NSMutableArray alloc]init];
        arrayLarge=[[NSMutableArray alloc]init];
        visibleCells=[[NSArray alloc]init];

        //初始化collection View和scroll View
        [self initCollectionViewAndScrollView];
        
        //7.21
        [self initCardViewController];
        
        
        //异步
        //1.获得全局的并发队列
        dispatch_queue_t queue =  dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        //2.添加任务到队列中，就可以执行任务
        //异步函数：具备开启新线程的能力
        dispatch_async(queue, ^{
            //请求数据
            NSLog(@"开始请求数据");
            
            //todo
            [self getMPShareInfo];
            
            [self postRequestComplete];
        });

}
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    

    self.navigationBar.hidden = YES;
    
    if(_activityView){
        [self.view addSubview:_activityView];
        
        _activityView.topImage.image = [UIImage imageNamed:@"activityHome.jpg"];
        _activityView.topImage.contentMode=UIViewContentModeScaleAspectFill;
        _activityView.topImage.clipsToBounds = YES;
        
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
        _activityView.shimmeringView = [[FBShimmeringView alloc] initWithFrame:CGRectMake(0, 0, 120, 80)];
        [self.view addSubview:_activityView.shimmeringView];
        
        UILabel *loadingLabel = [[UILabel alloc] initWithFrame:_activityView.shimmeringView.bounds];
        loadingLabel.textAlignment = NSTextAlignmentLeft;
        
        loadingLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:28];
        loadingLabel.textColor = [UIColor whiteColor];
        loadingLabel.shadowColor = [UIColor colorWithWhite:0.3f alpha:0.8f];
        loadingLabel.text = NSLocalizedString(@"Activity", nil);
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
    
    
       //参加活动通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(joinActivityBtnClick:) name:@"notificationJoinActivityBtnClick" object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(cancelActivityBtnClick:) name:@"notificationCancelActivityBtnClick" object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(activityChatBtnClick:) name:@"notificationActivityChatBtn" object:nil];

    //重新加载数据
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadData) name:@"notificationHSReloadData" object:nil];

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
//    return [_arrayOfCells count] * 3;//为了测试，虚拟3倍数据
    return n;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    //7.21
    static NSString *reuseString=@"HSActivityCardView";
    [collectionView registerClass:[HSActivityCardView class] forCellWithReuseIdentifier:reuseString];
    
//    HSActivityCardView *cardView=[[HSActivityCardView alloc]init];
    HSActivityCardView *cardView=[collectionView dequeueReusableCellWithReuseIdentifier:reuseString forIndexPath:indexPath];
    cardView.tag=indexPath.row;
    cardView.tableView.tag=cardView.tag;
    cardView.tableView.delegate = cardViewController;
    cardView.tableView.dataSource = cardViewController;
//    cardView.tableView.panGestureRecognizer.delegate=cardViewController;
//    NSLog(@"%@",cardView.tableView.panGestureRecognizer.delegate);
    if([_arrayOfCells count]>indexPath.row){
        //官方分享赋值
//        [self setValueForCell:cardView
//                     withDict:[_arrayOfCells objectAtIndex:indexPath.row]];
    }
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

#pragma mark
#pragma mark 《手势动画相关》
#pragma mark <初始化collectionview和scrollView>
-(void)initCollectionViewAndScrollView {
    
    //cell、collectionView、 scrollView与屏幕同高。
    //cell、scrollView和屏幕一样大，collectionView的宽度是cell的n倍。
    //scrollView的contentSize是collectionView的frame。
    //collectionView添加到scrollView后，scrollView缩小为0.45
    
    //初始化collectionview
    HSCollectionViewSmallLayout *smallLayout = [[HSCollectionViewSmallLayout alloc] init];
    CGRect collectionViewFrame=CGRectMake(0, 0, kScreenWidth*n,kScreenHeight);
    _collectView = [[UICollectionView alloc] initWithFrame:collectionViewFrame collectionViewLayout:smallLayout];
    
    [self.collectionView registerClass:[HSActivityCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.contentInset = UIEdgeInsetsMake(0, 1, 0, 0);//内容的左边距
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.scrollEnabled=NO;//collectionView不滚动
    
    //缩小collectionView，修正位置
    factor=factorMin;
    self.collectionView.transform=CGAffineTransformMakeScale(0.45,0.45);
    collectionViewFrame=self.collectionView.frame;
    collectionViewFrame.origin.x=0;
    collectionViewFrame.origin.y=0;
    self.collectionView.frame=collectionViewFrame;
    
    //初始化scrollView
    float scrollViewHeight=kScreenHeight*0.45;
    float scrollViewY=kScreenHeight-scrollViewHeight;
    CGRect scrollViewFrame=CGRectMake(0, scrollViewY, kScreenWidth, scrollViewHeight);
    self.scrollView=[[UIScrollView alloc]initWithFrame:scrollViewFrame];
    
    self.scrollView.contentSize=self.collectionView.frame.size;//设置滑动的范围
    self.scrollView.pagingEnabled=NO;
    self.scrollView.showsHorizontalScrollIndicator=YES;
    self.scrollView.clipsToBounds=NO;//不裁剪越界的collectionView，这样就不用在手势过程中修改宽度了
    
    //添加pan手势给scrollView
    self.panGestureRecognizerScollView=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePanScollView:)];
    self.panGestureRecognizerScollView.delegate=self;
    
//    [self.scrollView addGestureRecognizer:self.panGestureRecognizerScollView];
    [self.scrollView addSubview:self.collectionView];
//    [self.view addSubview:self.scrollView];
    
    //缩小scrollView，摆正位置，把缩小后的scrollView的宽度增大到与屏幕同宽
    //    factor=factorMin;
    //    self.scrollView.transform=CGAffineTransformMakeScale(factor,factor);
    //    scrollViewFrame.origin.x=0;
    //    scrollViewFrame.origin.y=kScreenHeight-self.scrollView.frame.size.height;
    //    scrollViewFrame.size.width=kScreenWidth;
    //    self.scrollView.frame=scrollViewFrame;
}

#pragma mark <pan手势是否开始>
//要设置手势的delegate=self
- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer {
    
    //手势滑动的距离
    CGPoint translation=[gestureRecognizer translationInView:self.view];
    
    if (translation.x<0)
        translation.x=-translation.x;
    if (translation.y<0)
        translation.y=-translation.y;
    
    //判断左右还是上下滑动多，上下滑动较多就开始缩放手势
    return translation.x>translation.y?NO:YES;
}

#pragma mark <pan手势处理ScollView>
- (void)handlePanScollView:(id)sender {
    //手势开始
    if ([sender state]==UIGestureRecognizerStateBegan) {
        //获取放大的cell的index
        self.currentCellIndexPath=[self.collectionView indexPathForItemAtPoint:[sender locationInView:self.collectionView]];
        
        //设置position要用到
        CGRect oldFrame=self.scrollView.frame;
        
        //计算锚点的x
        float anchorPointX=([sender locationInView:self.view].x-self.scrollView.frame.origin.x)/self.scrollView.frame.size.width;
        
        //设置苗点
        //        self.scrollView.layer.anchorPoint=CGPointMake(anchorPointX, 0.45);
        self.scrollView.layer.anchorPoint=CGPointMake(anchorPointX, 1);
        
        //设置frame会自动根据锚点位置设置position
        self.scrollView.frame=oldFrame;
        
    }
    //手势改变
    else if ([sender state]==UIGestureRecognizerStateChanged) {
        
        //获取手势x、y轴移动的距离，用x、y表示
        CGPoint translation=[sender translationInView:self.view];
        
        //计算factor
        factor-=translation.y/100.0;
        factor=factor>factorMax*1.2?factorMax*1.2:factor;
        factor=factor<factorMin*0.8?factorMin*0.8:factor;
        
        //缩放
        self.scrollView.transform=CGAffineTransformMakeScale(factor,factor);
        
        //设置可视cell的透明度
        [self setAllVisibleCellsSubviewsAlpha];//先自动获取可视cell再设置透明度
        
        //让collectionView在scollView上左右滑动
        CGPoint pp=self.scrollView.contentOffset;
        pp.x-=translation.x/factor;
        self.scrollView.contentOffset=pp;
        
        //清除上次的位移，因为是累加的。
        UIPanGestureRecognizer *p=(UIPanGestureRecognizer *)sender;
        [p setTranslation:CGPointMake(0, 0) inView:self.view];
        
    }
    //手势结束
    else if ([sender state]==UIGestureRecognizerStateEnded) {
        
        //判断要放大还是缩小
        factor=factor >= (factorMax+factorMin)/2?factorMax:factorMin;
        
        [UIView animateWithDuration:0.2 animations:^{
            //缩放
            self.scrollView.transform=CGAffineTransformMakeScale(factor,factor);
            //获取然后设置透明度
            [self setAllVisibleCellsSubviewsAlpha];
            
            //放大
            if (factor == factorMax) {
                self.scrollView.pagingEnabled=YES;//翻页功能
                
                //让scrollView滚动到当前的cell
                CGPoint pp=self.scrollView.contentOffset;
                pp.x=self.view.frame.size.width * self.currentCellIndexPath.row/factorMax;
                self.scrollView.contentOffset=pp;
            }
            //缩小
            if (factor ==factorMin ) {
                self.scrollView.pagingEnabled=NO;//翻页功能
                
                //让scrollView滚动scrollView平移的相反距离
                CGPoint pp=self.scrollView.contentOffset;
                pp.x-=self.scrollView.frame.origin.x/factorMin;//缩小到了factorMin。先滚动再平移。。。
                self.scrollView.contentOffset=pp;
            }
            
            //放缩结束，scrollView都与屏幕同宽，摆正位置
            CGRect frame=self.scrollView.frame;
            frame.origin.x=0;
            frame.size.width=self.view.frame.size.width;
            self.scrollView.frame=frame;
        }];
    }
}

#pragma mark <点击一个cell>
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    //如果是缩小的
    if(factor==factorMin) {
        //保存放大后要滚动显示的那个cell的index
        self.currentCellIndexPath=indexPath;
        //用来设置position
        CGRect oldFrame=self.scrollView.frame;
        
        //计算锚点
        float anchorPointX=[self.panGestureRecognizerScollView locationInView:self.view].x/self.view.frame.size.width;
        //设置锚点
        self.scrollView.layer.anchorPoint=CGPointMake(anchorPointX, factorMin);
        
        //设置frame会自动根据锚点位置设置position
        self.scrollView.frame=oldFrame;
        
        //放大动画
        factor=factorMax;
        [UIView animateWithDuration:0.2 animations:^{
            //缩放
            self.scrollView.transform=CGAffineTransformMakeScale(factor,factor);
            
            //获取然后设置透明度
            [self setAllVisibleCellsSubviewsAlpha];
            
            if(factor == factorMax) {
                self.scrollView.pagingEnabled=YES;
                
                //让scrollView滚动到当前的cell
                CGPoint pp=self.scrollView.contentOffset;
                pp.x=self.view.frame.size.width*self.currentCellIndexPath.row/factorMax;
                self.scrollView.contentOffset=pp;
                
                //放缩结束，scrollView都与屏幕同宽，摆正位置
                CGRect frame=self.scrollView.frame;
                frame.origin.x=0;
                frame.size.width=self.view.frame.size.width;
                self.scrollView.frame=frame;
            }
        }];
    }
}
#pragma mark 《手势动画结束》
#pragma mark

#pragma mark <设置所有可视cell的子视图>
-(void)setAllVisibleCellsSubviewsAlpha {
    visibleCells=[self.collectionView visibleCells];
    for (HSActivityCollectionViewCell *cell in visibleCells) {
        [cell setSubviewsAlphaWithFactor:factor];
    }
}

//- (void)viewWillAppear:(BOOL)animated {
//     NSLog(@"activity viewWillAppear");
//    //异步
//    //1.获得全局的并发队列
//    dispatch_queue_t queue =  dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    //2.添加任务到队列中，就可以执行任务
//    //异步函数：具备开启新线程的能力
//    dispatch_async(queue, ^{
//        //请求数据
//        NSLog(@"开始请求数据");
//        
//        //todo
//        [self getMPShareInfo];
//        
//        [self postRequestComplete];
//    });
//    
//}

- (void)viewDidAppear:(BOOL)animated {
    
//    self.collectionView.sc
    //滚动到首页的动画
//    [UIView animateWithDuration:0.3 animations:^{
//        //        self.collectionView.scrollsToTop=YES;//没有效果
//        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
//    }];
}

#pragma mark joinActivityBtnClick
-(void)joinActivityBtnClick:(NSNotification *) noti {
    if(noti){
        
        HSActivityCollectionViewCell *cell = (HSActivityCollectionViewCell*)noti.object;
        
        cell.joinActivityBtn.userInteractionEnabled = NO;
        //获取用户token
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        
        if(![userDefaults objectForKey:@"user_token"]){
            NSLog(@"user_token为空，");
        }
        else{
            NSString *user_token = [[NSString alloc]initWithString:[userDefaults objectForKey:@"user_token"]];//如果不存在usertoken,则不能赋值
            
            NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:user_token,@"user_token",cell.activity_id,@"activity_id",nil];
            NSDictionary *requestData = [[NSDictionary alloc] initWithObjectsAndKeys:[dic JSONString],@"requestData", nil];
            //        [self httpInit];
            NSLog(@"user_token:%@",user_token);
            NSLog(@"activity_id:%@",cell.activity_id);
            
            //参加活动
            [self.requestDataCtrl doActivityAttend:requestData andRequestCB:^(BOOL code,id responseObject, NSString *error){
                if(code){
                    
                    cell.joinNumber++;
                    NSString *activityJoinCount = [NSString stringWithFormat:@"已有 %i 人参加",cell.joinNumber];
                    [cell.activityJoinCountSmall setText:activityJoinCount];
                    [cell.activityJoinCountLarge setText:activityJoinCount];
                    //                                = activity_user_num.intValue;
                    
                    //发送后台请求，后台请求成功后，更改按钮
                    cell.joinActivityBtn.alpha=0;
                    cell.activityChat.alpha=1;
                    cell.cancelActivityBtn.alpha=1;
                    
                }
                else{
//                    int subCode = [[responseObject objectForKey:@"subCode"] intValue];
//                    switch (subCode) {
//                        case 0:
//                            ShowHud(@"请求参数缺失", NO);
//                            break;
//                        case 1:
//                            ShowHud(@"token失效", NO);
//                            break;
//                        case 2:
//                            ShowHud(@"该活动不存在", NO);
//                            break;
//                        case 3:
//                            ShowHud(@"用户是创建者，已经加入该活动", NO);
//                            break;
//                        case 4:
//                            ShowHud(@"用户已经参加该活动", NO);
//                            break;
//                        case 5:
//                            ShowHud(@"该活动人数已满", NO);
//                            break;
//                        case 6:
//                            ShowHud(@"参加活动失败", NO);
//                            break;
//                        default:
//                            break;

                    ShowHud(@"网络错误", NO);
                    NSLog(@"请求失败，%@",error);
                }
                cell.joinActivityBtn.userInteractionEnabled = YES;
            }];
            
            
        }

       
    }
}

#pragma mark cancelActivityBtnClick
-(void)cancelActivityBtnClick:(NSNotification *) noti {
    if(noti){
        HSActivityCollectionViewCell *cell = (HSActivityCollectionViewCell*)noti.object;
        
        cell.cancelActivityBtn.userInteractionEnabled = NO;
        //获取用户token
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        
        if(![userDefaults objectForKey:@"user_token"]){
            NSLog(@"user_token为空，");
        }
        else{
            NSString *user_token = [[NSString alloc]initWithString:[userDefaults objectForKey:@"user_token"]];//如果不存在usertoken,则不能赋值
            
            NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:user_token,@"user_token",cell.activity_id,@"activity_id",nil];
            NSDictionary *requestData = [[NSDictionary alloc] initWithObjectsAndKeys:[dic JSONString],@"requestData", nil];
            //        [self httpInit];
            NSLog(@"user_token:%@",user_token);
            NSLog(@"activity_id:%@",cell.activity_id);
            
//            doActivityAttendCancel
            [self.requestDataCtrl doActivityAttend:requestData andRequestCB:^(BOOL code,id responseObject, NSString *error){
                if(code){
                    cell.joinNumber--;
                    NSString *activityJoinCount = [NSString stringWithFormat:@"已有 %i 人参加",cell.joinNumber];
                    [cell.activityJoinCountSmall setText:activityJoinCount];
                    [cell.activityJoinCountLarge setText:activityJoinCount];
                    
                    //发送后台请求，后台请求成功后，更改按钮
                    cell.joinActivityBtn.alpha=1;
                    cell.activityChat.alpha=0;
                    cell.cancelActivityBtn.alpha=0;
                }
                else{
//                    int subCode = [[responseObject objectForKey:@"subCode"] intValue];
//                    switch (subCode) {
//                        case 0:
//                            ShowHud(@"请求参数缺失", NO);
//                            break;
//                        case 1:
//                            ShowHud(@"token失效", NO);
//                            break;
//                        case 2:
//                            ShowHud(@"该活动不存在", NO);
//                            break;
//                        case 3:
//                            ShowHud(@"用户是创建者，不能退出该活动", NO);
//                            break;
//                        case 4:
//                            ShowHud(@":用户尚未参加该活动", NO);
//                            break;
//                        case 5:
//                            ShowHud(@"退出活动失败", NO);
//                            break;
//                        case 6:
//                            ShowHud(@"参加活动失败", NO);
//                            break;
//                        default:
//                            break;
                    ShowHud(@"网络错误", NO);
                    NSLog(@"请求失败，%@",error);
                }
                
                cell.cancelActivityBtn.userInteractionEnabled = YES;

            }];
            
        }
    }
}

#pragma mark activityChatBtnClick
-(void)activityChatBtnClick:(NSNotification *)noti{
    if(noti){
        HSActivityCollectionViewCell *cell = (HSActivityCollectionViewCell *)noti.object;
     _groupDetail = [[HSGroupDetailController alloc]init];
        UIWindow *appWindow = [[UIApplication sharedApplication] keyWindow];
//    [self presentViewController:_groupDetail animated:YES completion:nil];
        [appWindow insertSubview:_groupDetail.view aboveSubview:cell.contentView];
//        [cell.contentView addSubview:_groupDetail.view];
    }
}
#pragma 三个按钮
- (void) createActivity{
    NSLog(@"create activity");
    UIWindow *appWindow = [[UIApplication sharedApplication] keyWindow];
//    HSCreatActivityViewController *_createActivityVC = [[HSCreatActivityViewController alloc]init];不能用这种方式，因为局部变量会被释放掉，必须全局声明
    _createActivityVC=[[HSCreatActivityViewController alloc]init];
    
    
    
    //简单的屏幕适配，等比缩放
    float fitFactor=[UIScreen mainScreen].bounds.size.width/ _createActivityVC.view.frame.size.width;
    _createActivityVC.view.transform=CGAffineTransformMakeScale(fitFactor, fitFactor);
    _createActivityVC.view.center=CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2);
    
    
    
    [appWindow insertSubview:_createActivityVC.view aboveSubview:appWindow.rootViewController.view];
    
    
    
//    [self presentViewController:createActivityVC animated:YES completion:nil];
}
- (void) findActivity{
    NSLog(@"findActivity");
}
- (void) NotiBtn{
    NSLog(@"NotiBtn");
}

#pragma mark 官方分享数据持久化
-(void)reloadMPData{
    
    //请求网络数据
    dispatch_queue_t queue =  dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //2.添加任务到队列中，就可以执行任务
    //异步函数：具备开启新线程的能力
    dispatch_async(queue, ^{
        
        NSMutableArray *MPImg = [[NSMutableArray alloc]init];
        NSArray *tmpImg = [[NSArray alloc]init];
        for(int i=0;i<[_officialArray count];i++){
            
            NSDictionary *dict = [_officialArray objectAtIndex:i];
            
            NSString *imgStr = [[NSString alloc]init];
            
            //获取图片路径
            if([[dict objectForKey:@"activity_img_path"] isKindOfClass:[NSArray class]] && [[dict objectForKey:@"activity_img_path"] count]>0){
                //默认取第一个数组
                tmpImg = [dict objectForKey:@"activity_img_path"];
                //                                           if(tmpImg)
                imgStr = [tmpImg objectAtIndex:0];
            }
            else if([[dict objectForKey:@"activity_img_path"] isKindOfClass:[NSString class]] ){
                imgStr = [dict objectForKey:@"activity_img_path"];
            }
            else{
                imgStr = @"";//todo
            }
            //请求网络数据
            NSURL * url = [NSURL URLWithString:[HSDataFormatHandle encodeURL:imgStr]];//
            NSData* data = [NSData dataWithContentsOfURL:url];//获取网咯图片数据,速度太慢，不用这种
            UIImage *imageTmp = [[UIImage alloc]init];
            
            if(data){
                imageTmp   = [UIImage imageWithData:data];
            }
            else{//虽然data为nil，但是此时imagetmp不是空，可能还没释放
                if(i==0)
                    imageTmp = [UIImage imageNamed:@"Index.jpg"];
                else if(i==1){
                    imageTmp = [UIImage imageNamed:@"activity_1.jpg"];
                }
                else{
                    imageTmp = [UIImage imageNamed:@"activityHome.jpg"];
                }
            }
            
            //        activity_name
            NSString *activity_name = [[NSString alloc]init];
            if([[dict objectForKey:@"activity_name"] isKindOfClass:[NSString class]]){
                activity_name = [dict objectForKey:@"activity_name"];
            }
            else{
                activity_name = @"LiveForest";
            }
            
            //  activity_summary
            NSString *activity_summary = [[NSString alloc]init];
            if([[dict objectForKey:@"activity_summary"] isKindOfClass:[NSString class]]){
                activity_summary = [dict objectForKey:@"activity_summary"];
            }
            else{
                activity_summary = @"活动测试ByLiveForest";
            }
            
            NSDictionary *dicForMP = [NSDictionary  dictionaryWithObjects:[NSArray arrayWithObjects:imageTmp,activity_name,activity_summary, nil] forKeys:[NSArray arrayWithObjects:@"img",@"activity_name",@"activity_summary", nil]];
            [MPImg addObject:dicForMP];
            //异步请求数据，主线程更新视图
        }
        
        
        
        //请求数据
        //为 galleryImage赋值
        if([MPImg count]>0){
            _galleryImages = MPImg;
            NSLog(@"_galleryImages赋值成功");
            // First Load
            dispatch_async(dispatch_get_main_queue(), ^{ /* do UI things */
                [self changeSlide];
            });
        }
        //数据持久化
    });
}

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


#pragma mark 请求系统推荐数据
-(void)getMPShareInfo{
    //获取用户token
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    if(![userDefaults objectForKey:@"user_token"]){
        NSLog(@"user_token为空，");
    }
    else{
        NSString *user_token = [[NSString alloc]initWithString:[userDefaults objectForKey:@"user_token"]];//如果不存在usertoken,则不能赋值
        
        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:user_token,@"user_token",nil];
        NSDictionary *requestData = [[NSDictionary alloc] initWithObjectsAndKeys:[dic JSONString],@"requestData", nil];

//
        [self.requestDataCtrl getMPActivityList:requestData andRequestCB:^(BOOL code,id responseObject, NSString *error){
            if(code){
                if(responseObject){
                    
                    [_officialArray addObjectsFromArray:responseObject];
                    if([_officialArray count]>0){
                        
                        //官方活动图片加载
                        [self reloadMPData];
                        
                        //本地缓存
                        //异步缓存数据
                        //1.获得全局的并发队列
                        //                                   dispatch_queue_t queue =  dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                        //                                   //2.添加任务到队列中，就可以执行任务
                        //                                   //异步函数：具备开启新线程的能力
                        //                                   dispatch_async(queue, ^{
                        //                                       //请求数据
                        //                                       NSLog(@"异步缓存数据");
                        //                                       //存储到本地sqlite
                        ////                                       [_sqlDB removeTable:@"HSIndexMPTable"];
                        //                                       if(![_sqlDB queryData:@"HSIndexMPTable"]){
                        //
                        //                                           [_sqlDB saveDataList:@"HSIndexMPTable" andData:[_officialArray JSONString]];
                        //
                        ////                                           NSLog(@"[_officialArray ]:%@",[_officialArray class]);
                        ////                                           NSLog(@"[_officialArray JSONString]%@",[[_officialArray JSONString] class]);
                        //                                       }else{
                        //                                           //更新
                        //                                           //json序列化
                        //                                       [_sqlDB updateData:@"HSIndexMPTable" andData:[_officialArray JSONString]];
                        //                                       }
                        ////                                       if([_sqlDB queryData:@"HSIndexMPTable"]){
                        ////                                           NSString *str = [_sqlDB queryData:@"HSIndexMPTable"];
                        //////                                           JSONDecoder *json = [[JSONDecoder alloc]init];
                        ////
                        ////                                           NSLog(@"query:%@",[[str objectFromJSONString] class]);
                        ////                                           NSArray *arr =[str objectFromJSONString];
                        ////                                           NSLog(@"query:%@",arr);
                        ////                                       }
                        //                                   });
                        
                        
                    }
                    else{
                        NSLog(@"官方活动为空");
                    }
                    
                }
                else{
                    NSLog(@"获取官方活动为空");
                }
            }
            else{
                NSLog(@"请求官方活动失败,异常");
            }
        }];

        
    }
    
    
}
#pragma 注册
//  请求数据完成后的处理
- (void)postRequestComplete
{
    //构造请求数据
    //获取用户token
    //NSLog(@"postRequestComplete");
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    //todo，应该给游客固定的token
    if(![userDefaults objectForKey:@"user_token"]){
        NSLog(@"user_token为空，");
    }
    else{
        NSString *user_token = [[NSString alloc]initWithString:[userDefaults objectForKey:@"user_token"]];//如果不存在usertoken,则不能赋值
        NSLog(@"%@",[userDefaults objectForKey:@"user_token"]);
        
        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:user_token,@"user_token",nil];
        NSDictionary *requestData = [[NSDictionary alloc] initWithObjectsAndKeys:
                                     [dic JSONString],@"requestData", nil];
        NSLog(@"%@",requestData);

//
        [self.requestDataCtrl getMixActivityList:requestData andRequestCB:^(BOOL code,id responseObject, NSString *error){
            if(code){
                if(responseObject){
                    
                    _arrayOfCells = [[NSMutableArray alloc] initWithArray:responseObject];
                    n = [_arrayOfCells count];
                    if(n>=3){ //数组长度大于0，在更新
                        //因为是异步请求，所以等请求玩成后，重新加载数据
                        
                        CGRect frame = _collectView.frame;
                        
                        if (factor==factorMax) {
                            frame.size.width =kScreenWidth*[_arrayOfCells count];
                        } else {
                            frame.size.width =kScreenWidth*[_arrayOfCells count]*0.45;
                        }
                        
                        scrollView.contentSize = frame.size;
                        _collectView.frame = frame;
                        
                        //todo  关于reloaddata，应该以什么方式？主线程处理
                        dispatch_async(dispatch_get_main_queue(), ^{ /* do UI things */
                            [_collectView reloadData];
                        });
                        //                                   or [self performSelectorOnMainThread:@selector(doUIthings) withObject:nil waitUntilDone:NO];
                        //                                   [self.collectionView reloadData];
                    }else{
                        //n=0
                        if([_officialArray count]>0){
                            [_arrayOfCells addObjectsFromArray:_officialArray];
                            n = [_arrayOfCells count];
                            //NSLog(@"%@",_arrayOfCells);
                            //NSLog(@"%li",n);
                            
                            if(n>0){
                                CGRect frame = _collectView.frame;
                                if (factor==factorMax) {
                                    frame.size.width =kScreenWidth*[_arrayOfCells count];
                                } else {
                                    frame.size.width =kScreenWidth*[_arrayOfCells count]*0.45;
                                }
                                scrollView.contentSize = frame.size;
                                _collectView.frame = frame;
                                
                                //todo
                                dispatch_async(dispatch_get_main_queue(), ^{ /* do UI things */
                                    [_collectView reloadData];
                                });
                            }
                        }
                        else{
                            //请求系统推荐数据
                            [self.requestDataCtrl getMPActivityList:requestData andRequestCB:^(BOOL code,id responseObject, NSString *error){
                                if(code){
                                    
                                    if(!responseObject)
                                    {
                                        NSLog(@"是字符串类型，为空");
                                        return;
                                    }else{
                                        //NSLog(@"%@",[responseObject objectForKey:@"shareList"]);
                                        //_temp = [responseObject objectForKey:@"shareList"];
                                        //[_arrayOfCells addObjectsFromArray:_temp];
                                        //NSLog(@"%@",_temp);
                                        [_arrayOfCells addObjectsFromArray:responseObject];
                                        n = [_arrayOfCells count];
                                        //NSLog(@"%@",_arrayOfCells);
                                        //NSLog(@"%li",n);
                                        
                                        if(n>0){
                                            CGRect frame = _collectView.frame;
                                            if (factor==factorMax) {
                                                frame.size.width =kScreenWidth*[_arrayOfCells count];
                                            } else {
                                                frame.size.width =kScreenWidth*[_arrayOfCells count]*0.45;
                                            }
                                            scrollView.contentSize = frame.size;
                                            _collectView.frame = frame;
                                            
                                            //todo
                                            dispatch_async(dispatch_get_main_queue(), ^{ /* do UI things */
                                                [_collectView reloadData];
                                            });
                                        }
                                    }
                                    
                                    
                                }
                                else{
                                    NSLog(@"获取官方推荐活动异常");
                                }
                            }];
                            
                        }
                        
                    }
                    
                    
                    
                }
                else{
                    NSLog(@"活动列表为空");
                }
            }
            else{
                NSLog(@"获取推荐活动异常");
            }
        }];

    }
}

#pragma mark 给cell赋值
- (void) setValueForCell:(HSActivityCollectionViewCell *)cell andWithDict:( NSDictionary *)dict{
    //        activity_name
    [cell.avtivityNameSmall setText:[dict objectForKey:@"activity_name"]];
    [cell.avtivityNameLarge setText:[dict objectForKey:@"activity_name"]];
    
    //  activity_summary
    [cell.activityDescriptionLarge setText:[dict objectForKey:@"activity_summary"]];
    [cell.activityDescriptionSmall setText:[dict objectForKey:@"activity_summary"]];
    
    //活动创建时间
    [cell.publishTimeSmall setText:[HSDataFormatHandle dateFormaterString:[dict objectForKey:@"create_time"]]];
    [cell.publishTimeLarge setText:[HSDataFormatHandle dateFormaterString:[dict objectForKey:@"create_time"]]];
    
    
    
    //  activity_time
    [cell.activityTimeSmall setText:[HSDataFormatHandle dateFormaterString:[dict objectForKey:@"activity_time"]]];
    [cell.activityTimeLarge setText:[HSDataFormatHandle dateFormaterString:[dict objectForKey:@"activity_time"]]];
    
    //
    //  activity_user_num
    NSString *activity_user_num = [dict objectForKey:@"activity_user_num"];
    NSString *activityJoinCount = [NSString stringWithFormat:@"已有 %@ 人参加",activity_user_num];
    [cell.activityJoinCountSmall setText:activityJoinCount];
    [cell.activityJoinCountLarge setText:activityJoinCount];
    cell.joinNumber = activity_user_num.intValue;
    
    //todo：获取参加活动的头像列表
    //         http://121.41.104.156:10086/Social/Activity/getActivityUserList?requestData={"user_token":"0irh2FUS2FdYrgJknj2F2LdsmcFkm6lof9wzlO8AKTiYso3D","activity_id":"1"}
    
    //  activity_summary
    [cell.activityAddressTagLarge setText:[dict objectForKey:@"activity_location"]];
    
    //经纬度
    
    cell.activity_lon = [dict objectForKey:@"activity_lon"];
    cell.activity_lat = [dict objectForKey:@"activity_lat"];
    
    //        activity_id
    cell.activity_id = [dict objectForKey:@"activity_id"];
    
    //        activity_category_id
    cell.activity_category_id = [dict objectForKey:@"activity_category_id"];
    
    //        user_id
    cell.user_id = [dict objectForKey:@"user_id"];
    
    //        sport_id
    cell.sport_id = [dict objectForKey:@"sport_id"];
    
    //        group_id
    cell.group_id = [dict objectForKey:@"group_id"];
    
    //        isOfficial
    cell.isOfficial = [dict objectForKey:@"isOfficial"];
    
    //        hasAttended
    cell.hasAttended = [dict objectForKey:@"hasAttended"];
    //初始化 是否已经参加活动按钮
    if([cell.hasAttended isEqualToString:@"1"]){
        cell.joinActivityBtn.alpha=0;
        cell.activityChat.alpha=1;
        cell.cancelActivityBtn.alpha=1;
    }else{
        cell.joinActivityBtn.alpha=1;
        cell.activityChat.alpha=0;
        cell.cancelActivityBtn.alpha=0;
    }
    
    //        //七牛图片获取
    
    if([[dict objectForKey:@"activity_img_path"] isKindOfClass:[NSArray class]] && [[dict objectForKey:@"activity_img_path"] count]>0){
        NSArray *imgArray = [[NSArray alloc]initWithArray:[dict objectForKey:@"activity_img_path"]];
        
        [HSDataFormatHandle getImageWithUri:imgArray[0] isYaSuo:true imageTarget:cell.backgroundImgSmall defaultImage:[UIImage imageNamed:@"activity_1.jpg"] andRequestCB:^(UIImage *image) {
                [cell.backgroundImgLarge setImage:image];

        }];

    }
    else{
        //使用默认的图片
        NSLog(@"返回的图片为空：%@",[[dict objectForKey:@"activity_img_path"] class]);
        [cell.backgroundImgSmall setImage:[UIImage imageNamed:@"activity_1.jpg"]];
        //        cell.backgroundImgSmall.contentMode = UIViewContentModeScaleAspectFill;
        
        [cell.backgroundImgLarge setImage:[UIImage imageNamed:@"activity_1.jpg"]];
    }
    
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

- (void)reloadData{
    //异步
    //1.获得全局的并发队列
    dispatch_queue_t queue =  dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //2.添加任务到队列中，就可以执行任务
    //异步函数：具备开启新线程的能力
    dispatch_async(queue, ^{
        //请求数据
        NSLog(@"开始请求数据");
        
        //todo
        [self getMPShareInfo];
        
        [self postRequestComplete];
    });

}
@end
