//
//  HSMineController.m
//  HotSNS
//
//  Created by 陈秋寒 on 15/3/19.
//  Copyright (c) 2015年 李长远. All rights reserved.
//

#import "HSMineController.h"
//#import "HSTabBarController.h"
#import "HSLoginViewController.h"
#import <YLMoment.h>
#import "HSCommentViewController.h"


@interface HSMineController()
@property (nonatomic, strong)HSCommentViewController *commentViewController;
@end

@implementation HSMineController
//4.11
static long n=3;
static float factor=0.45;
static float factorMax=2.222222;
static float factorMin=1;
static NSString * const reuseIdentifier = @"Cell";
@synthesize scrollView;
@synthesize panGestureRecognizerScollView;
@synthesize currentCellIndexPath;


@synthesize collectView = _collectView;
@synthesize arrayOfCells = _arrayOfCells;
//@synthesize dictionaryWithEvent = _dictionaryWithEvent;
@synthesize recipes = _recipes;

@synthesize smallLayout = _smallLayout;

@synthesize mineView = _mineView;

@synthesize currentCellTag =_currentCellTag;

@synthesize userInfo = _userInfo;

@synthesize commentViewController;

- (id)init {
    self = [super init];
    if (self) {
        //后台请求类
        self.requestDataCtrl = [[HSRequestDataController alloc] init];

        self.utils = [[HSUtilsVC alloc]init];
        
        //view初始化
        _mineView = [[HSMineView alloc]init];//用initwithfram无效
        if(_mineView){
            _mineView.frame =CGRectMake(kScreenWidth*2, 0, kScreenWidth, kScreenHeight);
            [_mineView.backgroundImage setUserInteractionEnabled:YES];
            UITapGestureRecognizer *tapTopImage=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(topImagePress)];
            [_mineView.backgroundImage addGestureRecognizer:tapTopImage];
            //        _mineView.backgroundImage.delegate=self;
            //         [noti setUserInteractionEnabled:YES];
            
            //下滑结束
            UIPanGestureRecognizer* panGestureRecognizer=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePan:)];
            panGestureRecognizer.delegate = self;
            [_mineView addGestureRecognizer:panGestureRecognizer];
        
        }
        
        
        arraySmall=[[NSMutableArray alloc]init];
        arrayLarge=[[NSMutableArray alloc]init];
        visibleCells=[[NSArray alloc]init];
        
        //初始化collection View和scroll View
        [self initCollectionViewAndScrollView];
        
        [self.mineView.backBtn addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self initCommentViewController];

    self.navigationBar.hidden = YES;
    
    
    
    if(_mineView){
        [self.view addSubview:_mineView];
//
        //现获取本地图片
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        
        _mineView.backgroundImage.contentMode = UIViewContentModeScaleAspectFill;
        _mineView.reflectedImage.contentMode =  UIViewContentModeScaleAspectFill;
        
        if([userDefaults objectForKey:@"user_logo_blurImg"]){
            
            [_mineView.reflectedImage setImage:[UIImage imageWithData:[userDefaults objectForKey:@"user_logo_blurImg"]]];
            

           [_mineView.backgroundImage setImage:[UIImage imageWithData:[userDefaults objectForKey:@"user_logo_blurImg"]]];
            
//
        }
        if([userDefaults objectForKey:@"user_logo_img"])
        {
            _mineView.avarlImage.image = [UIImage imageWithData:[userDefaults objectForKey:@"user_logo_img"]];
        }
//        NSLog(@"%f",_mineView.backgroundImage.frame.origin.y);
//        NSLog(@"%f",_mineView.reflectedImage.frame.origin.y);
        
        //todo 有问题，高度不能用clipstobounds
        _mineView.reflectedImage.transform = CGAffineTransformMakeScale(1.1, -1);
        _mineView.reflectedImage.clipsToBounds=YES;
        //解决方案，reflectedImage更改高度
        _mineView.backgroundImage.transform = CGAffineTransformMakeScale(1.2,1.2);
        _mineView.backgroundImage.clipsToBounds=YES;
        


        
        CAGradientLayer *gradientReflected = [CAGradientLayer layer];
        gradientReflected.frame = _mineView.reflectedImage.bounds;
        gradientReflected.colors = @[(id)[[UIColor colorWithRed:0 green:0 blue:0 alpha:1] CGColor],
                                     (id)[[UIColor colorWithWhite:0 alpha:0] CGColor]];
        [_mineView.reflectedImage.layer insertSublayer:gradientReflected atIndex:0];
        
        _mineView.avarlImage.layer.cornerRadius = _mineView.avarlImage.frame.size.width/2;
        _mineView.avarlImage.clipsToBounds = YES;
        _mineView.avarlImage.layer.borderWidth = 5.0f;
        _mineView.avarlImage.layer.borderColor = [UIColor grayColor].CGColor;
//        _mineView.avarlImage.image = [UIImage imageNamed:@"Home.jpg"];
        _mineView.avarlImage.contentMode = UIViewContentModeScaleAspectFill;
//        [_mineView.avarlImage setImage: [UIImage imageNamed:@"avatar_bg.png"]];
        
        
        [_mineView.gameBtn addTarget:self action:@selector(gamePress) forControlEvents:UIControlEventTouchUpInside];
        [_mineView.settingBtn addTarget:self action:@selector(gamePress) forControlEvents:UIControlEventTouchUpInside];
        //        [_mineView.NotiBtn setImage:[UIImage imageNamed:@"notification.png"] forState:UIControlStateNormal];
        [_mineView.NotiBtn addTarget:self action:@selector(notiPress) forControlEvents:UIControlEventTouchUpInside];
        [_mineView.NotiBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        
        // 注销按钮
        [_mineView.logoutBtn addTarget:self action:@selector(logOut) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(praiseBtnClick:) name:@"notificationHSMineCellPraise" object:nil];
    //    notificationHSMineCellComment
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(doComment:) name:@"notificationHSMineCellComment" object:nil];
    //    notificationHSMineCellThird
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(shareThird:) name:@"notificationHSMineCellThird" object:nil];
    
    
    //异步请求网络数据
    dispatch_queue_t queue =  dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //2.添加任务到队列中，就可以执行任务
    //异步函数：具备开启新线程的能力
    dispatch_async(queue, ^{
        [self setPersonalInfo];
//        [self getPersonInfo];
        [self postRequestComplete];
        
    });
    
    //设置用户按钮点击事件
    UITapGestureRecognizer* _tapGestureRecognizer_attendLabel = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handlerUserFanOrFollowingTap:)];
    
        UITapGestureRecognizer* _tapGestureRecognizer_fansLabel = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handlerUserFanOrFollowingTap:)];
    
    _tapGestureRecognizer_attendLabel.numberOfTapsRequired = 1;
    
    _tapGestureRecognizer_fansLabel.numberOfTouchesRequired = 1;
    
    
    self.mineView.attendLabel.userInteractionEnabled = true;
    
    self.mineView.fansLabel.userInteractionEnabled = true;
    
    //为粉丝按钮添加点击事件
    [self.mineView.fansLabel addGestureRecognizer:_tapGestureRecognizer_fansLabel];
    
    //为关注按钮添加点击事件
    [self.mineView.attendLabel addGestureRecognizer:_tapGestureRecognizer_attendLabel];
}


