//
//  HSIndexController.m
//  HotSNS
//
//  Created by 陈秋寒 on 15/3/19.
//  Copyright (c) 2015年 李长远. All rights reserved.
//

#import "HSIndexController.h"
//#import "HSTabBarController.h"
#import "HSVisitMineController.h"
#import "treasureViewController.h"
#import "ServiceHeader.h"

#import <YLMoment.h>

#import "HSCommentViewController.h"

#import "HSFriendsChatListVC.h"
#import "UIButton+WebCache.h"
#import "HSDataFormatHandle.h"

@interface HSIndexController() <HSIndexViewCellDelegate>
@property (nonatomic, strong) HSCommentViewController *commentViewController;

@property (nonatomic, strong) UIButton *footerView;
@property (nonatomic, strong) UIButton *headerView;
@property (nonatomic, strong) HSVisitMineController *visitMineVC;

@end

@implementation HSIndexController
//4.11
static long n=6;  //todo(可以先加载白色的或者之前缓存的，然后请求完数据后对collectinview更新，reloaddata即可（需要改变collectionview的宽度，但是有bug）)
static float factor=0.45;
static float factorMax=2.222222;
static float factorMin=1;
static NSString * const reuseIdentifier = @"Cell";

//@synthesize scrollView;
@synthesize panGestureRecognizerScollView;
@synthesize currentCellIndexPath;


@synthesize collectionView;
@synthesize arrayOfCells = _arrayOfCells;
//@synthesize dictionaryWithEvent = _dictionaryWithEvent;
//@synthesize recipes = _recipes;
//@synthesize topImage = _topImage;
//@synthesize reflected = _reflected;
//
//@synthesize btnMap = _btnMap;
//@synthesize btnTuSDK = _btnTuSDK;

//@synthesize navCtrl = _navCtrl;
//@synthesize visibleCellsArray= _visibleCellsArray;
//@synthesize notiBtn = _notiBtn;

@synthesize manager;
@synthesize indexView =_indexView;

@synthesize galleryImages = _galleryImages;
@synthesize slide = _slide;

@synthesize offView;
@synthesize noti;

@synthesize officialArray = _officialArray;


@synthesize currentCellTag;

@synthesize shareActivityVC;

@synthesize sqlDB = _sqlDB;

@synthesize mapGameCV = _mapGameCV;

@synthesize commentViewController;


@synthesize footerView;
@synthesize headerView;
//7.1-warjiang
@synthesize locService = _locService;
@synthesize userLocation1 = _userLocation1;
@synthesize userLocation2 = _userLocation2;
@synthesize flagCount = _flagCount;

//- (HSScaleScrollView *)scrollView {
////    if (!_scrollView) {
////        _scrollView = [[HSScaleScrollView alloc]initWithCellCount:n Delegate:self];
////    }
//    _scrollView = [[HSScaleScrollView alloc]initWithCellCount:n Delegate:self];
//
//    return _scrollView;
//}


- (void)test {
    _officialArray = [NSMutableArray array];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"share_description"] = @"分享描述";
    dic[@"user_nickname"] = @"用户昵称";
    dic[@"user_logo_img_path"] = @"http://imgtu.5011.net/uploads/content/20170309/2037731489026344.png";
    dic[@"share_img_path"] = @[@"http://www.kuaihou.com/uploads/allimg/130130/1-1301300103061P.jpg",
                               @"http://www.sznews.com/travel/images/attachement/jpg/site3/20150603/7427ea33bc7416d8b93b4c.jpg",
                               @"http://img2.niutuku.com/desk/anime/1913/1913-7515.jpg",
                               @"http://t1.niutuku.com/960/22/22-435778.jpg",
                               @"http://g.hiphotos.baidu.com/zhidao/wh%3D450%2C600/sign=aef92f0b09f79052ef4a4f3a39c3fbfc/aa64034f78f0f736219e10190a55b319ebc41341.jpg",
                               @"http://pic.wenwen.soso.com/p/20091004/20091004223808-749075817.jpg",
                               @"http://dynamic-image.yesky.com/600x-/uploadImages/2012/229/62SW1O3LI8UQ.jpg",
                               @"http://e.hiphotos.baidu.com/zhidao/pic/item/342ac65c103853431f0bcc079313b07ecb8088d4.jpg",
                               @"http://s3.sinaimg.cn/orignal/4c42990eaf4e962a49782"];
    
    dic[@"share_like_num"] = @"10";
    dic[@"comment_count"] = @"10";
    [_officialArray addObject: dic];
    [_officialArray addObject: dic];
    [_officialArray addObject: dic];
    [_officialArray addObject: dic];
    [_arrayOfCells addObjectsFromArray:_officialArray];
    n = [_arrayOfCells count];

    [self.scrollView insertItemsAtRightWithDataSourceArrayCount:_arrayOfCells.count];
    

}

- (id)init {
    self = [super init];
    if (self) {
        
        self.requestDataCtrl = [[HSRequestDataController alloc] init];
        
        //_sqlDB
        _sqlDB = [[HSFMDBSqlite alloc]init];
        
        //officialArray
        _officialArray = [[NSMutableArray alloc]init];
        
        _galleryImages = [[NSArray alloc]init];
        
        
        
        _indexView = [[HSIndexView alloc]init];
//        _indexView.frame =CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        //加载collectionView数据
        _arrayOfCells = [[NSMutableArray alloc]init];
        
        arraySmall=[[NSMutableArray alloc]init];
        arrayLarge=[[NSMutableArray alloc]init];
        visibleCells=[[NSArray alloc]init];
        
        //初始化collection View和scroll View
//        [self initCollectionViewAndScrollView];
        HSCollectionViewSmallLayout *smallLayout = [[HSCollectionViewSmallLayout alloc] init];
        CGRect collectionViewFrame=CGRectMake(0, 0, kScreenWidth*n,kScreenHeight);
        collectionView = [[UICollectionView alloc] initWithFrame:collectionViewFrame collectionViewLayout:smallLayout];
        self.scrollView = [[HSScaleScrollView alloc]initWithCellCount:n Delegate:self shouldGetMoreData:NO];
        [self.view addSubview:self.scrollView];
        //7.12
//        [self initCommentViewController];


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
            
            [self postRequestComplete:@"0" andRequestNum:@"6"];
        });      
    }
    
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //5.25
//    [self initCommentViewController];//实现模块化定制之后，这里就不会执行了，导致评论按钮无效
    
    self.navigationBar.hidden = YES;
    
//    _srcStringArray = @[@"http://ww2.sinaimg.cn/thumbnail/904c2a35jw1emu3ec7kf8j20c10epjsn.jpg",
//                        @"http://ww2.sinaimg.cn/thumbnail/98719e4agw1e5j49zmf21j20c80c8mxi.jpg",
//                        @"http://ww2.sinaimg.cn/thumbnail/67307b53jw1epqq3bmwr6j20c80axmy5.jpg",
//                        @"http://ww2.sinaimg.cn/thumbnail/9ecab84ejw1emgd5nd6eaj20c80c8q4a.jpg",
//                        @"http://ww2.sinaimg.cn/thumbnail/642beb18gw1ep3629gfm0g206o050b2a.gif",
//                        @"http://ww4.sinaimg.cn/thumbnail/9e9cb0c9jw1ep7nlyu8waj20c80kptae.jpg",
//                        @"http://ww2.sinaimg.cn/thumbnail/98719e4agw1e5j49zmf21j20c80c8mxi.jpg",
//                        @"http://ww2.sinaimg.cn/thumbnail/67307b53jw1epqq3bmwr6j20c80axmy5.jpg",
//                        @"http://ww2.sinaimg.cn/thumbnail/9ecab84ejw1emgd5nd6eaj20c80c8q4a.jpg"];
//    
    //从本地读取缓存
