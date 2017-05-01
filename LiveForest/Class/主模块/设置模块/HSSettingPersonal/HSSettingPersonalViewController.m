//
//  HSSettingPersonalViewController.m
//  LiveForest
//
//  Created by Swift on 15/5/11.
//  Copyright (c) 2015年 HOTeam. All rights reserved.
//

#import "HSSettingPersonalViewController.h"
#import "HSAboutWeViewController.h"
#import "HSBlindPhoneVC.h"

@interface HSSettingPersonalViewController ()

/*所有社交服务的服务*/
@property(nonatomic,strong) SocialService* socialService;

/*绑定手机号的界面*/
@property(nonatomic,strong) HSPhoneBindViewController* hSPhoneBindViewController;

@end

static CGAffineTransform transform;
static float rowHeight=44;
static float factor;

@implementation HSSettingPersonalViewController
@synthesize imageView;
//float rowHeight=44;//行高

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    imageView.userInteractionEnabled=YES;
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(back)];
    [imageView addGestureRecognizer:tap];
    
    
    //屏幕适配
    int width=[UIScreen mainScreen].bounds.size.width;
//    float factor;
    switch (width) {
        case 320:
            factor = 1;
            break;
        case 375:
            factor = 1.17;
            break;
        case 414:
            factor = 1.17;
            break;
            
        default:
            factor = 1.17;
            break;
    }
//    self.view.transform = CGAffineTransformMakeScale(factor, factor);
//    self.tableView.transform = CGAffineTransformMakeScale(factor, factor);
    transform = CGAffineTransformMakeScale(factor, factor);
    
    //
    //调整位置