#pragma mark 处理用户的点击事件
-(void)handlerUserFanOrFollowingTap:(UITapGestureRecognizer *)recognizer{
    
    BOOL isFans;
    
    //如果是点击了关注列表
    if(recognizer.view == self.mineView.attendLabel){
        isFans = false;
        
    }else
    //如果是点击了粉丝列表
    {
        isFans = true;
    }

    //初始化一个用户列表的ViewController
    HSFriendListViewController* _hSFriendListViewController = [[HSFriendListViewController alloc] initWithParameter:isFans];
    
    [self presentModalViewController:_hSFriendListViewController animated:YES];
}

#pragma arrayInit

- (HSMineViewCell *)arrayInit:(HSMineViewCell *)cell{
    [arrayLarge removeAllObjects];
    [arraySmall removeAllObjects];
    
    arraySmall=[[NSMutableArray alloc]init];
    arrayLarge=[[NSMutableArray alloc]init];
    
    for (int i=1; i<5; i++) {
        [arraySmall addObject:[cell.contentView viewWithTag:i]];
    }
    
    for (int i=12; i<19; i++) {
        [arrayLarge addObject:[cell.contentView viewWithTag:i]];
    }
    
    int k=0;
    cell.nameLabelSmall=arraySmall[k++];
    cell.timeLabelSmall=arraySmall[k++];
    cell.textLabelSmall=arraySmall[k++];
    cell.contentImgViewSmall=arraySmall[k++];
    
    k=0;
    cell.nameLabelLarge=arrayLarge[k++];
    cell.timeLabelLarge=arrayLarge[k++];
    cell.textLabelLarge=arrayLarge[k++];
    cell.contentImgViewLarge=arrayLarge[k++];
    cell.praiseBtnLarge=arrayLarge[k++];
    cell.praiseLabelLarge=arrayLarge[k++];
    cell.commentBtnLarge=arrayLarge[k++];
    
    
    return cell;
}

- (void)setSmallAlpha:(HSMineViewCell*)cell andwithSec:(float)progress{
    cell.nameLabelSmall.alpha = progress;
    cell.timeLabelSmall.alpha = progress;
    cell.textLabelSmall.alpha = progress;
    cell.contentImgViewSmall.alpha = progress;
}
- (void)setLargeAlpha:(HSMineViewCell*)cell andwithSec:(float)progress{
    //    cell.avataImgBtnLarge.alpha = progress;
    cell.nameLabelLarge.alpha = progress;
    cell.timeLabelLarge.alpha = progress;
    cell.textLabelLarge.alpha = progress;
    cell.contentImgViewLarge.alpha = progress;
    cell.praiseBtnLarge.alpha = progress;
    cell.praiseLabelLarge.alpha = progress;
    cell.commentBtnLarge.alpha = progress;
}

#pragma collectionView controller
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return n;//为了测试，虚拟3倍数据
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"cellForItemAtIndexPath");
    HSMineViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    //4.11
    
    //    [self initArraysWithCell:cell];//初始化cell的大小视图数组
    //    [self setCellSubviewsAlpha];//设置透明度
    [cell setSubviewsAlphaWithFactor:factor];
    