//    [_officialArray addObject:officialString];
//    [_sqlDB removeTable:@"HSIndexMPTable"];
//    NSString *tmp = [_sqlDB queryData:@"HSIndexMPTable"];
//    if(tmp){
//        //本地有缓存
//        if([[tmp objectFromJSONString] isKindOfClass:[NSArray class]]){
//    [_officialArray addObjectsFromArray:[tmp objectFromJSONString]];
////        NSLog(@"_officialArray,class%@",[_officialArray class]);
//    [self reloadMPData];
////    NSLog(@"_officialArray atindex 0:%@",[_officialArray objectAtIndex:0]);
////            NSLog(@"[_officialArray objectAtIndex:0]:class:%@",[[_officialArray objectAtIndex:0] class]);
//        }
//    }else{
//        _galleryImages = @[[UIImage imageNamed:@"Index.jpg"], [UIImage imageNamed:@"activityHome.jpg"],[UIImage imageNamed:@"Home.jpg"]];
//    }
    
    //幻灯片
    //会获取 缓存的数据
    _slide = 0;
    
    if(_indexView){
        [self.view addSubview:_indexView];
        
        _indexView.topImage.image = [UIImage imageNamed:@"Index.jpg"];
        _indexView.topImage.contentMode = UIViewContentModeScaleAspectFill;
        _indexView.topImage.clipsToBounds=YES;
        //点击图片
        [_indexView.topImage setUserInteractionEnabled:YES];
        UITapGestureRecognizer *tapTopImage=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTopImage:)];
        [_indexView.topImage addGestureRecognizer:tapTopImage];
//        tapTopImage.delegate=self;//这句话不能加，否则 得实现手势代理操作，太麻烦
        
        //背景图片
        _indexView.reflectedImage.image =[UIImage imageNamed:@"Index.jpg"];
        _indexView.reflectedImage.contentMode = UIViewContentModeScaleAspectFill;
        _indexView.reflectedImage.clipsToBounds = YES;
        _indexView.reflectedImage.transform = CGAffineTransformMakeScale(1.0, -1.0);
        //渐隐
        CAGradientLayer *gradientReflected = [CAGradientLayer layer];
        CGRect rect = _indexView.reflectedImage.bounds;
        rect.size.width = [UIScreen mainScreen].bounds.size.width;
        gradientReflected.frame = rect;
        gradientReflected.colors = @[(id)[[UIColor colorWithRed:0 green:0 blue:0 alpha:1] CGColor],
                                     (id)[[UIColor colorWithWhite:0 alpha:0] CGColor]];
        [_indexView.reflectedImage.layer insertSublayer:gradientReflected atIndex:0];

        [_indexView.shareBtn addTarget:self action:@selector(publishActivity) forControlEvents:UIControlEventTouchUpInside];
        [_indexView.NotiBtn addTarget:self action:@selector(btn__notiBtn) forControlEvents:UIControlEventTouchUpInside];
//        [_indexView.NotiBtn setImage:[UIImage imageNamed:@"notification.png"] forState:UIControlStateNormal];

        [_indexView.treatureBtn addTarget:self action:@selector(treasure) forControlEvents:UIControlEventTouchUpInside];
        
        
        //shimmer
        _indexView.shimmeringView = [[FBShimmeringView alloc] initWithFrame:CGRectMake(10, 0, 80, 80)];
        [self.view addSubview:_indexView.shimmeringView];
        
        UILabel *loadingLabel = [[UILabel alloc] initWithFrame:_indexView.shimmeringView.bounds];
        loadingLabel.textAlignment = NSTextAlignmentLeft;
        
        loadingLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:25];
        loadingLabel.textColor = [UIColor whiteColor];
        loadingLabel.shadowColor = [UIColor colorWithWhite:0.4f alpha:0.8f];
        loadingLabel.text = NSLocalizedString(@"运动社", nil);
        _indexView.shimmeringView.contentView = loadingLabel;
//        _indexView.shimmeringView.shimmeringDirection =
        // Start shimmering.
        _indexView.shimmeringView.shimmeringPauseDuration = 0.1;
        _indexView.shimmeringView.shimmeringAnimationOpacity = 0.3;
        _indexView.shimmeringView.shimmeringSpeed = 40;
        _indexView.shimmeringView.shimmeringHighlightLength = 1;
//        _indexView.shimmeringView.shimmeringSpeed = 40;
        _indexView.shimmeringView.shimmering = YES;
        

    }
    
    // Loop gallery - fix loop:
    //异步
    //1.获得全局的并发队列
//    dispatch_queue_t queue =  dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //2.添加任务到队列中，就可以执行任务
    //异步函数：具备开启新线程的能力
//    dispatch_async(queue, ^{
        NSTimer *timer = [NSTimer timerWithTimeInterval:6.0f target:self selector:@selector(changeSlide) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
//    });
    

  

//    //缩小scrollView，摆正位置，把缩小后的scrollView的宽度增大到与屏幕同宽
//    CGRect scrollViewFrame=self.scrollView.frame;
//    factor=factorMin;
//    self.scrollView.transform=CGAffineTransformMakeScale(factor,factor);
//    scrollViewFrame.origin.x=0;
//    scrollViewFrame.origin.y=kScreenHeight-self.scrollView.frame.size.height;
//    scrollViewFrame.size.width=kScreenWidth;
//    self.scrollView.frame=scrollViewFrame;
//    self.scrollView.showsHorizontalScrollIndicator=YES;

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(praiseBtnClick:) name:@"notificationHSIndexCellPraise" object:nil];
//    notificationHSIndexCellComment
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(doComment:) name:@"notificationHSIndexCellComment" object:nil];
//    notificationHSIndexCellThird
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(shareThird:) name:@"notificationHSIndexCellThird" object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(enlargeImage:) name:@"notificationHSIndexCellContentImage" object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reduceImage:) name:@"notificationHSIndexCellLargedImage" object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(avataBtn:) name:@"notificationHSIndexCellavataBtn" object:nil];

    //重新加载数据
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadDataByNotification) name:@"notificationHSReloadData" object:nil];

    
    [self test];
}

//三个按钮的selector函数
#pragma mark 通知
-(void)btn__notiBtn{
//    ShowHud(@"敬请期待", NO);
    
    //初始化通知
    noti = [[HSNotificationViewController alloc]init];
    
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    [window insertSubview:noti.view aboveSubview:window.rootViewController.view];
//    noti.view.alpha = 1;
//    [self.view addSubview: noti.notiView];
//    [self presentViewController:noti animated:YES completion:nil];
//    NSLog(@"notibtnpress");
//    HSFriendsChatListVC *chatList = [[HSFriendsChatListVC alloc] init];
    // 初始化 UINavigationController。
//    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:chatList];
    
//    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(selectLeftAction:)];
//    UIBarButtonItem *leftBarBtn = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:@selector(selectLeftAction:)];
//    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"Home" style:UIBarButtonItemStyleBordered target:self action:@selector(selectLeftAction:)];
//    nav.navigationItem.leftBarButtonItem = leftButton;
////    nav.navigationItem.leftBarButtonItem = leftButton;
//    // 设置背景颜色为黑色。
//    [nav.navigationBar setBackgroundColor:[UIColor grayColor]];
//    
//    nav.navigationItem.rightBarButtonItem = leftButton;
//    [nav.navigationBar setBarTintColor:[UIColor blueColor]];
//    nav.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonItemStyleDone target:self action:Nil];//设置navigationbar左边按钮
//    [nav.navigationBar setTintColor:[UIColor whiteColor]];//设置navigationbar上左右按钮字体颜色
//    
//    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
//    [window insertSubview:chatList.view aboveSubview:self.view];
//    [self presentViewController:chatList animated:YES completion:nil];
//    [self pushViewController:chatList animated:YES];
//    self.navigationController.ro
//    [self.navigationController pushViewController:chatList animated:YES];
    
}



