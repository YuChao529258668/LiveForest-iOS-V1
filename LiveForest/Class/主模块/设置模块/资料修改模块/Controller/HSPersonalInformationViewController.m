//
//  HSPersonalInformationViewController.m
//  LiveForest
//
//  Created by 余超 on 15/6/29.
//  Copyright (c) 2015年 HOTeam. All rights reserved.
//

#import "HSPersonalInformationViewController.h"
#import "HSPickView.h"
#import "HSDataFormatHandle.h"
#import "HSDatePickView.h"
#import "HSNicknameViewController.h"
#import "MBProgressHUD.h"
#import "HSAddressMViewController.h"
#import "HSLabelSelectView.h"
#import "HSSportLabelCell.h"
@interface HSPersonalInformationViewController ()
@property (nonatomic, strong) NSMutableArray *selectedID;
@end
//个性标签高度
static float sharpCellHeight = 30;
//运动标签高度
static float sprotCellHeight= 30;
static CGAffineTransform transform;
static float rowHeight=52;//从故事板获取
static float factor;

@implementation HSPersonalInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //加入向左箭头
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"navigationbar_back"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
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
    transform = CGAffineTransformMakeScale(factor, factor);
    
    //调整位置
    //    CGRect newFrame = self.tableView.frame;
    //    newFrame.origin=CGPointZero;
    //    CGRect barFrame=self.navigationController.navigationBar.frame;
    //    newFrame.origin.y=barFrame.size.height;
    //    self.tableView.frame=newFrame;
    
    //图片处理
    // 启动GPS
    [TuSDKTKLocation shared].requireAuthor = YES;
    
    // 异步方式初始化滤镜管理器
    // 需要等待滤镜管理器初始化完成，才能使用所有功能
    //    [self showHubWithStatus:LSQString(@"lsq_initing", @"正在初始化")];
    [TuSDK checkManagerWithDelegate:self];
    
    self.requestDataCtrl = [[HSRequestDataController alloc] init];
    
    self.tableView.tableFooterView = [UIView new];

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
            
            if(![[userDefaults objectForKey:@"user_nickname"]  isEqual: @""]){
                [self.nickName setText:[userDefaults objectForKey:@"user_nickname"]];
            }
            else
            {
                [self.nickName setText:@"LF主页君"];
            }
            NSString *userCity  = [userDefaults objectForKey:@"user_city"];
            if(userCity == nil || userCity.length == 0 || [userCity isEqualToString:@"-10086"])
            {
                [self.city setText:@"点击设置城市"];
            }
            else
            {
                HSDataFormatHandle *handle = [[HSDataFormatHandle alloc]init];
                NSString *city = [handle areaFormatHandleWithStringID:userCity];
                [self.city setText:city];
            }
            NSString *userBirthday = [userDefaults objectForKey:@"user_birthday"];
            if(userBirthday == nil || userBirthday.length == 0 || [userBirthday isEqualToString:@"-10086"])
            {
                [self.age setText:@"点击设置生日"];
            }
            else
            {
                [self.age setText:[userDefaults objectForKey:@"user_birthday"]];
            }
            if([userDefaults objectForKey:@"user_sex"] != nil && ![[userDefaults objectForKey:@"user_sex"] isEqual:@""]){
                switch ([[userDefaults objectForKey:@"user_sex"] intValue]) {
                    case 0:
                        //男
                        [self.sex setText:@"男"];
                        break;
                    case 1:
                        //女
                        [self.sex setText:@"女"];
                        break;
                    default:
                        [self.sex setText:@"女"];
                        break;
                }
            }
            //运动标签
            id user_sport_id = [userDefaults objectForKey:@"user_sport_id"];
            if ([user_sport_id isKindOfClass:[NSArray class]]) {
                self.selectedID = user_sport_id;
                [self addSportLabelView:user_sport_id];
            }
        }
    }];
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
//对tableview的填充


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 1){//修改用户头像
        [self editAvarlImage];
    }
    if(indexPath.row == 2){//修改用户昵称
        [self editUserNickname];
    }
    if(indexPath.row == 4){//修改用户的生日
        //监听通知
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didClickSaveBirthday:) name:@"didClickSaveBirthday" object:nil];
        [self editUserBirthday];
        //取消高亮
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    if(indexPath.row == 5){//修改用户的城市区域
        //监听通知
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didClickSaveCityInfo:) name:@"didClickSaveCity" object:nil];
        [self editUserAreaInfo];
        //取消高亮
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    if(indexPath.row == 6){//收货地址管理
        [self editUserAddress];
        //取消高亮
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    if(indexPath.row == 8){//运动标签修改
        [self editSportLabels];
        //取消高亮
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}
#pragma mark addImage
- (void)editAvarlImage{
    
    UIActionSheet *as=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册选择", nil];
    [as showInView:self.view];
}
#pragma mark - 修改用户昵称
-(void)editUserNickname
{
    HSNicknameViewController *nickNameVC = [[HSNicknameViewController alloc]init];
    nickNameVC.nickname = self.nickName.text;
    nickNameVC.title = @"修改昵称";
    [self pushViewController:nickNameVC animated:YES];
}
#pragma mark - 修改用户生日
-(void)editUserBirthday
{
    HSDatePickView *datePickView = [[HSDatePickView alloc]init];
    
    [datePickView show];
}
#pragma mark 保存用户生日
-(void)didClickSaveBirthday:(NSNotification *)noti
{
    NSString *dateString = noti.userInfo[@"dateString"];
    self.age.text = dateString;
    //保存去后台
    [self updatePersonBirthday:dateString];
    //移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"didClickSaveBirthday" object:nil];
}
#pragma mark 更新后台用户生日信息
-(void)updatePersonBirthday:(NSString *)dateString
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *user_token = [userDefaults objectForKey:@"user_token"];
    if(!user_token || dateString == nil){
        NSLog(@"user_token为空，或者dateString 为空");
    }else{
        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:user_token,@"user_token",
                             dateString,@"user_birthday",nil];
        NSDictionary *requestData = [[NSDictionary alloc] initWithObjectsAndKeys:[dic JSONString],@"requestData", nil];
        
        NSLog(@"requestData:%@",requestData);
        [self.requestDataCtrl updatePersonBirthday:requestData andRequestCB:^(BOOL code, id responseObject, NSString *error) {
            if (code)
            {
                NSLog(@"更新生日成功");
                //写入本地文件
                [self.userInfoControl updateUserBirthday:dateString];
            }
            else
            {
                NSLog(@"更新生日请求失败，%@",error);
            }
        }];
        
    }

}