//    cell.nameLabelSmall.text=[NSString stringWithFormat:@"%ld",indexPath.row];
//    cell.nameLabelLarge.text=[NSString stringWithFormat:@"%ld",indexPath.row];
    
    [cell setSubviewsAlphaWithFactor:factor];//设置透明度
    
//    [cell.contentImgViewSmall setImage:[UIImage imageNamed:@"activity_1.jpg"]];
//    [cell.contentImgViewLarge setImage:[UIImage imageNamed:@"activity_1.jpg"]];
//    cell.contentImgViewSmall.contentMode = UIViewContentModeScaleAspectFit;
//    cell.contentImgViewLarge.contentMode = UIViewContentModeScaleAspectFit;
    
    cell.backgroundColor = [UIColor whiteColor];
    cell.layer.cornerRadius = 4;
    cell.clipsToBounds = YES;
    
    if([_arrayOfCells count]>indexPath.row){
        //赋值
        [self setValueForCell:cell andWithDict:[_arrayOfCells objectAtIndex:indexPath.row]];
        
        //删除一个cell
        //        为每个cell添加tag
        cell.tag = indexPath.row;
        //        NSLog(@"section:%ld",(long)indexPath.section);
        [cell.deleteShareBtn addTarget:self action:@selector(deleteSharePress:) forControlEvents:UIControlEventTouchUpInside];

    }
    
    
//#pragma mark 评论按钮 注册事件
//    [self initCommentButtonsOfCell:cell];

    //cell屏幕适配 7.3
    static int width;
    static float factorWidth;
    static float factorHeight;
    static CGAffineTransform transform;
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
    width=[UIScreen mainScreen].bounds.size.width;
    transform=CGAffineTransformMakeScale(factorWidth, factorHeight);
    
    CGPoint oldOrigin=cell.frame.origin;
    float oldWidth=cell.frame.size.width;
    cell.transform=transform;
    CGRect newFrame=cell.frame;
    newFrame.origin=oldOrigin;
    newFrame.size.width=oldWidth;
    cell.frame=newFrame;

    
    return cell;
    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


#pragma mark label系统
-(id)label:(NSString *)text font:(UIFont *)font textColer:(UIColor *)color point:(CGPoint)point
{
    //1.创建lable
    UILabel *label= [[UILabel alloc]init];
    //2.设置 文字
    [label setText:text];
    //3.设置字体
    [label setFont:font];
    //4.设置文字颜色
    [label setTextColor:color];
    //5.设置对齐模式
    [label setTextAlignment:NSTextAlignmentCenter];
    //6 根据文本计数占用宽高
    CGSize size = CGSizeMake(MAXFLOAT, MAXFLOAT);
    CGSize fontSize =  [self sizeWithString:text font:font maxSize:size];
    //7 设置label x,y,w,h
    label.frame=CGRectMake(point.x,point.y,fontSize.width,fontSize.height);
    return label;
}


/**
 *  根据文本获取文本占用的大小
 *
 *  @param string  文本
 *  @param font    字体
 *  @param maxSize 最大的宽高
 *
 *
 *   说明：
 *
 *  - (CGRect)boundingRectWithSize:(CGSize)size options:(NSStringDrawingOptions)options attributes:(NSDictionary *)attributes context:(NSStringDrawingContext *)context NS_AVAILABLE_IOS(7_0);
 *
 *  size:文本能占用的最大宽高
 *  options: 计算方式
 *  attributes: 字体和大小
 *  context: nil
 *  计算的文本超过了给定的最大的宽高,就返回最大宽高,没有超过,就返回真实占用的宽高
 *
 */
- (CGSize)sizeWithString:(NSString *)string font:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *dict = @{NSFontAttributeName:font};
    CGRect rect =  [string boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil];
    CGSize cgsize = [string sizeWithAttributes:@{NSFontAttributeName:font}];
    //    NSLog(@"%f======%f",cgsize.width,cgsize.height);
    return rect.size;
}


