//
//  HSVisitMineController.m
//  HotSNS
//
//  Created by 微光 on 15/3/25.
//  Copyright (c) 2015年 李长远. All rights reserved.
//

#import "HSVisitMineController.h"
#import "HSVisitMineCell.h"

//4.16 by qiang
// 引用 IMKit 头文件。
#import <RongIMKit/RongIMKit.h>
#import "HSCommentViewController.h"
#import "ServiceHeader.h"

@interface HSVisitMineController ()

    /*初始化评论界面*/
    @property (nonatomic, strong)HSCommentViewController *commentViewController;
@end

@implementation HSVisitMineController
//4.11
static int n=6;
static float factor=0.45;
static float factorMax=2.222222;
static float factorMin=1;
static NSString * const reuseIdentifier = @"Cell";
//@synthesize scrollView;
@synthesize panGestureRecognizerScollView;
@synthesize currentCellIndexPath;
@synthesize visitMineView;

//@synthesize collectionView = _collectView;
@synthesize arrayOfCells = _arrayOfCells;
//@synthesize dictionaryWithEvent = _dictionaryWithEvent;
@synthesize recipes = _recipes;

@synthesize smallLayout = _smallLayout;

@synthesize userId = _userId;
@synthesize userInfo = _userInfo;
@synthesize commentViewController;


static NSString *cellIdentifier = @"CellForHSMineWithIdentifier";

-(void)disimissVisitMineView {
    [self.view removeFromSuperview];
}

#pragma mark - LifeCycle

- (id)init {
    self = [super init];
    if (self) {
        
        //后台请求类
        self.requestDataCtrl = [[HSRequestDataController alloc] init];
        
        self.utils = [[HSUtilsVC alloc]init];
        
         _arrayOfCells = [NSMutableArray arrayWithObjects: nil];
        
        arraySmall=[[NSMutableArray alloc]init];
        arrayLarge=[[NSMutableArray alloc]init];
        visibleCells=[[NSArray alloc]init];
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(praiseBtnClick:) name:@"notificationHSMineCellPraise" object:nil];

        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(shareThird:) name:@"notificationHSMineCellThird" object:nil];
        
        
        //初始化collection View和scroll View
//        [self initCollectionViewAndScrollView];
        self.scrollView =[[HSScaleScrollView alloc]initWithCellCount:_arrayOfCells.count Delegate:self shouldGetMoreData:YES];
        
//        [self.view addSubview:self.scrollView];
        
//        [self initCommentViewController];

    }
    return self;
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"notificationHSMineCellPraise" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"notificationHSMineCellThird" object:nil];
}
#pragma mark - View LifeCycle