#pragma mark - 修改用户城市信息--wf
-(void)editUserAreaInfo
{
    HSPickView *areaPickView = [[HSPickView alloc]initWithFrame:self.tableView.frame Level:AreaLevelCity];
    //加到当前的屏幕上
    [areaPickView show];
    
}
#pragma mark 保存用户城市信息
-(void)didClickSaveCityInfo:(NSNotification *)noti
{
    self.city.text = noti.userInfo[@"areaInfo"];
    NSString *areaID = noti.userInfo[@"areaID"];
    //保存去后台
    [self updatePersonCityWithCityID:areaID];
    //移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"didClickSaveCity" object:nil];
}

#pragma mark 更新后台用户城市
-(void)updatePersonCityWithCityID:(NSString *)cityID
{

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *user_token = [userDefaults objectForKey:@"user_token"];
    if(!user_token || cityID == nil){
        NSLog(@"user_token为空，或者cityID 为空");
    }else{
        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:user_token,@"user_token",
                             cityID,@"user_city",nil];
        NSDictionary *requestData = [[NSDictionary alloc] initWithObjectsAndKeys:[dic JSONString],@"requestData", nil];
        
        NSLog(@"requestData:%@",requestData);
        [self.requestDataCtrl updatePersonCity:requestData andRequestCB:^(BOOL code, id responseObject, NSString *error) {
            if (code)
            {
                NSLog(@"更新城市成功");
                //写入本地文件
                [self.userInfoControl updateUserCity:cityID];
            }
            else
            {
                NSLog(@"更新城市请求失败，%@",error);
            }
        }];

    }
}

#pragma mark - 管理用户收货地址
-(void)editUserAddress
{
    HSAddressMViewController *addressMViewC = [[HSAddressMViewController alloc]init];
    addressMViewC.title = @"管理收货地址";
    [self.navigationController pushViewController:addressMViewC animated:YES];
}

#pragma mark - 修改用户运动标签
- (void)editSportLabels
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showSportLabelView:) name:@"showSportLabel" object:nil];
    HSLabelSelectView *selectView = [[HSLabelSelectView alloc]initWithSelectedID:self.selectedID isSingleSelection:NO];
    [selectView show];
}
/**
 *修改完后通知页面显示，发送后台修改
 */
-(void)showSportLabelView:(NSNotification *)noti
{
    //取出用户修改运动标签内容
    NSMutableArray *selectedSportsIDs = noti.userInfo[@"selectedIDs"];
    
    self.selectedID = selectedSportsIDs;
    
    [self addSportLabelView:selectedSportsIDs];
    
    //修改后台
    [self updatePersonSports:selectedSportsIDs];
}
#pragma -mark 添加运动标签
- (void)addSportLabelView:(NSMutableArray *)selectedSportsIDs
{
    NSIndexPath *indexpath = [NSIndexPath indexPathForRow:8 inSection:0];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexpath];
    
    CGFloat width = cell.contentView.bounds.size.width - 22;
    //移除已有的标签
    for (UIView *subView in cell.contentView.subviews) {
        if ([subView isKindOfClass:[HSSportLabelCell class]]) {
            [subView removeFromSuperview];
        }
    }
    //修改
    HSSportLabelCell *label = [[HSSportLabelCell alloc]initWithFrame:CGRectMake(55, 3, width, 20) sportsID:selectedSportsIDs];
    
    //动态修改cell的高度
    CGSize size = cell.bounds.size;
    size.height = label.viewHeight;
    cell.bounds = CGRectMake(0, 0, size.width, size.height);
    
    //修改下一行的高度
    NSIndexPath *indexpath2 = [NSIndexPath indexPathForRow:9 inSection:0];
    UITableViewCell *nextCell = [self.tableView cellForRowAtIndexPath:indexpath2];
    CGRect f = nextCell.frame;
    f.origin.y = CGRectGetMaxY(cell.frame);
    nextCell.frame = f;
    sprotCellHeight=cell.bounds.size.height*1.3;
    //刷新tableView
    [self.tableView reloadData];
    [cell.contentView addSubview:label];

}
#pragma mark 修改后台用户运动标签
-(void)updatePersonSports:(NSArray *)userSportID
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *user_token = [userDefaults objectForKey:@"user_token"];
    if(!user_token){
        NSLog(@"user_token为空");
    }else{
        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:user_token,@"user_token",
                             userSportID,@"user_sport_id",nil];
        NSDictionary *requestData = [[NSDictionary alloc] initWithObjectsAndKeys:[dic JSONString],@"requestData", nil];
        
        NSLog(@"requestData:%@",requestData);
        [self.requestDataCtrl updatePersonSports:requestData andRequestCB:^(BOOL code, id responseObject, NSString *error) {
            if (code)
            {
                NSLog(@"更新运动标签成功");
                //写入本地文件
                [self.userInfoControl updateUserSportsID:userSportID];
            }
            else
            {
                NSLog(@"更新运动标签失败，%@",error);
            }
        }];
        
    }

    
}

