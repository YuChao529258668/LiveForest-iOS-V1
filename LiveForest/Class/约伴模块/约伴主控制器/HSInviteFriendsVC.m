//
//  HSInviteFriendsVC.m
//  LiveForest
//
//  Created by 傲男 on 15/7/8.
//  Copyright (c) 2015年 HOTeam. All rights reserved.
//

#import "HSInviteFriendsVC.h"
#import "HSInviteFriendsCardView.h"
//#import "HSYueBanListTableViewController.h"
#import "HSMyMyYueBanDetailListView.h"
#import "HSInviteFriendsCard.h"
#import "HSRequestDataController.h"
#import "Macros.h"
#import "HSAddInviteView.h"
#import "HSYueBanDetailViewController.h"
//#import "HSDataFormatHandle.h"
#import "HSMyInviteHistoryViewController.h"
#import "HSInviteFriendsCard.h"

@interface HSInviteFriendsVC ()<HSInviteFriendsCardViewDelegate>

@property (nonatomic, strong)HSRequestDataController *requestDataCtrl;
@end

@implementation HSInviteFriendsVC

static long n=6;  //todo(可以先加载白色的或者之前缓存的，然后请求完数据后对collectinview更新，reloaddata即可（需要改变collectionview的宽度，但是有bug）)
static float factor=0.45;
static float factorMax=2.222222;
static float factorMin=1;
static NSString * const reuseIdentifier = @"HSInviteFriendsCardView";
static NSString * const receiveAll = @"receiveAllInvites";

@synthesize collectionView;


- (HSRequestDataController *)requestDataCtrl
{
    if (_requestDataCtrl == nil) {
        _requestDataCtrl = [[HSRequestDataController alloc]init];
        self.myYueBanHistoryList = [[NSMutableArray alloc]init];
    }
    return _requestDataCtrl;
}
- (id)init {
    self = [super init];
    if (self) {
        _inviteFriendsView = [[HSInviteFriendsView alloc]init];
//        _inviteFriendsView.frame = [UIScreen mainScreen].bounds;
    }
    
    //初始化scrollview,collection
    [self initCollectionViewAndScrollView];
    self.scrollView = [[HSScaleScrollView alloc]initWithCellCount:n Delegate:self shouldGetMoreData:NO];
    
    //接收推送通知 changed by qiang on 7.8
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(pushInfoShow:) name:@"notificationHSInviteFriendsView" object:nil];
    
    //接收约伴创建成功通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(createYuebanSuccessNotification) name:@"createYuebanSuccess" object:nil];
    
    //接收停止约伴的通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(stopYuebanSuccessNotification) name:@"stopYuebanSuccess" object:nil];
    
    //获取用户未停止的约伴详情，并根据获取的情况展现不同的界面
    [self getMyYueBanDetailList:@"1"];
    
    [self.inviteFriendsView.isFriendsBtn addTarget:self action:@selector(isFriendSwith) forControlEvents:UIControlEventValueChanged];
    [self getUserDefaults];
    return self;
}

- (void)loadView{
    self.view = _inviteFriendsView;
    
    [_inviteFriendsView.clickYueBanBtn addTarget:self action:@selector(yueBanBtnPress:) forControlEvents:UIControlEventTouchUpInside];
    
    //击我的邀请按钮
    [_inviteFriendsView.historyBtn addTarget:self action:@selector(showMyInviteList:) forControlEvents:UIControlEventTouchUpInside];
    
//    self.view.frame = [UIScreen mainScreen].bounds;

}

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    
    [self test];//测试数据
    [self.scrollView reloadDataWithArrayCount:self.inviteFromStrangerArray.count];
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
#pragma mark  获取到了推送的通知
- (void) pushInfoShow:(NSNotification *)noti{
    if(noti.object){
//        [_inviteFriendsView.messageLabel setText:noti.object];
    }
}
#pragma mark - 获取到了发起约伴成功的通知
- (void) createYuebanSuccessNotification{
    //获取用户未停止的约伴详情，并根据获取的情况展现不同的界面
    [self getMyYueBanDetailList:@"1"];
}