#pragma mark -寻宝
-(void)treasure{
    
    UIAlertView *av = [[UIAlertView alloc]initWithTitle:nil message:@"敬请期待" delegate:self cancelButtonTitle:@"好" otherButtonTitles: nil];
    [av show];
    
    NSLog(@"treasure...");
    //改变了初始化的位置  by qiang
    
    
    //7.1-warjiang
//    _locService = [[BMKLocationService alloc] init];
//    _locService.delegate = self;
//    [_locService startUserLocationService];
//    self.flagCount = 0;
//    
//    //调用CordovaService，跳转到H5页面
//    [CordovaService.getSingletonInstance startPage:@"game.html" fromViewController:self];
    
    

}

- (void) publishActivity{
//        HSCreatActivityViewController *tuSDK = [[HSCreatActivityViewController alloc]init];不能用这种方式，因为局部变量会被释放掉，必须全局声明
//    HSShareView *sh= [[HSShareView alloc]init];
    
//    [appWindow addSubview:tuSDK.view];
    
//    [self.view insertSubview:sh aboveSubview:self.collectionView];
//        [self presentViewController:tuSDK animated:YES completion:nil];
     shareActivityVC=[[HSShareActivityViewController alloc]init];
    [self presentViewController:shareActivityVC animated:YES completion:nil];
    
//    UIWindow *appWindow = [[UIApplication sharedApplication] keyWindow];
//    [appWindow insertSubview:shareActivityVC.view aboveSubview:appWindow.rootViewController.view];
    
    
    
    
    

}


#pragma collectionView controller
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
     NSLog(@"数组长度:%ld",[_arrayOfCells count]);
    
    return [_arrayOfCells count];//为了测试，虚拟3倍数据