-(id)drawUILable1{
    
    return nil;
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
    
    [_collectView registerClass:[HSMineViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    _collectView.delegate = self;
    _collectView.dataSource = self;
    _collectView.contentInset = UIEdgeInsetsMake(0, 1, 0, 0);//内容的左边距
    _collectView.backgroundColor = [UIColor clearColor];
    _collectView.scrollEnabled=NO;//collectionView不滚动
    
    //缩小collectionView，修正位置
    factor=factorMin;
    _collectView.transform=CGAffineTransformMakeScale(0.45,0.45);
    collectionViewFrame=_collectView.frame;
    collectionViewFrame.origin.x=0;
    collectionViewFrame.origin.y=0;
    _collectView.frame=collectionViewFrame;
    
    //初始化scrollView
    float scrollViewHeight=kScreenHeight*0.45;
    float scrollViewY=kScreenHeight-scrollViewHeight;
    CGRect scrollViewFrame=CGRectMake(0, scrollViewY, kScreenWidth, scrollViewHeight);
    self.scrollView=[[UIScrollView alloc]initWithFrame:scrollViewFrame];
    
    self.scrollView.contentSize=_collectView.frame.size;//设置滑动的范围
    self.scrollView.pagingEnabled=NO;
    self.scrollView.showsHorizontalScrollIndicator=YES;
    self.scrollView.clipsToBounds=NO;//不裁剪越界的collectionView，这样就不用在手势过程中修改宽度了
    self.scrollView.delegate = self;
    
    //添加pan手势给scrollView
    self.panGestureRecognizerScollView=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePanScollView:)];
    self.panGestureRecognizerScollView.delegate=self;
    
        [self.scrollView addGestureRecognizer:self.panGestureRecognizerScollView];
    [self.scrollView addSubview:_collectView];
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
    NSLog(@"gestureRecognizerShouldBexigin");
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
    NSLog(@"handlePanScollView");
    NSLog(@"缩放手势开始");
    //评论视图什么的，通通收回去
    [[NSNotificationCenter defaultCenter]postNotificationName:@"狼来了" object:nil];

    //手势开始
    if ([sender state]==UIGestureRecognizerStateBegan) {
        //获取放大的cell的index
        self.currentCellIndexPath=[_collectView indexPathForItemAtPoint:[sender locationInView:_collectView]];
        
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
    NSLog(@"handlePanScollView");
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
    visibleCells=[_collectView visibleCells];
    for (HSMineViewCell *cell in visibleCells) {
        [cell setSubviewsAlphaWithFactor:factor];
    }
}

//#pragma mark <设置某个cell的子视图透明度>
//-(void)setCellSubviewsAlpha {
//    for (UIView *view in arraySmall) {
//        view.alpha=2-factor;
//    }
//    for (UIView *view in arrayLarge) {
//        view.alpha=factor-1;
//    }
//}
//
//#pragma mark <获取某个cell的子视图>
//-(void)initArraysWithCell:(UICollectionViewCell *)cell {
//
//    [arraySmall removeAllObjects];
//    [arrayLarge removeAllObjects];
//
//    UIView *view;
//    for (int i=2; i<6; i++) {
//        view=[cell viewWithTag:i];
//        [arraySmall addObject:view];
//    }
//
//    for (int i=12; i<19; i++) {
//        view=[cell viewWithTag:i];
//        [arrayLarge addObject:view];
//    }
//
//    //以后可能要用到
//    //    int k=0;
//    //    self.backgroundImgSmall=arraySmall[k++];
//    //    self.avtivityNameSmall=arraySmall[k++];
//    //    self.publishTimeSmall=arraySmall[k++];
//    //    self.activityDescriptionSmall=arraySmall[k++];
//    //    self.activityTimeTagSmall=arraySmall[k++];
//    //    self.activityTimeSmall=arraySmall[k++];
//    //    self.activityJoinCountSmall=arraySmall[k++];
//    //
//    //    k=0;
//    //    self.backgroundImgLarge=arrayLarge[k++];
//    //    self.avtivityNameLarge=arrayLarge[k++];
//    //    self.publishTimeLarge=arrayLarge[k++];
//    //    self.activityDescriptionLarge=arrayLarge[k++];
//    //    self.activityTimeTagLarge=arrayLarge[k++];
//    //    self.activityTimeLarge=arrayLarge[k++];
//    //    self.mapViewLarge=arrayLarge[k++];
//    //    self.activityJoinCountLarge=arrayLarge[k++];
//}
//-(void)chushihua1 {
//
//    //设置宽度和position都无效。。。
//    //缩小为屏幕一半。初始是屏幕的两倍
//    factor=1;
//    _collectView.transform=CGAffineTransformMakeScale(0.5,0.5);
//
//    //因为position在这里修改无效，只好修改锚点了。。。
//    //    _collectView.layer.anchorPoint=CGPointMake(1, 0);
//    _collectView.layer.anchorPoint=CGPointMake(1, 1);
//
//
//    CGRect frame=CGRectMake(0, self.view.frame.size.height/2, self.view.frame.size.width, self.view.frame.size.height/2);
//    self.scrollView.frame=frame;
//
//    CGSize s=_collectView.frame.size;
//    //    s.height=self.view.frame.size.height/2;
//    self.scrollView.contentSize=s;
//    _collectView.scrollEnabled=NO;
//    self.scrollView.clipsToBounds=NO;
//
//    [self.scrollView addSubview:_collectView];
//    //    [self.view addSubview:self.scrollView];
//
//    //    self.panGestureRecognizer.enabled=NO;
//    //    factor=0.5;
//    //    self.scrollView.layer.anchorPoint=CGPointMake(0.5,0);
//    //    self.scrollView.layer.position=CGPointMake(0, self.view.frame.size.height);
//    //    self.scrollView.transform=CGAffineTransformMakeScale(1,factor);
//
//}
//
- (void)viewWillAppear:(BOOL)animated {
    NSLog(@"hsmine viewWillAppear ");
   
    
    
}

- (void)viewDidAppear:(BOOL)animated {
    NSLog(@"hsmine viewDidAppear ");
//    NSLog(@"%@",NSStringFromCGRect(self.view.frame));
    //滚动到首页的动画
//    [UIView animateWithDuration:0.3 animations:^{
//        //        _collectView.scrollsToTop=YES;//没有效果
//        [_collectView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
//    }];
    //异步
    //1.获得全局的并发队列
//    dispatch_queue_t queue =  dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    //2.添加任务到队列中，就可以执行任务
//    //异步函数：具备开启新线程的能力
//    dispatch_async(queue, ^{
//        //请求数据
//        NSLog(@"开始请求数据");
//        //请求网络数据
//        [self getPersonInfo];
//        
//        [self postRequestComplete];
//    });
}

- (void)viewWillDisappear:(BOOL)animated{
    NSLog(@"hsmine view will disappear");
}

- (void)viewDidDisappear:(BOOL)animated{
    NSLog(@"hsmine view did disappear");
}

#pragma 三个按钮
//notiPress
- (void)notiPress{
    NSLog(@"notiPress");
}
//setPress
- (void)setPress{
    NSLog(@"setPress");
}
//gamePress
- (void)gamePress{
    NSLog(@"gamePress");
}

#pragma 注册
//  请求数据完成后的处理
- (void)postRequestComplete
{
    
    
    //构造请求数据
    //获取用户token
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    //todo
    if(![userDefaults objectForKey:@"user_token"]){
        NSLog(@"user_token为空，");
        return;
    }
    
    NSString *user_token = [[NSString alloc]initWithString:[userDefaults objectForKey:@"user_token"]];
    NSLog(@"%@",[userDefaults objectForKey:@"user_token"]);
    
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:user_token,@"user_token",nil];
    NSDictionary *requestData = [[NSDictionary alloc] initWithObjectsAndKeys:
                                 [dic JSONString],@"requestData", nil];
    NSLog(@"%@",requestData);

    [self.requestDataCtrl getShareList:requestData andRequestCB:^(BOOL code,id responseObject, NSString *error){
        if(code){
            
            //                       NSMutableArray *tmp = [[NSMutableArray alloc]initWithArray:[responseObject objectForKey:@"shareList"]];
            if(responseObject){
                //_arrayOfCells = [responseObject objectForKey:@"shareList"];
                //                       NSLog(@"data count:%ld",[_arrayOfCells count]);
                //                       NSLog(@"[responseObject]:%@",[responseObject objectForKey:@"shareList"]);
                _arrayOfCells = [[NSMutableArray alloc] initWithArray:responseObject];
                n = [_arrayOfCells count];
                //NSLog(@"%@",[responseObject objectForKey:@"shareList"] );
//                if(n>3){ //数组长度大于0，在更新
                    //因为是异步请求，所以等请求玩成后，重新加载数据
                    //                       collectionView.frame = CGRectMake(0, 0, kScreenWidth*([_arrayOfCells count]),kScreenHeight);
                    CGRect frame = _collectView.frame;
                    
                    if (factor==factorMax) {
                        frame.size.width =kScreenWidth*[_arrayOfCells count];
                    } else {
                        frame.size.width =kScreenWidth*[_arrayOfCells count]*0.45;
                    }
                    
                    scrollView.contentSize = frame.size;
                    _collectView.frame = frame;
                    
                    [_collectView reloadData];
//                }else{
////                    [self.requestDataCtrl getMPShareList:requestData andRequestCB:^(BOOL code,id responseObject, NSString *error){
////                        if(code){
////                            
////                            if(!responseObject)
////                            {
////                                NSLog(@"是字符串类型，为空");
////                                return;
////                            }else{
////                                [_arrayOfCells addObjectsFromArray:responseObject];
////                                n = [_arrayOfCells count];
////                                //NSLog(@"%@",_arrayOfCells);
////                                //NSLog(@"%li",n);
////                                
////                                if(n>0){ //数组长度大于0，在更新
////                                    //因为是异步请求，所以等请求玩成后，重新加载数据
////                                    //                       collectionView.frame = CGRectMake(0, 0, kScreenWidth*([_arrayOfCells count]),kScreenHeight);
////                                    CGRect frame = _collectView.frame;
////                                    if (factor==factorMax) {
////                                        frame.size.width =kScreenWidth*[_arrayOfCells count];
////                                    } else {
////                                        frame.size.width =kScreenWidth*[_arrayOfCells count]*0.45;
////                                    }
////                                    scrollView.contentSize = frame.size;
////                                    _collectView.frame = frame;
////                                    
////                                    [_collectView reloadData];
////                                }
////                            }
////                            
////                            
//                        }
//                        else{
//                            NSLog(@"获取官方分享异常");
//                        }
//                    }];
        
//                }
            }
     
            
        }
        else{
            NSLog(@"请求个人分享数据异常");
        }
    }];
    
}