#pragma mark -//接收停止约伴的通知
-(void)stopYuebanSuccessNotification{
    
    NSLog(@"停止了");
    [self getMyYueBanDetailList:@"1"];
}
#pragma mark
#pragma mark 《手势动画相关》
#pragma mark <初始化collectionview和scrollView>
- (void)initCollectionViewAndScrollView {
    
    //cell、collectionView、 scrollView与屏幕同高。
    //cell、scrollView和屏幕一样大，collectionView的宽度是cell的n倍。
    //scrollView的contentSize是collectionView的frame。
    //collectionView添加到scrollView后，scrollView缩小为0.45
    
    //初始化collectionview
    HSCollectionViewSmallLayout *smallLayout = [[HSCollectionViewSmallLayout alloc] init];
    CGRect collectionViewFrame=CGRectMake(0, 0, kScreenWidth*n,kScreenHeight);
    collectionView = [[UICollectionView alloc] initWithFrame:collectionViewFrame collectionViewLayout:smallLayout];
    
    [self.collectionView registerClass:[HSInviteFriendsCardView class] forCellWithReuseIdentifier:reuseIdentifier];
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
    self.scrollView.delegate=self;
    
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
    
    //    在collectionview上放置刷新按钮
    //    UIButton *freshBtn = [[UIButton alloc]initWithFrame:CGRectMake(5, kScreenHeight/3*2, 100, 60)];
    //    [freshBtn setImage:[UIImage imageNamed:@"分享刷新.jpg"] forState:UIControlStateNormal];
    //    freshBtn.contentMode = UIViewContentModeScaleAspectFit;
    ////    [self.collectionView addSubview:freshBtn];
    //    UIWindow *window = [[UIApplication sharedApplication]keyWindow];
    //    [window.rootViewController.view insertSubview:freshBtn aboveSubview:self.collectionView];
    //    [freshBtn addTarget:self action:@selector(updateData) forControlEvents:UIControlEventTouchUpInside];
}