//    return  n;
   
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView2 cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"index controller indexPath = %ld",indexPath.row);
//    if (indexPath.row+1>_arrayOfCells.count) {
//        NSLog(@"异常！cell count = %ld",collectionView.visibleCells.count);
//    }
    
    HSIndexViewCell *cell;
    cell = [collectionView2 dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
//    cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
//    cell.backgroundColor = [UIColor greenColor];
    
    if([_arrayOfCells count]>indexPath.row){
        [self setValueForCell:cell andWithDict:[_arrayOfCells objectAtIndex:indexPath.row]];
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
    
    CGPoint oldOrigin=cell.frame.origin;
    float oldWidth=cell.frame.size.width;
    cell.transform=transform;
    CGRect newFrame=cell.frame;
    newFrame.origin=oldOrigin;
    newFrame.size.width=oldWidth;
    cell.frame=newFrame;
    
    
    //高清屏幕截图
//    UIGraphicsBeginImageContextWithOptions(cell.contentView.frame.size, NO, 0.0);
//    [cell.contentView.layer renderInContext:UIGraphicsGetCurrentContext()];
//    UIImage *screenShotCut=UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    UIImageView *iv=[[UIImageView alloc]initWithImage:screenShotCut];
//    [cell.contentView addSubview:iv];
    
    
//    __weak HSIndexController *weakSelf=self;
    cell.delegate = self;
    
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

#pragma mark  点击头像，进入好友主页
- (void)avataBtn:(NSNotification*)noti {
    
    if(noti){
    
    HSIndexViewCell *cell=(HSIndexViewCell *)noti.object;
    
    NSString *userID = [[NSString alloc]initWithFormat:@"%@",cell.userID];
    
   
    
    _visitMineVC=[[HSVisitMineController alloc]init];
        [_visitMineVC requestPersonalInfoWithUserID:userID];
        [self presentViewController:_visitMineVC animated:YES completion:nil];
//        [self show:_visitMineVC.view];
//        _visitMineVC.userId = userID;
//    UIWindow *appWindow = [[UIApplication sharedApplication] keyWindow];
//    [appWindow insertSubview:_visitMineVC.view aboveSubview:appWindow.rootViewController.view];
//    [self.view addSubview:visitMineVC2.view];
    
    }
}

#pragma mark 界面从下向上 弹出
- (void)show:(UIView*)view{
    UIWindow *window = [[UIApplication sharedApplication]keyWindow];
    CGRect frame = window.frame;
    frame.origin.y = kScreenHeight;
    view.frame = frame;
    [window insertSubview:view aboveSubview:self.view];
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = window.frame;
        frame.origin.y = 0;
        view.frame = frame;
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark
- (void)viewWillAppear:(BOOL)animated {
    NSLog(@"index viewWillAppear");
}

- (void)viewDidAppear:(BOOL)animated {
     NSLog(@"index viewDidAppear");
}

- (void)viewWillDisappear:(BOOL)animated{
    NSLog(@"index viewWillDisappear");
}
- (void)viewDidDisappear:(BOOL)animated{
    NSLog(@"index viewDidDisappear");
}


#pragma 注册
//  请求数据完成后的处理
- (void)postRequestComplete:(NSString *)share_id andRequestNum:(NSString *)requestNum{
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
        
        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:
                             user_token,@"user_token",
                             share_id,@"share_id",
                             requestNum,@"requestNum",
                             nil];
        NSDictionary *requestData = [[NSDictionary alloc] initWithObjectsAndKeys:
                                     [dic JSONString],@"requestData", nil];
//        NSLog(@"%@",requestData);
        
        [self.requestDataCtrl getFollowingShareList:requestData andRequestCB:^(BOOL code,id responseObject, NSString *error){
            if(code){
                
                if(!responseObject)
                {
                    NSLog(@"responseObject是字符串类型，为空");
                    return;
                }
                else {
//                    NSLog(@"%@",responseObject);
//                    for (NSDictionary *dic in responseObject) {
//                        NSLog(@"%@",[dic JSONString]);
//                    }
                    //todo
                    [ _arrayOfCells addObjectsFromArray: responseObject];
                    n = [_arrayOfCells count];
                    if(n>=3){ //数组长度大于0，在更新
                        //因为是异步请求，所以等请求玩成后，重新加载数据
//                        
//                        CGRect frame = collectionView.frame;
//                        
//                        if (factor==factorMax) {
//                            frame.size.width =kScreenWidth*[_arrayOfCells count];
//                        } else {
//                            frame.size.width =kScreenWidth*[_arrayOfCells count]*0.45;
//                        }
//                        
//                        scrollView.contentSize = frame.size;
//                        collectionView.frame = frame;
//                        
//                        //                        [self.scrollView reloadDataWithArrayCount:_arrayOfCells.count];
//                        
//                        //todo  关于reloaddata，应该以什么方式？主线程处理
//                        dispatch_async(dispatch_get_main_queue(), ^{ /* do UI things */
//                            //                            [collectionView reloadData];
//                            //                            [self.scrollView reloadDataWithArrayCount:_arrayOfCells.count];
//                            [self.scrollView reloadData];
//                            
//                        });
                        //                                   or [self performSelectorOnMainThread:@selector(doUIthings) withObject:nil waitUntilDone:NO];
                        //                                   [self.collectionView reloadData];
                        
//                        [self.scrollView reloadDataWithArrayCount:_arrayOfCells.count];
                        NSLog(@"啦啦啦%s",__func__);
                        [self.scrollView insertItemsAtRightWithDataSourceArrayCount:_arrayOfCells.count];
                    }else{
                        //这个 可以去掉
                        //如果官方请求数据已经完毕，则不需要重新请求
                        if([_officialArray count]>0){
                            [_arrayOfCells addObjectsFromArray:_officialArray];
                            n = [_arrayOfCells count];
                            //NSLog(@"%@",_arrayOfCells);
                            //NSLog(@"%li",n);
                            
                            if(n>0){
//                                CGRect frame = collectionView.frame;
//                                if (factor==factorMax) {
//                                    frame.size.width =kScreenWidth*[_arrayOfCells count];
//                                } else {
//                                    frame.size.width =kScreenWidth*[_arrayOfCells count]*0.45;
//                                }
//                                scrollView.contentSize = frame.size;
//                                collectionView.frame = frame;
//                                
//                                //todo
//                                dispatch_async(dispatch_get_main_queue(), ^{ /* do UI things */
//                                    [collectionView reloadData];
//                                });
                                
                                [self.scrollView reloadDataWithArrayCount:_arrayOfCells.count];

                            }
                        }
                        else{
                            //请求系统推荐数据
                            [self.requestDataCtrl getMPShareList:requestData andRequestCB:^(BOOL code,id responseObject, NSString *error){
                                if(code){
                                    
                                    if(!responseObject)
                                    {
                                        NSLog(@"是字符串类型，为空");
                                        return;
                                    }else {
                                        [_arrayOfCells addObjectsFromArray:responseObject];
                                        n = [_arrayOfCells count];
                                        if(n>0){
//                                            CGRect frame = collectionView.frame;
//                                            if (factor==factorMax) {
//                                                frame.size.width =kScreenWidth*[_arrayOfCells count];
//                                            } else {
//                                                frame.size.width =kScreenWidth*[_arrayOfCells count]*0.45;
//                                            }
//                                            scrollView.contentSize = frame.size;
//                                            collectionView.frame = frame;
//                                            
//                                            //todo
//                                            dispatch_async(dispatch_get_main_queue(), ^{ /* do UI things */
//                                                [self.collectionView reloadData];
//                                            });
                                            
                                            [self.scrollView reloadDataWithArrayCount:_arrayOfCells.count];

                                        }
                                    }
                                    
                                    
                                }
                                else{
                                    NSLog(@"获取系统推荐数据异常");
                                }
                            }];
                            
                        }
                        
                    }
                }
                
            }
            else{
                
            }
        }];
        
    }
}


#pragma btnClick
- (void)btnClick{
    NSLog(@"btnClick");
}


#pragma mark <隐藏添加评论视图>
//-(void)addCommentViewDisappear {
//    //如果没放大过，currentCellIndexPath会是nil，所以factor==2的时候才会被调用。
//    NSIndexPath *indexPath=[NSIndexPath indexPathForItem:currentCellTag inSection:0];
//    
//    HSIndexViewCell *cell=(HSIndexViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
//    
//    if (cell.commentView.alpha!=0) {
//        [cell addCommentViewDisappearWithAnimation];
//    }
//}

#pragma mark - Change slider
- (void)changeSlide
{
    if([_galleryImages count]>0){
    if(_slide > _galleryImages.count-1) _slide = 0;
//     _indexView.topImage.image = [UIImage imageNamed:@"Index.jpg"];

    UIImage *toImage = [_galleryImages objectAtIndex:_slide];
    [UIView transitionWithView:self.view
                      duration:0.4
                       options:UIViewAnimationOptionTransitionCrossDissolve | UIViewAnimationCurveEaseInOut |UIViewAnimationOptionAllowUserInteraction
                    animations:^{
                        _indexView.topImage.image = toImage;
                        _indexView.reflectedImage.image = toImage;
                    } completion:nil];
    _slide++;
        }
}

#pragma mark 点击官方推荐分享
- (void)tapTopImage:(UIImageView *)topImage{
    
    
    offView = [[HSOfficialViewController alloc]init];

//    评论模块 5.27
//    HSOfficialView *officialView=offView.offView;
//    //评论按钮
//    [officialView.commentBtnLarge addTarget:commentViewController action:@selector(commentBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    //发送评论按钮
//    [officialView.commentView.sendBtn addTarget:commentViewController action:@selector(sendCommentBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    //黑色背景按钮
//    [officialView.commentView.blackBtn addTarget:commentViewController action:@selector(blackBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    //返回按钮
//    [officialView.commentView.backBtn addTarget:commentViewController action:@selector(blackBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    

    if([_officialArray count]>0){
        if([[[_officialArray objectAtIndex:0] class] isKindOfClass:[NSDictionary class]]){
            
            if(_slide == 0){
                [offView getShareInfoWithDic:[_officialArray objectAtIndex:[_officialArray count]-1]];
            }
            else{
                [offView getShareInfoWithDic:[_officialArray objectAtIndex:_slide-1]];
            }
            UIWindow *appWindow = [[UIApplication sharedApplication] keyWindow];
//            [appWindow insertSubview:offView.view aboveSubview:appWindow.rootViewController.view];
            
            CGRect frame=self.view.frame;
            frame.origin.y=kScreenHeight;
            offView.view.frame=frame;
            
            [UIView animateWithDuration:0.3 animations:^{
                [appWindow insertSubview:offView.view aboveSubview:appWindow.rootViewController.view];
                CGRect frame=self.view.frame;
                frame.origin.y=0;
                offView.view.frame=frame;
                
            }completion:^(BOOL finished) {
            }];
            //            [self.view insertSubview:offView.view aboveSubview:self.scrollView];
//            [self presentViewController:offView animated:YES completion:nil];
        }
        else{
            ShowHud(@"数据异常", NO);
        }
    }
    else{
        ShowHud(@"数据异常", NO);
        //构造静态数据等处理
        
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
        
        [self.requestDataCtrl getMPShareList:requestData andRequestCB:^(BOOL code,id responseObject, NSString *error){
            if(code){
                if(responseObject){
                    
                    [_officialArray addObjectsFromArray:responseObject];
                    //                               NSLog(@"%@",_officialArray);
                    if([_officialArray count]>0){
                        
                        //官方活动图片加载
                        [self reloadMPData];
                    }
                    else{
                        NSLog(@"官方活动为空");
                    }
                }
                else{
                    NSLog(@"获取官方数据格式有问题");
                }
            }
            else{
                NSLog(@"%@",error);
            }
            
        }];
        
        
    }
    
    
}


#pragma praiseBtnLarge:
#pragma mark 点赞 成功效果
-(void)praiseBtnClick:(NSNotification *)notification {
//    HSIndexViewCell *cell= [[HSIndexViewCell alloc]init];
    HSIndexViewCell *cell= notification.userInfo[@"cell"];
    
    //处理点赞后的效果
    [self praiseBtnEffect:cell];

    if(notification.object){
     cell=(HSIndexViewCell *)notification.object;
    NSLog(@"cell.shareID:%@",cell.shareID);
    }
    
//    cell.praiseBtnLarge.userInteractionEnabled = NO;
    
    NSLog(@"%@",cell.shareID);

    //获取用户token
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    if(![userDefaults objectForKey:@"user_token"]){
        NSLog(@"user_token为空，");
    }
    else{
        NSString *user_token = [[NSString alloc]initWithString:[userDefaults objectForKey:@"user_token"]];//如果不存在usertoken,则不能赋值
        
        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:user_token,@"user_token",
                             cell.shareID,@"share_id",nil];
        NSDictionary *requestData = [[NSDictionary alloc] initWithObjectsAndKeys:[dic JSONString],@"requestData", nil];
        
        [self.requestDataCtrl doShareLike:requestData andRequestCB:^(BOOL code,id responseObject, NSString *error){
            if(code){
                //处理点赞后的效果
                [self praiseBtnEffect:cell];
            }
            else{
                ShowHud(@"系统异常", NO);
                NSLog(@"异常");
            }
//            cell.praiseBtnLarge.userInteractionEnabled = YES;
        }];
        
    }

}

-(void)praiseBtnEffect:(HSIndexViewCell*)cell{
    
    UIImage *image;
    int praiseNum = cell.praiseLabelLarge.text.intValue;
//    NSLog(@"praiseNum:%i",praiseNum);
    if(!cell.praiseJudge){
        praiseNum++;
        image=[UIImage imageNamed:@"ic_thumb_up_blue_48dp.png"];
        cell.praiseJudge = YES;
    }
    else{
        praiseNum--;
        image=[UIImage imageNamed:@"ic_thumb_up_black_48dp.png"];
        cell.praiseJudge = NO;
    }
    
    NSString *type = [[NSString alloc]initWithFormat:@"%i",praiseNum];
    [cell.praiseLabelLarge setText:type];
    [cell.praiseBtnLarge setImage:(UIImage *)image forState:UIControlStateNormal];
    
    [UIView animateWithDuration:0.15 animations:^{
        cell.praiseBtnLarge.transform=CGAffineTransformMakeScale(2, 2);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.05 animations:^{
            cell.praiseBtnLarge.transform=CGAffineTransformMakeScale(1, 1);
        }];
    }];
    