#pragma mark - TuSDKFilterManagerDelegate
/**
 * 滤镜管理器初始化完成
 *
 * @param manager
 *            滤镜管理器
 */
- (void)onTuSDKFilterManagerInited:(TuSDKFilterManager *)manager
{
    //    [self showHubSuccessWithStatus:LSQString(@"lsq_inited", @"初始化完成")];
}
#pragma mark - cameraComponentHandler
/**
 *  2-2 相机组件
 */
- (void) cameraComponentHandler;
{
    // 开启访问相机权限
    [TuSDKTSDeviceSettings checkAllowWithType:lsqDeviceSettingsCamera
                                    completed:^(lsqDeviceSettingsType type, BOOL openSetting)
     {
         if (openSetting) {
             lsqLError(@"Can not open camera");
             return;
         }
         [self showCameraController];
     }];
}

#pragma mark - cameraComponentHandler TuSDKPFCameraDelegate
- (void)showCameraController;
{
    TuSDKPFCameraOptions *opt = [TuSDKPFCameraOptions build];
    
    // 视图类 (默认:TuSDKPFCameraView, 需要继承 TuSDKPFCameraView)
    // opt.viewClazz = [TuSDKPFCameraView class];
    
    // 默认相机控制栏视图类 (默认:TuSDKPFCameraConfigView, 需要继承 TuSDKPFCameraConfigView)
    // opt.configBarViewClazz = [TuSDKPFCameraConfigView class];
    
    // 默认相机底部栏视图类 (默认:TuSDKPFCameraBottomView, 需要继承 TuSDKPFCameraBottomView)
    // opt.bottomBarViewClazz = [TuSDKPFCameraBottomView class];
    
    // 闪光灯视图类 (默认:TuSDKPFCameraFlashView, 需要继承 TuSDKPFCameraFlashView)
    // opt.flashViewClazz = [TuSDKPFCameraFlashView class];
    
    // 滤镜视图类 (默认:TuSDKPFCameraFilterGroupView, 需要继承 TuSDKPFCameraFilterGroupView)
    // opt.filterViewClazz = [TuSDKPFCameraFilterView class];
    
    // 聚焦触摸视图类 (默认:TuSDKICFocusTouchView, 需要继承 TuSDKICFocusTouchView)
    // opt.focusTouchViewClazz = [TuSDKICFocusTouchView class];
    
    // 摄像头前后方向 (默认为后置优先)
    // opt.avPostion = [AVCaptureDevice firstBackCameraPosition];
    
    // 设置分辨率模式
    // opt.sessionPreset = AVCaptureSessionPresetHigh;
    
    // 闪光灯模式 (默认:AVCaptureFlashModeOff)
    // opt.defaultFlashMode = AVCaptureFlashModeOff;
    
    // 是否开启滤镜支持 (默认: 关闭)
    //    opt.enableFilters = YES;
    
    // 默认是否显示滤镜视图 (默认: 不显示, 如果enableFilters = NO, showFilterDefault将失效)
    opt.showFilterDefault = YES;
    
    // 滤镜列表行视图宽度
    // opt.filterBarCellWidth = 75;
    
    // 滤镜列表选择栏高度
    // opt.filterBarHeight = 100;
    
    // 滤镜分组列表行视图类 (默认:TuSDKCPGroupFilterGroupCell, 需要继承 TuSDKCPGroupFilterGroupCell)
    //     opt.filterBarGroupCellClazz = [TuSDKCPGroupFilterGroupCell class];
    
    // 滤镜列表行视图类 (默认:TuSDKCPGroupFilterItem, 需要继承 TuSDKCPGroupFilterItem)
    //     opt.filterBarTableCellClazz = [TuSDKCPGroupFilterItem class];
    
    // 需要显示的滤镜名称列表 (如果为空将显示所有自定义滤镜)
    //    opt.filterGroup = nil;
    //     opt.filterGroup = @[@"SkinNature", @"SkinPink", @"SkinJelly", @"SkinNoir", @"SkinRuddy", @"SkinPowder", @"SkinSugar"];
    
    opt.filterGroup = @[@"SkinNature"];
    //nslo
    // 是否保存最后一次使用的滤镜
    opt.saveLastFilter = YES;
    
    // 自动选择分组滤镜指定的默认滤镜
    //    opt.autoSelectGroupDefaultFilter = YES;
    //todo
    opt.autoSelectGroupDefaultFilter = NO;
    
    // 开启滤镜配置选项
    opt.enableFilterConfig = YES;
    
    // 视频视图显示比例 (默认：0， 0 <= mRegionRatio, 当设置为0时全屏显示)
    // opt.cameraViewRatio = 0.75f;
    
    // 视频视图显示比例类型 (默认:lsqRatioAll, 如果设置cameraViewRatio > 0, 将忽略ratioType)
    opt.ratioType = lsqRatioAll;
    
    // 是否开启长按拍摄 (默认: NO)
    opt.enableLongTouchCapture = YES;
    
    // 开启持续自动对焦 (默认: NO)
    opt.enableContinueFoucs = YES;
    
    // 自动聚焦延时 (默认: 5秒)
    // opt.autoFoucsDelay = 5;
    
    // 长按延时 (默认: 1.2秒)
    // opt.longTouchDelay = 1.2;
    
    // 保存到系统相册 (默认不保存, 当设置为YES时, TuSDKResult.asset)
    opt.saveToAlbum = NO; //todo这句保证不保存在 相册中，因此缓存不会消失，可以使用.image
    
    // 保存到临时文件 (默认不保存, 当设置为YES时, TuSDKResult.tmpFile)
    // opt.saveToTemp = NO;
    
    // 保存到系统相册的相册名称
    // opt.saveToAlbumName = @"TuSdk";
    
    // 照片输出压缩率 0-1 如果设置为0 将保存为PNG格式 (默认: 0.95)
    // opt.outputCompress = 0.95f;
    
    // 视频覆盖区域颜色 (默认：[UIColor clearColor])
    opt.regionViewColor = [UIColor colorWithRed:51 / 255.0 green:51 / 255.0 blue:51 / 255.0 alpha:1.0];
    
    // 照片输出分辨率
    // opt.outputSize = CGSizeMake(1440, 1920);
    
    // 禁用前置摄像头自动水平镜像 (默认: NO，前置摄像头拍摄结果自动进行水平镜像)
    // opt.disableMirrorFrontFacing = YES;
    
    TuSDKPFCameraViewController *controller = opt.viewController;
    // 添加委托
    controller.delegate = self;
    [self presentModalNavigationController:controller animated:YES];
    //    [self openEditAdvancedWithController:controller result:result];
    
}