#pragma topImageClick
- (void)topImagePress{
    NSLog(@"topImagePress");
}

#pragma mark 点赞判断
- (void) setShareLikeState:(NSString *)shareID andCell:(HSMineViewCell *)cell{
    
    
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
 
//        NSLog(@"requestData:%@",requestData);
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

#pragma praiseBtnLarge:
#pragma mark 点赞 成功效果
-(void)praiseBtnClick:(NSNotification *)notification {
    HSMineViewCell *cell= [[HSMineViewCell alloc]init];
    
    if(notification.object){
        cell=(HSMineViewCell *)notification.object;
        NSLog(@"cell.shareID:%@",cell.shareID);
    }
    
    cell.praiseBtnLarge.userInteractionEnabled = NO;
    
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
            cell.praiseBtnLarge.userInteractionEnabled = YES;
        }];
        
    }
    
}

-(void)praiseBtnEffect:(HSMineViewCell*)cell{
    
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
}


#pragma mark share third
- (void) shareThird:(NSNotification *)noti{
    HSMineViewCell *cell = [[HSMineViewCell alloc]init];
    if(noti){
        cell = (HSMineViewCell *)noti.object;
        NSLog(@"shareid:%@",cell.shareID);
        
        //        显示压缩后的图片
        NSCharacterSet *whitespace = [NSCharacterSet  URLQueryAllowedCharacterSet];//编码，将空格编码
        NSString* strAfterDecodeByUTF8AndURI = [cell.imgUrl stringByAddingPercentEncodingWithAllowedCharacters:whitespace];
        [self shareWithcontent:cell.textLabelLarge.text withTitle:@"LiveForest分享" withImage:strAfterDecodeByUTF8AndURI withShareID:cell.shareID];
    }
    
}
-(void)shareWithcontent:(NSString*)content withTitle:(NSString*)title withImage:(NSString*)imageUrl withShareID:(NSString*)shareID{
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
#pragma mark 设置个人信息
- (void) setPersonalInfo{
    //6.20 by qiang
    //获取个人信息
    self.userInfoControl = [[HSUserInfoHandler alloc]init];
    [self.userInfoControl getUserInfoAndSaveHandler:^(BOOL completion){
        if(completion){
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            //判断是否已经有个人信息
            if([userDefaults objectForKey:@"user_logo_img"]){
                _mineView.avarlImage.image = [UIImage imageWithData:[userDefaults objectForKey:@"user_logo_img"]];
            }
            else{
                _mineView.avarlImage.image=[UIImage imageNamed:@"Home.jpg"];
            }
            //背景头像模糊
            if([userDefaults objectForKey:@"user_logo_blurImg"]){
                _mineView.backgroundImage.image = [UIImage imageWithData:[userDefaults objectForKey:@"user_logo_blurImg"]];
                _mineView.reflectedImage.image = [UIImage imageWithData:[userDefaults objectForKey:@"user_logo_blurImg"]];
            }
            else{
                _mineView.backgroundImage.image=[UIImage imageNamed:@"HomeBlur.png"];
                _mineView.reflectedImage.image=[UIImage imageNamed:@"HomeBlur.png"];
            }
            //昵称
            if([userDefaults objectForKey:@"user_nickname"]){
                [_mineView.nickName setText:[userDefaults objectForKey:@"user_nickname"]];
            }
            //描述
            if([userDefaults objectForKey:@"user_introduction"]){
                [_mineView.descriptionLabel setText:[userDefaults objectForKey:@"user_introduction"]];
            }
            //关注
            if([userDefaults objectForKey:@"user_following_num"]){
                [_mineView.attendPersons setText:[userDefaults objectForKey:@"user_following_num"]];
            }
            //粉丝
            if([userDefaults objectForKey:@"user_fans_num"]){
                [_mineView.fansPersons setText:[userDefaults objectForKey:@"user_fans_num"]];
            }
            //积分
            if([userDefaults objectForKey:@"user_credit_num"]){
                [_mineView.grades setText:[userDefaults objectForKey:@"user_credit_num"]];
            }
        }
    }];
    
    
    
}

-(void) logOut{
    _mineView.logoutBtn.userInteractionEnabled = NO;
    NSLog(@"log out");
    //构造请求数据
    //获取用户token
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    //todo
    if(![userDefaults objectForKey:@"user_token"]){
        NSLog(@"user_token为空，");
        return;
    }
    
    NSString *user_token = [[NSString alloc]initWithString:[userDefaults objectForKey:@"user_token"]];
    
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:user_token,@"user_token",nil];
    NSDictionary *requestData = [[NSDictionary alloc] initWithObjectsAndKeys:[dic JSONString],@"requestData", nil];

//
    [self.requestDataCtrl doLogout:requestData andRequestCB:^(BOOL code,id responseObject, NSString *error){
        if(code){
            ShowHud(@"注销成功", NO);
            HSLoginViewController *loginVC = [[HSLoginViewController alloc] init];
            //                   [self dismissViewControllerAnimated:YES completion:nil];
            //                   [[UIApplication sharedApplication] keyWindow].rootViewController = loginVC;
            //                   [self presentViewController:loginVC animated:YES completion:nil];
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            
            //删除用户token和用户id
            [userDefaults removeObjectForKey:@"user_token"];
            [userDefaults removeObjectForKey:@"user_id"];
            [userDefaults removeObjectForKey:@"user_logo_blurImg"];
            [userDefaults removeObjectForKey:@"user_logo_img"];
//            [userDefaults removeObjectForKey:@"hasRegistered"];
            
            //                   [self.view removeFromSuperview];
            //                   [[[UIApplication sharedApplication] keyWindow].rootViewController.view removeFromSuperview];
            //                   [[[UIApplication sharedApplication] keyWindow].rootViewController dismissViewControllerAnimated:YES completion:nil];
            
            //                   [[UIApplication sharedApplication] keyWindow].rootViewController = nil;
            //                   [[UIApplication sharedApplication] keyWindow].rootViewController = loginVC;
            //                   [self.view removeFromSuperview];
            [[[UIApplication sharedApplication] keyWindow].rootViewController dismissViewControllerAnimated:YES completion:nil];
            
            [[UIApplication sharedApplication] keyWindow].rootViewController = loginVC;
        }
        else{
            ShowHud(@"注销失败", NO);
        }
        _mineView.logoutBtn.userInteractionEnabled = YES;

    }];
    
}