//    image=[UIImage imageNamed:@"ic_thumb_up_blue_48dp.png"];
//    [cell.praiseBtnLarge setImage:image forState:UIControlStateNormal];

}

#pragma mark share third
- (void) shareThird:(NSNotification *)noti{
    HSIndexViewCell *cell = [[HSIndexViewCell alloc]init];
    if(noti){
        cell = (HSIndexViewCell *)noti.object;
        NSLog(@"shareid:%@",cell.shareID);
        
        //        显示压缩后的图片
                NSCharacterSet *whitespace = [NSCharacterSet  URLQueryAllowedCharacterSet];//编码，将空格编码
                NSString* strAfterDecodeByUTF8AndURI = [cell.imgUrl stringByAddingPercentEncodingWithAllowedCharacters:whitespace];
    [self shareWithcontent:cell.textLabelLarge.text withTitle:@"LiveForest分享" withImage:strAfterDecodeByUTF8AndURI withShareID:cell.shareID];
    }
    
}
-(void)shareWithcontent:(NSString*)content withTitle:(NSString*)title withImage:(NSString*)imageUrl withShareID:(NSString *)shareID{
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:content
                                       defaultContent:@"liveforest 分享"
                                                image:[ShareSDK imageWithUrl:imageUrl]
                                                title:title
                                                  url:[[NSString alloc]initWithFormat:@"http://m.live-forest.com/static/view/share/weekly_report.html?type=share&id=%@",shareID]
                                          description:@"liveforest 描述"
                                            mediaType:SSPublishContentMediaTypeNews];
    //创建弹出菜单容器
    id<ISSContainer> container = [ShareSDK container];
    //iPad
    //[container setIPadContainerWithView:sender arrowDirect:UIPopoverArrowDirectionUp];
    //定义shareList
    NSArray *shareList = [ShareSDK getShareListWithType:
                          ShareTypeSinaWeibo,
                          ShareTypeWeixiSession,
                          ShareTypeWeixiTimeline,
                          ShareTypeSMS,nil];
    //弹出分享菜单
    [ShareSDK showShareActionSheet:container
                         shareList:shareList
                           content:publishContent
                     statusBarTips:YES
                       authOptions:nil
                      shareOptions:nil
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                
                                if (state == SSResponseStateSuccess)
                                {
                                    NSLog(NSLocalizedString(@"TEXT_ShARE_SUC", @"分享成功"));
                                }
                                else if (state == SSResponseStateFail)
                                {
                                    NSLog(NSLocalizedString(@"TEXT_ShARE_FAI", @"分享失败,错误码:%d,错误描述:%@"), [error errorCode], [error errorDescription]);
                                }
                            }];
}
#pragma mark 点赞模块
#pragma mark 点赞判断
- (void) setShareLikeState:(NSString *)shareID andCell:(HSIndexViewCell *)cell{

    
//    praiseJudge = NO;
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    if(![userDefaults objectForKey:@"user_token"]){
        NSLog(@"user_token为空，");
    }
    else{
        NSString *user_token = [[NSString alloc]initWithString:[userDefaults objectForKey:@"user_token"]];//如果不存在usertoken,则不能赋值
        
        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:user_token,@"user_token",
                             shareID,@"share_id",
                             nil];
        NSDictionary *requestData = [[NSDictionary alloc] initWithObjectsAndKeys:[dic JSONString],@"requestData", nil];
        
        [self.requestDataCtrl getUserShareLikeState:requestData andRequestCB:^(BOOL code,BOOL state, NSString *error){
            if(code){
                if(state)
                {
                    [cell.praiseBtnLarge setImage:[UIImage imageNamed:@"ic_thumb_up_blue_48dp.png"] forState:UIControlStateNormal];
                    cell.praiseJudge = true;
                }
                else{
                    cell.praiseJudge = false;
//                    NSLog(@"还没点过赞");
                    [cell.praiseBtnLarge setImage:[UIImage imageNamed:@"ic_thumb_up_black_48dp.png"] forState:UIControlStateNormal];
                }
            }
            else{
//                ShowHud(@"获取点赞状态失败",NO);
                NSLog(@"获取点赞状态失败");
            }
        }];
        
        
    }

}

#pragma mark enlargeImage
- (void)enlargeImage:(NSNotification *)noti{
    
    HSIndexViewCell *cell = [[HSIndexViewCell alloc]init];
    cell = (HSIndexViewCell*)noti.object;
    
//    cell.imgHighQualityUrlArray

    
//    [cell.contentView addSubview:cell.blackCellEnlargeImage];
//    [cell.contentView addSubview:cell.largedImage];
//    
//    //todo
//    cell.largedImage.image = nil;
//    cell.blackCellEnlargeImage.alpha = 0.6;
//    
//    [cell.imgViewTmp sd_setImageWithURL:cell.imgHighQualityUrl
//                                        completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//                                            cell.largedImage.image = image;
//                                        }];
//    
//    cell.largedImage.reverse = YES;
//    [cell.largedImage animate];
//    cell.largedImage an
}

#pragma mark reduceImage
- (void)reduceImage:(NSNotification *)noti{
    HSIndexViewCell *cell = [[HSIndexViewCell alloc]init];
    cell = (HSIndexViewCell*)noti.object;

    
//    [cell.largedImage animate];
    [UIView animateWithDuration:0.5 animations:^{
//        cell.largedImage.transform = CGAffineTransformMakeScale(0.8, 0.8);
//        cell.largedImage.reverse = YES;
//        [cell.largedImage animate];
    } completion:^(BOOL finished){
//        cell.largedImage.alpha = 0;
//         cell.contentView.alpha = 1;
        [cell.blackCellEnlargeImage removeFromSuperview];
        [cell.largedImage removeFromSuperview];
    }];
    
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
            if([[dict objectForKey:@"share_img_path"] isKindOfClass:[NSArray class]] && [[dict objectForKey:@"share_img_path"] count]>0){
                //默认取第一个数组
                tmpImg = [dict objectForKey:@"share_img_path"];
                //                                           if(tmpImg)
                imgStr = [tmpImg objectAtIndex:0];
            }
            else if([[dict objectForKey:@"share_img_path"] isKindOfClass:[NSString class]]){
                imgStr = [dict objectForKey:@"share_img_path"];
            }
            else{
                imgStr = @"";
            }
            
            NSString *encodeURL = [HSDataFormatHandle encodeURL:imgStr];
            
//            NSURL * url = [NSURL URLWithString:encodeURL];
            NSURL * url = [[NSURL alloc] initWithString:encodeURL];
            
            NSData* data = [NSData dataWithContentsOfURL:url];//获取网咯图片数据,速度太慢，不用这种
            
            //            NSData* data = nil;
            UIImage *imageTmp = [[UIImage alloc]init];
            
            if(data){
                imageTmp   = [UIImage imageWithData:data];
            }
            else//(imageTmp == nil)
            {
                if(i==0)
                    imageTmp = [UIImage imageNamed:@"Index.jpg"];
                else if(i==1){
                    imageTmp = [UIImage imageNamed:@"activity_1.jpg"];
                }
                else{
                    imageTmp = [UIImage imageNamed:@"activityHome.jpg"];
                }
            }
            
            [MPImg addObject:imageTmp];
            
            
            //异步请求数据，主线程更新视图
        }
        
        
        dispatch_async(dispatch_get_main_queue(), ^{ /* do UI things */
            //        NSLog(@"mpimg:  %@",MPImg);
            //为 galleryImage赋值
            if([MPImg count]>0){
                _galleryImages = MPImg;
                NSLog(@"_galleryImages赋值成功");
                // First Load
                [self changeSlide];
            }
            //数据持久化
        });
        
    });
}



