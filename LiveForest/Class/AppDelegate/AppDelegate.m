//
//  AppDelegate.m
//  LiveForest
//
//  Created by 微光 on 15/4/10.
//  Copyright (c) 2015年 HOTeam. All rights reserved.
//

#import "AppDelegate.h"

#import "HSLoginViewController.h" //yc

#import "HSRegisterViewController.h"
#import <ShareSDK/ShareSDK.h>

//腾讯开放平台（对应QQ和QQ空间）SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>

//微信SDK头文件
#import "WXApi.h"

//新浪微博SDK头文件
#import "WeiboSDK.h"


//#import <TencentOpenAPI/QQApiInterface.h>
//融云 sdk
#import <RongIMKit/RongIMKit.h>

//测试信息补全页面
#import "HSInfoCompletingVC.h"

#import "Aspects.h"

//友盟推送
#define UMSYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

@interface AppDelegate ()

@property (nonatomic, strong) DoubleBounceView *bounceView;
@property (strong, nonatomic) UILabel *infoLabel;

@end

@implementation AppDelegate
#define IOS_VERSION_GREATER_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)

@synthesize loginVC = _loginVC;

@synthesize mapManager = _mapManager;

@synthesize imageOfTuSDK;
@synthesize frameOfImageOfTuSDK;
@synthesize tagTextField;
@synthesize resultImage;
@synthesize inputImage;
@synthesize result;
@synthesize imageTipLabel;
@synthesize imageWithLabels;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //todo by qiang  判断是否有多个window，并对rootviewcontroller赋值
//    NSArray *windows = [[UIApplication sharedApplication] windows];
//    for(UIWindow *window in windows) {
//        NSLog(@"window: %@",window.description);
//        if(window.rootViewController == nil){
//            UIViewController* vc = [[UIViewController alloc]initWithNibName:nil bundle:nil];
//            window.rootViewController = vc;
//        }
//    }
    
    //ui
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    //背景图片
    UIImageView *backgroundImage = [[UIImageView alloc]initWithFrame:self.window.frame];
    backgroundImage.image = [UIImage imageNamed:@"splash"];  //图片尺寸 放在了图片set中
    [self.window addSubview:backgroundImage];
    
    //初始化第三方组件
    [self initThirdFramework:launchOptions];

    //记录  判断是否是推送唤起了应用  changed by qiang
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"pushMessageLanuchApp"];
    _pushMessageLanuchApp = [[[launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey] objectForKey:@"aps"] objectForKey:@"alert"];
    if(_pushMessageLanuchApp){
        [[NSUserDefaults standardUserDefaults] setObject:_pushMessageLanuchApp forKey:@"pushMessageLanuchApp"];
    }
    
    //记录应用是否第一次 启动
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"appFinishedLanunch"];
    
    
    
    // 监测网络情况,如果没联网，并且有缓存，则直接进入应用；如果没有缓存，进入登陆界面；如果从断网联网了，那么通知各个模块，重新加载数据
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name: kReachabilityChangedNotification
                                               object: nil];
    hostReach = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    [hostReach startNotifier];

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setObject:@"9sz9UP9bo4VM7I1zdXoPrk2FHnJShMGuSwadv9D2BUVhs3D" forKey:@"user_token"];//测试代码，使用默认的user_token
    
    //如果有缓存个人token，则直接进入应用（先判断网络状态），否则进入登陆界面
    if ([[userDefaults objectForKey:@"user_token"] length] > 0)
    {
        
        //如果没网络，则直接进入应用，否则，需要进行判断
        if(NotReachable == hostReach.currentReachabilityStatus)
        {
            // 显示登录控制器
            self.window.rootViewController = [SingletonForRootViewCtrl sharedInstance];
            
        }
        else{
            // 已经登录过
//            [self autoLoginWithUserDefaults:userDefaults];
            self.window.rootViewController = [SingletonForRootViewCtrl sharedInstance];  //todo，如果不在这里设置，就会报错，说 rootviewcontroller没设置，先这样做吧。

        }
        
    }
    else
    {
        // 登录界面
        NSLog(@"App Delegate.m ==========line 184 登陆流程");
        _loginVC  = [[HSLoginViewController alloc]init];
        
        self.window.rootViewController = _loginVC;
        
//        self.window.rootViewController = [SingletonForRootViewCtrl sharedInstance];  //todo，如果不在这里设置，就会报错，说 rootviewcontroller没设置，先这样做吧。

    }
    
    //网络连接好了，重新加载数据
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadThirdFramework:) name:@"notificationHSReloadData" object:nil];
    
    return YES;
    
}

