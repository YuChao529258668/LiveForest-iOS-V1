//
//  HSCreatActivityViewController.m
//  LiveForest
//
//  Created by Swift on 15/4/17.
//  Copyright (c) 2015年 HOTeam. All rights reserved.
//
#import "HSShareActivityViewController.h"
#import "HSEditEntryView.h"
#import "HSConstantURL.h"

#import "HSShareView.h"

//TuSDK
#import "SimpleEditMultipleComponent.h"
#import "SimpleCameraComponent.h"
#import "TuSDKFramework.h"
#import "DemoRootView.h"
#import "HSEditMultipleView.h"
#import "AppDelegate.h"
#import "HSImageResultController.h"

#import "HSLabelSelectView.h"

#import "ZLPhotoPickerBrowserViewController.h"

#import "HSRelatedActivityVC.h"
#import "HSAtFriendViewController.h"
#import "HSFriendInfo.h"

@interface HSShareActivityViewController () <DemoRootViewDelegate, TuSDKFilterManagerDelegate, ZLPhotoPickerBrowserViewControllerDataSource,ZLPhotoPickerBrowserViewControllerDelegate>
{
    
}
@property (strong, nonatomic) NSMutableArray *imageUrlArray;
@property (strong, nonatomic) NSMutableArray *imageUpLoadUrlArray;
@property (strong, nonatomic) NSMutableArray *pastersArray;

@property (strong, nonatomic) NSMutableArray *imageArray;
@property (strong, nonatomic) NSMutableArray *tapArray;
@property (strong, nonatomic) UITapGestureRecognizer *tap0;
@property (strong, nonatomic) UITapGestureRecognizer *tap1;
@property (strong, nonatomic) UITapGestureRecognizer *tap2;
@property (strong, nonatomic) UITapGestureRecognizer *tap3;
@property (strong, nonatomic) UITapGestureRecognizer *tap4;
@property (strong, nonatomic) UITapGestureRecognizer *tap5;
@property (strong, nonatomic) UITapGestureRecognizer *tap6;
@property (strong, nonatomic) UITapGestureRecognizer *tap7;
@property (strong, nonatomic) UITapGestureRecognizer *tap8;

@property (copy, nonatomic) NSString *pasterId;
/**
 *  选中的关联活动
 */
@property (nonatomic, strong) NSMutableArray *selectedSportID;

/**
 *  选中的@好友
 */
@property (nonatomic, strong) NSMutableArray *selectedFriends;

/**
 *  选中的关联活动ID
 */
@property (nonatomic, copy) NSString *relateActivityID;
@end

@implementation HSShareActivityViewController

//@synthesize imageView=_shView.firstImageVIew;
//@synthesize manager;
//
//
//@synthesize shView = _shView;
//
@synthesize imageUrlArray;
@synthesize imageArray;
@synthesize imageUpLoadUrlArray;
@synthesize pastersArray;
@synthesize tapArray;
@synthesize tap0;
@synthesize tap1;
@synthesize tap2;
@synthesize tap3;
@synthesize tap4;
@synthesize tap5;
@synthesize tap6;
@synthesize tap7;
@synthesize tap8;
@synthesize pasterId;