#pragma mark backMap
-(void)backMap{
    UIWindow *win = [[UIApplication sharedApplication] keyWindow];
//    [self.view removeFromSuperview];
    UIView *view=[win viewWithTag:101];
    [view removeFromSuperview];
    
    _locService.delegate = nil;
    _locService = nil;
}


#pragma mark 评论模块,注册评论事件
//初始化评论视图控制器
//- (void)initCommentViewController {
////    commentViewController=[[HSCommentViewController alloc]init];
//    commentViewController=[[HSCommentViewController alloc]initWithShareID:<#(NSString *)#>];
//}
//添加各种评论事件处理函数，itemFor...函数里面调用
//- (void)initCommentButtonsOfCell:(HSIndexViewCell *)cell {
//    //评论按钮
//    [cell.commentBtnLarge addTarget:commentViewController action:@selector(commentBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    //发送评论按钮
//    [cell.commentView.sendBtn addTarget:commentViewController action:@selector(sendCommentBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    //黑色背景按钮
//    [cell.commentView.blackBtn addTarget:commentViewController action:@selector(blackBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    //返回按钮
//    [cell.commentView.backBtn addTarget:commentViewController action:@selector(blackBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//}



#pragma mark
#pragma mark 《footer View》
#pragma mark 判断要展示哪个 滑动scrollView时手指离开瞬间
// 滑动scrollView，并且手指离开时执行。一次有效滑动，只执行一次。
// 当pagingEnabled属性为YES时，不调用，该方法
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView2 withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    
    //    NSLog(@"scrollViewWillEndDragging");
    //    CGPoint v=[scrollView.panGestureRecognizer velocityInView:scrollView];
    //    NSLog(@"v = %@",NSStringFromCGPoint(v));
    
    NSLog(@"targetContentOffset = %@",NSStringFromCGPoint(*targetContentOffset));
    NSLog(@"contentOffset = %@",NSStringFromCGPoint(scrollView2.contentOffset));
    NSLog(@"collectionView = %@",NSStringFromCGRect(collectionView.frame));
    
    
    //    int n=(*targetContentOffset).x/kScreenWidth;
    //    NSLog(@"n = %d",n);
    //    NSIndexPath *indexPath=[NSIndexPath indexPathForItem:n inSection:0];
    if (targetContentOffset->x > self.collectionView.frame.size.width * 0.8) {
        
        //todo 先不用
        [self addFooterToScrollView];
    }
    
//    
//    if (targetContentOffset->x < self.collectionView.frame.size.width * 0.1) {
//        [self addHeaderToScrollView];
//    }
}

#pragma mark 添加footer
- (void)addFooterToScrollView {
    
    if (footerView == nil) {
        
        //修改scrollView的contentSize，footer放在collectionView后面
        
        //求缩放的factor，计算footerFrame的时候要用到
        //        factor =scrollView.frame.size.height/scrollView.bounds.size.height;
        factor =collectionView.bounds.size.height/collectionView.frame.size.height;
        
        //计算footerFrame
        CGRect footerFrame=collectionView.frame;
        footerFrame.origin.x=scrollView.contentSize.width+1;
        footerFrame.size.width=[[UIScreen mainScreen]bounds].size.width/factor;
        
        //创建菊花
        UIActivityIndicatorView *juHua=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        juHua.center=CGPointMake(footerFrame.size.width/2, footerFrame.size.height/2);
        //        juHua.tintColor=[UIColor redColor];
        //        juHua.backgroundColor=[UIColor blueColor];
        [juHua startAnimating];
        
        //创建footerView
        footerView=[[UIButton alloc]initWithFrame:footerFrame];
        footerView.backgroundColor=[UIColor whiteColor];
        [footerView addTarget:self action:@selector(footerViewClick) forControlEvents:UIControlEventTouchUpInside];
        [footerView addSubview:juHua];
        [scrollView addSubview:footerView];
        //        [scrollView insertSubview:footerView aboveSubview:collectionView];
        
        //修改contentSize
        CGSize newContentSize=scrollView.contentSize;
        newContentSize.width+=footerView.frame.size.width+2;
        scrollView.contentSize=newContentSize;
        
        NSLog(@"footer.frame %@",NSStringFromCGRect(footerView.frame));
        
        //        [self performSelector:@selector(removeFooterFromScrollView) withObject:nil afterDelay:6.0];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSLog(@"开始请求数据");
            [self getMoreData];
        });
        
    }
    
}

//即将开始滚动，发送开始滚动通知,todo
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    //评论视图什么的，通通收回去
        [[NSNotificationCenter defaultCenter]postNotificationName:@"狼来了" object:nil];
    [commentViewController commentViewDisappearWithAnimation];
    
    
    //添加header View
    CGPoint v=[scrollView.panGestureRecognizer velocityInView:scrollView];
    //如果往右拉
    if (v.x>0) {
        //如果接近最左边了 self.view.frame.size.width * 0.1
        if (self.scrollView.contentOffset.x <= 0) {
//            [self addHeaderToScrollView];
            
            CGRect labelFrame=CGRectZero;
            labelFrame.size.width=160;
            labelFrame.size.height=50;
            
            UILabel *label=[[UILabel alloc]initWithFrame:labelFrame];
            label.text=@"开始刷新数据";
            label.textAlignment=NSTextAlignmentCenter;
            label.backgroundColor=[UIColor whiteColor];
            label.center=self.view.center;
            label.alpha=0.7;
            label.transform=CGAffineTransformMakeScale(0.7, 0.7);
//            [self.view addSubview:label];
//            
//            [UIView animateWithDuration:1 animations:^{
//                label.alpha=1;
//                label.transform=CGAffineTransformMakeScale(1.3, 1.3);
//            } completion:^(BOOL finished) {
//                [UIView animateWithDuration:0.2 animations:^{
//                    label.transform=CGAffineTransformMakeScale(6, 6);
//                    label.alpha=0.1;
//                } completion:^(BOOL finished) {
//                    [label removeFromSuperview];
//                }];
//            }];
//            
            
//            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//                NSLog(@"开始更新数据");
//                [self updateData];
//                
//            });
        }
    }
}

//- (void)scrollViewDidScroll:(nonnull UIScrollView *)scrollView {
//    //添加header View
////    CGPoint v=[scrollView.panGestureRecognizer velocityInView:scrollView];
////    //如果往右拉
////    if (v.x>0) {
////        //如果接近最左边了 self.view.frame.size.width * 0.1
////        if (self.scrollView.contentOffset.x <= 0) {
////            [self addHeaderToScrollView];
////        }
////    }
//    
//    //如果接近最左边了 self.view.frame.size.width * 0.1
//    if (self.scrollView.contentOffset.x < 0) {
////        [self addHeaderToScrollView];
//    }
//
//
//}