- (void)backBtnClick:(id)sender {
//    [[UIApplication sharedApplication].keyWindow.rootViewController dismissViewControllerAnimated:YES completion:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}



//#pragma mark 评论模块,注册评论事件
////初始化评论视图控制器
//- (void)initCommentViewController {
//    commentViewController=[[HSCommentViewController alloc]init];
//}
////添加各种评论事件处理函数，itemFor...函数里面调用
//- (void)initCommentButtonsOfCell:(HSMineViewCell *)cell {
//    //评论按钮
//    [cell.commentBtnLarge addTarget:commentViewController action:@selector(commentBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    //发送评论按钮
//    [cell.commentView.sendBtn addTarget:commentViewController action:@selector(sendCommentBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    //黑色背景按钮
//    [cell.commentView.blackBtn addTarget:commentViewController action:@selector(blackBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    //返回按钮
//    [cell.commentView.backBtn addTarget:commentViewController action:@selector(blackBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//}

//即将开始滚动，发送开始滚动通知
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    //评论视图什么的，通通收回去
    //    [[NSNotificationCenter defaultCenter]postNotificationName:@"狼来了" object:nil];
    [commentViewController commentViewDisappearWithAnimation];
}

//删除分享deleteSharePress
- (void) deleteSharePress:(UIButton *)btn{
//    NSLog(@"%@",[btn.superview.superview class]);
    //获取点击的cell
    HSMineViewCell *cell = (HSMineViewCell *)btn.superview.superview;
    
    //先从后台删除，若成功，则删除
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if(![userDefaults objectForKey:@"user_token"]){
        NSLog(@"user_token为空，");
        ShowHud(@"鉴权失败", NO);
        return;
    }
    NSString *user_token = [[NSString alloc]initWithString:[userDefaults objectForKey:@"user_token"]];
//    NSLog(@"%@",[userDefaults objectForKey:@"user_token"]);
    NSString *share_id = cell.shareID;
    
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:
                         user_token,@"user_token",
                         share_id,@"share_id",
                         nil];
    NSDictionary *requestData = [[NSDictionary alloc] initWithObjectsAndKeys:
                                 [dic JSONString],@"requestData", nil];
    
    [self.requestDataCtrl doShareDelete:requestData andRequestCB:^(BOOL code, NSString *error){
        if(code){
            //删除数组中得一个
            [_arrayOfCells removeObjectAtIndex:cell.tag];
            
            
            //n需要重新复制
            n = [_arrayOfCells count];
            CGRect frame = _collectView.frame;
            
            if (factor==factorMax) {
                frame.size.width =kScreenWidth*[_arrayOfCells count]*0.45;
            } else {
                frame.size.width =kScreenWidth*[_arrayOfCells count]*0.45;
            }
            //    NSLog(@"%i",[_arrayOfCells count]);
            scrollView.contentSize = frame.size;
            _collectView.frame = frame;
            
            [_collectView reloadData];

        }
        else{
            ShowHud(@"删除失败，请重试", NO);
        }
    }];
    