/**
 *  获取一个拍摄结果
 *
 *  @param controller 默认相机视图控制器
 *  @param result     拍摄结果
 */
- (void)onTuSDKPFCamera:(TuSDKPFCameraViewController *)controller captureResult:(TuSDKResult *)result;
{
    //    [self openEditAdvancedWithController:controller result:result];
    //开启高级编辑组件
    [self openEditMultipleWithController:controller result:result];
    //    [controller dismissModalViewControllerAnimated:YES];
    //    [controller dismissViewControllerAnimated:YES completion:nil];
    lsqLDebug(@"onTuSDKPFCamera: %@", result);
}


#pragma mark - editAdvancedComponentHandler
/**
 *  4-1 高级图片编辑组件
 */
- (void)editAdvancedComponentHandler;
{
    lsqLDebug(@"editAdvancedComponentHandler");
    _albumComponent =
    [TuSDK albumCommponentWithController:self
                           callbackBlock:^(TuSDKResult *result, NSError *error, UIViewController *controller)
     {
         // 获取图片错误
         if (error) {
             lsqLError(@"album reader error: %@", error.userInfo);
             return;
         }
         [self openEditAdvancedWithController:controller result:result];
         
     }];
    
    [_albumComponent showComponent];
}

/**
 *  开启图片高级编辑
 *
 *  @param controller 来源控制器
 *  @param result     处理结果
 */