#pragma mark 界面加载完毕的回调事件
- (void)loadView{
    visitMineView=[[HSVisitMineView alloc]initWithParentController:self];
    //        visitMineView.topImage.image = blurImage;
    //        visitMineView.topImage.transform = CGAffineTransformMakeScale(1.0,1.15);
    visitMineView.topImage.contentMode = UIViewContentModeScaleAspectFill;
    visitMineView.topImage.clipsToBounds=YES;
    
    visitMineView.reflected.transform = CGAffineTransformMakeScale(1.0, -1);
    //        visitMineView.reflected.image =blurImage;
    visitMineView.reflected.contentMode = UIViewContentModeScaleAspectFill;
    visitMineView.reflected.clipsToBounds=YES;
    //渐变
    CAGradientLayer *gradientReflected = [CAGradientLayer layer];
    gradientReflected.frame = visitMineView.reflected.bounds;
    gradientReflected.colors = @[(id)[[UIColor colorWithRed:0 green:0 blue:0 alpha:1] CGColor],
                                 (id)[[UIColor colorWithWhite:0 alpha:0] CGColor]];
    [visitMineView.reflected.layer insertSublayer:gradientReflected atIndex:0];
    
    [visitMineView.backBtn addTarget:self action:@selector(disimissVisitMineView) forControlEvents:(UIControlEventTouchUpInside)];
    
    //        userLogo.frame = CGRectMake(10, kScreenHeight/2*0.25, 140, 140);
    visitMineView.avartarImage.layer.cornerRadius = visitMineView.avartarImage.frame.size.width/2;
    visitMineView.avartarImage.clipsToBounds = YES;
    visitMineView.avartarImage.layer.borderWidth = 5.0f;
    visitMineView.avartarImage.layer.borderColor = [UIColor grayColor].CGColor;
    //        visitMineView.avartarImage.image = [UIImage imageNamed:@"avarl.jpg"];
    visitMineView.avartarImage.contentMode = UIViewContentModeScaleAspectFill;
    //右上角按钮
    [visitMineView.chatBtn addTarget:self action:@selector(chatPress:) forControlEvents:UIControlEventTouchUpInside];
    [visitMineView.attendBtn addTarget:self action:@selector(attendPress:) forControlEvents:UIControlEventTouchUpInside];
    //下滑结束
    UIPanGestureRecognizer* panGestureRecognizer=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePan:)];
    panGestureRecognizer.delegate = self;
    [panGestureRecognizer requireGestureRecognizerToFail:self.scrollView.panGestureRecognizerScollView];//修复缩放和下滑消失的手势冲突
    [visitMineView addGestureRecognizer:panGestureRecognizer];

    //将生成的页面赋值给当前View
    self.view=visitMineView;
    [self.view addSubview:self.scrollView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    visitMineView.topImage.image = [UIImage imageNamed:@"Home.jpg"];
//    visitMineView.reflected.transform = CGAffineTransformMakeScale(1.0, -1.0);
//    visitMineView.reflected.image = [UIImage imageNamed:@"Home.jpg"];
    
    //加载collectionView数据
   
//    for (int i = 1; i < 5; i++) {
//        
//        NSDictionary *dict = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[NSString stringWithFormat:@"pic_home%d",i], @"Jaspr Wang", @"12:20", @"健身开始，上午游泳下午健身房", [NSString stringWithFormat:@"pic_product%d",i], nil] forKeys:[NSArray arrayWithObjects:@"avatarImg", @"name", @"time", @"text", @"contentImg", nil]];
//        [_arrayOfCells addObject:dict];
//    }
    
    //添加查看详细信息的按钮点击事件
    //注册点击事件
    [self.visitMineView.showDetailInfoBtn addTarget:self action:@selector(onClickByDetailButton:) forControlEvents:UIControlEventTouchUpInside];
    
    //设置用户按钮点击事件
    //初始化手势监听器
    UITapGestureRecognizer* _tapGestureRecognizer_attendLabel = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handlerUserFanOrFollowingTap:)];
    
    //初始化手势监听器
    UITapGestureRecognizer* _tapGestureRecognizer_fansLabel = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handlerUserFanOrFollowingTap:)];
    
    _tapGestureRecognizer_attendLabel.numberOfTapsRequired = 1;
    
    _tapGestureRecognizer_fansLabel.numberOfTouchesRequired = 1;
    
    
    self.visitMineView.attentionLabel.userInteractionEnabled = true;
    
    self.visitMineView.fansLabel.userInteractionEnabled = true;
    
    //为粉丝按钮添加点击事件
    [self.visitMineView.fansLabel addGestureRecognizer:_tapGestureRecognizer_fansLabel];
    
    //为关注按钮添加点击事件
    [self.visitMineView.attentionLabel addGestureRecognizer:_tapGestureRecognizer_attendLabel];

    
}

#pragma mark 处理用户的点击事件
-(void)handlerUserFanOrFollowingTap:(UITapGestureRecognizer *)recognizer{
    
    BOOL isFans;
    
    //如果是点击了关注列表
    if(recognizer.view == self.visitMineView.attentionLabel){
        isFans = false;
        
    }else
        //如果是点击了粉丝列表
    {
        isFans = true;
    }
    
    //初始化一个用户列表的ViewController
    HSFriendListViewController* _hSFriendListViewController = [[HSFriendListViewController alloc] initWithParameter:isFans withFriend:self.userId];
    
    [self presentModalViewController:_hSFriendListViewController animated:YES];
}


/**
 *@function 响应详细资料的点击事件
 **/
- (IBAction)onClickByDetailButton:(id)sender{
    
    //加载当前的故事版
    UIStoryboard *sb=[UIStoryboard storyboardWithName:@"Storyboard" bundle:[NSBundle mainBundle]];
    
    //获取当前需要跳转的UIViewController
    HSMineDetailViewController *vc=[sb instantiateViewControllerWithIdentifier:@"MineDetailStoryBoard"];
    
    vc.userInfo = self.userInfo;
    
    //进行UIViewController的跳转
    [self presentViewController:vc animated:YES completion:nil];
}