#pragma mark -
#pragma mark 自动登录

- (void)autoLoginWithUserDefaults:(NSUserDefaults *)userDefaults
{
    //网络请求
    self.requestCtrl = [[HSRequestDataController alloc] init];
    
    //NSString *loginName = [userDefaults objectForKey:@"loginName"];
    //NSString *loginPassword = [userDefaults objectForKey:@"loginPassword"];
    NSString *user_token = [userDefaults objectForKey:@"user_token"];
    
    //构造请求数据 TODO token 过期
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:user_token,@"user_token",nil];
    NSDictionary *requestData = [[NSDictionary alloc] initWithObjectsAndKeys:[dic JSONString],@"requestData", nil];
    //NSLog(@"%@",requestData);
    
    [self.requestCtrl doLogin:requestData andRequestCB:^(BOOL code, id responseObject, NSString * error){
        if(code){
            if([[responseObject objectForKey:@"user_id"] isKindOfClass:[NSString class]]){
                [self setUserID: [responseObject objectForKey:@"user_id"]];
            }
            else{
                NSLog(@"没有返回id,id不是string");
            }
            
            [self performSelectorOnMainThread:@selector(showControllerWithSuccess:) withObject:@"true" waitUntilDone:NO];
        }
        else{
            ShowHud(@"自动登录失败，请联网", NO);
            [self performSelectorOnMainThread:@selector(showControllerWithSuccess:) withObject:@"false" waitUntilDone:NO];
        }
    }];
    
}
#pragma mark -自动登录 跳转 viewcontroller， true跳转主页面，false跳转登录页面
- (void)showControllerWithSuccess:(NSString *)success
{
    [self.bounceView removeFromSuperview];
    [self.infoLabel removeFromSuperview];
    
    if ([success isEqualToString:@"true"])
    {
        //测试资料补全页
//        self.window.rootViewController = [[HSInfoCompletingVC alloc]init];
//        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"enterInfoCompletingVCByPhone"];
        // 显示登录控制器
        self.window.rootViewController = [SingletonForRootViewCtrl sharedInstance];
        
    }
    else
    {
        // 显示登录控制器
        self.window.rootViewController = [[HSLoginViewController alloc] init];
    }
}


//#pragma -mark sharesdk handleOpenURL
- (BOOL)application:(UIApplication *)application
      handleOpenURL:(NSURL *)url
{
    return [ShareSDK handleOpenURL:url
                        wxDelegate:self];
}
//
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return [ShareSDK handleOpenURL:url
                 sourceApplication:sourceApplication
                        annotation:annotation
                        wxDelegate:self];
}




- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
#pragma RC申请权限
#ifdef __IPHONE_8_0
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    // Register to receive notifications.
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void(^)())completionHandler
{
    // Handle the actions.
    if ([identifier isEqualToString:@"declineAction"]){
    }
    else if ([identifier isEqualToString:@"answerAction"]){
    }
}
#endif


#pragma mark -

#pragma mark -
#pragma mark 注册推送

- (void)registerPushForNonIOS8
{
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
}