//    NSIndexPath *indexpath = [NSIndexPath indexPathForRow:cell.tag inSection:0];
//    NSArray *deleteItems = @[indexpath];
//    [_collectView deleteItemsAtIndexPaths:deleteItems];
    
//    NSLog(@"%li",(long)cell.tag);
}

#pragma mark pangesture手势处理
- (void)handlePan:(UIPanGestureRecognizer *)gesture{
    
//    UIWindow *appWindow = [[UIApplication sharedApplication] keyWindow];
    //手势开始
    if ([gesture state]==UIGestureRecognizerStateBegan) {
//        CGRect frame=self.view.frame;
//        //        //上下平移
//                frame.origin.y = 0;
//                appWindow.rootViewController.view.frame = frame;
//        [appWindow insertSubview:appWindow.rootViewController.view belowSubview:self.view];
        
    }
    //手势改变
    else if ([gesture state]==UIGestureRecognizerStateChanged) {
        
        
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
        //        settingView.alpha=self.view.frame.origin.y/self.view.frame.size.height;
        
        //清空手势的位移，因为位移是累加的。
        [gesture setTranslation:CGPointMake(0, 0) inView:self.view];
        
    }
    //手势结束
    else if ([gesture state]==UIGestureRecognizerStateEnded) {
        
        //获取手势的位移
        //        CGPoint translation=[gesture translationInView:self.view];
        
        //速度velocity.y>0是往下平移
        if ([gesture velocityInView:self.view].y>0) {
            [UIView animateWithDuration:0.3 animations:^{
                CGRect frame=self.view.frame;
                frame.origin.y=kScreenHeight;
                self.view.frame=frame;
                
            }completion:^(BOOL finished) {
                [self.view removeFromSuperview];
            }];
        }else{
            [UIView animateWithDuration:0.3 animations:^{
                CGRect frame=self.view.frame;
                frame.origin.y=0;
                self.view.frame=frame;
                
            }completion:^(BOOL finished) {
                //                [self.view removeFromSuperview];
            }];
        }
    }
    else if([gesture state]==UIGestureRecognizerStateCancelled){
        //速度velocity.y>0是往下平移
        if ([gesture velocityInView:self.view].y>0) {
            [UIView animateWithDuration:0.3 animations:^{
                CGRect frame=self.view.frame;
                frame.origin.y=kScreenHeight;
                self.view.frame=frame;
                
            }completion:^(BOOL finished) {
                [self.view removeFromSuperview];
            }];
        }else{
            [UIView animateWithDuration:0.3 animations:^{
                CGRect frame=self.view.frame;
                frame.origin.y=0;
                self.view.frame=frame;
                
            }completion:^(BOOL finished) {
                //                [self.view removeFromSuperview];
            }];
        }
    }
    
}