- (void) tapTopImage{
    NSLog(@"点击topimage...........");
}
- (void)backIconPressed:(id)sender {
    NSLog(@"backIconPressed");
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma collectionView controller
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return n;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HSVisitMineCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    //4.11
    [cell setSubviewsAlphaWithFactor:factor];
    
//    cell.nameLabelSmall.text=[NSString stringWithFormat:@"%ld",indexPath.row];
//    cell.nameLabelLarge.text=[NSString stringWithFormat:@"%ld",indexPath.row];
    
    [cell setSubviewsAlphaWithFactor:factor];//设置透明度
    
    
//    
//    [cell.contentImgViewSmall setImage:[UIImage imageNamed:@"activity_1.jpg"]];
//    [cell.contentImgViewLarge setImage:[UIImage imageNamed:@"activity_1.jpg"]];
//    cell.contentImgViewLarge.contentMode = UIViewContentModeScaleAspectFit;
//    cell.contentImgViewSmall.contentMode = UIViewContentModeScaleAspectFit;
    
    cell.backgroundColor = [UIColor whiteColor];
    cell.layer.cornerRadius = 4;
    cell.clipsToBounds = YES;
    //对view进行赋值操作
    //    NSDictionary *dict = [_arrayOfCells objectAtIndex:indexPath.row % 4];//多了虚拟的4组数据，自定义
    //    [cell.avataImgBtn setBackgroundImage:[UIImage imageNamed:dict[@"avatarImg"]] forState:UIControlStateNormal];
    //    //    [cell.avataImgBtn addTarget:self action:@selector(avatarBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    //    cell.nameLabel.text = dict[@"name"];
    //    cell.timeLabel.text = dict[@"time"];
    //    cell.textLabel.text = dict[@"text"];
    //    [cell.contentImgView setImage:[UIImage imageNamed:dict[@"contentImg"]]];
    //    cell.backgroundColor = [UIColor whiteColor];
    
    if([_arrayOfCells count]>indexPath.row){
      
        //赋值
        [self setValueForCell:cell andWithDict:[_arrayOfCells objectAtIndex:indexPath.row]];

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



#pragma mark
#pragma mark 《手势动画相关》
#pragma mark <初始化collectionview和scrollView>
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
//    [self.collectionView registerClass:[HSVisitMineCell class] forCellWithReuseIdentifier:reuseIdentifier];
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
//    self.scrollView.delegate=self;
//    self.scrollView.contentSize=self.collectionView.frame.size;//设置滑动的范围
//    self.scrollView.pagingEnabled=NO;
//    self.scrollView.showsHorizontalScrollIndicator=YES;
//    self.scrollView.clipsToBounds=NO;//不裁剪越界的collectionView，这样就不用在手势过程中修改宽度了
//    
//    //添加pan手势给scrollView
//    self.panGestureRecognizerScollView=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePanScollView:)];
//    self.panGestureRecognizerScollView.delegate=self;
//    
//    [self.scrollView addGestureRecognizer:self.panGestureRecognizerScollView];
//    [self.scrollView addSubview:self.collectionView];
//    [self.view addSubview:self.scrollView];
//    
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
//- (void)handlePanScollView:(id)sender {
//    //手势开始
//    if ([sender state]==UIGestureRecognizerStateBegan) {
//        NSLog(@"visitMine 缩放手势开始");
//        //评论视图什么的，通通收回去
//        [[NSNotificationCenter defaultCenter]postNotificationName:@"狼来了" object:nil];
//
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

#pragma mark <点击一个cell>
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
#pragma mark 《手势动画结束》
#pragma mark

#pragma mark <设置所有可视cell的子视图>
//-(void)setAllVisibleCellsSubviewsAlpha {
//    visibleCells=[self.collectionView visibleCells];
//    for (HSVisitMineCell *cell in visibleCells) {
//        [cell setSubviewsAlphaWithFactor:factor];
//    }
//}


- (void)viewWillAppear:(BOOL)animated {
    NSLog(@"visit mine view will appear");


}

- (void)viewDidAppear:(BOOL)animated {
    //滚动到首页的动画
//    if([self.collectionView numberOfItemsInSection:0]>=4) {
//        [UIView animateWithDuration:3 animations:^{
//            //        self.collectionView.scrollsToTop=YES;//没有效果
//            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
//        }completion:^(BOOL finished) {
//            [UIView animateWithDuration:3 animations:^{
//                [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
//            }];
//            
//        }];
//    }
//    NSLog(@"%@",self.scrollView.collectionView.dataSource.class);
//    NSLog(@"%@",self.scrollView.collectionView.dataSource);
//    NSLog(@"%@",self.scrollView.collectionView);
//    self.scrollView.collectionView.dataSource = self;
//    [self.scrollView reloadDataWithArrayCount:_arrayOfCells.count];
}


#pragma 右上角按钮
#pragma chat
- (void)chatPress:(id)sender{
    
//    // 连接融云服务器。
//
//    // 您需要根据自己的 App 选择场景触发聊天。这里的例子是一个 Button 点击事件。
//    RCConversationViewController *conversationVC = [[RCConversationViewController alloc]init];
//    conversationVC.conversationType =ConversationType_PRIVATE; //会话类型，这里设置为 PRIVATE 即发起单聊会话。
//    conversationVC.targetId = [_userInfo objectForKey:@"user_id"]; // 接收者的 targetId，这里为举例。
////    conversationVC.targetId = [[NSUserDefaults standardUserDefaults] objectForKey:@"rong_cloud_id"];  //测试自己
////    conversationVC.targetId = @"143219816402170975";
//    conversationVC.targetName = [_userInfo objectForKey:@"user_nickname"]; // 接受者的 username，这里为举例。
//    conversationVC.title = @"私人聊天室"; // 会话的 title。
//
//                    //backIcon
////                    UIButton *backIcon = [[UIButton alloc] initWithFrame:CGRectMake(0 , 20, 36, 36)];
////                    [backIcon setImage:[UIImage imageNamed:@"ic_arrow_back_white_48dp.png"] forState:UIControlStateNormal];
//////                    [backIcon setTitle:@"Back" forState:UIControlStateNormal];
//////                    backIcon.backgroundColor = [UIColor blueColor];
////                    [backIcon addTarget:self action:@selector(backIconPressed) forControlEvents:UIControlEventTouchUpInside];
//    
////    [conversationVC.view addSubview:backIcon];
//    
//    // 初始化 UINavigationController。
//    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:conversationVC];
//    
//    // 设置背景颜色为黑色。
//    [conversationVC.navigationController.navigationBar setBackgroundColor:[UIColor blackColor]];
//    conversationVC.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Back" style:UIBarButtonSystemItemAction target:self action:@selector(backConversion)];//设置navigationbar左边按钮
//    
//    [self presentViewController:nav animated:YES completion:nil];

//    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
//    [window insertSubview: nav.view aboveSubview:self.view];
    
    //获取到当前用户的user_token
    NSString *user_token = [[NSString alloc]initWithString:[[NSUserDefaults standardUserDefaults] objectForKey:@"user_token"]];//如果不存在usertoken,则不能赋值
    
    
    //启动对话页面
    [[IMService getSingletonInstance] singleChatroom:user_token withFriendInfo:_userInfo fromViewController:self];
    
}
- (void)backIconPressed{
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma attendPress
//todo
- (void)attendPress:(UIButton*)sender{
    
    //新增接口
    NSString *user_token = [[NSString alloc]initWithString:[[NSUserDefaults standardUserDefaults] objectForKey:@"user_token"]];//如果不存在usertoken,则不能赋值
    //NSLog(@"%@",visitMineView);
    NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:user_token,@"user_token",
                         _userId,@"user_following_id", nil];
    NSDictionary *requestData = [[NSDictionary alloc] initWithObjectsAndKeys:[dic JSONString],@"requestData", nil];
    
    if(!visitMineView.hasAttended){
        //则点击为了关注
        [self.requestDataCtrl doFollowingAttention:requestData andRequestCB:^(BOOL code, NSString *error){
            if(code){
                [visitMineView.attendBtn setImage:[UIImage imageNamed:@"ic_unfollow"] forState:UIControlStateNormal];
                [visitMineView.attendStateLabel setText:@"已关注"];
                visitMineView.hasAttended = true;
            }
            else{
                ShowHud(@"关注失败，请重试", NO);
            }
        }];
        
    }else{
        [self.requestDataCtrl doFollowingCancel:requestData andRequestCB:^(BOOL code, NSString *error){
            if(code){
                [visitMineView.attendBtn setImage:[UIImage imageNamed:@"ic_add_person"] forState:UIControlStateNormal];
                [visitMineView.attendStateLabel setText:@"关注"];
                visitMineView.hasAttended = false;

            }
            else{
                ShowHud(@"取消关注失败，请重试", NO);
            }
        }];
        
    }
    
}


#pragma 注册
//  请求数据完成后的处理
- (void)postRequestComplete
{
    //todo for test
    //构造请求数据
    
    //获取用户token
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    if(![userDefaults objectForKey:@"user_token"]){
        NSLog(@"user_token为空，");
    }
    else{
        NSString *user_token = [[NSString alloc]initWithString:[userDefaults objectForKey:@"user_token"]];//如果不存在usertoken,则不能赋值
        //NSLog(@"%@",visitMineView);
        NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:user_token,@"user_token",
                             _userId,@"user_id", nil];
        NSDictionary *requestData = [[NSDictionary alloc] initWithObjectsAndKeys:
                                 [dic JSONString],@"requestData", nil];
    NSLog(@"%@",requestData);

        [self.requestDataCtrl getShareList:requestData andRequestCB:^(BOOL code,id responseObject, NSString *error){
            if(code){
                
                if(!responseObject)
                {
                    NSLog(@"responseObject是字符串类型，为空");
                    return;
                }
                else {
                    [_arrayOfCells addObjectsFromArray:responseObject];
                    
                    n = [_arrayOfCells count];
//                    if(n>=3){ //数组长度大于0，在更新
                        //因为是异步请求，所以等请求玩成后，重新加载数据
                        
//                        CGRect frame = _collectView.frame;
                    
//                        if (factor==factorMax) {
//                            frame.size.width =kScreenWidth*[_arrayOfCells count];
//                        } else {
//                            frame.size.width =kScreenWidth*[_arrayOfCells count]*0.45;
//                        }
                    
//                        scrollView.contentSize = frame.size;
//                        _collectView.frame = frame;
                    
                        //todo  关于reloaddata，应该以什么方式？主线程处理
                        dispatch_async(dispatch_get_main_queue(), ^{ /* do UI things */
//                            [_collectView reloadData];
                            [self.scrollView reloadDataWithArrayCount:_arrayOfCells.count];
                        });
                        //                                   or [self performSelectorOnMainThread:@selector(doUIthings) withObject:nil waitUntilDone:NO];
                        //                                   [self.collectionView reloadData];
//                    } else{
//                        请求系统推荐数据
//                        [self.requestDataCtrl getMPShareList:requestData andRequestCB:^(BOOL code,id responseObject, NSString *error){
//                            if(code){
//                                
//                                if(!responseObject)
//                                {
//                                    NSLog(@"是字符串类型，为空");
//                                    return;
//                                }else{
//                                    
//                                    [_arrayOfCells addObjectsFromArray:responseObject];
//                                    n = [_arrayOfCells count];
//                                    
//                                    if(n>0){
//                                        CGRect frame = _collectView.frame;
//                                        if (factor==factorMax) {
//                                            frame.size.width =kScreenWidth*[_arrayOfCells count];
//                                        } else {
//                                            frame.size.width =kScreenWidth*[_arrayOfCells count]*0.45;
//                                        }
//                                        scrollView.contentSize = frame.size;
//                                        _collectView.frame = frame;
//                                        
//                                        //todo
//                                        dispatch_async(dispatch_get_main_queue(), ^{ /* do UI things */
//                                            [_collectView reloadData];
//                                        });
//                                    }
//                                }
//                                
//                                
//                            }
//                            else{
//                                NSLog(@"获取官方分享异常");
//                            }
//                        }];
//                    
//                    }
                    
                }
                
                
            }
            else{
                NSLog(@"请求个人分享数据异常");
            }
        }];
       }
    
}

#pragma mark <隐藏添加评论视图>
//-(void)addCommentViewDisappear {
//    //如果没放大过，currentCellIndexPath会是nil，所以factor==2的时候才会被调用。
//    HSVisitMineCell *cell=(HSVisitMineCell *)[self.collectionView cellForItemAtIndexPath:self.currentCellIndexPath];
//    if (cell.addCommentView.alpha!=0) {
////        [cell addCommentViewDisappearWithAnimation];
//    }
//}

#pragma mark 接收到userid后，进行请求个人信息
- (void)requestPersonalInfoWithUserID:(NSString *)userID{
    _userId = userID;
    if(!_userId){
        return;
    }
    [self getFollowingInfo];
    [self postRequestComplete];
}
#pragma 获取被关注人的个人详情
-(void)getFollowingInfo{
    //获取用户token
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    if(![userDefaults objectForKey:@"user_token"]){
        NSLog(@"user_token为空，");
    }
    else{
        NSString *user_token = [[NSString alloc]initWithString:[userDefaults objectForKey:@"user_token"]];//如果不存在usertoken,则不能赋值
        //NSLog(@"%@",visitMineView);
        NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:user_token,@"user_token",
                             _userId,@"user_id", nil];
        NSDictionary *requestData = [[NSDictionary alloc] initWithObjectsAndKeys:[dic JSONString],@"requestData", nil];
        
//        getUserInfo
        [self.requestDataCtrl getUserInfo:requestData andRequestCB:^(BOOL code,id responseObject, NSString *error){
            if(code){
                
                //DDLogInfo(@"%@",[responseObject objectForKey:@"userInfo"]);
                //DDLogInfo(@"%@",[[responseObject objectForKey:@"followingInfo"] class]);
                if(responseObject){
                    //DDLogInfo(@"%@",[responseObject objectForKey:@"userInfo"]);
                    _userInfo = responseObject;
                    //DDLogInfo(@"line 894");
                    //初始化 view
                    [self initViewWithData];
                    NSLog(@"%ld",self.arrayOfCells.count);
                    [self.scrollView reloadDataWithArrayCount:self.arrayOfCells.count];
                    
                }
                else{
                    NSLog(@"获取数据格式出错");
                    
                }
                
            }
            else{
                 NSLog(@"异常");
            }
        }];
        
    }
    
}