- (void)openEditAdvancedWithController:(UIViewController *)controller
                                result:(TuSDKResult *)result;
{
    if (!controller || !result) return;
    
    _photoEditComponent =
    [TuSDK photoEditCommponentWithController:controller
                               callbackBlock:^(TuSDKResult *result, NSError *error, UIViewController *controller)
     {
         [self clearComponents];
         // 获取图片失败
         if (error) {
             lsqLError(@"editAdvanced error: %@", error.userInfo);
             return;
         }
         [result logInfo];
         //         NSLog(@"图片：%@",result.image);
         if([result loadResultImage]){
             NSData *fData = UIImageJPEGRepresentation([result loadResultImage], 0.3);//图片压缩todo
             self.imageURL =(NSString *)[result imageAsset].url;
             UIImage *image = [UIImage imageWithData:fData];
             
             //             _shView.firstImageVIew.image = [self addTagToImage:image];
             //             _shView.firstImageVIew.contentMode = UIViewContentModeScaleAspectFill;
             //             _shView.firstImageVIew.clipsToBounds=YES;
             //
             //             _shView.firstImageVIew.image =[result loadResultImage];
             NSLog(@"[self.imageURL];%@",self.imageURL);
         }else{
             NSLog(@"图片为空，为获取到");
         }
     }];
    
    //    // 图片编辑入口控制器配置选项
    //    // 默认: true, 开启裁剪旋转功能
    //    _photoEditComponent.options.editEntryOptions.enableCuter = YES;
    //    // 默认: true, 开启滤镜功能
    //    _photoEditComponent.options.editEntryOptions.enableFilter = YES;
    //    // 默认: true, 开启贴纸功能
    //    _photoEditComponent.options.editEntryOptions.enableSticker = YES;
    //    // 最大输出图片按照设备屏幕 (默认:false, 如果设置了LimitSideSize, 将忽略LimitForScreen)
    //    _photoEditComponent.options.editEntryOptions.limitForScreen = YES;
    //    // 保存到系统相册
    _photoEditComponent.options.editEntryOptions.saveToAlbum = NO;
    //
    //    // 图片编辑滤镜控制器配置选项
    //    // 默认: true, 开启滤镜配置选项
    //    _photoEditComponent.options.editFilterOptions.enableFilterConfig = YES;
    //    // 是否仅返回滤镜，不返回处理图片(默认：false)
    //    _photoEditComponent.options.editFilterOptions.onlyReturnFilter = YES;
    //    // 滤镜列表行视图宽度
    //    _photoEditComponent.options.editFilterOptions.filterBarCellWidth = 75;
    //    // 滤镜列表选择栏高度
    //    _photoEditComponent.options.editFilterOptions.filterBarHeight = 100;
    //    // 滤镜分组列表行视图类 (默认:TuSDKCPGroupFilterGroupCell, 需要继承 TuSDKCPGroupFilterGroupCell)
    //    _photoEditComponent.options.editFilterOptions.filterBarGroupCellClazz = [TuSDKCPGroupFilterGroupCell class];
    //    // 滤镜列表行视图类 (默认:TuSDKCPGroupFilterItem, 需要继承 TuSDKCPGroupFilterItem)
    //    _photoEditComponent.options.editFilterOptions.filterBarTableCellClazz = [TuSDKCPGroupFilterItem class];
    //
    //    // 图片编辑裁切旋转控制器配置选项
    //    // 是否开启图片旋转(默认: false)
    _photoEditComponent.options.editCuterOptions.enableTrun = YES;
    //    // 是否开启图片镜像(默认: false)
    _photoEditComponent.options.editCuterOptions.enableMirror = YES;
    //    // 裁剪比例 (默认:lsqRatioAll)
    //    _photoEditComponent.options.editCuterOptions.ratioType = lsqRatioAll;
    //    // 是否仅返回裁切参数，不返回处理图片
    //    _photoEditComponent.options.editCuterOptions.onlyReturnCuter = YES;
    
    // 设置图片
    _photoEditComponent.inputImage = result.image;
    _photoEditComponent.inputTempFilePath = result.imagePath;
    _photoEditComponent.inputAsset = result.imageAsset;
    // 是否在组件执行完成后自动关闭组件 (默认:NO)
    _photoEditComponent.autoDismissWhenCompelted = YES;
    
    
    
    
    //默认:TuSDKPFEditEntryView, 需要继承 TuSDKPFEditEntryView
    //    _photoEditComponent.options.editEntryOptions.viewClazz=[HSEditEntryView class];
    
    
    
    
    [_photoEditComponent showComponent];
    
}

/**
 *  清楚所有控件
 */
- (void)clearComponents;
{
    // 自定义系统相册组件
    _albumComponent = nil;
    // 头像设置组件
    _avatarComponent = nil;
    // 图片编辑组件
    _photoEditComponent = nil;
}

#pragma mark - TuSDKCPComponentErrorDelegate
/**
 *  获取组件返回错误信息
 *
 *  @param controller 控制器
 *  @param result     返回结果
 *  @param error      异常信息
 */
- (void)onComponent:(TuSDKCPViewController *)controller result:(TuSDKResult *)result error:(NSError *)error;
{
    lsqLDebug(@"onComponent: controller - %@, result - %@, error - %@", controller, result, error);
}
#pragma mark 弹出actionSheet选照相或者相册
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex==0) {
        //拍照
        [self cameraComponentHandler];
    } else if (buttonIndex==1) {
        //相册
        //        [self editAdvancedComponentHandler];
        //        SimpleEditMultipleComponent *semc=[[SimpleEditMultipleComponent alloc]init];
        //        semc.edi
        
        //        DemoSimpleBase *simple = [self simpleWithIndexPath:indexPath];
        //        if (!simple) return;
        //
        //        [self.delegate demoRootView:self selectedSimple:simple withAction:demoListItemActionSelected];
        [self showSimpleWithController:self];
        
    }
}
#pragma mark

#pragma mark - avatarComponentHandler
/**
 *  头像设置组件
 */
- (void) avatarComponentHandler:(UIImageView *)imageView
{
    //    lsqLDebug(@"avatarComponentHandler");
    NSLog(@"avatarComponentHandler头像设置组件");
    _avatarComponent =
    [TuSDK avatarCommponentWithController:self
                            callbackBlock:^(TuSDKResult *result, NSError *error, UIViewController *controller)
     {
         
         [self clearComponents];
         // 获取头像图片
         if (error) {
             lsqLError(@"avatar reader error: %@", error.userInfo);
             NSLog(@"// 获取头像图片失败");
             return;
         }
         //         NSLog(@"result.imageAsset.url:%@",result.imageAsset.url);
         if([result loadResultImage]){
             NSData *fData = UIImageJPEGRepresentation([result loadResultImage], 0.3);//图片压缩todo
             self.imageURL =(NSString *)[result imageAsset].url;
             imageView.image = [UIImage imageWithData:fData];
             imageView.contentMode = UIViewContentModeScaleAspectFill;
             NSLog(@"[self.imageURL];%@",self.imageURL);
         }
         else{
             self.imageURL = nil;
         }
     }];
    // 需要显示的滤镜名称列表 (如果为空将显示所有自定义滤镜)
    //todo
    _avatarComponent.options.cameraOptions.filterGroup = nil;
    //  @[@"SkinNature", @"SkinPink", @"SkinJelly", @"SkinNoir", @"SkinRuddy", @"SkinPowder", @"SkinSugar"];
    /*_avatarComponent.options.
     *  摄像机配置选项
     @property (nonatomic, readonly) TuSDKPFCameraOptions *cameraOptions;
     *  旋转和裁剪视图控制器配置选项
     @property (nonatomic, readonly) TuSDKPFEditTurnAndCutOptions *editTurnAndCutOptions;
     */
    // 是否在组件执行完成后自动关闭组件 (默认:NO)
    _avatarComponent.autoDismissWhenCompelted = YES;
    [_avatarComponent showComponent];
}