#pragma mark - 初始化
- (instancetype)init{
    self = [super init];
    
    // 启动GPS
    [TuSDKTKLocation shared].requireAuthor = YES;
    
    // 异步方式初始化滤镜管理器
    // 需要等待滤镜管理器初始化完成，才能使用所有功能
//    [self showHubWithStatus:LSQString(@"lsq_initing", @"正在初始化")];
    [TuSDK checkManagerWithDelegate:self];

    
    _shView = [[HSShareView alloc]init];
    if(_shView){
        self.view = _shView;
        
        self.userInfoControl = [[HSUserInfoHandler alloc]init];
        [self.userInfoControl getUserInfoAndSaveHandler:^(BOOL completed){
            if(completed){
                _shView.avarlImage.layer.cornerRadius = _shView.avarlImage.frame.size.width/2;
                _shView.avarlImage.clipsToBounds = YES;
                
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                //判断是否已经有个人信息
                if([userDefaults objectForKey:@"user_logo_img"]){
                    _shView.avarlImage.image = [UIImage imageWithData:[userDefaults objectForKey:@"user_logo_img"]];
                }
                else{
                    _shView.avarlImage.image=[UIImage imageNamed:@"Home.jpg"];
                }
                
                if(![[userDefaults objectForKey:@"user_nickname"]  isEqual: @""]){
                    [_shView.nameLabel setText:[userDefaults objectForKey:@"user_nickname"]];
                }
               
            }
        }];

        
        
        
        //初始化view的按钮
        [_shView.shareBtn addTarget:self action:@selector(submit:) forControlEvents:UIControlEventTouchUpInside];
        [_shView.backBtn addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        //运动关联按钮
        [_shView.sportBtn addTarget:self action:@selector(chooseSportLables) forControlEvents:UIControlEventTouchUpInside];
        //加入选择运动通知
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(editSelectedSportID:) name:@"showSportLabel" object:nil];
        
        //@好友
        [_shView.atBtn addTarget:self action:@selector(chooseFriends) forControlEvents:UIControlEventTouchUpInside];
        //加入at好友通知
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(editAtFriendsID:) name:@"atFriendsID" object:nil];
        
        //活动关联按钮
        [_shView.activityBtn addTarget:self action:@selector(relatedActivity) forControlEvents:UIControlEventTouchUpInside];
        //活动关联通知
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(editRelateActivityID:) name:@"relatedActivityID" object:nil];
        
        UITapGestureRecognizer *tapImage = [[UITapGestureRecognizer alloc]init];
        [tapImage addTarget:self action:@selector(addImage:)];
        //firstImageView是加号，添加图片
        [_shView.firstImageVIew addGestureRecognizer:tapImage];
        
        //地理位置
        [_shView.mapBtn addTarget:self action:@selector(getLocation:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    imageUrlArray = [[NSMutableArray alloc]init];
    imageArray = [[NSMutableArray alloc]init];
    pastersArray = [[NSMutableArray alloc]init];
    imageUpLoadUrlArray = [[NSMutableArray alloc]init];
    //初始化手势数组
    [self initTapArray];
    [self updateImageViewsFrame];
//    self.shView.scrollView.contentSize=self.shView.scrollView.frame.size;
//    CGRect f=self.shView.scrollView.frame;
//    f.size.height/=2;
//    self.shView.scrollView.frame=f;

    //地理位置相关
    //省
    province = @"";
    //市
    city = @"";
    //区
    district = @"";
    //经度
    longitude = @"";
    //纬度
    latitude = @"";
    //位置
    location = @"";
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    float factor=[UIScreen mainScreen].bounds.size.width/self.view.frame.size.width;
//    self.view.transform = CGAffineTransformMakeScale(factor, factor);

    
    // Do any additional setup after loading the view from its nib.
//    _shView = [[HSShareView alloc]init];
//    if(_shView){
//        self.view = _shView;
//        
//        //初始化view的按钮
//        [_shView.cameraBtn addTarget:self action:@selector(cameraBtnClick) forControlEvents:UIControlEventTouchUpInside];
//        [_shView.albumBtn addTarget:self action:@selector(albumBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//        [_shView.shareBtn addTarget:self action:@selector(submit:) forControlEvents:UIControlEventTouchUpInside];
//        [_shView.backBtn addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    }
//    
//    // 启动GPS
//    [TuSDKTKLocation shared].requireAuthor = YES;
//    
//    // 异步方式初始化滤镜管理器
//    // 需要等待滤镜管理器初始化完成，才能使用所有功能
//    [self showHubWithStatus:LSQString(@"lsq_initing", @"正在初始化")];
//    [TuSDK checkManagerWithDelegate:self];


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/**
 *  消除通知
 */
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"showSportLabel" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"relatedActivityID" object:nil];
    NSLog(@"%s",__func__);
}

#pragma mark - 点击事件
- (void)cameraBtnClick {
    NSLog(@"camera click");
    [self cameraComponentHandler];
}
- (void)albumBtnClick:(id)sender {
    [self editAdvancedComponentHandler];
}
- (void)backBtnClick:(id)sender {
//    [self dismissViewControllerAnimated:YES completion:nil];
//    [self.view removeFromSuperview];
    [self dismissViewControllerAnimated:self completion:nil];
}