#pragma mark 获取个人详情
- (void) initViewWithData{
    //DDLogInfo(@"viewDidAppear");
    //DDLogInfo(@"%@",_userId);
    //DDLogInfo(@"%@",_userInfo);
    //滚动到首页的动画
    //    if([self.collectionView numberOfItemsInSection:0]>=4) {
    //        [UIView animateWithDuration:3 animations:^{
    //            //        self.collectionView.scrollsToTop=YES;//没有效果
    //            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
    //        }completion:^(BOOL finished) {
    //            [UIView animateWithDuration:3 animations:^{
    //                [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
    //            }];
    //
    //        }];
    //    }
    /*
     _userInfo
     {
     "user_age" = "-10086";
     "user_city" = "-10086";
     "user_credit_num" = 0;
     "user_fans_num" = 2;
     "user_following_num" = 3;
     "user_introduction" = "-10086";
     "user_logo_img_path" = "-10086";
     "user_nickname" = "-10086";
     "user_sex" = "-10086";
     }
     *topImage;
     *reflected;
     *avartarImage;
     *backBtn;
     *attentionLabel;//关注的人数
     *fansLabel;//粉丝数
     *friendRankBtn;
     //*addfrd,*noti,*msg
     *chatBtn;
     *attendBtn;
     */
    //加载上部图片
    //todo


//    NSString *urlAvarlImage = [[NSString alloc]initWithFormat:@"%@%s",[_userInfo objectForKey:@"user_logo_img_path"],QiNiuImageYaSuo];
//    NSURL * urlAvarl = [NSURL URLWithString:[urlAvarlImage stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
//    [visitMineView.avartarImage sd_setImageWithURL:urlAvarl
//                                  placeholderImage:[UIImage imageNamed:@"Home.jpg"]
//                                         completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//                                                                                          else{
//                                                 //用默认的模糊图片
//                                                 [visitMineView.topImage setImage:[UIImage imageNamed:@"HomeBlur.png"]];
//                                                 [visitMineView.reflected setImage:[UIImage imageNamed:@"HomeBlur.png"]];
//                                             }
//                                         }];
//    [visitMineView.avartarImage sd_setImageWithURL:urlAvarl placeholderImage:[UIImage imageNamed:@"Home.jpg"]];
    [HSDataFormatHandle getImageWithUri:[_userInfo objectForKey:@"user_logo_img_path"] isYaSuo:true imageTarget:visitMineView.avartarImage defaultImage:[UIImage imageNamed:@"Home.jpg"] andRequestCB:^(UIImage *image) {
    }];
    //请求模糊图片
    NSString *urlBlurImg = [[NSString alloc]initWithFormat:@"%@%s",[_userInfo objectForKey:@"user_logo_img_path"],QiNiuImageBlur];
//    NSURL * urlBlurLogo = [NSURL URLWithString:[urlBlurImg stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
//    [visitMineView.topImage sd_setImageWithURL:urlBlurLogo
//                                  placeholderImage:[UIImage imageNamed:@"HomeBlur.png"]
//                                         completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//                                             if(image){
//                                                 visitMineView.reflected.image = image;
//                                             }
//                                             else{
//                                                 [visitMineView.reflected setImage:[UIImage imageNamed:@"HomeBlur.png"]];
//                                             }
//                                         }
//     ];
    
    [HSDataFormatHandle getImageWithUri:urlBlurImg isYaSuo:NO imageTarget:visitMineView.topImage defaultImage:[UIImage imageNamed:@"HomeBlur.png"] andRequestCB:^(UIImage *image) {
        visitMineView.reflected.image = image;
    }];
    //图片结束
    
    NSString *text = [[NSString alloc] init];
//    NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
    //user_nickname 昵称
    text = [self transformToString:[_userInfo objectForKey:@"user_nickname"] andReplaceStr:@"未知用户"];
    [visitMineView.nickName setText:text];
    
    //attentionLabel 关注人数
    text = [self transformToString:[_userInfo objectForKey:@"user_following_num"] andReplaceStr:@"0"];
    [visitMineView.attentionLabel setText:text];
    
    //fansLabel 粉丝数
    text = [self transformToString:[_userInfo objectForKey:@"user_fans_num"] andReplaceStr:@"0"];
    [visitMineView.fansLabel setText:text];
    
    
    NSString *sex = [[NSString alloc] init];
    sex = [self transformToString:[_userInfo objectForKey:@"user_sex"] andReplaceStr:@"2"];
    switch ([sex intValue]) {
        case 0:
            sex = @"男";
            break;
        case 1:
            sex = @"女";
            break;
        default:
            sex = @"未知性别";
            break;
    }
    
    NSString *age = [[NSString alloc] init];
//    age = [ isEqualToString:@"-10086"] ? @"0":[_userInfo objectForKey:@"user_age"];
//    只有用户生日  user_birthday
    age = [HSDataFormatHandle getAgeFromBirthday:[_userInfo objectForKey:@"user_birthday"]];
    
    NSString *temp = [NSString stringWithFormat:@"%@  %@岁",sex, age];
    NSDictionary *attribute = @{
                                NSFontAttributeName:[UIFont systemFontOfSize:20]
                                };
    CGSize labelSize = [temp sizeWithAttributes:attribute];
    [visitMineView.sexAge setText:temp];
    visitMineView.sexAge.frame = CGRectMake(visitMineView.sexAge.frame.origin.x,
                                                 visitMineView.sexAge.frame.origin.y,
                                                 labelSize.width,
                                                 labelSize.height);
    
    
    //关注  1代表互粉，2代表我关注他，他没关注我
    if([[_userInfo objectForKey:@"user_relationship"] isEqualToString:@"1"] || [[_userInfo objectForKey:@"user_relationship"] isEqualToString:@"2"]){
        visitMineView.hasAttended = true;
        [visitMineView.attendBtn setImage:[UIImage imageNamed:@"ic_unfollow"] forState:UIControlStateNormal];
        [visitMineView.attendStateLabel setText:@"已关注"];
    }
    else{
        visitMineView.hasAttended = false;
        [visitMineView.attendBtn setImage:[UIImage imageNamed:@"ic_add_person"] forState:UIControlStateNormal];
        [visitMineView.attendStateLabel setText:@"关注"];
    }

}