#pragma mark 添加header
- (void)addHeaderToScrollView2 {
    
    if (headerView == nil) {
        
        //修改scrollView的contentSize，footer放在collectionView后面
        
        //求缩放的factor，计算footerFrame的时候要用到
        //        factor =scrollView.frame.size.height/scrollView.bounds.size.height;
        factor =collectionView.bounds.size.height/collectionView.frame.size.height;
        
        //计算headerView frame
        CGRect headerFrame=collectionView.frame;
        headerFrame.size.width=[[UIScreen mainScreen]bounds].size.width/factor-2;
//        headerFrame.origin.x=scrollView.contentSize.width-1-headerFrame.size.width;
        headerFrame.origin.x=0;
        
        //创建菊花
        UIActivityIndicatorView *juHua=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        juHua.center=CGPointMake(headerFrame.size.width/2, headerFrame.size.height/2);
        //        juHua.tintColor=[UIColor redColor];
        //        juHua.backgroundColor=[UIColor blueColor];
        [juHua startAnimating];
        
        //创建headerView
        headerView=[[UIButton alloc]initWithFrame:headerFrame];
        headerView.backgroundColor=[UIColor whiteColor];
        [headerView addTarget:self action:@selector(headerViewClick) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:juHua];
        [scrollView addSubview:headerView];
        //        [scrollView insertSubview:footerView aboveSubview:collectionView];
        
//        //scrollView左移
//        CGRect scrollViewFrame=self.scrollView.frame;
//        scrollViewFrame.origin.x+=headerFrame.size.width;
//        scrollView.frame=scrollViewFrame;
        
        //collectionView右滚
        CGRect collectionViewFrame=collectionView.frame;
        collectionViewFrame.origin.x+=headerFrame.size.width;
        collectionView.frame=collectionViewFrame;
        
//        //修改contentSize
//        CGSize newContentSize=scrollView.contentSize;
//        newContentSize.width+=headerView.frame.size.width+2;
//        scrollView.contentSize=newContentSize;
        
        NSLog(@"headerView.frame %@",NSStringFromCGRect(headerView.frame));
        
        //        [self performSelector:@selector(removeFooterFromScrollView) withObject:nil afterDelay:6.0];
        
        
        
        //创建label
        CGRect labelFrame=juHua.frame;
        labelFrame.size.width=headerView.frame.size.width;
        labelFrame.size.height=100;
        
        //        labelFrame.origin.y
        UILabel *label=[[UILabel alloc]initWithFrame:labelFrame];
        label.text=@"刷新数据";
        label.textAlignment=NSTextAlignmentCenter;
        label.center=CGPointMake(juHua.center.x, juHua.center.y*1.3);
        [headerView addSubview:label];

        
        
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//            NSLog(@"开始更新数据");
//            [self updateData];
//
//        });
        
    }
    
}

#pragma mark 添加header
- (void)addHeaderToScrollView {
    
    if (headerView == nil) {
        
        //修改scrollView的contentSize，footer放在collectionView后面
        
        //求缩放的factor，计算footerFrame的时候要用到
        //        factor =scrollView.frame.size.height/scrollView.bounds.size.height;
        factor =collectionView.bounds.size.height/collectionView.frame.size.height;
        
        //计算headerView frame
        CGRect headerFrame=collectionView.frame;
        headerFrame.size.width=[[UIScreen mainScreen]bounds].size.width/factor-2;
        //        headerFrame.origin.x=scrollView.contentSize.width-1-headerFrame.size.width;
        headerFrame.origin.x=0;
        
        //创建菊花
        UIActivityIndicatorView *juHua=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        juHua.center=CGPointMake(headerFrame.size.width/2, headerFrame.size.height/2);
        //        juHua.tintColor=[UIColor redColor];
        //        juHua.backgroundColor=[UIColor blueColor];
        [juHua startAnimating];
        
        //创建headerView
        headerView=[[UIButton alloc]initWithFrame:headerFrame];
        headerView.backgroundColor=[UIColor whiteColor];
        [headerView addTarget:self action:@selector(headerViewClick) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:juHua];
//        [scrollView addSubview:headerView];
        //        [scrollView insertSubview:footerView aboveSubview:collectionView];
        
        
        NSLog(@"headerView.frame %@",NSStringFromCGRect(headerView.frame));
        
        //        [self performSelector:@selector(removeFooterFromScrollView) withObject:nil afterDelay:6.0];
        
        
        
        //创建label
        CGRect labelFrame=juHua.frame;
        labelFrame.size.width=headerView.frame.size.width;
        labelFrame.size.height=100;
        UILabel *label=[[UILabel alloc]initWithFrame:labelFrame];
        label.text=@"刷新数据";
        label.textAlignment=NSTextAlignmentCenter;
        label.center=CGPointMake(juHua.center.x, juHua.center.y*1.3);
        [headerView addSubview:label];
        
        
        
        
        UIView *leftView=[[UIView alloc]init];
        leftView.backgroundColor=[UIColor redColor];
        CGRect leftViewFrame=CGRectZero;
        leftViewFrame.size.width=2*headerFrame.size.width+1;
        leftViewFrame.size.height=headerFrame.size.height;
        leftViewFrame.origin.x-=headerFrame.size.width-1;
        leftView.frame=leftViewFrame;
        
        [leftView addSubview:headerView];
        
        UIView *firstCell=self.collectionView.visibleCells.firstObject;
        [firstCell addSubview:leftView];
        firstCell.clipsToBounds=NO;
//        [self.collectionView addSubview:leftView];
        [scrollView addSubview:leftView];
        collectionView.clipsToBounds=NO;
        self.scrollView.clipsToBounds=NO;
        
        //        //scrollView左移
        //        CGRect scrollViewFrame=self.scrollView.frame;
        //        scrollViewFrame.origin.x+=headerFrame.size.width;
        //        scrollView.frame=scrollViewFrame;
        
//        //collectionView右滚
//        CGRect collectionViewFrame=collectionView.frame;
//        collectionViewFrame.origin.x+=headerFrame.size.width;
//        collectionView.frame=collectionViewFrame;
        
        //        //修改contentSize
        //        CGSize newContentSize=scrollView.contentSize;
        //        newContentSize.width+=headerView.frame.size.width+2;
        //        scrollView.contentSize=newContentSize;

        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSLog(@"开始更新数据");
            [self updateData];
            
        });
        
    }
    
}

#pragma mark 删除footer
- (void)removeFooterFromScrollView {
    if (footerView!=nil) {
        [footerView removeFromSuperview];
        footerView=nil;
        
        scrollView.contentSize=collectionView.frame.size;
    }
}

#pragma mark 删除header
- (void)removeHeaderFromScrollView {
    
    if (headerView!=nil) {
        [headerView removeFromSuperview];
        headerView=nil;
        
        scrollView.contentSize=collectionView.frame.size;
        
        //collectionView左滚
        CGRect collectionViewFrame=collectionView.frame;
        collectionViewFrame.origin.x+=headerView.frame.size.width;
        collectionView.frame=collectionViewFrame;

    }
}

#pragma mark 点击放大footerView
- (void)footerViewClick {
    NSLog(@"点击了footerView");
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"footerViewClick" object:self];
    
}

#pragma mark 点击放大headerView
- (void)headerViewClick {
    NSLog(@"点击了headerView");
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"headerViewClick" object:self];
    
}

- (void)getMoreData {
    
    
    //获取完数据之后，调用 removeFooterFromScrollView 删除footer View
    //异步
    //1.获得全局的并发队列
//    dispatch_queue_t queue =  dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    //2.添加任务到队列中，就可以执行任务
//    //异步函数：具备开启新线程的能力
//    dispatch_async(queue, ^{
//        //请求数据
//        NSString *share_id = [[_arrayOfCells objectAtIndex:[_arrayOfCells count]-1 ] objectForKey:@"share_id"];
//        [self postRequestComplete:share_id andRequestNum:@"10"];
//        [self removeFooterFromScrollView];
//    });

    
}

#pragma mark 刷新按钮
- (void)updateData {
    //异步
    //1.获得全局的并发队列
    dispatch_queue_t queue =  dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //2.添加任务到队列中，就可以执行任务
    //异步函数：具备开启新线程的能力
    dispatch_async(queue, ^{
        //请求数据
        NSLog(@"开始请求数据");
//        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        NSString *num = [[NSString alloc]initWithFormat:@"%lu",(unsigned long)[_arrayOfCells count]];
        [self postRequestComplete:@"0" andRequestNum:num];
        
    });

}
//7.1-warjiang
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
//    NSLog(@"定位经纬度： lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    if (self.flagCount == 1) {
        self.userLocation1 = userLocation;
//        NSLog(@"%@",self.userLocation1);
    }
    self.flagCount++;
    self.userLocation2 = userLocation;
    [self updatePOS];
}
//OC-->JS
-(void)updatePOS{
    //setLatlon(latitude,longitude)
    NSString *strExe = [[NSString alloc] initWithFormat:@"updatePOS(%lf,%lf)",_userLocation2.location.coordinate.latitude,_userLocation2.location.coordinate.longitude];
    [_mapGameCV.webView stringByEvaluatingJavaScriptFromString:strExe];
//    NSLog(@"%@",strExe);
}