#pragma mark - TuSDK
#pragma mark TuSDKFilterManagerDelegate
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

#pragma mark TuSDKCPComponentErrorDelegate
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

#pragma mark cameraComponentHandler
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

#pragma mark cameraComponentHandler TuSDKPFCameraDelegate
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

#pragma mark 头像设置组件
- (void) avatarComponentHandler:(UIImageView *)imageView
{
    //    lsqLDebug(@"avatarComponentHandler");
    NSLog(@"avatarComponentHandler头像设置组件");
    _avatarComponent =
    [TuSDK avatarCommponentWithController:self
                            callbackBlock:^(TuSDKResult *result, NSError *error, UIViewController *controller)
     {
         
//         [self clearComponents];
         
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
             
             
//             [self editAdvancedComponentHandler];
//             [_avatarComponent.options.editTurnAndCutOptions.viewController presentViewController:_photoEditComponent.options.editEntryOptions.viewController animated:YES completion:nil];

//             [self openEditAdvancedWithController:_avatarComponent.options.editTurnAndCutOptions.viewController result:result];
             
             [self openEditAdvancedWithController:self result:result];

//             TuSDKPFEditEntryController *editEntryController = [[TuSDKPFEditEntryController alloc]init];
//             editEntryController.inputImage = result.image;
//             [_avatarComponent.options.editTurnAndCutOptions.viewController presentViewController:editEntryController animated:YES completion:nil];
             
//             [self openEditAdvancedWithController:[UIApplication sharedApplication].keyWindow.rootViewController result:result];
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

#pragma mark 高级图片编辑组件
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
             
             _shView.firstImageVIew.image = [self addTagToImage:image];
             _shView.firstImageVIew.contentMode = UIViewContentModeScaleAspectFill;
             _shView.firstImageVIew.clipsToBounds=YES;
             
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
    _photoEditComponent.options.editEntryOptions.viewClazz=[HSEditEntryView class];
    
    
    TuSDKPFEditEntryController *editEntryController = [[TuSDKPFEditEntryController alloc]init];
    editEntryController.inputImage = result.image;
    [_avatarComponent.options.editTurnAndCutOptions.viewController presentViewController:editEntryController animated:YES completion:nil];

    
//    [_photoEditComponent showComponent];
    
//    _photoEditComponent.options.editEntryOptions.viewController.inputImage = _avatarComponent.options.editTurnAndCutOptions.viewController.inputImage;
//    UIImage *image = [UIImage imageNamed:@"评论头像.png"];
//    _photoEditComponent.options.editEntryOptions.viewController.inputImage = image;
//
//    [_avatarComponent.options.editTurnAndCutOptions.viewController presentViewController:_photoEditComponent.options.editEntryOptions.viewController animated:YES completion:nil];
//    _photoEditComponent.options.editEntryOptions.viewController.inputImage = _avatarComponent.options.editTurnAndCutOptions.viewController.inputImage;
//    _photoEditComponent.options.editEntryOptions.viewController.inputImage = [UIImage imageNamed:@"评论头像.png"];
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




#pragma mark 提交submit
- (void) submit:(id)sender{
//    add_new_photo.png
    if ([imageArray count]>0 && [imageUrlArray count]>0) {
        
        //菊花加载
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.labelText = @"正在分享";

        //初始化后台请求，七牛上传
        self.requestDataCtrl = [[HSRequestDataController alloc] init];
        QNUploadManager *upManager = [[QNUploadManager alloc] init];
        
        //分享按钮不能继续点击
//        [_shView setUserInteractionEnabled:NO];
        
        //所有图片上传
        arr_index = 0;
        for(int i=0;i<imageArray.count;i++){
//            NSData *fData = UIImageJPEGRepresentation([result loadResultImage], 0.3);//图片压缩todo
//            
//            //保存到图片数组
//            UIImage *image=[UIImage imageWithData:fData];
        //把图片转成NSData类型的数据来保存文件
        NSData *dataImag;
        //判断图片是不是png格式的文件
        if (UIImagePNGRepresentation([imageArray objectAtIndex:i])) {
            //返回为png图像。
            dataImag = UIImagePNGRepresentation([imageArray objectAtIndex:i]);
        }else {
            //返回为JPEG图像。
            dataImag = UIImageJPEGRepresentation([imageArray objectAtIndex:i], 0.6);
        }
        //        NSLog(@"dataImag:  %@",dataImag);
        NSLog(@"图片上传开始");
        //转化imageURL格式
        NSString *fileName=[NSString stringWithFormat:@"%@", [imageUrlArray objectAtIndex:i]]; //必须
        NSDictionary *dic = @{@"fileName": fileName, @"prefix": @"imageTestByHot"};
        NSString *data = [dic JSONString];
        NSDictionary *requestData = @{@"requestData"  : data};
        //        NSLog(@"data:%@",data);
        
//      后台交互
        [self.requestDataCtrl getQiniuUpTokenWithParam:requestData andRequestCB:^(BOOL code,id responseObject, NSString *error){
                if(code){
                    NSString *saveKey = [responseObject objectForKey:@"saveKey"];
                    NSString *upToken = [responseObject objectForKey:@"upToken"];
                    //开始上传
                    [upManager putData:dataImag key:saveKey token:upToken
                              complete: ^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
//                                  将key存入数组
                                  NSString *imgUrl = [[NSString alloc]initWithFormat:@"%s%@",QiNiuImageUrl,key];
                                  [imageUpLoadUrlArray addObject:imgUrl];
                                  NSLog(@"图片上传成功！");
                                  //如果所有图片上传成功，写入后台，否则不写入
                                  if(arr_index == imageArray.count-1){
                                      //写入后台
                                      NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                                      NSString *user_token = [[NSString alloc]initWithString:[userDefaults objectForKey:@"user_token"]];
//                                      NSLog(@"%@",[userDefaults objectForKey:@"user_token"]);
                                      NSString *share_category = @"0";
                                      NSMutableArray *shere_img_path = imageUpLoadUrlArray;
                                      
                                      NSString *share_description = _shView.shareTextView.text;
                                      
                                      NSMutableArray *share_img_path_with_pasters = [[NSMutableArray alloc]init ];
                                      for ( int i = 0 ; i<self.pastersArray.count; i++) {
                                          NSString *str = shere_img_path [i];
                                          NSString *objItd = self.pastersArray[i];
                                          if(![objItd isEqualToString:@""]){
                                              NSArray *arrToSend = [[NSArray alloc]initWithObjects:objItd, nil];
                                              NSDictionary *para = [[NSDictionary alloc]initWithObjectsAndKeys:arrToSend ,str, nil];
    //                                        [para setValue:objItd forKey:str];
                                              [share_img_path_with_pasters addObject:para];
                                          }
                                          
                                      }

                                      
                                      //构造请求数据  todo请求字段缺少
                                      NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:user_token,@"user_token",share_category,@"share_category",shere_img_path ,@"share_img_path",share_description,@"share_description",share_img_path_with_pasters,@"share_img_path_with_pasters",nil];
                                      NSLog(@"%@",dic);
                                      if(![location isEqualToString:@""]){
                                          HSDataFormatHandle *dataHandler = [[HSDataFormatHandle alloc]init];
                                          [dic setObject:longitude forKey:@"share_lon"];
                                          [dic setObject:latitude forKey:@"share_lat"];
                                          [dic setObject:[dataHandler areaIDFormatHandleWithProvince:province City:city District:nil] forKey:@"share_city"];
                                          [dic setObject:[dataHandler areaIDFormatHandleWithProvince:province City:city District:district] forKey:@"share_county"];
                                          [dic setObject:location forKey:@"share_location"];
                                      }
                                      //关联活动
                                      if(self.relateActivityID != nil){
                                          NSArray *activity_ids = @[self.relateActivityID];
                                          [dic setObject:activity_ids forKey:@"activity_ids"];
                                      }
                                      //at好友id
                                      if (self.selectedFriends != nil && self.selectedFriends.count != 0) {
                                          [dic setObject:self.selectedFriends forKey:@"user_ids"];
                                      }
                                      //关联运动
                                      if (self.selectedSportID != nil && self.selectedSportID.count != 0){
                                          [dic setObject:self.selectedSportID forKey:@"sport_ids"];
                                      }
                                      NSDictionary *requestData = [[NSDictionary alloc] initWithObjectsAndKeys:
                                                                   [dic JSONString] ,@"requestData", nil];
                                                                           NSLog(@"%@",requestData);
                                      //放进后台
                                      [self.requestDataCtrl createShareWithParam:requestData andRequestCB:^(BOOL code,id responseObject, NSString *error){
                                          if(code){
                                              NSLog(@"写入数据库成功");
                                              ShowHud(@"分享成功", NO);
                                              [self dismissViewControllerAnimated:YES completion:nil];
                                              NSLog(@"分享成功");
//                                              [_shView.shareBtn setUserInteractionEnabled:YES];
//                                              [self.view removeFromSuperview];
                                              [self dismissViewControllerAnimated:YES completion:nil];
                                          }
                                          else{
                                              NSLog(@"分享失败");
                                              ShowHud(@"分享失败", NO);
//                                              [_shView.shareBtn setUserInteractionEnabled:YES];
                                              NSLog(@"异常,写入数据库");

                                          }
                                          //菊花结束
                                          [hud hide:YES];
                                      }];
                                  }
                                  
                                  //异步执行完成后，再加1
                                  arr_index++;
                                  
                              } option:nil];
                }
                else{
                    NSLog(@"%@",error);
                    //菊花结束
                    [hud hide:YES];
                }
            }];
        }
        
        //        NSLog(@"图片上传结束");
    }
    else{
        ShowHud(@"请选择图片", NO);
        NSLog(@"图片不存在");
    }
    
}

#pragma mark 添加图片
- (void)addImage:(UITapGestureRecognizer *)tap{
//    NSLog(@"addimage");
//
    //方案1
    UIActionSheet *as=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册选择", nil];
    [as showInView:self.view];
    
    self.pasterId = @"";
    
    
    
    //方案2
////        [self editAdvancedComponentHandler];
//    UIImageView *imageView=(UIImageView *)tap.view;
//    [self avatarComponentHandler:imageView];
    
    
    
    //方案3
//    TuSDKPFPhotosViewController *photosViewController = [[TuSDKPFPhotosViewController alloc]init];
//    [self presentViewController:photosViewController animated:YES completion:nil];

//    TuSDKPFAlbumViewController *albumViewController = [[TuSDKPFAlbumViewController alloc]init];
//    [self presentViewController:albumViewController animated:YES completion:nil];
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
             //             NSData *fData = UIImageJPEGRepresentation([result loadResultImage], 0.3);//图片压缩todo
             
             //保存到图片数组
             //             UIImage *image=[UIImage imageWithData:fData];
             
             AppDelegate *delegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
             
             UIImage *image=delegate.imageWithLabels;
             
             
             [imageArray addObject:image];
             
             //  *****           pastersArray addObject:];
             //更新imageView布局，scrollView的contentSize
             [self updateImageViewsFrame];
             
             //保存到图片URL数组
             NSString *urlString = (NSString *)[result imageAsset].url;
             [imageUrlArray addObject:urlString];
             
             NSDictionary *dict = @{urlString:pasterId};
             //             long num = result.stickers.count;
             //             if (num == 1.0) {
             //                 [pastersArray addObject:dict];
             //             }
             [pastersArray addObject:pasterId];
             
             
             
             //             self.imageURL = imageUrlArray[0];
             //             _shView.fi
             //             NSLog(@"[self.imageURL];%@",self.imageURL);
         }else{
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
    //    _photoEditMultipleComponent.options.editMultipleOptions.saveToAlbum = YES;
    //    // 控制器关闭后是否自动删除临时文件
    //    _photoEditMultipleComponent.options.editMultipleOptions.isAutoRemoveTemp = YES;
    //
    //    // 图片编辑滤镜控制器配置选项
    // @see-http://tusdk.com/docs/ios/api/Classes/TuSDKPFEditFilterOptions.html
    // _photoEditMultipleComponent.options.editFilterOptions
    //    // 默认: true, 开启滤镜配置选项
    //    _photoEditMultipleComponent.options.editFilterOptions.enableFilterConfig = YES;
    //    // 保存到临时文件
    //    _photoEditMultipleComponent.options.editFilterOptions.saveToTemp = YES;
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
    //    _photoEditMultipleComponent.options.editSkinOptions.saveToTemp = YES;
    //    // 照片输出压缩率 0-100 如果设置为0 将保存为PNG格式
    //    _photoEditMultipleComponent.options.editSkinOptions.outputCompress = 0.95f;
    //
    //    // 图片编辑贴纸选择控制器配置选项
    //     _photoEditMultipleComponent.options.editStickerOptions
    TuSDKPFEditStickerView *view = (TuSDKPFEditStickerView *)_photoEditMultipleComponent.options.editStickerOptions.viewClazz;
    NSUInteger a = view.stickerView.stickerCount;
    NSLog(@"%lu",(unsigned long)a);
    _photoEditMultipleComponent.options.editStickerOptions.stickerViewDelegate = self;
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
    _photoEditMultipleComponent.options.editMultipleOptions.viewClazz=[HSEditMultipleView class];
    AppDelegate *d=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    d.resultImage=result.image;
    d.inputImage=_photoEditMultipleComponent.inputImage;
    d.result=result;
    
    //    NSLog(@"%@",result.image);
    //    NSLog(@"%@",result.imagePath);
    
    
//    _photoEditMultipleComponent.options.cutSize = CGSizeMake(640, 640);

    [_photoEditMultipleComponent showComponent];
}


#pragma mark - 标签系统
- (UIImage *)addTagToImage:(UIImage *)image {
    
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    UIImageView *imageView=[[UIImageView alloc]initWithImage:image];
    UITextField *tagTF=appDelegate.tagTextField;
    
    //屏幕截图
    UIGraphicsBeginImageContext(imageView.frame.size);
    //绘制图片
    [imageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    //平移
    CGContextRef r=UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(r, tagTF.frame.origin.x-imageView.frame.origin.x, tagTF.frame.origin.y-imageView.frame.origin.y);
    
    //绘制标签
    [tagTF.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    //获取截图
    UIImage *screenShotCut=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return screenShotCut;
}
#pragma mark - 底部的4个按钮
#pragma mark 弹出运动选择框
- (void)chooseSportLables
{
    HSLabelSelectView *sportSelectView = [[HSLabelSelectView alloc]initWithSelectedID:self.selectedSportID isSingleSelection:YES];
    
    [sportSelectView show];
}

#pragma mark 通知修改选中的运动标签
- (void)editSelectedSportID:(NSNotification *)noti
{
    self.selectedSportID = noti.userInfo[@"selectedIDs"];
    if (self.selectedSportID == nil || self.selectedSportID.count == 0) {
        _shView.sportBtn.selected = NO;
    }else{
        _shView.sportBtn.selected = YES;
    }
    
}
- (void)viewTapped:(UITapGestureRecognizer *)tap{
    if([_shView.shareTextView isFirstResponder]){
        [_shView.shareTextView resignFirstResponder];
    }
}

#pragma mark @好友
- (void)chooseFriends
{
    HSAtFriendViewController *atFriendVC = [[HSAtFriendViewController alloc]init];
    //传入的好友id的数组
    atFriendVC.selectedFriendsID = self.selectedFriends;
    [self presentViewController:atFriendVC animated:YES completion:nil];
}
#pragma mark 好友通知
- (void)editAtFriendsID:(NSNotification *)noti
{
    self.selectedFriends = noti.userInfo[@"atFriendIDs"];
    NSLog(@"%@",self.selectedFriends);
    //判断是否为空，不为空设置按钮选中状态
    if(self.selectedFriends == nil || self.selectedFriends.count == 0)
    {
        _shView.atBtn.selected = NO;
    }
    else
    {
        _shView.atBtn.selected = YES;
    }
}
#pragma mark 活动关联按钮
- (void)relatedActivity
{
    HSRelatedActivityVC *relatedActivityVC = [[HSRelatedActivityVC alloc]init];
    //初始值赋值
    relatedActivityVC.activityID = self.relateActivityID;
    [self presentViewController:relatedActivityVC animated:YES completion:nil];
}

#pragma mark 通知修改活动图标
- (void)editRelateActivityID:(NSNotification *)noti
{
    self.relateActivityID = noti.userInfo[@"activityID"];
    if (self.relateActivityID == nil) {
        _shView.activityBtn.selected = NO;
    }else{
        _shView.activityBtn.selected = YES;
    }
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



#pragma mark - 九宫格
- (void)initTapArray {
    tap0 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageViewTap:)];
    tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageViewTap:)];
    tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageViewTap:)];
    tap3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageViewTap:)];
    tap4 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageViewTap:)];
    tap5 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageViewTap:)];
    tap6 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageViewTap:)];
    tap7 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageViewTap:)];
    tap8 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageViewTap:)];
    
    tapArray =[[NSMutableArray alloc]initWithObjects:tap0, tap1, tap2, tap3, tap4, tap5, tap6, tap7, tap8, nil];
    
    //添加手势
    UITapGestureRecognizer *t;
    UIImageView *iv;
    for (int i=0; i<9; i++) {
        t=tapArray[i];
        iv=self.shView.imageViewArray[i];
        [iv addGestureRecognizer:t];
    }
}