#pragma mark 点赞判断
- (void) setShareLikeState:(NSString *)shareID andCell:(HSVisitMineCell *)cell{
    
    
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
        
        
        
        NSLog(@"requestData:%@",requestData);
        
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
    HSVisitMineCell *cell= [[HSVisitMineCell alloc]init];
    
    if(notification.object){
        cell=(HSVisitMineCell *)notification.object;
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

-(void)praiseBtnEffect:(HSVisitMineCell*)cell{
    
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


#pragma mark - User Interaction

#pragma mark 分享到第三方
- (void) shareThird:(NSNotification *)noti{
    HSVisitMineCell *cell = [[HSVisitMineCell alloc]init];
    if(noti){
        cell = (HSVisitMineCell *)noti.object;
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

#pragma mark 参数判断
- (NSString *)transformToString:(id)needHandle andReplaceStr:(NSString *)str{
//    NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
//    //user_nickname 昵称
//    if([needHandle isKindOfClass:[NSNumber class]]){
//        return  [numberFormatter stringFromNumber:needHandle];
//    }
//    else if([needHandle isKindOfClass:[NSString class]]){
//        if([needHandle isEqualToString:@""] || [needHandle isEqualToString:@"-10086"]){
//            return str;
//        }
//        else return needHandle;
//    }
//    return str;
    if([needHandle isEqualToString:@""] || [needHandle isEqualToString:@"-10086"]){
        return str;
    }
    else return needHandle;
}


//#pragma mark 评论模块,注册评论事件
////初始化评论视图控制器
//- (void)initCommentViewController {
//    commentViewController=[[HSCommentViewController alloc]init];
//}
////添加各种评论事件处理函数，itemFor...函数里面调用
//- (void)initCommentButtonsOfCell:(HSVisitMineCell *)cell {
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

#pragma mark 给cell赋值
- (void) setValueForCell:(HSVisitMineCell *)cell andWithDict:( NSDictionary *)dict{
    
    //user_nickname
    NSString *user_nickname = [[NSString alloc] initWithString:
                               ([[dict objectForKey:@"user_nickname"] isEqualToString:@"-10086"]?@"未知用户":[dict objectForKey:@"user_nickname"])];
    
    [cell.nameLabelLarge setText:user_nickname];
    [cell.nameLabelSmall setText:user_nickname];
    
    //share_create_time
    [cell.timeLabelSmall setText:[HSDataFormatHandle dateFormaterString:[dict objectForKey:@"share_create_time"]]];
    [cell.timeLabelLarge setText:[HSDataFormatHandle dateFormaterString:[dict objectForKey:@"share_create_time"]]];
    
    //share_description
    NSString *share_description = [[NSString alloc] initWithString:[dict objectForKey:@"share_description"]];
    if (([[dict objectForKey:@"share_description"] isEqualToString:@"-10086"])||([[dict objectForKey:@"share_description"] isEqualToString:@" "])) {
        share_description = @"暂无描述";
    }
    
    [cell.textLabelLarge setText:share_description];
    [cell.textLabelSmall setText:share_description];
    
    //share_img_path
    //图片数组6.20by qiang
    NSMutableArray *_srcStringArray = [[NSMutableArray alloc]init];
    NSArray *imgArray = [[NSArray alloc]initWithArray:[dict objectForKey:@"share_img_path"]];
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
//    [cell setSubviewsAlphaWithFactor:1];
    [cell setSubviewsAlphaWithFactor:self.scrollView.scaleFactor];

    //点赞
    NSString *praiseCount = [HSDataFormatHandle handleStringNumber:[dict objectForKey:@"share_like_num"]];
    [cell.praiseLabelLarge setText:praiseCount];
    
    //评论
    NSString *commentCount = [HSDataFormatHandle handleStringNumber:[dict objectForKey:@"comment_count"]];
    [cell.commentCount setText:commentCount];
    
    //shareid
    cell.shareID = [dict objectForKey:@"share_id"];
    [self setShareLikeState:[dict objectForKey:@"share_id"] andCell:cell];
    
    
    //cell的地理位置信息
    if([[dict objectForKey:@"share_location"] isEqualToString:@"-10086"] || ![dict objectForKey:@"share_location"] ||[[dict objectForKey:@"share_location"] isEqualToString:@""]){
        [cell.mapLocationImg removeFromSuperview];
        [cell.mapLocationLabel removeFromSuperview];    }
    else{
        [cell.mapLocationLabel setText:[dict objectForKey:@"share_location"]];
    }
    
}

#pragma mark 手势处理
/**
 *@function 处理拖动手势
 **/
- (void)handlePan:(UIPanGestureRecognizer *)gesture{
    //手势开始
    if ([gesture state]==UIGestureRecognizerStateBegan) {
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }
    /*
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
     */
    
}

#pragma mark backConversion 
- (void) backConversion{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark HSScaleScrollViewDelegate 协议
- (void)registerClassForCollectionView:(UICollectionView *)cv {
    [cv registerClass:[HSVisitMineCell class] forCellWithReuseIdentifier:reuseIdentifier];
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
@end