#pragma collectionView controller
- (NSInteger)collectionView:(UICollectionView *)collectionView2 numberOfItemsInSection:(NSInteger)section {
    
//    return self.picActivityArray.count;
//    if (self.inviteFromStrangerArray.count==0) {
//        return 3;
//    }
    
    return self.inviteFromStrangerArray.count;
//    return n;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView2 cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    //7.21
//    static NSString *reuseString=@"HSActivityCardView";
//    [collectionView registerClass:[HSInviteFriendsCardView class] forCellWithReuseIdentifier:reuseIdentifier];
    
    //    HSActivityCardView *cardView=[[HSActivityCardView alloc]init];
    HSInviteFriendsCardView *cardView=[collectionView2 dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cardView.tag=indexPath.row;
    cardView.inviteFriendsCard = (HSInviteFriendsCard *)self.inviteFromStrangerArray[indexPath.row];
    
    cardView.ybDelegate = self;
    
    return cardView;
    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

#pragma mark 获取好友约伴列表
-(void)getYuebanListFromFriends{
    NSLog(@"%s",__func__);
    NSString *user_token = [[NSUserDefaults standardUserDefaults]objectForKey:@"user_token"];
    if (user_token == nil) {
        NSLog(@"user_token为空");
        return;
    }
    NSDictionary *dict = [[NSDictionary alloc]initWithObjectsAndKeys:user_token,@"user_token", nil];
    NSDictionary *requestData = [[NSDictionary alloc]initWithObjectsAndKeys:[dict JSONString],@"requestData", nil];
    [self.requestDataCtrl getYueBanListFromFriends:requestData andRequestCB:^(BOOL code, id responseObject, NSString *error) {
        if (code) {
            self.inviteFromFriendArray = [HSInviteFriendsCard inviteFriendsWithArray:responseObject];
            [self.scrollView reloadDataWithArrayCount:self.inviteFromFriendArray.count];
        }
    }];
}
#pragma mark 获取陌生人约伴列表
-(void)getYuebanListFromStrangers{
    NSLog(@"%s",__func__);
    NSString *user_token = [[NSUserDefaults standardUserDefaults]objectForKey:@"user_token"];
    if (user_token == nil) {
        NSLog(@"user_token为空");
        return;
    }
    NSDictionary *dict = [[NSDictionary alloc]initWithObjectsAndKeys:user_token,@"user_token", nil];
    NSDictionary *requestData = [[NSDictionary alloc]initWithObjectsAndKeys:[dict JSONString],@"requestData", nil];

    [self.requestDataCtrl getYueBanListFromStrangers:requestData andRequestCB:^(BOOL code, id responseObject, NSString *error) {
        if (code) {
//            NSLog(@"%@",responseObject);
            self.inviteFromStrangerArray = [HSInviteFriendsCard inviteFriendsWithArray:responseObject];
//            [self test];//测试数据
            [self.scrollView reloadDataWithArrayCount:self.inviteFromStrangerArray.count];
            
        }
    }];
}

- (void)test {
    [_inviteFriendsView.clickYueBanBtn setTitle:@"createYueBan" forState:UIControlStateDisabled];
    
    self.inviteFromStrangerArray = [NSMutableArray array];
    for (int i =1; i<5; i++) {
        HSInviteFriendsCard *c = [[HSInviteFriendsCard alloc]init];
        //发起者id
//        @property(nonatomic,copy)NSString *user_id;
//        //发起者姓名
//        @property(nonatomic,copy)NSString *user_nickname;
//        //发起者头像url
//        @property(nonatomic,copy)NSString *user_logo_img_path;
//        //发起者性别
//        @property(nonatomic,copy)NSString *user_sex;
//        //发起者个人说明
//        @property(nonatomic,copy)NSString *user_introduction;
//        //约伴创建者生日时间戳
//        @property(nonatomic,copy)NSString *user_birthday;
//        //发起活动
//        @property(nonatomic,copy)NSString *yueban_sport_id;
//        @property(nonatomic,copy)NSString *yueban_sport;
//        //发起内容
//        @property(nonatomic,copy)NSString *yueban_text_info;
//        
        c.yueban_text_info = [NSString stringWithFormat:@"这是第%d个邀请的内容",i];
        c.yueban_title = @"这是标题";
        c.user_nickname = @"小红帽";
        c.user_logo_img_path = @"http://img3.duitang.com/uploads/item/201505/22/20150522222701_NTxyt.thumb.224_0.jpeg";
        [self.inviteFromStrangerArray addObject:c];
    }
}
#pragma mark 用户参与/拒绝约伴
//yes：1参加 0拒绝
-(void)updataUserYueBanState:(NSString *)yuebanId WithYesOrNo:(BOOL)yesOrNo{
    NSString *yes = yesOrNo?@"1":@"0";
    NSString *user_token = [[NSUserDefaults standardUserDefaults]objectForKey:@"user_token"];
    if (user_token == nil) {
        NSLog(@"user_token为空");
        return;
    }
   
    NSDictionary *dict = [[NSDictionary alloc]initWithObjectsAndKeys:user_token,@"user_token",yes,@"yueban_user_state",yuebanId,@"yueban_id", nil];
    NSDictionary *requestData = [[NSDictionary alloc]initWithObjectsAndKeys:[dict JSONString],@"requestData" ,nil];

    [self.requestDataCtrl updataUserYueBanState:requestData andRequestCB:^(BOOL code,  NSString *error) {
        if (code) {
            //同意参加成功
        }else{
            ShowHud(@"处理失败，请重试", NO);
        }
    }];
}

#pragma mark 获取我的约伴列表
/*
 @param
 user_token:String	M	用户token
 yueban_state:String	M	约伴状态'1':获取当前广播中的约伴列表，'0':获取历史的（停止广播的）约伴列表
*/
- (void)getMyYueBanDetailList:(NSString *)yueban_state{
    NSString *user_token = [[NSUserDefaults standardUserDefaults]objectForKey:@"user_token"];
    if (user_token == nil) {
        NSLog(@"user_token为空");
        return;
    }
    
    NSDictionary *dict = [[NSDictionary alloc]initWithObjectsAndKeys:user_token,@"user_token",yueban_state,@"yueban_state",nil];
    NSDictionary *requestData = [[NSDictionary alloc]initWithObjectsAndKeys:[dict JSONString],@"requestData" ,nil];
    
    [self.requestDataCtrl getMyYueBanDetailList:requestData andRequestCB:^(BOOL code,id responseObject, NSString *error) {
        if (code) {
            //根据yueban_state，赋值
            if([yueban_state isEqualToString:@"1"]){
                //未停止广播的个人约伴信息
                if(responseObject && [responseObject count]>0){
                    //存在还未停止的个人约伴信息，按钮为进入详情，并显示约伴的一些信息
                    self.myUnStoppedYueBanDetail = [HSMyYueBanDetailList yueBanDetailWithDic:[responseObject objectAtIndex:0]];//实际只有一个，为了扩展（以后可能有很多），默认用第一个
                    //展现我正在发起的约伴简介界面
                    [self showMyUnStoppedYueBanUI];
                }else{
                    //不存在还未停止的个人约伴信息,那么按钮显示为 + 号，可以创建约伴
                    
                    //首先获取还未关闭的我发起的约伴，如果有，则直接展示简洁，如果没有，则展示发起约伴按钮
                    [self showMyCreateYueBanUI];
                }
                          
            }
            else{
                [self.myYueBanHistoryList addObjectsFromArray:[HSMyYueBanDetailList yueBanDetailArrayWithArray:responseObject]];
            }
            
        }else{
            //如果出错，展示发起按钮 todo
//            [self showMyCreateYueBanUI];
            ShowHud(@"处理失败，请重试", NO);
        }
    }];
}

#pragma mark 约伴按钮点击事件
/*
 根据不同情况，显示不同东西
 1、如果名字是：showYueBanDetail，则展示约伴详情
 2、如果名字是：createYueBan，则调用 创建约伴界面
 */
- (void)yueBanBtnPress:(UIButton *)btn{
    NSString *title = [btn titleForState:UIControlStateDisabled];
    if([title isEqualToString:@"createYueBan"]){
        //调用 创建约伴界面
        HSAddInviteView  *addInviteView = [[HSAddInviteView alloc]init];
        [addInviteView show];
        
        NSLog(@"创建约伴界面");
    }else if([title isEqualToString:@"showYueBanDetail"]){
        //展示约伴详情
        NSLog(@"展示约伴详情");
        [self jumpToQmy];
    }
//    
//    if([btn.currentTitle isEqualToString:@"createYueBan"]){
//        //调用 创建约伴界面
//        HSAddInviteView  *addInviteView = [[HSAddInviteView alloc]init];
//        [addInviteView show];
//        
//        NSLog(@"创建约伴界面");
//    }else if([btn.currentTitle isEqualToString:@"showYueBanDetail"]){
//        //展示约伴详情
//        NSLog(@"展示约伴详情");
//        [self jumpToQmy];
//    }
}

-(void)jumpToQmy{
//    static HSYueBanDetailViewController *yuebanDetailViewController;
    HSYueBanDetailViewController *yuebanDetailViewController = [[HSYueBanDetailViewController alloc]initWithYueBanID:self.myUnStoppedYueBanDetail.yueban_id];
    
//    [self addChildViewController:yuebanDetailViewController];
    
    [self presentViewController:yuebanDetailViewController animated:YES completion:nil];
//    UIWindow *window = [[UIApplication sharedApplication]keyWindow];
//    [window insertSubview:yuebanDetailViewController.view aboveSubview:self.collectionView];
//    [self.view insertSubview:yuebanDetailViewController.view aboveSubview:self.scrollView];
//    [self transitionFromViewController:self toViewController:yuebanDetailViewController duration:0.3 options:UIViewAnimationOptionTransitionFlipFromBottom animations:nil completion:nil];
    
}


#pragma mrak 展现我正在发起的约伴简介界面
- (void)showMyUnStoppedYueBanUI{
    [_inviteFriendsView.clickYueBanBtn setTitle:@"showYueBanDetail"
                                       forState:UIControlStateDisabled];
    [_inviteFriendsView.clickYueBanBtn setImage:[UIImage imageNamed:@"yueBan_detail"]
                                       forState:UIControlStateNormal];
    [_inviteFriendsView.yueBanDescriptionLabel setText:[[NSString alloc]initWithFormat:@"已有 %@ 人参加邀请", self.myUnStoppedYueBanDetail.attend_count]];

}

#pragma mark 展现创建约伴界面
- (void)showMyCreateYueBanUI{
    [_inviteFriendsView.clickYueBanBtn setTitle:@"createYueBan"
                                       forState:UIControlStateDisabled];
    [_inviteFriendsView.clickYueBanBtn setImage:[UIImage imageNamed:@"yueBan_create"]
                                       forState:UIControlStateNormal];
    [_inviteFriendsView.yueBanDescriptionLabel setText:@"发起约伴邀请"];
}



#pragma mark 点击我的邀请按钮
- (void)showMyInviteList:(UIButton *)btn{
    //    self.myInviteHistoryView = [[HSMyInviteHistoryView alloc]init];
    //    UIWindow *window = [[UIApplication sharedApplication]keyWindow];
    //    [window insertSubview:self.myInviteHistoryView aboveSubview:self];
    //    [self show:self.myInviteHistoryView];
    static HSMyInviteHistoryViewController *m;
    m = [[HSMyInviteHistoryViewController alloc]init];
//    [[UIApplication sharedApplication].keyWindow addSubview:m.view];
    [self presentViewController:m animated:YES completion:nil];
    
//    self.view.alpha = 0.1;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];

}



#pragma mark - HSScaleScrollViewDelegate 协议
- (void)registerClassForCollectionView:(UICollectionView *)cv {
    [cv registerClass:[HSInviteFriendsCardView class] forCellWithReuseIdentifier:reuseIdentifier];
}

- (void)setDataSourceForCollectionView:(UICollectionView *)cv {
    cv.dataSource = self;
}

- (void)getMoreDataForScaleScrollView {
    
}

- (void)getNewDataForScaleScrollView {
    
}

- (void)gestureRecognizerStateChangedWithScaleFactor:(float)factor {
    
}

- (BOOL)shouldMyPanGestureRecognizerBebgin {
    return YES;
}

-(void)getUserDefaults{
    if ([[NSUserDefaults standardUserDefaults]objectForKey:receiveAll]) {
        NSString * receive = [[NSUserDefaults standardUserDefaults]objectForKey:receiveAll];
        if ([receive isEqualToString:@"1"]) {
            self.inviteFriendsView.isFriendsBtn.on = YES;
            [self getYuebanListFromStrangers];
        }else{
            self.inviteFriendsView.isFriendsBtn.on = NO;
             [self getYuebanListFromFriends];
        }
    }else{
        NSString *receive = @"1";
        [[NSUserDefaults standardUserDefaults]setObject:receive forKey:receiveAll];
    }
    
    
}

-(void)isFriendSwith{

    NSString *receive = [[NSUserDefaults standardUserDefaults]objectForKey:receiveAll];
    if ([receive isEqualToString:@"1"]) {
        [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:receiveAll];
        NSLog(@"friends");
        [self getYuebanListFromFriends];
    }else{
        [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:receiveAll];
        NSLog(@"strangers");
        [self getYuebanListFromStrangers];
    }
    

    
    
    
}

#pragma mark - HSInviteFriendsCardViewDelegate 协议
- (void)agreeBtnClickWithYueBanDataModel:(HSInviteFriendsCard *)inviteFriendsCard {
    [self updataUserYueBanState:inviteFriendsCard.yueban_id WithYesOrNo:YES];

    long index = [self.inviteFromStrangerArray indexOfObject:inviteFriendsCard];
    NSIndexPath *indxpath = [NSIndexPath indexPathForItem:index inSection:0];
    
    [self.inviteFromStrangerArray removeObject:inviteFriendsCard];
//    [self.scrollView reloadDataWithArrayCount:self.inviteFromStrangerArray.count];
    
    [self.scrollView deleteItemAtIndexPath:indxpath];
}

- (void)refuseBtnClickWithYueBanDataModel:(HSInviteFriendsCard *)inviteFriendsCard {
    long index = [self.inviteFromStrangerArray indexOfObject:inviteFriendsCard];
    NSIndexPath *indxpath = [NSIndexPath indexPathForItem:index inSection:0];

    [self updataUserYueBanState:inviteFriendsCard.yueban_id WithYesOrNo:NO];
    [self.inviteFromStrangerArray removeObject:inviteFriendsCard];
//    [self.scrollView reloadDataWithArrayCount:self.inviteFromStrangerArray.count];
    
    [self.scrollView deleteItemAtIndexPath:indxpath];
}

#pragma mark
- (void)viewWillAppear:(BOOL)animated {
    NSLog(@"HSInviteFriendsVC viewWillAppear");
}

- (void)viewDidAppear:(BOOL)animated {
    NSLog(@"HSInviteFriendsVC viewDidAppear");
}

- (void)viewWillDisappear:(BOOL)animated{
    NSLog(@"HSInviteFriendsVC viewWillDisappear");
}
- (void)viewDidDisappear:(BOOL)animated{
    NSLog(@"HSInviteFriendsVC viewDidDisappear");
}

@end