//点击图片放大
- (void)imageViewTap:(UITapGestureRecognizer *)tap {
//    static BOOL isScale = NO;
    static UIImageView *bigIV;
    static UIButton *deleteBtn;
    
    if (!bigIV) {
        bigIV = [[UIImageView alloc]initWithFrame:self.view.bounds];
//        bigIV.tag=0;
        bigIV.contentMode=UIViewContentModeScaleAspectFit;
        bigIV.backgroundColor=[UIColor blackColor];
        bigIV.userInteractionEnabled = YES;
        UITapGestureRecognizer *t=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageViewTap:)];
        [bigIV addGestureRecognizer:t];
        [self.view addSubview:bigIV];
        bigIV.hidden=YES;
        
        CGRect btnFrame=CGRectZero;
//        btnFrame.origin.x=[UIScreen mainScreen].bounds.size.width*0.85;
//        btnFrame.origin.y=[UIScreen mainScreen].bounds.size.height*0.06;
        btnFrame.origin.x=bigIV.bounds.size.width*0.85;
        btnFrame.origin.y=bigIV.bounds.size.height*0.06;
        btnFrame.size.height = 30;
        btnFrame.size.width =50;
        deleteBtn = [[UIButton alloc]initWithFrame:btnFrame];
        deleteBtn.backgroundColor = [UIColor blackColor];
        deleteBtn.alpha=0.8;
        [deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
        [deleteBtn addTarget:self action:@selector(removeImage:) forControlEvents:UIControlEventTouchUpInside];
        
        [bigIV addSubview:deleteBtn];
//        [[UIApplication sharedApplication].keyWindow addSubview:deleteBtn];
    }