#pragma mark 给cell赋值
- (void) setValueForCell:(HSIndexViewCell *)cell andWithDict:( NSDictionary *)dict{
//    NSLog(@"%@",dict);
    [cell.textLabelSmall setText:[dict objectForKey:@"share_description"]];
    [cell.textLabelLarge setText:[dict objectForKey:@"share_description"]];
    
    [cell.timeLabelSmall setText:[HSDataFormatHandle dateFormaterString:[dict objectForKey:@"share_create_time"]]];
    [cell.timeLabelLarge setText:[HSDataFormatHandle dateFormaterString:[dict objectForKey:@"share_create_time"]]];
    
    
    //nameLabelLarge  & nameLabelSmall
    NSString *text = [dict objectForKey:@"user_nickname"];
    if ([text isEqualToString:@"-10086"] || [text isEqualToString:@""] ||!text) {
        text = @"官方推荐";
    }
    cell.nameLabelLarge.text = text;
    cell.nameLabelSmall.text = text;
    
    //avataImgBtnSmall & avataImgBtnLarge
    //头像图片开始
    NSString *avatarUrl = [[NSString alloc]initWithString:[dict objectForKey:@"user_logo_img_path"]];
//    NSString *zipAvatarlUrl = [[NSString alloc] initWithFormat:@"%@%s",avatarUrl ,QiNiuImageYaSuo];
//    NSURL * urlAvarl = [NSURL URLWithString:[zipAvatarlUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];//网络图片url
    
    //由于头像是button，所以另外以一个imageview请求
    //不能临时搞一个uiimageview，不会重复请求，因此，要在cell中设置一个固定的
    
    //异步
    //1.获得全局的并发队列
    dispatch_queue_t queue =  dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //2.添加任务到队列中，就可以执行任务
    //异步函数：具备开启新线程的能力
    dispatch_async(queue, ^{

//    [cell.imgViewTmp sd_setImageWithURL:urlAvarl
//                              completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//                                  if(image){
//                                      [cell.avataImgBtnSmall setBackgroundImage:image forState:UIControlStateNormal];
//                                      
//                                      [cell.avataImgBtnLarge setBackgroundImage:image forState:UIControlStateNormal];
//                                  }
//                                  else{
//                                      [cell.avataImgBtnSmall setBackgroundImage:[UIImage imageNamed:@"评论头像.png"] forState:UIControlStateNormal];
//                                      
//                                      [cell.avataImgBtnLarge setBackgroundImage:[UIImage imageNamed:@"评论头像.png"] forState:UIControlStateNormal];
//                                  }
//                              }];
        
        [HSDataFormatHandle getImageWithUri:avatarUrl isYaSuo:true imageTarget:cell.imgViewTmp defaultImage:[UIImage imageNamed:@"评论头像"] andRequestCB:^(UIImage *image) {
            [cell.avataImgBtnSmall setBackgroundImage:image forState:UIControlStateNormal];
            
            [cell.avataImgBtnLarge setBackgroundImage:image forState:UIControlStateNormal];
        }];

    });

    
    
    //七牛图片获取
    //        NSURL *url = [NSURL URLWithString:@"http://cc.cocimg.com/bbs/3g/img/ccicon.png"];
    //        NSData *data = [NSData dataWithContentsOfURL:url];
    //        UIImage *image = [[UIImage alloc] initWithData:data];
    //        [imageView setImage:image];
    if([[dict objectForKey:@"share_img_path"] isKindOfClass:[NSArray class]]){
        NSArray *imgArray = [[NSArray alloc]initWithArray:[dict objectForKey:@"share_img_path"]];
        //        显示压缩后的图片
        //图片数组6.20by qiang
        NSMutableArray *_srcStringArray = [[NSMutableArray alloc]init];
        for(int i=0;i<imgArray.count;i++){
            NSString *imaUrl = [[NSString alloc] initWithFormat:@"%@%s",[imgArray objectAtIndex:i] ,QiNiuImageYaSuo];
            if(i==0){
                cell.imgUrl = imaUrl;
            }
            imaUrl = [HSDataFormatHandle encodeURL:imaUrl];
            [_srcStringArray addObject:imaUrl];
        }
        cell.photoGroupLarge = [[SDPhotoGroup alloc] initWithArrayOfUrl:_srcStringArray frame:cell.contentImgViewLarge.frame];
        cell.photoGroupSmall = [[SDPhotoGroup alloc] initWithArrayOfUrl:_srcStringArray frame:cell.contentImgViewSmall.frame];
        [cell.arrayLarge addObject:cell.photoGroupLarge];
        [cell.arraySmall addObject:cell.photoGroupSmall];
        [cell setSubviewsAlphaWithFactor:self.scrollView.scaleFactor];
        [cell.contentView addSubview:cell.photoGroupSmall];
        [cell.contentView addSubview:cell.photoGroupLarge];

    }
    
    //图片结束
    //shareid
    cell.shareID = [dict objectForKey:@"share_id"];
    //        NSLog(@"shareid:%@",shareID);
    
    //点赞
    NSString *shareLikeNumber = [HSDataFormatHandle handleStringNumber:[dict objectForKey:@"share_like_num"]];
    [cell.praiseLabelLarge setText:shareLikeNumber];
    
    //评论数
    NSString *commentCount = [HSDataFormatHandle handleStringNumber:[dict objectForKey:@"comment_count"]];
    [cell.commentCountLabel setText:commentCount];
    //初始化点赞 todo
    
    //        cell.praiseJudge = [self getShareLikeState:shareID]; //todo  是否点赞初始化，需要请求后台数据
    [self setShareLikeState:cell.shareID andCell:cell];

    cell.userID = [dict objectForKey:@"user_id"];
    
    //cell的地理位置信息
    if([[dict objectForKey:@"share_location"] isEqualToString:@"-10086"] || ![dict objectForKey:@"share_location"] ||[[dict objectForKey:@"share_location"] isEqualToString:@""]){
        [cell.mapLocationImg removeFromSuperview];
        [cell.mapLocationLabel removeFromSuperview];    }
    else{
        [cell.mapLocationLabel setText:[dict objectForKey:@"share_location"]];

    }
    //        [cell.shareThird addTarget:self action:@selector(shareThird:) forControlEvents:UIControlEventTouchUpInside];
    //        NSLog(@"userid:%@",[[dict objectForKey:@"user_id"] class]);
}

#pragma mark 会话列表
- (void) selectLeftAction:(id)btn{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark 重新加载数据
- (void)reloadDataByNotification{
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
        
        [self postRequestComplete:@"0" andRequestNum:@"20"];
    });

}

#pragma mark HSScaleScrollViewDelegate 协议
- (void)registerClassForCollectionView:(UICollectionView *)cv {
    [cv registerClass:[HSIndexViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
}

- (void)setDataSourceForCollectionView:(UICollectionView *)cv {
    cv.dataSource = self;
}

- (void)getMoreDataForScaleScrollView {
    NSString *share_id = [[_arrayOfCells objectAtIndex:[_arrayOfCells count]-1 ] objectForKey:@"share_id"];
    [self postRequestComplete:share_id andRequestNum:@"6"];
}

- (void)getNewDataForScaleScrollView {
    
}

- (void)gestureRecognizerStateChangedWithScaleFactor:(float)factor {
    
}

- (BOOL)shouldMyPanGestureRecognizerBebgin {
    return YES;
}


#pragma mark HSIndexViewCellDelegate 协议
- (void)commentBtnClickWithShareID:(NSString *)shareID {
    
}
- (void)praiseBtnClickWithShareID:(NSString *)shareID {
    
}
- (void)shareBtnClickWithShareID:(NSString *)shareID {
    
}
- (void)tapToScaleLarge:(HSIndexViewCell *)cell {
    [self.scrollView scaleFromCell:cell];
}


@end
