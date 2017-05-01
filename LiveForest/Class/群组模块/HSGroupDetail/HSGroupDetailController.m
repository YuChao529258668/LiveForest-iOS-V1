//
//  HSGroupDetailController.m
//  LiveForest
//
//  Created by 微光 on 15/5/13.
//  Copyright (c) 2015年 HOTeam. All rights reserved.
//

#import "HSGroupDetailController.h"

@interface HSGroupDetailController ()

@end

@implementation HSGroupDetailController

@synthesize groupDetailView = _groupDetailView;

static int n=3;
static float factor=0.45;
static float factorMax=2.222222;
static float factorMin=1;
static NSString * const reuseIdentifier = @"groupDetailCell";
@synthesize scrollView;
@synthesize panGestureRecognizerScollView;
@synthesize currentCellIndexPath;


@synthesize collectionView=_collectView;
@synthesize arrayWithEvent = _arrayWithEvent;

@synthesize smallLayout = _smallLayout;


- (id)init {
    self = [super init];
    if (self) {
        
        _groupDetailView = [[HSGroupDetailView alloc]init];
        
        if(!_groupDetailView){
            NSLog(@"_groupDetailView is empty");
        }
        else{
            _groupDetailView.topImage.image = [UIImage imageNamed:@"group_topImage"];
            _groupDetailView.topImage.contentMode = UIViewContentModeScaleAspectFill;
            _groupDetailView.topImage.clipsToBounds=YES;
            
            _groupDetailView.reflectedImage.transform = CGAffineTransformMakeScale(1.0, -1.0);
            _groupDetailView.reflectedImage.image = [UIImage imageNamed:@"group_topImage"];
            _groupDetailView.reflectedImage.contentMode = UIViewContentModeScaleAspectFill;
            _groupDetailView.reflectedImage.clipsToBounds=YES;
            CAGradientLayer *gradientReflected = [CAGradientLayer layer];
            gradientReflected.frame =  _groupDetailView.reflectedImage.bounds;
            gradientReflected.colors = @[(id)[[UIColor colorWithRed:0 green:0 blue:0 alpha:1] CGColor],
                                         (id)[[UIColor colorWithWhite:0 alpha:0] CGColor]];
            [ _groupDetailView.reflectedImage.layer insertSublayer:gradientReflected atIndex:0];
            
            [_groupDetailView.backBtn addTarget:self action:@selector(backPress:) forControlEvents:UIControlEventTouchUpInside];
            
            [_groupDetailView.chatBtn addTarget:self action:@selector(beginChat:) forControlEvents:UIControlEventTouchUpInside];
            
            [_groupDetailView.joinBtn addTarget:self action:@selector(joinPress:) forControlEvents:UIControlEventTouchUpInside];
            
            [self.view addSubview:_groupDetailView];
        }
        //初始化collection View和scroll View
        [self initCollectionViewAndScrollView];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //    self.view.backgroundColor = [UIColor redColor];
    
}


#pragma collectionView controller
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    //    return [_arrayWithEvent count] * 3;//为了测试，虚拟3倍数据
    return n;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    HSGroupDetailCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    [cell setSubviewsAlphaWithFactor:factor];
    
    NSString *string;
    switch (indexPath.row) {
//        case 0:
//            cell.groupNameLabel.text = @"群组聊天";
//            string=@"群组聊天.png";
//            [cell.beginChat setTitle:@"进入聊天" forState:UIControlStateNormal];
//            [cell.beginChat addTarget:self action:@selector(beginChat:) forControlEvents:UIControlEventTouchUpInside];
//            break;
        case 0:
//            [cell.beginChat setTitle:@"详情敬请期待" forState:UIControlStateNormal];
//            cell.groupNameLabel.text = @"群组照片";
            string=@"card1.png";
            break;
        case 1:
//            [cell.beginChat setTitle:@"详情敬请期待" forState:UIControlStateNormal];
//            cell.groupNameLabel.text = @"群组活动";
            string=@"card2.png";
            break;
        case 2:
//            [cell.beginChat setTitle:@"详情敬请期待" forState:UIControlStateNormal];
//            cell.groupNameLabel.text = @"群组人员";
            string=@"card3.png";
            break;
            
        default:
//            cell.titleLabel.text = @"其他球";
//            string=@"其他球";
            break;
    }
    UIImage *image=[UIImage imageNamed:string];
    cell.contentImage.image=image;
    
    
//    cell.backBtn.backgroundColor=[UIColor blueColor];
//    cell.backgroundColor=[UIColor whiteColor];
    cell.layer.cornerRadius = 4;
    cell.clipsToBounds = YES;

    
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
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

#pragma mark backPress:
- (void)backPress:(UIButton *)btn{
    [self.view removeFromSuperview];
//    [self dismissViewControllerAnimated:YES completion:nil];
}

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
    
    [_collectView registerClass:[HSGroupDetailCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
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
    
    //添加pan手势给scrollView
    self.panGestureRecognizerScollView=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePanScollView:)];
    self.panGestureRecognizerScollView.delegate=self;
    
        [self.scrollView addGestureRecognizer:self.panGestureRecognizerScollView];
    [self.scrollView addSubview:_collectView];
        [self.view addSubview:self.scrollView];
    
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
    for (HSGroupDetailCollectionViewCell *cell in visibleCells) {
        [cell setSubviewsAlphaWithFactor:factor];
    }
}

#pragma mark beginChat
- (void)beginChat:(UIButton *)btn{
    
    NSLog(@"beginChat");
    
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
    [self presentViewController:conversationVC animated:YES completion:nil];
//    
//    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
//    [window insertSubview:conversationVC.view aboveSubview:self.view];
}
- (void)backIconPressed{
//    [self.view removeFromSuperview];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark joinPress:
- (void) joinPress:(UIButton *) btn{
    if(!_groupDetailView.hasJoin){
        
        [_groupDetailView.joinBtn setImage:[UIImage imageNamed:@"ic_join"] forState:UIControlStateNormal];
        _groupDetailView.hasJoin = YES;
    }else{
        [_groupDetailView.joinBtn setImage:[UIImage imageNamed:@"ic_quit"] forState:UIControlStateNormal];
        _groupDetailView.hasJoin = NO;
    }
}
@end