- (void)registerPushForIOS8
{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= _IPHONE80_
    
    //Types
    UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
    
    //Actions
    UIMutableUserNotificationAction *acceptAction = [[UIMutableUserNotificationAction alloc] init];
    
    acceptAction.identifier = @"ACCEPT_IDENTIFIER";
    acceptAction.title = @"Accept";
    
    acceptAction.activationMode = UIUserNotificationActivationModeForeground;
    acceptAction.destructive = NO;
    acceptAction.authenticationRequired = NO;
    
    //Categories
    UIMutableUserNotificationCategory *inviteCategory = [[UIMutableUserNotificationCategory alloc] init];
    
    inviteCategory.identifier = @"INVITE_CATEGORY";
    
    [inviteCategory setActions:@[acceptAction] forContext:UIUserNotificationActionContextDefault];
    
    [inviteCategory setActions:@[acceptAction] forContext:UIUserNotificationActionContextMinimal];
    
    NSSet *categories = [NSSet setWithObjects:inviteCategory, nil];
    
    
    UIUserNotificationSettings *mySettings = [UIUserNotificationSettings settingsForTypes:types categories:categories];
    
    [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
    
    
    [[UIApplication sharedApplication] registerForRemoteNotifications];
#endif
}

- (void)registerPush
{
    if (IOS_VERSION_GREATER_THAN(@"8.0"))
    {
        [self registerPushForIOS8];
    }
    else
    {
        [self registerPushForNonIOS8];
    }
}


#pragma mark -
#pragma mark 收到远程推送
// 获取苹果推送权限成功。
-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    
    NSData *data = [deviceToken copy];
    NSLog(@"%@:%@",deviceToken,data);
    //持久化
    //    NSLog(@"%@",NSStringFromClass([deviceToken description]));
    //
    NSString *tokenID = [[[[deviceToken description] stringByReplacingOccurrencesOfString: @"<" withString: @""]
                          stringByReplacingOccurrencesOfString: @">" withString: @""]
                         stringByReplacingOccurrencesOfString: @" " withString: @""] ;
    //    NSString *str = @"123";
    //
    //    NSLog(@"data:%@",data);
    //    NSLog(@"device:%@",deviceToken);
    NSLog(@"tokenID:%@",tokenID);
    //    NSLog(@"str:%@",str);
    //    NSLog(@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"UMtokenId"]);
    //        if([tokenID isKindOfClass:[NSString class]]){
    //            NSLog(@"um token is sdtring");
    //        }
    [[NSUserDefaults standardUserDefaults] setObject:tokenID forKey:@"UMtokenId"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [UMessage registerDeviceToken:deviceToken];
    //    //友盟推送
    //    NSLog(@"友盟推送:%@",[[[[deviceToken description] stringByReplacingOccurrencesOfString: @"<" withString: @""]
    //                  stringByReplacingOccurrencesOfString: @">" withString: @""]
    //                 stringByReplacingOccurrencesOfString: @" " withString: @""]);
    //融云推送
    //    NSLog(@"%@",deviceToken);
    // 设置 deviceToken。
    //    [[RCIM sharedRCIM] setDeviceToken:deviceToken];
    //    3689d2ba174c099ab4b3c93b0fffbb855860dfe1e206cbd88fbff88f792ca830
    //    3689d2ba 174c099a b4b3c93b0fffbb855860dfe1e206cbd88fbff88f792ca830
    //信鸽推送
    //    NSString * deviceTokenStr = [XGPush registerDevice:deviceToken];
    //    [[NSUserDefaults standardUserDefaults] setObject:deviceTokenStr forKey:@"tokenId"];
    //    [[NSUserDefaults standardUserDefaults] synchronize];
    //
    //    void (^successBlock)(void) = ^(void){
    //        //成功之后的处理
    //        NSLog(@"[XGPush]register successBlock ,deviceToken: %@",deviceTokenStr);
    //    };
    //
    //    void (^errorBlock)(void) = ^(void){
    //        //失败之后的处理
    //        NSLog(@"[XGPush]register errorBlock");
    //    };
    
    //注册设备
    //    [[XGSetting getInstance] setChannel:@"appstore"];
    //    [[XGSetting getInstance] setGameServer:@"巨神峰"];
    //    [XGPush registerDevice:deviceToken successCallback:successBlock errorCallback:errorBlock];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    //to be done ...
    //    [UMessage didReceiveRemoteNotification:userInfo];
    NSString *parent_type = [HSDataFormatHandle handleNumber:[userInfo objectForKey:@"parent_type"]];
    NSString *sub_type = [HSDataFormatHandle handleNumber:[userInfo objectForKey:@"sub_type"]];
    
    NSDictionary *aps = [userInfo objectForKey:@"aps"];
    NSString *pushMessage = [aps objectForKey:@"alert"];
    NSLog(@"获取的后台推送消息:%@",pushMessage);
    //关闭友盟对话框
    [UMessage setAutoAlert:NO];
    //    //此方法不要删除
    //    [UMessage didReceiveRemoteNotification:userInfo];
    //
    //    self.userInfo = userInfo;
    //    // app was already in the foreground
    //    if([UIApplication sharedApplication].applicationState == UIApplicationStateActive || [UIApplication sharedApplication].applicationState == UIApplicationStateBackground)
    if([UIApplication sharedApplication].applicationState == UIApplicationStateActive) //应用内进入
    {
        if([parent_type isEqualToString:@"00"]){ //用户模块
            //        if([sub_type isEqualToString:@"00"]){ //好友接收邀请
            //            NSString *user_id = [HSDataFormatHandle handleNumber:[userInfo objectForKey:@"id"]];
            //        }else if([sub_type isEqualToString:@"01"]){ //好友关注了我
            //            NSString *user_id = [HSDataFormatHandle handleNumber:[userInfo objectForKey:@"id"]];
            //
            //        }
        }else if([parent_type isEqualToString:@"01"]){//图片分享
            if([sub_type isEqualToString:@"00"]){ //分享被评论
                NSString *share_id = [HSDataFormatHandle handleNumber:[userInfo objectForKey:@"id"]];
                
                //                封装数据
                NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:share_id,@"id",parent_type,@"parent_type",sub_type,@"sub_type",pushMessage,@"pushMessage", nil];
                //点击通知的这一个后，会进入详情
                [[NSNotificationCenter defaultCenter]postNotificationName:@"notificationHSNotificationDataSource" object:dic];
                
                
            }
            //        else if([sub_type isEqualToString:@"01"]){ //被某个用户在某个分享中 @
            //            NSString *share_id = [HSDataFormatHandle handleNumber:[userInfo objectForKey:@"id"]];
            //
            //        }
        }else if([parent_type isEqualToString:@"02"]){//约伴
            //todo
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"邀请"
                                                             message:pushMessage
                                                            delegate:self
                                                   cancelButtonTitle:@"查看"
                                                   otherButtonTitles:@"忽略", nil];
            [alert show];
            //        if([sub_type isEqualToString:@"00"]){ //熟人发起的约伴邀请
            //            NSString *yueban_id = [HSDataFormatHandle handleNumber:[userInfo objectForKey:@"id"]];
            //        }else if([sub_type isEqualToString:@"01"]){ //你的约伴有人参加了
            //            NSString *yueban_id = [HSDataFormatHandle handleNumber:[userInfo objectForKey:@"id"]];
            //
            //        }
        }else if([parent_type isEqualToString:@"03"]){//线上活动
            //        if([sub_type isEqualToString:@"00"]){ //参与抽奖活动中奖了
            //            NSString *activity_id = [HSDataFormatHandle handleNumber:[userInfo objectForKey:@"id"]];
            //        }
        }else if([parent_type isEqualToString:@"04"]){//游戏
            //        if([sub_type isEqualToString:@"00"]){ //被邀请参与某个游戏
            //            NSString *share_id = [HSDataFormatHandle handleNumber:[userInfo objectForKey:@"id"]];
            //        }else if([sub_type isEqualToString:@"01"]){ //用户创建的多人游戏被人参加了
            //            NSString *share_id = [HSDataFormatHandle handleNumber:[userInfo objectForKey:@"id"]];
            //
            //        }else if([sub_type isEqualToString:@"02"]){ //用户创建的多人游戏被完成了
            //            NSString *share_id = [HSDataFormatHandle handleNumber:[userInfo objectForKey:@"id"]];
            //
            //        }
        }
        
        
        
    }
    else {  //应用外直接进入
        //        直接进入推送页面
        [[NSNotificationCenter defaultCenter]postNotificationName:@"notificationHSInviteFriends" object:pushMessage];
        NSLog(@"邀请按钮发通知啦！");
        //        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"邀请"
        //                                                         message:pushMessage
        //                                                        delegate:self
        //                                               cancelButtonTitle:@"查看"
        //                                               otherButtonTitles:@"忽略", nil];
        //        [alert show];
        
    }
    //    UIViewController *vc = [[UIViewController alloc] init];
    //    [vc.view setBackgroundColor:[UIColor blueColor]];
    //    UILabel *alertLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, kScreenHeight/3, kScreenWidth, kScreenHeight*2/3)];
    ////    [alertLabel set];
    //    [alertLabel setText:@"参加活动不,亲？"];
    //    [alertLabel setText:alert];
    //    [alertLabel setTextColor:[UIColor whiteColor]];
    //    [self.window.rootViewController presentViewController:vc animated:YES completion:nil];
    //    self.window.rootViewController
    //    [s];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0){
        //        NSLog(@"点击了ok，message:%@",alertView.message);
        [[NSNotificationCenter defaultCenter]postNotificationName:@"notificationHSInviteFriends" object:alertView.message];
        NSLog(@"邀请按钮发通知啦！");
    }
    else{
        NSLog(@"点击了no");
        
    }
    //    [UMessage sendClickReportForRemoteNotification:self.userInfo];
}