#pragma mark 给cell赋值
- (void) setValueForCell:(HSMineViewCell *)cell andWithDict:( NSDictionary *)dict{
    
    NSString *text = [dict objectForKey:@"share_description"];
    if ([text isEqualToString:@""]) {
        text = @"爱运动、爱分享——LiveForest";
    }
    [cell.textLabelSmall setText:text];
    [cell.textLabelLarge setText:text];
    
    [cell.timeLabelSmall setText:[HSDataFormatHandle dateFormaterString:[dict objectForKey:@"share_create_time"] ]];
    [cell.timeLabelLarge setText:[HSDataFormatHandle dateFormaterString:[dict objectForKey:@"share_create_time"] ]];
    
    
    
    text = [[NSString alloc] initWithString:
            [[dict objectForKey:@"user_nickname"] isEqualToString:@"-10086"]?@"LiveForest":[dict objectForKey:@"user_nickname"]];
    if([[dict objectForKey:@"user_nickname"] isEqualToString:@""]){
        text = @"LiveForest";
    }
    [cell.nameLabelSmall setText:_mineView.nickName.text];
    [cell.nameLabelLarge setText:_mineView.nickName.text];
    
    //七牛图片获取
    //        NSURL *url = [NSURL URLWithString:@"http://cc.cocimg.com/bbs/3g/img/ccicon.png"];
    //        NSData *data = [NSData dataWithContentsOfURL:url];
    //        UIImage *image = [[UIImage alloc] initWithData:data];
    //        [imageView setImage:image];
    //异步请求网络数据
    
    NSArray *imgArray = [[NSArray alloc]initWithArray:[dict objectForKey:@"share_img_path"]];
    NSMutableArray *_srcStringArray = [[NSMutableArray alloc]init];
    for(int i=0;i<imgArray.count;i++){
        NSString *imaUrl = [[NSString alloc] initWithFormat:@"%@%s",[imgArray objectAtIndex:i] ,QiNiuImageYaSuo];
        if(i==0){
            cell.imgUrl = imaUrl;
        }
        imaUrl = [HSDataFormatHandle encodeURL:imaUrl];
        [_srcStringArray addObject:imaUrl];
    }
    
    SDPhotoGroup *photoGroupLarge = [[SDPhotoGroup alloc] initWithArrayOfUrl:_srcStringArray frame:cell.contentImgViewLarge.frame];
    SDPhotoGroup *photoGroupSmall = [[SDPhotoGroup alloc] initWithArrayOfUrl:_srcStringArray frame:cell.contentImgViewSmall.frame];
    
    //            NSLog(@"%f",photoGroupSmall.frame.size.width);
    
    [cell.contentView addSubview:photoGroupLarge];
    [cell.contentView addSubview:photoGroupSmall];
    [cell.arrayLarge addObject:photoGroupLarge];
    [cell.arraySmall addObject:photoGroupSmall];
#warning 替换成新的手势模块后记得修改为下面的语句
    [cell setSubviewsAlphaWithFactor:1];//这里有bug，替换成新的手势模块后记得修改为下面的语句
//    [cell setSubviewsAlphaWithFactor:self.scrollView.scaleFactor];

    
    //点赞
    NSString *praiseCount = [HSDataFormatHandle handleStringNumber:[dict objectForKey:@"share_like_num"]];
    [cell.praiseLabelLarge setText:praiseCount];
    
    //shareid
    cell.shareID = [dict objectForKey:@"share_id"];
    [self setShareLikeState:cell.shareID andCell:cell];
    
    
    //cell的地理位置信息
    if([[dict objectForKey:@"share_location"] isEqualToString:@"-10086"] || ![dict objectForKey:@"share_location"] ||[[dict objectForKey:@"share_location"] isEqualToString:@""]){
        [cell.mapLocationBtn removeFromSuperview];
        [cell.mapLocationLabel removeFromSuperview];    }
    else{
        [cell.mapLocationLabel setText:[dict objectForKey:@"share_location"]];
    }
    
    //评论数
    NSString *commentCount = [HSDataFormatHandle handleStringNumber:[dict objectForKey:@"comment_count"]];
    [cell.commentCount setText:commentCount];
}
@end
