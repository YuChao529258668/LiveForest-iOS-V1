//
//  HSGroup.m
//  HotSNS
//
//  Created by 微光 on 15/4/6.
//  Copyright (c) 2015年 李长远. All rights reserved.
//

#import "HSGroupController.h"
//#import "HSTabBarController.h"
#import "HSVisitMineController.h"
// 引用 IMKit 头文件。
#import <RongIMKit/RongIMKit.h>
// 引用 RCChatViewController 头文件。
//#import "RCChatViewController.h"


@implementation HSGroupController

//4.11
static int n=4;
static float factor=0.45;
static float factorMax=2.222222;
static float factorMin=1;
static NSString * const reuseIdentifier = @"groupCell";
@synthesize scrollView;
@synthesize panGestureRecognizerScollView;
@synthesize currentCellIndexPath;


@synthesize collectionView=_collectView;
@synthesize arrayWithEvent = _arrayWithEvent;
//@synthesize dictionaryWithEvent = _dictionaryWithEvent;
@synthesize chatView = _chatView;

@synthesize smallLayout = _smallLayout;


@synthesize navCtrl = _navCtrl;
//@synthesize visibleCellsArray= _visibleCellsArray;

//static NSString *cellIdentifier = @"groupCell";
@synthesize groupDetail = _groupDetail;

@synthesize galleryImages = _galleryImages;
@synthesize slide = _slide;


- (id)init {
    self = [super init];
    if (self) {
        
        _galleryImages = [[NSMutableArray alloc]init];
        
        _chatView = [[HSChatView alloc]init];
//        _chatView.frame = CGRectMake(kScreenWidth*3, 0, kScreenWidth, kScreenHeight);
        _chatView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        
        if(!_chatView){
            NSLog(@"chatView is empty");
        }

        visibleCells=[[NSArray alloc]init];

        //初始化collection View和scroll View
        [self initCollectionViewAndScrollView];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    
   
    if(_chatView){
        [self.view addSubview:_chatView];
        
        _chatView.topImage.image = [UIImage imageNamed:@"group_topImage"];
        _chatView.topImage.contentMode = UIViewContentModeScaleAspectFill;
        _chatView.topImage.clipsToBounds=YES;
        
        _chatView.reflectedImage.transform = CGAffineTransformMakeScale(1.0, -1.0);
         _chatView.reflectedImage.image = [UIImage imageNamed:@"group_topImage"];
         _chatView.reflectedImage.contentMode = UIViewContentModeScaleAspectFill;
         _chatView.reflectedImage.clipsToBounds=YES;
        CAGradientLayer *gradientReflected = [CAGradientLayer layer];
        gradientReflected.frame =  _chatView.reflectedImage.bounds;
        gradientReflected.colors = @[(id)[[UIColor colorWithRed:0 green:0 blue:0 alpha:1] CGColor],
                                     (id)[[UIColor colorWithWhite:0 alpha:0] CGColor]];
        [ _chatView.reflectedImage.layer insertSublayer:gradientReflected atIndex:0];

        //shimmer
        _chatView.shimmeringView = [[FBShimmeringView alloc] initWithFrame:CGRectMake(0, 0, 120, 80)];
        [self.view addSubview:_chatView.shimmeringView];
        
        UILabel *loadingLabel = [[UILabel alloc] initWithFrame:_chatView.shimmeringView.bounds];
        loadingLabel.textAlignment = NSTextAlignmentLeft;
        
        loadingLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:28];
        loadingLabel.textColor = [UIColor whiteColor];
        loadingLabel.shadowColor = [UIColor colorWithWhite:0.3f alpha:0.8f];
        loadingLabel.text = NSLocalizedString(@"Group", nil);
//        _indexView.shimmeringView.contentView = loadingLabel;
        _chatView.shimmeringView.contentView = loadingLabel;
        //        _chatView.shimmeringView.shimmeringDirection =
        // Start shimmering.
        _chatView.shimmeringView.shimmeringPauseDuration = 0.1;
        _chatView.shimmeringView.shimmeringAnimationOpacity = 0.3;
        _chatView.shimmeringView.shimmeringSpeed = 40;
        _chatView.shimmeringView.shimmeringHighlightLength = 1;
        //        _chatView.shimmeringView.shimmeringSpeed = 40;
        _chatView.shimmeringView.shimmering = YES;
    }
 
    //加载collectionView数据
//    _arrayWithEvent = [NSMutableArray arrayWithObjects: nil];
    
    NSArray *testForGroupIMG = [NSArray arrayWithObjects:@"group_topImage",@"groupForTest1.jpg",@"groupForTest2.jpg", nil];
    for (int i = 0; i <3 ; i++) {
        
        NSDictionary *dicForMP = [NSDictionary  dictionaryWithObjects:[NSArray arrayWithObjects:[testForGroupIMG objectAtIndex:i], nil] forKeys:[NSArray arrayWithObjects:@"img", nil]];
       
        [_galleryImages addObject:dicForMP];
    }
    
    
    //幻灯片
    //会获取 缓存的数据
    _slide = 0;
    
    // Loop gallery - fix loop:
    NSTimer *timer = [NSTimer timerWithTimeInterval:6.0f target:self selector:@selector(changeSlide) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];

    //todo
    [self changeSlide];
    
}