#pragma mark 百度地图启动合法性检测delegate

/**
 *返回网络错误
 *@param iError 错误号
 */
- (void)onGetNetworkState:(int)iError
{
    if (0 == iError) {
        NSLog(@"联网成功");
    }
    else{
        NSLog(@"onGetNetworkState %d",iError);
    }
    
}
/**
 *返回授权验证错误
 *@param iError 错误号 : 为0时验证通过，具体参加BMKPermissionCheckResultCode
 */
- (void)onGetPermissionState:(int)iError
{
    if (0 == iError) {
        NSLog(@"授权成功");
    }
    else {
        NSLog(@"onGetPermissionState %d",iError);
    }
}

#pragma mark 缓存
- (void) cacheSaved{
    //    AFNetworking基于NSURL开发的，这个就可以缓存
    NSURLCache *URLCache = [[NSURLCache alloc] initWithMemoryCapacity:4 * 1024 * 1024 diskCapacity:20 * 1024 * 1024 diskPath:nil];
    [NSURLCache setSharedURLCache:URLCache];
    
}
#pragma mark map
- (void)initMapManager{
    _mapManager = [[BMKMapManager alloc] init];
    BOOL ret = [_mapManager start:@"kT8UIQ5othxi3t3rxwSGwwIm"  generalDelegate:self];
    if (!ret) {
        NSLog(@"badidu map manager start failed!");
    }
    
}
#pragma mark shareSDK
- (void) initShareSDK{
    
    
    [ShareSDK registerApp:@"65db19d41432"];//字符串api20为您的ShareSDK的AppKey
    
    //添加新浪微博应用 注册网址 http://open.weibo.com
    [ShareSDK connectSinaWeiboWithAppKey:@"2886581071"
                               appSecret:@"57016ce226c43fbcebd4db8cdbc896f5"
                             redirectUri:@"http://m.live-forest.com/index.php/Home/Weco/oauthCallback"];
    //当使用新浪微博客户端分享的时候需要按照下面的方法来初始化新浪的平台
    [ShareSDK  connectSinaWeiboWithAppKey:@"2886581071"
                                appSecret:@"57016ce226c43fbcebd4db8cdbc896f5"
                              redirectUri:@"http://m.live-forest.com/index.php/Home/Weco/oauthCallback"
                              weiboSDKCls:[WeiboSDK class]];
    
//    //添加腾讯微博应用 注册网址 http://dev.t.qq.com
//    [ShareSDK connectTencentWeiboWithAppKey:@"801307650"
//                                  appSecret:@"ae36f4ee3946e1cbb98d6965b0b2ff5c"
//                                redirectUri:@"http://www.sharesdk.cn"];
//    
//    //添加QQ空间应用  注册网址  http://connect.qq.com/intro/login/
//    [ShareSDK connectQZoneWithAppKey:@"100371282"
//                           appSecret:@"aed9b0303e3ed1e27bae87c33761161d"
//                   qqApiInterfaceCls:[QQApiInterface class]
//                     tencentOAuthCls:[TencentOAuth class]];
//    
//    //添加QQ应用  注册网址   http://mobile.qq.com/api/
//    [ShareSDK connectQQWithQZoneAppKey:@"100371282"
//                     qqApiInterfaceCls:[QQApiInterface class]
//                       tencentOAuthCls:[TencentOAuth class]];

    //微信登陆的时候需要初始化
    [ShareSDK connectWeChatWithAppId:@"wx20b6a34093f521ce"
                           appSecret:@"e7703ef18636376d70ce3035289ac511"
                           wechatCls:[WXApi class]];
    
   }