//    if (isScale == NO) {
    if (bigIV.hidden) {

//        isScale = YES;
//        bigIV.tag = 1;
        UIImageView *iv=(UIImageView *)tap.view;
        bigIV.image=iv.image;
//        bigIV.contentMode=UIViewContentModeScaleAspectFit;
//        bigIV.backgroundColor=[UIColor blackColor];
//        bigIV.userInteractionEnabled = YES;
//        UITapGestureRecognizer *t=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageViewTap:)];
//        [bigIV addGestureRecognizer:t];
//        [self.view addSubview:bigIV];
        
//        CGRect btnFrame=CGRectZero;
//        btnFrame.origin.x=[UIScreen mainScreen].bounds.size.width*0.7;
//        btnFrame.origin.y=[UIScreen mainScreen].bounds.size.height*0.15;
////        btnFrame.origin.x=bigIV.bounds.size.width*0.7;
////        btnFrame.origin.y=bigIV.bounds.size.height*0.2;
//        btnFrame.size.height = 30;
//        btnFrame.size.width =50;
//        deleteBtn = [[UIButton alloc]initWithFrame:btnFrame];
//        deleteBtn.backgroundColor = [UIColor blackColor];
//        [deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
//        [deleteBtn addTarget:self action:@selector(removeImage:) forControlEvents:UIControlEventTouchUpInside];
////        [bigIV addSubview:deleteBtn];
//        [[UIApplication sharedApplication].keyWindow addSubview:deleteBtn];
        
        int imageIndex = (int)[self.shView.imageViewArray indexOfObject:iv];
        deleteBtn.tag = imageIndex;
//        bigIV.tag=1;
        bigIV.hidden=NO;
        deleteBtn.hidden=NO;
    } else {
//        isScale = NO;
//        [bigIV removeFromSuperview];
//        bigIV=nil;
        bigIV.hidden=YES;
        deleteBtn.hidden=YES;
    }
}
//删除图片
- (void)removeImage:(UIButton *)btn {
    int imageIndex = (int)btn.tag;
    [self.imageArray removeObjectAtIndex:imageIndex];
    [self.pastersArray removeObjectAtIndex:imageIndex];
    [self updateImageViewsFrame];
//    [btn.superview removeFromSuperview];
    btn.superview.hidden=YES;
//    [btn removeFromSuperview];
    btn.hidden=YES;
}