#pragma mark 新版图图
/**
 *  显示范例
 *
 *  @param controller 启动控制器
 */
- (void)showSimpleWithController:(UIViewController *)controller;
{
    //    if (!controller) return;
    //    self.controller = controller;
    
    lsqLDebug(@"editAdvancedComponentHandler");
    
    _albumComponent =
    [TuSDK albumCommponentWithController:controller
                           callbackBlock:^(TuSDKResult *result, NSError *error, UIViewController *controller)
     {
         // 获取图片错误
         if (error) {
             lsqLError(@"album reader error: %@", error.userInfo);
             return;
         }
         [self openEditMultipleWithController:controller result:result];
     }];
    
    [_albumComponent showComponent];
}

/**
 *  开启多功能图片编辑
 *
 *  @param controller 来源控制器
 *  @param result     处理结果
 */
#pragma mark 滤镜处理结果
- (void)openEditMultipleWithController:(UIViewController *)controller
                                result:(TuSDKResult *)result;
{
    if (!controller || !result) return;
    
    // 组件选项配置
    // @see-http://tusdk.com/docs/ios/api/Classes/TuSDKCPPhotoEditMultipleComponent.html
    _photoEditMultipleComponent =
    [TuSDK photoEditMultipleWithController:controller
                             callbackBlock:^(TuSDKResult *result, NSError *error, UIViewController *controller)
     {
         _albumComponent = nil;
         // 获取图片失败
         if (error) {
             lsqLError(@"editMultiple error: %@", error.userInfo);
             return;
         }
         //         [result logInfo];
         
         if([result loadResultImage]){
             NSData *fData = UIImageJPEGRepresentation([result loadResultImage], 0.3);//图片压缩todo
             [self.avarlImage setImage:[UIImage imageWithData:fData]];
             self.imageURL = (NSString *)[result imageAsset].url;
             
             //存取到后台，并保存到本地
             [self submitAvarlImage:self.avarlImage.image andImageURL:self.imageURL];
             
         }else{
             ShowHud(@"头像设置失败", NO);
             NSLog(@"图片为空，为获取到");
         }
         
     }];
    
    // @see-http://tusdk.com/docs/ios/api/Classes/TuSDKCPPhotoEditMultipleOptions.html
    // _photoEditMultipleComponent.options
    
    //    // 图片编辑入口控制器配置选项
    // @see-http://tusdk.com/docs/ios/api/Classes/TuSDKPFEditMultipleOptions.html
    // _photoEditMultipleComponent.options.editMultipleOptions
    //    // 禁用功能模块 默认：加载全部模块
    //    [_photoEditMultipleComponent.options.editMultipleOptions disableModule:lsqTuSDKCPEditActionCuter];
    //    // 最大输出图片按照设备屏幕 (默认:false, 如果设置了LimitSideSize, 将忽略LimitForScreen)
    //    _photoEditMultipleComponent.options.editMultipleOptions.limitForScreen = YES;
    //    // 保存到系统相册
//        _photoEditMultipleComponent.options.editMultipleOptions.saveToAlbum = NO;
    //    // 控制器关闭后是否自动删除临时文件
        _photoEditMultipleComponent.options.editMultipleOptions.isAutoRemoveTemp = YES;
    //
    //    // 图片编辑滤镜控制器配置选项
    // @see-http://tusdk.com/docs/ios/api/Classes/TuSDKPFEditFilterOptions.html
    // _photoEditMultipleComponent.options.editFilterOptions
    //    // 默认: true, 开启滤镜配置选项
    //    _photoEditMultipleComponent.options.editFilterOptions.enableFilterConfig = YES;
    //    // 保存到临时文件
//        _photoEditMultipleComponent.options.editFilterOptions.saveToTemp = YES;
    //    // 照片输出压缩率 0-100 如果设置为0 将保存为PNG格式
    //    _photoEditMultipleComponent.options.editFilterOptions.outputCompress = 0.95f;
    //    // 滤镜列表行视图宽度
    //    _photoEditMultipleComponent.options.editFilterOptions.filterBarCellWidth = 75;
    //    // 滤镜列表选择栏高度
    //    _photoEditMultipleComponent.options.editFilterOptions.filterBarHeight = 100;
    //    // 滤镜分组列表行视图类 (默认:TuSDKCPGroupFilterGroupCell, 需要继承 TuSDKCPGroupFilterGroupCell)
    //    _photoEditMultipleComponent.options.editFilterOptions.filterBarGroupCellClazz = [TuSDKCPGroupFilterGroupCell class];
    //    // 滤镜列表行视图类 (默认:TuSDKCPGroupFilterItem, 需要继承 TuSDKCPGroupFilterItem)
    //    _photoEditMultipleComponent.options.editFilterOptions.filterBarTableCellClazz = [TuSDKCPGroupFilterItem class];
    
    //todo：
    _photoEditMultipleComponent.options.editFilterOptions.filterGroup = @[ @"SkinPink",@"Noir",@"Harmony",@"SkinPink",@"Clear",@"Newborn",@"Cheerful",@"Instant",@"Abao"];
    //
    //    // 图片编辑裁切旋转控制器配置选项
    // @see-http://tusdk.com/docs/ios/api/Classes/TuSDKPFEditCuterOptions.html
    // _photoEditMultipleComponent.options.editCuterOptions
    //    // 是否开启图片旋转(默认: false)
    //    _photoEditMultipleComponent.options.editCuterOptions.enableTrun = YES;
    //    // 是否开启图片镜像(默认: false)
    //    _photoEditMultipleComponent.options.editCuterOptions.enableMirror = YES;
    //    // 裁剪比例 (默认:lsqRatioAll)
    //    _photoEditMultipleComponent.options.editCuterOptions.ratioType = lsqRatioAll;
    //    // 保存到临时文件
    //    _photoEditMultipleComponent.options.editCuterOptions.saveToTemp = YES;
    //    // 照片输出压缩率 0-100 如果设置为0 将保存为PNG格式
    //    _photoEditMultipleComponent.options.editCuterOptions.outputCompress = 0.95f;
    //
    //    // 美颜控制器视图配置选项
    // @see-http://tusdk.com/docs/ios/api/Classes/TuSDKPFEditSkinOptions.html
    // _photoEditMultipleComponent.options.editSkinOptions
    //    // 保存到临时文件
//        _photoEditMultipleComponent.options.editSkinOptions.saveToTemp = YES;
    //    // 照片输出压缩率 0-100 如果设置为0 将保存为PNG格式
    //    _photoEditMultipleComponent.options.editSkinOptions.outputCompress = 0.95f;
    //
    //    // 图片编辑贴纸选择控制器配置选项
    // _photoEditMultipleComponent.options.editStickerOptions
    // @see-http://tusdk.com/docs/ios/api/Classes/TuSDKPFEditStickerOptions.html
    //    // 单元格间距 (单位：DP)
    //    _photoEditMultipleComponent.options.editStickerOptions.gridPadding = 2;
    //    // 保存到临时文
    //    _photoEditMultipleComponent.options.editStickerOptions.saveToTemp = YES;
    //    // 照片输出压缩率 0-100 如果设置为0 将保存为PNG格式
    //    _photoEditMultipleComponent.options.editStickerOptions.outputCompress = 0.95f;
    //
    //    // 颜色调整控制器配置选项
    // _photoEditMultipleComponent.options.editAdjustOptions
    // @see-http://tusdk.com/docs/ios/api/Classes/TuSDKPFEditAdjustOptions.html
    //    // 保存到临时文
    //    _photoEditMultipleComponent.options.editAdjustOptions.saveToTemp = YES;
    //    // 照片输出压缩率 0-100 如果设置为0 将保存为PNG格式
    //    _photoEditMultipleComponent.options.editAdjustOptions.outputCompress = 0.95f;
    //
    //    // 锐化功能控制器配置选项
    // _photoEditMultipleComponent.options.editSharpnessOptions
    // @see-http://tusdk.com/docs/ios/api/Classes/TuSDKPFEditSharpnessOptions.html
    //    // 保存到临时文
    //    _photoEditMultipleComponent.options.editSharpnessOptions.saveToTemp = YES;
    //    // 照片输出压缩率 0-100 如果设置为0 将保存为PNG格式
    //    _photoEditMultipleComponent.options.editSharpnessOptions.outputCompress = 0.95f;
    //
    //    // 大光圈控制器配置选项
    // _photoEditMultipleComponent.options.editApertureOptions
    // @see-http://tusdk.com/docs/ios/api/Classes/TuSDKPFEditApertureOptions.html
    //    // 保存到临时文
    //    _photoEditMultipleComponent.options.editApertureOptions.saveToTemp = YES;
    //    // 照片输出压缩率 0-100 如果设置为0 将保存为PNG格式
    //    _photoEditMultipleComponent.options.editApertureOptions.outputCompress = 0.95f;
    //
    //    // 暗角控制器功能控制器配置选项
    // _photoEditMultipleComponent.options.editVignetteOptions
    // @see-http://tusdk.com/docs/ios/api/Classes/TuSDKPFEditVignetteOptions.html
    //    // 保存到临时文
    //    _photoEditMultipleComponent.options.editVignetteOptions.saveToTemp = YES;
    //    // 照片输出压缩率 0-100 如果设置为0 将保存为PNG格式
    //    _photoEditMultipleComponent.options.editVignetteOptions.outputCompress = 0.95f;
    
    // 设置图片
    _photoEditMultipleComponent.inputImage = result.image;
    _photoEditMultipleComponent.inputTempFilePath = result.imagePath;
    _photoEditMultipleComponent.inputAsset = result.imageAsset;
    // 是否在组件执行完成后自动关闭组件 (默认:NO)
    _photoEditMultipleComponent.autoDismissWhenCompelted = YES;
    
    
    
    //默认:TuSDKPFEditEntryView, 需要继承 TuSDKPFEditEntryView
    //    _photoEditMultipleComponent.options.editEntryOptions.viewClazz=[HSEditEntryView class];
    //    _photoEditMultipleComponent.options.editMultipleOptions.viewClazz=[HSEditMultipleView class];
    //    AppDelegate *d=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    //    d.resultImage=result.image;
    //    d.inputImage=_photoEditMultipleComponent.inputImage;
    //    d.result=result;
    
    //    NSLog(@"%@",result.image);
    //    NSLog(@"%@",result.imagePath);
    
    
    
    [_photoEditMultipleComponent showComponent];
}

