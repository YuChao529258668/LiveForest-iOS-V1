//
//  HSGameRootViewController.m
//  LiveForest
//
//  Created by 余超 on 15/9/9.
//  Copyright © 2015年 HOTeam. All rights reserved.
//

#import "HSGameRootViewController.h"
#import "HSScaleScrollView.h"
#import "HSGameCell.h"
#import <FBShimmeringView.h>

#import "HSGameChartsViewController.h"
#import "HSOnGoingGameViewController.h"
#import "HSGameProcessViewController.h"
#import "HSGameInviteViewController.h"


#import "ServiceHeader.h"//引入服务头文件

#import <TuSDK/TuSDK.h>

static NSString *reuseIdentifier = @"HSGameCell";

@interface HSGameRootViewController ()<HSScaleScrollViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) HSGameChartsViewController *gameChartsVC;
@property (nonatomic, strong) HSOnGoingGameViewController *onGoingVC;
@property (nonatomic, strong) HSGameProcessViewController *gameProcessVC;
@property (nonatomic, strong) HSGameInviteViewController *gameInviteVC;
@property (weak, nonatomic) IBOutlet UIView *testView;

@end

@implementation HSGameRootViewController

#pragma mark - 初始化
- (instancetype)init {
    if (self = [super init]) {
        [self setUpScrollView];
        [self setUpShimmeringView];
        [self setUpControllers];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
//    self.scrollView = [[HSScaleScrollView alloc]initWithCellCount:0 Delegate:self shouldGetMoreData:NO];
//    [self setUpScrollView];
//    [self setUpShimmeringView];
    NSLog(@"HSGameRootViewController.h viewDidLoad");
    self.testView.hidden =YES;
    
    //页面加载好之后，开始请求健康数据
//    [[HealthKitService sharedInstance] requestAuthorization]; // 运行异常，先注释掉
    
}

//闪闪发光
- (void)setUpShimmeringView {
    //shimmer
    FBShimmeringView *shimmeringView;
    shimmeringView = [[FBShimmeringView alloc] initWithFrame:CGRectMake(10, 0, 80, 80)];
    [self.view addSubview:shimmeringView];
    
    UILabel *loadingLabel = [[UILabel alloc] initWithFrame:shimmeringView.bounds];
    loadingLabel.textAlignment = NSTextAlignmentLeft;
    loadingLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:25];
    loadingLabel.textColor = [UIColor whiteColor];
    loadingLabel.shadowColor = [UIColor colorWithWhite:0.4f alpha:0.8f];
    loadingLabel.text = NSLocalizedString(@"游戏", nil);
    
    shimmeringView.contentView = loadingLabel;
    shimmeringView.shimmeringPauseDuration = 0.1;
    shimmeringView.shimmeringAnimationOpacity = 0.3;
    shimmeringView.shimmeringSpeed = 40;
    shimmeringView.shimmeringHighlightLength = 1;
    shimmeringView.shimmering = YES;
}

- (void)setUpScrollView {
    self.scrollView = [[HSScaleScrollView alloc]initWithCellCount:4 Delegate:self shouldGetMoreData:NO];
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.scrollView.collectionView.collectionViewLayout;
//    layout.minimumInteritemSpacing = 5;
    layout.minimumLineSpacing = 10;
}

- (void)setUpControllers {
    self.gameChartsVC = [[HSGameChartsViewController alloc]init];
    self.onGoingVC = [[HSOnGoingGameViewController alloc]init];
    self.gameProcessVC = [[HSGameProcessViewController alloc]init];
    self.gameInviteVC = [[HSGameInviteViewController alloc]init];
    
    self.gameChartsVC.view.frame = [UIScreen mainScreen].bounds;
    self.onGoingVC.view.frame = [UIScreen mainScreen].bounds;
    self.gameProcessVC.view.frame = [UIScreen mainScreen].bounds;
    self.gameInviteVC.view.frame = [UIScreen mainScreen].bounds;

//    [self addChildViewController:self.gameChartsVC];
//    [self addChildViewController:self.onGoingVC];
//    [self addChildViewController:self.gameProcessVC];
//    [self addChildViewController:self.gameInviteVC];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 4;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HSGameCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    switch (indexPath.row) {
        case 0:
            [cell.contentView addSubview:self.onGoingVC.view];
            break;
        case 1:
            [cell.contentView addSubview:self.gameChartsVC.view];
            break;
        case 2:
            [cell.contentView addSubview:self.gameProcessVC.view];
            break;
        case 3:
            [cell.contentView addSubview:self.gameInviteVC.view];
            break;
        default:
            break;
    }
//    cell.backgroundColor = [UIColor blueColor];
    cell.clipsToBounds = YES;
    return cell;
}

#pragma mark - HSScaleScrollViewDelegate
//collectionView的cell注册
- (void)registerClassForCollectionView:(UICollectionView *)cv {
    [cv registerClass:[HSGameCell class] forCellWithReuseIdentifier:reuseIdentifier];
//    [cv registerNib:[UINib nibWithNibName:@"HSGameCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];

}
//设置collectionView的数据源
- (void)setDataSourceForCollectionView:(UICollectionView *)cv {
    cv.dataSource = self;
}
//向左滑动到尾部时会让委托去获取更多的数据
- (void)getMoreDataForScaleScrollView {
    
}
//让委托去获取新的数据
- (void)getNewDataForScaleScrollView {
    
}
//告诉委托我正在缩放，你可以做爱做的事，参数是缩放因子
- (void)gestureRecognizerStateChangedWithScaleFactor:(float)factor {
    
}
//询问委托，本类的手势是否应该开始
- (BOOL)shouldMyPanGestureRecognizerBebgin {
    return YES;
}

- (void)didScaleToSmallWithScrollView:(HSScaleScrollView *)scrollView {
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.scrollView.collectionView.collectionViewLayout;
    layout.minimumLineSpacing = 10;
}

- (void)didScaleToLargeWithScrollView:(HSScaleScrollView *)scrollView {
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.scrollView.collectionView.collectionViewLayout;
    layout.minimumLineSpacing = 2;
}
#pragma mark - 跳转到游戏界面
- (IBAction)startGameClick:(UIButton *)sender {
    
    //Test 测试分享服务
//    [[SocialService sharedInstance] doSocialShareWithContent:@"测试" AndHref:@"http://baidu.com" WithCallBack:^(bool code) {
//        NSLog(@"%@",code);
//    }];
    
    //启动Cordova服务
    [[CordovaService getSingletonInstance] startPage:@"game.html" fromViewController:self];
}

@end