//更新imageView布局和scrollView的contentSize
- (void)updateImageViewsFrame {
    UIImageView *iv;
    //显示非空的
    for (int i=0; i<imageArray.count; i++) {
        iv=self.shView.imageViewArray[i];
        iv.image=imageArray[i];
        iv.hidden=NO;
    }
    //隐藏空的
    for (int j=(int)imageArray.count; j<9; j++) {
        iv=self.shView.imageViewArray[j];
        iv.hidden=YES;
    }
    //点击会添加图片的imageView
    if (imageArray.count == 9) {
        self.shView.firstImageVIew.hidden=YES;
    } else {
        iv=self.shView.imageViewArray[imageArray.count];
        self.shView.firstImageVIew.frame=iv.frame;
    }
    //更新scrollView的contentSize，滚动范围
    CGSize contentSize =self.shView.scrollView.contentSize;
    contentSize.height = self.shView.firstImageVIew.frame.origin.y +self.shView.firstImageVIew.frame.size.height *1.3;
    self.shView.scrollView.contentSize = contentSize;

}

//定位

- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    _locService.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    _locService.delegate = nil;
    _geoCodeSearch.delegate = nil;
}

#pragma mark - 获取地理位置
- (void)getLocation:(id)sender {
    
//    更改下图标
    [_shView.mapBtn setImage:[UIImage imageNamed:@"ic_location_selected"] forState:UIControlStateNormal];
    
    _locService = [[BMKLocationService alloc] init];
    _locService.delegate = self;
    
    _geoCodeSearch = [[BMKGeoCodeSearch alloc] init];
    _geoCodeSearch.delegate = self;
    _reverseGeoSearchOption = [[BMKReverseGeoCodeOption alloc] init];
    
    
    //设置定位精确度
    [BMKLocationService setLocationDesiredAccuracy:kCLLocationAccuracyBest];
    //指定最小距离更新(米)
    [BMKLocationService setLocationDistanceFilter:kCLDistanceFilterNone];
    //启动LocationService
    [_locService startUserLocationService];
    
    //单独拿出来一个模块，但是有问题，先这样
//    HSMapLocationHandler *mapLocation = [[HSMapLocationHandler alloc]init];
//    [mapLocation getLocation];
    
}