#pragma mark 提交submit
- (void) submitAvarlImage:(UIImage *)image andImageURL:(NSString*)url{
    //    add_new_photo.png
    if (image && url) {
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:window animated:YES];
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.labelText = @"正在上传头像";
        //初始化后台请求，七牛上传
        self.requestDataCtrl = [[HSRequestDataController alloc] init];
        QNUploadManager *upManager = [[QNUploadManager alloc] init];
        
        //分享按钮不能继续点击
//        [self.infoCompletingView.avarlImage setUserInteractionEnabled:NO];
        
        //把图片转成NSData类型的数据来保存文件
        NSData *dataImag;
        //判断图片是不是png格式的文件
        if (UIImagePNGRepresentation(image)) {
            //返回为png图像。
            dataImag = UIImagePNGRepresentation(image);
        }else {
            //返回为JPEG图像。
            dataImag = UIImageJPEGRepresentation(image, 1.0);
        }
        //        NSLog(@"dataImag:  %@",dataImag);
        NSLog(@"图片上传开始");
        //转化imageURL格式
        NSString *fileName=[NSString stringWithFormat:@"%@", url]; //必须
        NSDictionary *dic = @{@"fileName": fileName, @"prefix": @"imageTestByHot"};
        NSString *data = [dic JSONString];
        NSDictionary* requestData = @{@"requestData"  : data};
        //      后台交互
        [self.requestDataCtrl getQiniuUpTokenWithParam:requestData andRequestCB:^(BOOL code,id responseObject, NSString *error){
            if(code){
                NSString *saveKey = [responseObject objectForKey:@"saveKey"];
                NSString *upToken = [responseObject objectForKey:@"upToken"];
                //开始上传
                [upManager putData:dataImag key:saveKey token:upToken
                          complete: ^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                              NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                              //todo
                              if(![userDefaults objectForKey:@"user_token"]){
                                  NSLog(@"user_token为空，");
                                  return;
                              }
                              NSString *user_token = [[NSString alloc]initWithString:[userDefaults objectForKey:@"user_token"]];
                              NSString *imgUrl = [[NSString alloc]initWithFormat:@"%s%@",QiNiuImageUrl,key];
                              NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                                   user_token,
                                                   @"user_token",
                                                   imgUrl,
                                                   @"user_logo_img_path",nil];
                              NSDictionary *requestData = [[NSDictionary alloc] initWithObjectsAndKeys:
                                                           [dic JSONString],@"requestData", nil];
                              //                                  将key存入数组
                              
                              NSLog(@"图片上传成功！");
                              //如果所有图片上传成功，写入后天，否则不写入
                              [self.requestDataCtrl updatePersonLogo:requestData andRequestCB:^(BOOL code,id responseObject, NSString *error){
                                  if(code){
                                      //更新用户个人头像信息到本地
                                      [hud hide:YES];
                                      //直接修改页面
                                      self.avarlImage.image = [UIImage imageWithData:dataImag];
                                      ShowHud(@"上传成功", NO);
                                      //写入本地
                                      [userDefaults setObject:dataImag forKey:@"user_logo_img"]; //直接存取到本地
                                      //用户头像url持久化
                                      [userDefaults setObject:imgUrl  forKey:@"user_logo_url"];
                                      [self.userInfoControl updateUserAvarlAndSaveHandler:imgUrl]; //更新模糊头像
                                  }
                                  else{
                                      NSLog(@"上传失败");
                                      [hud hide:YES];
                                      ShowHud(@"上传失败", NO);
                                      NSLog(@"异常,写入数据库");
                                      
                                  }
                              }];
                          } option:nil];
                
            }
            else{
                ShowHud(@"头像设置失败", NO);

                NSLog(@"%@",error);
            }
            
        }];
    }
    else{
        ShowHud(@"请选择图片", NO);
        NSLog(@"图片不存在");
    }
    
}

#pragma mark 消除分隔符
- (void)tableView:(nonnull UITableView *)tableView willDisplayCell:(nonnull UITableViewCell *)cell forRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    cell.transform=transform;

    if (indexPath.row==0 || indexPath.row==7 || indexPath.row==8 ) {
        cell.separatorInset = UIEdgeInsetsMake(0, cell.bounds.size.width, 0, 0);
    }
}

#pragma mark 屏幕适配
- (CGFloat)tableView:(nonnull UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (indexPath.row==0 || indexPath.row == 7) {
        return 34*factor;
    }
    
    if (indexPath.row==8) {
        return sprotCellHeight*factor;
    }
    if (indexPath.row==9) {
        return sharpCellHeight*factor;
    }

    if (indexPath.row!=1) {
        return rowHeight*factor;
    }
    
    return 86*factor;
}
-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