#pragma mark tuSDK
- (void)initTuSDK{
    //    / 可选: 设置日志输出级别 (默认不输出)
    //    [TuSDK setLogLevel:lsqLogLevelDEBUG];
    
    // 初始化SDK (请前往 http://tusdk.com 申请秘钥)
    [TuSDK initSdkWithAppKey:@"3f16e3a713b95f08-00-v6lqn1"];  //co.hoteam.liveforest
//    [TuSDK initSdkWithAppKey:@"091ff6046847f5f6-00-v6lqn1"]; //com.lf

}
//#pragma mark RCIM
//- (void)initRCIM:(NSString*)token{
//
//    // 初始化 SDK，传入 App Key，deviceToken 暂时为空，等待获取权限。
//    //    [RCIM initWithAppKey:@"x18ywvqf8dhwc" deviceToken:nil];
//    [[RCIM sharedKit] initWithAppKey:@"pgyu6atqykilu" deviceToken:nil];
//
//    //需要向后台请求token
//    // 快速集成第二步，连接融云服务器
//    //    NSString *token = @"pSuSfyWLL15qDs6NGg6FItGtQfYVwcTOdszM2MN6Wo1IdkOcb4CGiyYtVhRYzuXxHw+jEogwPCc=";
//    [[RCIM sharedKit] connectWithToken:token success:^(NSString *userId) {
//        // Connect 成功
//
//    } error:^(RCConnectErrorCode status) {
//        // Connect失败
//    }];
//}
#pragma mark Push
- (void) initPush{
    
#ifdef __IPHONE_8_0
    // 在 iOS 8 下注册苹果推送，申请推送权限。
    UIApplication *sharedApplication = [UIApplication sharedApplication];
    if([sharedApplication respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert)
                                                                                 categories:nil];
        [sharedApplication registerUserNotificationSettings:settings];
    } else {
        [sharedApplication registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound];
    }