/**
 *用户方向更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
//- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation {
//    
//}

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation {
    _reverseGeoSearchOption.reverseGeoPoint = userLocation.location.coordinate;
    BOOL flag = [_geoCodeSearch reverseGeoCode:_reverseGeoSearchOption];
    if (NO == flag) {
        NSLog(@"reverseGeoCodeSearch failed");
    }
    [_locService stopUserLocationService];
}

- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error {
    //省
    province = [NSString stringWithString:result.addressDetail.province];
    //市
    city = [NSString stringWithString:result.addressDetail.city];
    //区
    district = [NSString stringWithString:result.addressDetail.district];
    //经度
    longitude = [NSString stringWithFormat:@"%f",result.location.longitude];
    //纬度
    latitude = [NSString stringWithFormat:@"%f",result.location.latitude];
    //位置
    location = result.address;
}

/**
 *定位失败后，会调用此函数
 *@param error 错误号
 */
- (void)didFailToLocateUserWithError:(NSError *)error {
    NSLog(@"baidu map location failed error:%@",error);
}


- (BOOL)stickerView:(TuSDKPFStickerView *)view canAppend:(TuSDKPFSticker *)sticker{
//    view.backgroundColor = [UIColor redColor];
    uint64_t idt = sticker.idt;
    pasterId = [NSString stringWithFormat:@"%llu",idt];
// view.superview.
    NSLog(@"aa");
    return true;
    
}


@end