#pragma collectionView controller
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    //    return [_arrayWithEvent count] * 3;//为了测试，虚拟3倍数据
    return n;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    //    HSActivityCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    //4.11
    HSGroupCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    NSString *string;
    switch (indexPath.row) {
        case 0:
            cell.titleLabel.text = @"常用群组";
            string=@"创建群组.png";
            break;
        case 1:
            cell.titleLabel.text = @"推荐群组";
            string=@"参与群组.png";
            break;
        case 2:
            cell.titleLabel.text = @"我参与的";
            string=@"活动群组.png";
            break;
        case 3:
            cell.titleLabel.text = @"我管理的";
            string=@"推荐群组.png";
            break;
            
        default:
            cell.titleLabel.text = @"其他群组";
            string=@"其他群组";
            break;
    }
    UIImage *image=[UIImage imageNamed:string];
    cell.imageViewSmall.image=image;
    
    [cell setSubviewsAlphaWithFactor:factor];
//    cell.backBtn.backgroundColor=[UIColor blueColor];
    cell.backgroundColor=[UIColor whiteColor];
    cell.layer.cornerRadius = 4;
    cell.clipsToBounds = YES;
    
    cell.tableView.delegate=self;
    cell.tableView.dataSource=self;
//    cell.tableView.allowsSelection=YES;
//    cell.tableView.scrollEnabled=YES;
//    cell.tableView.userInteractionEnabled=YES;
    
    
//    [cell.backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];

    //    cell.tableView.scrollEnabled = NO;
    
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(gestureControl:) name:@"notificationHSGroupCellGesture" object:nil];
    
    return cell;
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
    
    [self.collectionView registerClass:[HSGroupCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
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
//    self.panGestureRecognizerScollView.delegate=self;
    
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
    for (HSGroupCollectionViewCell *cell in visibleCells) {
        [cell setSubviewsAlphaWithFactor:factor];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    
    //写在viewDidAppear里面就没用
//    if([self.collectionView numberOfItemsInSection:0]>=4) {
//        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
//    }
}

- (void)viewDidAppear:(BOOL)animated {
    //滚动到首页的动画
//    [UIView animateWithDuration:1 animations:^{
//        //        self.collectionView.scrollsToTop=YES;//没有效果
//        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
//    }];
}

- (void)backBtnClick {
    NSLog(@"backIconPressed");
    if(factor==factorMax) {
        
        CGRect oldFrame=self.scrollView.frame;
        
        //设置锚点
        self.scrollView.layer.anchorPoint=CGPointMake(0.5, 1);
        
        //设置frame会自动根据锚点位置设置position
        self.scrollView.frame=oldFrame;
        
        //放大动画
        factor=factorMin;
        [UIView animateWithDuration:0.2 animations:^{
            //缩放
            self.scrollView.transform=CGAffineTransformMakeScale(factor, factor);
            //设置透明度
            [self setAllVisibleCellsSubviewsAlpha];
            
            //缩小
            if (factor ==factorMin ) {
                self.scrollView.pagingEnabled=NO;//翻页功能
                
                //让scrollView滚动scrollView平移的相反距离
                CGPoint pp=self.scrollView.contentOffset;
                pp.x-=self.scrollView.frame.origin.x/factorMin;//缩小到0.45。先滚动再平移。。。
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 4;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
//    cell.userInteractionEnabled = YES;  //todo
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(80, 20, 100, 40)];
    [cell.contentView addSubview:lab];
    if(indexPath.row == 0){
        [lab setText: [[NSString alloc] initWithFormat:@"骑行社"]];
    }
    else{
        [lab setText: [[NSString alloc] initWithFormat:@"群组%ld",indexPath.row]];

//        cell.textLabel.text = [[NSString alloc]initWithFormat:@"群组%ld",indexPath.row];
    }
    
    UIImageView *avarlImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 10, 60, 60)];
//    avarlImg.layer.cornerRadius =avarlImg.frame.size.width/2;
//    avarlImg.clipsToBounds = YES;
//    avarlImg.layer.borderWidth = 1.0f;
//    avarlImg.layer.borderColor = [UIColor grayColor].CGColor;
    avarlImg.contentMode = UIViewContentModeScaleAspectFill;
    
    [cell.contentView addSubview:avarlImg];
    
    
    UIButton *chat = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-45, 20, 40, 40)];
    if(indexPath.row%2 == 0){
        avarlImg.image = [UIImage imageNamed:@"mineAvarl.png"];
        [chat setImage:[UIImage imageNamed:@"ic_chat_notif"] forState:UIControlStateNormal];
    }else{
        avarlImg.image = [UIImage imageNamed:@"avarl.jpg"];
        [chat setImage:[UIImage imageNamed:@"ic_chat_noNoti"] forState:UIControlStateNormal];
    }
    [chat addTarget:self action:@selector(chatPress:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.contentView addSubview:chat];
    
    return cell;
}

#pragma 设置行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 50;
//}
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    return 30;
//}

#pragma 设置标题
//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
//    switch (section) {
//        case 0:
//            return @"群组";
//            break;
//            
//        default:return @"群组";
//            break;
//    }
//    
//}
//- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
//    return @"LiveForest";
//}
/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */


#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // 您需要根据自己的 App 选择场景触发聊天。这里的例子是一个 Button 点击事件。
//    RCConversationViewController *conversationVC = [[RCConversationViewController alloc]init];
//    conversationVC.conversationType =ConversationType_PRIVATE; //会话类型，这里设置为 PRIVATE 即发起单聊会话。
//    conversationVC.targetId = @"143101183949804838"; // 接收者的 targetId，这里为举例。
//    conversationVC.targetName = @"test"; // 接受者的 username，这里为举例。
//    conversationVC.title = @"test"; // 会话的 title。
    _groupDetail = [[HSGroupDetailController alloc]init];
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    [window insertSubview:_groupDetail.view aboveSubview:window.rootViewController.view];
//     [self presentViewController:conversationVC animated:YES completion:nil];
    
}

-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (factor==2) {
//        return YES;
//    }
    return YES;
}

#pragma mark scrollview下滑时，如果scrollview在顶部，则触发通知
//tableview继承自secollview
//在自身刚要滑动时，判断是哪个scrollview

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView2 {
    
    if (scrollView2!=self.scrollView) {//防止自身scrollview滑动触发
        CGPoint v=[scrollView2.panGestureRecognizer velocityInView:self.view];
        CGPoint contentOffset=scrollView2.contentOffset;
        NSLog(@"%f",contentOffset.y);
        if (v.y>0 && contentOffset.y==0) {
            //此时，代表用户希望缩小cell
            //最好的方式是屏蔽当前tableview手势，让scrollview接管手势
//            scrollView2.scrollEnabled = NO;
            //手势控制接下来的事情
            NSLog(@"%f",contentOffset.y);
            [[NSNotificationCenter defaultCenter ]postNotificationName:@"slideDownTheGroupChapTableView" object:nil];
            
        }
//        else{
//            scrollView2.scrollEnabled = YES;
//        }

    }
}
#pragma mark 手势控制
//手势控制
//- (void)gestureControl:(NSNotification *)noti{
//    HSGroupCollectionViewCell *cell = [[HSGroupCollectionViewCell alloc]init];
//    if(noti){
//        cell = (HSGroupCollectionViewCell *)noti.object;
//        [self scrollViewWillBeginDragging:cell.tableView];
//        
//    }
//}

#pragma mark chatPress
- (void)chatPress:(UIButton *)btn{
    // 连接融云服务器。
    // 您需要根据自己的 App 选择场景触发聊天。这里的例子是一个 Button 点击事件。
    RCConversationViewController *conversationVC = [[RCConversationViewController alloc]init];
    conversationVC.conversationType =ConversationType_PRIVATE; //会话类型，这里设置为 PRIVATE 即发起单聊会话。
    conversationVC.targetId = @"143101183949804838"; // 接收者的 targetId，这里为举例。
    conversationVC.targetName = @"test"; // 接受者的 username，这里为举例。
    conversationVC.title = @"私人聊天室"; // 会话的 title。
    
    //backIcon
    UIButton *backIcon = [[UIButton alloc] initWithFrame:CGRectMake(0 , 20, 36, 36)];
    [backIcon setImage:[UIImage imageNamed:@"ic_arrow_back_white_48dp"] forState:UIControlStateNormal];
    [backIcon setTitle:@"Back" forState:UIControlStateNormal];
    //    backIcon.backgroundColor = [UIColor blueColor];
    [backIcon addTarget:self action:@selector(backIconPressed) forControlEvents:UIControlEventTouchUpInside];
    
    [conversationVC.view addSubview:backIcon];
//    [self presentViewController:conversationVC animated:YES completion:nil];
    conversationVC.view.tag = 102;
    
        UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    [window.rootViewController presentViewController:conversationVC animated:YES completion:nil];
//        [window insertSubview:conversationVC.view aboveSubview:window.rootViewController.view];
}
- (void)backIconPressed{
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
//    UIView *view = [window viewWithTag:102];
//        [view removeFromSuperview];
    [window.rootViewController dismissViewControllerAnimated:YES completion:nil];
//    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Change slider
- (void)changeSlide
{
    if([_galleryImages count]>0){
        if(_slide > _galleryImages.count-1) _slide = 0;
        //     _activityView.topImage.image = [UIImage imageNamed:@"Index.jpg"];
        NSDictionary *dic = [_galleryImages objectAtIndex:_slide];
        UIImage *toImage = [UIImage imageNamed:[dic objectForKey:@"img"]];
        //    :@"img",@"activity_name",@"activity_summary"
        [UIView transitionWithView:self.view
                          duration:0.4
                           options:UIViewAnimationOptionTransitionCrossDissolve | UIViewAnimationCurveEaseInOut |
         UIViewAnimationOptionAllowUserInteraction
                        animations:^{
                            _chatView.topImage.image = toImage;
                            _chatView.reflectedImage.image = toImage;
                        } completion:nil];
        _slide++;
    }
}

@end