//    CGRect newFrame = self.tableView.frame;
//    newFrame.origin=CGPointZero;
//    CGRect barFrame=self.navigationController.navigationBar.frame;
//    newFrame.origin.y=barFrame.size.height;
//    self.tableView.frame=newFrame;
//
//    rowHeight=44*factor;
    
    self.view.backgroundColor=self.tableView.backgroundColor;
    
    //进入前台，刷新通知按钮状态
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshSystemMessageState) name:UIApplicationWillEnterForegroundNotification object:nil];
    
    //初始化当前的数据请求类
    self.hSRequestDataController = [[HSRequestDataController alloc] init];

}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //获取个人信息
    self.userInfoControl = [[HSUserInfoHandler alloc]init];
    [self.userInfoControl getUserInfoAndSaveHandler:^(BOOL completed){
        if(completed){
            self.avarlImage.layer.cornerRadius = self.avarlImage.frame.size.width/2;
            self.avarlImage.clipsToBounds = YES;
            
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            //判断是否已经有个人信息
            if([userDefaults objectForKey:@"user_logo_img"]){
                self.avarlImage.image = [UIImage imageWithData:[userDefaults objectForKey:@"user_logo_img"]];
            }
            else{
                self.avarlImage.image=[UIImage imageNamed:@"Home.jpg"];
            }
            if([userDefaults objectForKey:@"user_nickname"]){
                [self.nameLabel setText:[userDefaults objectForKey:@"user_nickname"]];
            }
            
            //设置用户手机号
            self.label_user_phone.text =
            
            [StringUtils isValid:[userDefaults objectForKey:@"user_phone"]] ? [userDefaults objectForKey:@"user_phone"]:@"未绑定";
            
            //设置用户微信绑定
            self.label_user_wechatName.text = [userDefaults objectForKey:@"wechat_nickname"];
            
            //设置用户微博
            self.label_user_wecoName.text = [userDefaults objectForKey:@"weco_nickname"];
        }
    }];
    //检测用户设置--通知中是否开启应用通知功能
    if ([[UIApplication sharedApplication] isRegisteredForRemoteNotifications]) {
        self.systemMessageState.hidden = NO;
        self.systemMessageSwith.hidden = YES;
    }else{
        self.systemMessageState.hidden = YES;
        self.systemMessageSwith.hidden = NO;
    }
    [self.systemMessageSwith addTarget:self action:@selector(editSystenRemoteMessage:) forControlEvents:UIControlEventValueChanged];

}
- (void)back
{
//    [self.view removeFromSuperview];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)backBtnClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 打开修改系统消息设置页面
- (void)editSystenRemoteMessage:(UISwitch *) mySwitch
{
    self.systemMessageSwith.on = NO;
     [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
}
#pragma mark - 进入前台刷新页面
- (void)refreshSystemMessageState
{
    if ([[UIApplication sharedApplication] isRegisteredForRemoteNotifications]) {
        self.systemMessageState.hidden = NO;
        self.systemMessageSwith.hidden = YES;
    }else{
        self.systemMessageState.hidden = YES;
        self.systemMessageSwith.hidden = NO;
    }
}
#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Potentially incomplete method implementation.
//    // Return the number of sections.
//    return 0;
//}

//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete method implementation.
//    // Return the number of rows in the section.
//    return 0;
//}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

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

/*
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)updateAppPress:(id)sender {
    [self updateApp];
}
- (void)updateApp {
    //    [[PgyManager sharedPgyManager] checkUpdate];
    
    //    如果需要自定义检查更新，则需要调用
    //
    [[PgyManager sharedPgyManager] checkUpdateWithDelegete:self selector:@selector(updateMethod:)];
    //    其中updateMethod为检查更新的回调方法。如果有新版本，则包含新版本信息的字典会被回传，否则字典为nil。处理完更新信息后，需调用
    //
    [[PgyManager sharedPgyManager] updateLocalBuildNumber];
    //    来更新本地存储的蒲公英Build号。本地存储的Build号被更新后，SDK会将本地版本视为最新。对当前版本调用检查更新方法将不再回传更新信息。
}
- (IBAction)feedBackPress:(UIButton *)sender {
    [self feedBack];
}
- (void)feedBack {
    [[PgyManager sharedPgyManager] showFeedbackView];
}
- (void)aboutWe {
    HSAboutWeViewController *aboutWeVc = [[HSAboutWeViewController alloc]init];
    aboutWeVc.title = @"关于我们";
    [self.navigationController pushViewController:aboutWeVc animated:YES];
}
- (void)updateMethod:(id)sender{
    NSLog(@"%@",sender);
}
#pragma mark - Table view delegate

#pragma mark 消除分隔符
- (void)tableView:(nonnull UITableView *)tableView willDisplayCell:(nonnull UITableViewCell *)cell forRowAtIndexPath:(nonnull NSIndexPath *)indexPath {

    cell.transform=transform;
    CGRect frame = cell.frame;
    frame.origin.x = 0;
    frame.size.width = [UIScreen mainScreen].bounds.size.width ;
    cell.frame = frame;
    if (indexPath.row==0 ||indexPath.row==4 ||indexPath.row==8 ) {
//        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, cell.bounds.size.width);
        cell.separatorInset = UIEdgeInsetsMake(0, cell.bounds.size.width, 0, 0);
    }
}

- (CGFloat)tableView:(nonnull UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (indexPath.row!=1) {
        return rowHeight*factor;
    }
    return 76*factor;
}

#pragma mark 某个Cell的点击事件

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld",indexPath.row);
    //手机号绑定
    if(indexPath.row == 5){
        
        //初始化手机号绑定界面
        HSBlindPhoneVC *blindPhoneVC = [[HSBlindPhoneVC alloc]init];
        
        //将当前的手机号码赋值给控制器，不为空就显示更换绑定号
        blindPhoneVC.phoneNumber = self.label_user_phone.text;
        
        //跳转到手机号绑定界面
        [self.navigationController pushViewController:blindPhoneVC animated:YES];
        
        //设置通知中心，修改当前信息
        [[NSNotificationCenter defaultCenter]
                                    addObserver:self
                                    selector:@selector(dataRefresh:)
                                    name:@"SettingDataRefreshNotification"
                                    object:nil
         ];
        
    }
    //点击了微信绑定
    if(indexPath.row == 6){
        
        [self doWeChatBind];
        
    }
    
    if(indexPath.row == 7){
    
        [self doWeCoBind];
    }
    
    if (indexPath.row == 9) {//我们
        [self aboutWe];
    }
    
    if (indexPath.row == 10) {//反馈
//        [[PgyManager sharedPgyManager] showFeedbackView];
        [self feedBack];
    }
    
    if (indexPath.row == 11) {//应用更新
        [self updateApp];
    }
}

#pragma mark - Inner Help

/**
 *@function 通知中心回调，更新当前用户信息
 **/
-(void)dataRefresh:(NSNotification*)notification{

    NSDictionary *data = [notification userInfo];
    
    //如果是修改了手机号，则显示
    if ([data objectForKey:@"label_user_phone"]) {
        self.label_user_wechatName.text = [data objectForKey:@"label_user_phone"];
    }
    
}

/**
 *@function 执行微信绑定
 **/
- (void)doWeChatBind{

    //判断当前用户的微信信息是否已经绑定
    if(![self.label_user_wechatName.text isEqual:@"未绑定"]){
        //如果信息已经绑定则不允许点击
//        ShowHudWithDelay(@"您已经绑定了微信号！", NO, 1.0);
        ShowHud(@"您已经绑定了微信号！", NO);
        return;
    }
    
    
    //初始化获取社交信息的服务
    self.socialService = [[SocialService alloc] init];
    
    //获取用户信息
    [self.socialService getWeChatUserInfo:^(NSDictionary* userInfoDict){
        
        //获取当前user_token
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        
        NSString *user_token = [userDefaults objectForKey:@"user_token"];
        
        NSString *user_wechat_id = [userInfoDict objectForKey:@"openId"];
        
        //调用第三方绑定接口
        [self.hSRequestDataController
         doThirdBind:[NSDictionary dictionaryWithObjectsAndKeys:
                      user_token,@"user_token",
                      [userInfoDict objectForKey:@"openId"],@"uid",
                      [userInfoDict objectForKey:@"nickname"],@"nickname",
                      [userInfoDict objectForKey:@"sex"],@"sex",
                      [userInfoDict objectForKey:@"profileImage"],@"profileImage",
                      [userInfoDict objectForKey:@"education"],@"education",
                      [userInfoDict objectForKey:@"work"],@"work",
                      [userInfoDict objectForKey:@"birthday"],@"birthday",
                      @"0",@"thirdSource"
                      ,nil]
         andRequestCB:^(BOOL result, id responseObject, NSString *error) {
             
             if(result){
                 
                 [self.userInfoControl getUserInfoAndSaveHandler:^(BOOL completed){
                     //如果绑定成功，则刷新当前数据
                     self.label_user_wechatName.text =[userInfoDict objectForKey:@"nickname"];
//                     ShowHudWithDelay(@"绑定成功！", YES, 1.0);
                     ShowHud(@"绑定成功！", NO);
                 }];
                 
             }else{
                 //绑定失败则弹出窗
                 ShowHud(error, NO);
             }
             
         }];
        
        
    }];

}
/**
 *@function 执行微博绑定
 **/
- (void)doWeCoBind{
    
    //判断当前用户的微信信息是否已经绑定
    if(![self.label_user_wecoName.text isEqual:@"未绑定"]){
        //如果信息已经绑定则不允许点击
//        ShowHudWithDelay(@"您已经绑定了微博号！", NO, 1.0);
        ShowHud(@"您已经绑定了微博号！", NO);
        return;
    }
    
    if(!self.socialService){
        self.socialService = [[SocialService alloc] init];
    }
    
    //获取用户信息
    [self.socialService getWeCoUserInfo:^(NSDictionary* userInfoDict){
        
        //获取当前user_token
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        
        NSString *user_token = [userDefaults objectForKey:@"user_token"];
        
        NSString *user_wechat_id = [userInfoDict objectForKey:@"openId"];
        
        //调用第三方绑定接口
        [self.hSRequestDataController
         doThirdBind:[NSDictionary dictionaryWithObjectsAndKeys:
                      user_token,@"user_token",
                      [userInfoDict objectForKey:@"openId"],@"uid",
                      [userInfoDict objectForKey:@"nickname"],@"nickname",
                      [userInfoDict objectForKey:@"sex"],@"sex",
                      [userInfoDict objectForKey:@"profileImage"],@"profileImage",
                      [userInfoDict objectForKey:@"education"],@"education",
                      [userInfoDict objectForKey:@"work"],@"work",
                      [userInfoDict objectForKey:@"birthday"],@"birthday",
                      @"1",@"thirdSource"
                      ,nil]
         andRequestCB:^(BOOL result, id responseObject, NSString *error) {
             
             if(result){
                 
                 [self.userInfoControl getUserInfoAndSaveHandler:^(BOOL completed){
                     //如果绑定成功，则刷新当前数据
                     [self.label_user_wecoName setText:[userInfoDict objectForKey:@"nickname"]];
//                     ShowHudWithDelay(@"绑定成功！", YES, 1.0);
                     ShowHud(@"绑定成功！", NO);
                 }];
                 
             }else{
                 //绑定失败则弹出窗
                 ShowHud(error, NO);
             }
             
         }];
        
        
    }];
    
}

#pragma mark Getter / Setter

@end