#else
    // 注册苹果推送，申请推送权限。
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound];
#endif
    
}

#pragma mark setuserid
-(void) setUserID:(NSString*)setUserID{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:setUserID forKey:@"user_id"];
    [userDefaults synchronize];
}

#pragma mark 蒲公英
- (void) initPGY{
    //    一、关闭用户反馈功能(默认开启)：
    //
    //    [[PgyManager sharedPgyManager] setEnableFeedback:NO];
    //    二、自定义用户反馈激活方式(默认为摇一摇)：
    //
    //    // 设置用户反馈界面激活方式为三指拖动
    //    [[PgyManager sharedPgyManager] setFeedbackActiveType:kPGYFeedbackActiveTypeThreeFingersPan];
    //
    //    // 设置用户反馈界面激活方式为摇一摇
    //    [[PgyManager sharedPgyManager] setFeedbackActiveType:kPGYFeedbackActiveTypeShake];
    //    上述自定义必须在调用 [[PgyManager sharedPgyManager] startManagerWithAppId:@"PGY_APP_ID"] 前设置。
    
    //初始化蒲公英todo（随着提交，会变化）
    [[PgyManager sharedPgyManager] startManagerWithAppId:@"0ce3ecdbe9f391472d202837aa57e56c"];
    //    三、自定义用户界面风格
    //
    //    开发者可以通过设置用户反馈界面的颜色主题来改变界面风格，设置之后的颜色会影响到Title的背景颜色和录音按钮的边框颜色，默认为0x37C5A1(绿色)。
    //[[PgyManager sharedPgyManager] setThemeColor:[UIColor blackColor]];
    //    四、自定义摇一摇灵敏度
    //
    //    开发者可以自定义摇一摇的灵敏度，默认为2.3，数值越小灵敏度越高。
    
    [[PgyManager sharedPgyManager] setShakingThreshold:2.5];
    
    //自动检查更新
    [[PgyManager sharedPgyManager] checkUpdate];
}

- (void) didFailToRegisterForRemoteNotificationsWithError:(NSError *)err
{
    //todo
    //友盟获取token失败
    NSString *error_str = [NSString stringWithFormat: @"%@", err];
    NSLog(@"Failed to get token, error:%@", error_str);
    
}

#pragma mark 友盟反馈
- (void) initUMessage:(NSDictionary *)launchOptions{
    //必须先导入推送文件
    //    如果确实是第一次安装运行且没有弹出，请仔细按照证书配置的要求重新生成一遍Provisioning Profiles。
    
    //set AppKey and AppSecret
    [UMessage startWithAppkey:@"5585756667e58e2827000e24" launchOptions:launchOptions];
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= _IPHONE80_
    if(UMSYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0"))
    {
        //register remoteNotification types （iOS 8.0及其以上版本）
        UIMutableUserNotificationAction *action1 = [[UIMutableUserNotificationAction alloc] init];
        action1.identifier = @"action1_identifier";
        action1.title=@"Accept";
        action1.activationMode = UIUserNotificationActivationModeForeground;//当点击的时候启动程序
        
        UIMutableUserNotificationAction *action2 = [[UIMutableUserNotificationAction alloc] init];  //第二按钮
        action2.identifier = @"action2_identifier";
        action2.title=@"Reject";
        action2.activationMode = UIUserNotificationActivationModeBackground;//当点击的时候不启动程序，在后台处理
        action2.authenticationRequired = YES;//需要解锁才能处理，如果action.activationMode = UIUserNotificationActivationModeForeground;则这个属性被忽略；
        action2.destructive = YES;
        
        UIMutableUserNotificationCategory *categorys = [[UIMutableUserNotificationCategory alloc] init];
        categorys.identifier = @"category1";//这组动作的唯一标示
        [categorys setActions:@[action1,action2] forContext:(UIUserNotificationActionContextDefault)];
        
        UIUserNotificationSettings *userSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert
                                                                                     categories:[NSSet setWithObject:categorys]];
        [UMessage registerRemoteNotificationAndUserNotificationSettings:userSettings];
        
    } else{
        //register remoteNotification types (iOS 8.0以下)
        [UMessage registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge
         |UIRemoteNotificationTypeSound
         |UIRemoteNotificationTypeAlert];
    }
#else
    
    //register remoteNotification types (iOS 8.0以下)
    [UMessage registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge
     |UIRemoteNotificationTypeSound
     |UIRemoteNotificationTypeAlert];
    
#endif
    //for log
    [UMessage setLogEnabled:YES];
}

#pragma mark 初始化所有第三方东西
- (void)initThirdFramework:(NSDictionary *)launchOptions{
    [self initPGY];
    
    //友盟反馈
    //    [UMFeedback setAppkey:@"5585756667e58e2827000e24"];
    //友盟推送
    [self initUMessage:launchOptions];
    
    //缓存URL todo
    [self cacheSaved];
    
    //地图manager
    [self initMapManager];
    
    [NSDictionary aspect_hookSelector:NSSelectorFromString(@"weibosdk_WBSDKJSONString")
                          withOptions:AspectPositionInstead
                           usingBlock:^(id<AspectInfo> info)
     {
         return [(NSDictionary*)[info instance] jsonString];
     }
                                error:nil];
    
    //share sdk
    [self initShareSDK];
    
    //TUSDK
    [self initTuSDK];
}

#pragma mark 监测网络状态
- (void)reachabilityChanged:(NSNotification *)note {
    Reachability* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
    NetworkStatus status = [curReach currentReachabilityStatus];
    
    if (status == NotReachable) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"LiveForest"
                                                        message:@"请检查网络连接!"
                                                       delegate:nil
                                              cancelButtonTitle:@"YES" otherButtonTitles:nil];
        [alert show];
    }
    else{
//        ShowHud(@"正在为您加载数据...", NO);
        //重新初始化第三方组件
//        [self initThirdFramework:note.object];
//        通知各个模块重新加载数据
        [[NSNotificationCenter defaultCenter]postNotificationName:@"notificationHSReloadData" object:nil];
    }
}

@end
