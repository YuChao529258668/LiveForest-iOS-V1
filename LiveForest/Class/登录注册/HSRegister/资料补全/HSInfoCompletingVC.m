//
//  HSInfoCompletingVC.m
//  LiveForest
//
//  Created by 傲男 on 15/6/15.
//  Copyright (c) 2015年 HOTeam. All rights reserved.
//

#import "HSInfoCompletingVC.h"

@interface HSInfoCompletingVC ()

@end

@implementation HSInfoCompletingVC

- (instancetype)init{
    self = [super init];
    
    // 启动GPS
    [TuSDKTKLocation shared].requireAuthor = YES;
    
    // 异步方式初始化滤镜管理器
    // 需要等待滤镜管理器初始化完成，才能使用所有功能
    //    [self showHubWithStatus:LSQString(@"lsq_initing", @"正在初始化")];
    [TuSDK checkManagerWithDelegate:self];
    
    self.infoCompletingView = [[HSInfoCompletingView alloc]init];
    if(self.infoCompletingView){
        //头像点击
        UITapGestureRecognizer *tapImage = [[UITapGestureRecognizer alloc]init];
        [tapImage addTarget:self action:@selector(addImage:)];
        [self.infoCompletingView.avarlImage addGestureRecognizer:tapImage];
        
        //取消
        [self.infoCompletingView.cancel addTarget:self action:@selector(cancelPress:) forControlEvents:UIControlEventTouchUpInside];
        //提交
        [self.infoCompletingView.submit addTarget:self action:@selector(submitPress:) forControlEvents:UIControlEventTouchUpInside];
        
        
        self.view = self.infoCompletingView;
        
        self.requestDataCtrl = [[HSRequestDataController alloc] init];
        
        //初始化个人信息
        [self initView];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
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
#pragma mark addImage
- (void)addImage:(UITapGestureRecognizer *)tap{
    
    UIActionSheet *as=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册选择", nil];
    [as showInView:self.view];
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
    opt.regionViewColor = [UIColor colorWithRed:51 / 255.0 green:51 / 255.0 blue:51 / 255.0 alpha:1.0];;
    
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
             [self.infoCompletingView.avarlImage setImage:[UIImage imageWithData:fData]];
             self.imageURL = (NSString *)[result imageAsset].url;

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
        ShowHud(@"正在上传头像", NO);
        
        //初始化后台请求，七牛上传
        self.requestDataCtrl = [[HSRequestDataController alloc] init];
        QNUploadManager *upManager = [[QNUploadManager alloc] init];
        
        //分享按钮不能继续点击
        [self.infoCompletingView.avarlImage setUserInteractionEnabled:NO];
        
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
        self.requestData = @{@"requestData"  : data};
        //      后台交互
        [self.requestDataCtrl getQiniuUpTokenWithParam:self.requestData andRequestCB:^(BOOL code,id responseObject, NSString *error){
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
                                      NSLog(@"上传成功");
                                      ShowHud(@"上传成功", NO);
                                      //更新用户个人头像信息
                                      [userDefaults setObject:dataImag forKey:@"user_logo_img"]; //直接存取到本地
                                      //用户头像url持久化
                                      [userDefaults setObject:imgUrl  forKey:@"user_logo_url"];
//                                      imgUrl
                                      [self.userInfoControl updateUserAvarlAndSaveHandler:imgUrl];
                                  }
                                  else{
                                      NSLog(@"上传失败");
                                      ShowHud(@"上传失败，请重试", NO);
                                      NSLog(@"异常,写入数据库");
                                      
                                  }
                                  [self.infoCompletingView.avarlImage setUserInteractionEnabled:YES];
                              }];
                          } option:nil];
                //
                //             }
                //             failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                //                 NSLog(@"%@", error);
                ////                 NSLog(@"分享失败");
                //                 ShowHud(@"分享失败，请重试", NO);
                //                 [_shView.shareBtn setUserInteractionEnabled:YES];
                //             }];
                
                
            }
            else{
                NSLog(@"%@",error);
            }
            
        }];
    }
    else{
        ShowHud(@"请选择图片", NO);
        NSLog(@"图片不存在");
    }
    
}

#pragma mark cancelPress
- (void) cancelPress:(UIButton *)btn{
    
    [self dismissViewControllerAnimated:YES completion:nil];
     [[UIApplication sharedApplication] keyWindow].rootViewController = [SingletonForRootViewCtrl sharedInstance];
    
}

#pragma  mark submit
- (void) submitPress:(UIButton *)btn{
//    self.infoCompletingView.submit.userInteractionEnabled = NO;
    self.view.userInteractionEnabled = NO;
    if(!self.infoCompletingView.nickname.text){
        ShowHud(@"请输入用户名", NO);
        self.view.userInteractionEnabled = YES;

        return;
    }
    if(!self.infoCompletingView.birthday.text || self.infoCompletingView.birthday.text.length == 0)
    {
        ShowHud(@"请选择出生日期", NO);
        self.view.userInteractionEnabled = YES;

        return;
    }
    if([self.infoCompletingView.city.text isEqual:@""]){
        ShowHud(@"请选择城市", NO);
        self.view.userInteractionEnabled = YES;

        return;
    }
    if(self.infoCompletingView.selectedSportID == nil || self.infoCompletingView.selectedSportID.count == 0){
        ShowHud(@"请选择运动标签", NO);
        self.view.userInteractionEnabled = YES;
        
        return;
    }
    UIImage *image = self.infoCompletingView.avarlImage.image;
    NSString *url = self.imageURL;
//    self.globalImageURL
    
    //菊花加载
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"正在提交个人信息";

    if(image && url){
        //初始化后台请求，七牛上传
        QNUploadManager *upManager = [[QNUploadManager alloc] init];
        
        //分享按钮不能继续点击
        [self.view setUserInteractionEnabled:NO];
        
        //把图片转成NSData类型的数据来保存文件
        NSData *dataImag;
        //判断图片是不是png格式的文件
        if (UIImagePNGRepresentation(image)) {
            //返回为png图像。
            dataImag = UIImagePNGRepresentation(image);
        }else {
            //返回为JPEG图像。
            dataImag = UIImageJPEGRepresentation(image, 0.3);
        }
        //        NSLog(@"dataImag:  %@",dataImag);
        NSLog(@"图片上传开始");
        //转化imageURL格式
        NSString *fileName=[NSString stringWithFormat:@"%@", url]; //必须
        NSDictionary *dic = @{@"fileName": fileName, @"prefix": @"imageTestByHot"};
        NSString *data = [dic JSONString];
        NSDictionary *requestKey = @{@"requestData"  : data};
        //      后台交互
        [self.requestDataCtrl getQiniuUpTokenWithParam:requestKey andRequestCB:^(BOOL code,id responseObject, NSString *error){
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
                              NSString *imgUrl =[[NSString alloc]initWithFormat:@"%s%@",QiNiuImageUrl,key];
                              NSString *user_nickname = self.infoCompletingView.nickname.text;
                              //生日
                              NSString *user_birthday = self.infoCompletingView.birthday.text;
                              NSString *user_sex;
                              if(self.infoCompletingView.male.selected){
                                  user_sex = @"0";
                              }
                              else{
                                   user_sex = @"1";
                              }
                              NSString *user_city = self.infoCompletingView.cityID;
                              NSArray *user_sport_id = self.infoCompletingView.selectedSportID;
                              NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                                   user_token,
                                                   @"user_token",
                                                   user_nickname,
                                                   @"user_nickname",
                                                   user_birthday,
                                                   @"user_birthday",
                                                   user_sex,
                                                   @"user_sex",
                                                   user_city,
                                                   @"user_city",
                                                   user_sport_id,
                                                   @"user_sport_id",
                                                   imgUrl,
                                                   @"user_logo_img_path",
                                                   nil];
                              self.requestData= [[NSDictionary alloc] initWithObjectsAndKeys:
                                                           [dic JSONString],@"requestData", nil];
                              //                                  将key存入数组
                              
                              NSLog(@"图片上传成功！");
                              //如果所有图片上传成功，写入后天，否则不写入
                              [self.requestDataCtrl updateUserInfo:self.requestData andRequestCB:^(BOOL code,id responseObject, NSString *error){
                                  if(code){
                                      NSLog(@"提交成功");
                                      
                                      [hud hide:YES];

                                      ShowHud(@"提交成功", NO);
                                      //更新用户个人模糊头像信息
                                      [self.userInfoControl updateUserAvarlAndSaveHandler:imgUrl];
                                      //更新用户个人头像信息
                                      [userDefaults setObject:dataImag forKey:@"user_logo_img"]; //直接存取到本地
                                      //用户头像url持久化
                                      [userDefaults setObject:imgUrl  forKey:@"user_logo_url"];
                                      //                                      imgUrl
                                      //                                      [self.userInfoControl updateUserInfoAndSaveHandler:[self.requestData objectForKey:@"requestData"]];
                                      [self.userInfoControl updateUserInfoAndSaveHandler:self.requestData];

                                      [self dismissViewControllerAnimated:YES completion:nil];
                                      [[UIApplication sharedApplication] keyWindow].rootViewController = [SingletonForRootViewCtrl sharedInstance];
                                  }
                                  else{
                                      NSLog(@"提交失败");
                                      ShowHud(@"提交失败，请重试", NO);
                                      NSLog(@"异常,写入数据库");
                                      self.view.userInteractionEnabled = YES;
                                      [hud hide:YES];
                                  }
//                                  [self.infoCompletingView.avarlImage setUserInteractionEnabled:YES];
                                  

                              }];
                          } option:nil];
                //
                //             }
                //             failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                //                 NSLog(@"%@", error);
                ////                 NSLog(@"分享失败");
                //                 ShowHud(@"分享失败，请重试", NO);
                //                 [_shView.shareBtn setUserInteractionEnabled:YES];
                //             }];
                
                
            }
            else{
                NSLog(@"%@",error);
                ShowHud(@"网络请求失败，请重试", NO);
                self.view.userInteractionEnabled = YES;

            }
            
        }];

    }
    else if(image && self.globalImageURL){
        //不需要上传七牛，直接提交
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        //todo
        if(![userDefaults objectForKey:@"user_token"]){
            NSLog(@"user_token为空，");
            return;
        }
        NSString *user_token = [[NSString alloc]initWithString:[userDefaults objectForKey:@"user_token"]];
        NSString *user_nickname = self.infoCompletingView.nickname.text;
        //生日
        NSString *user_birthday = self.infoCompletingView.birthday.text;
        NSString *user_sex;
        if(self.infoCompletingView.male.selected){
            user_sex = @"0";
        }
        else{
            user_sex = @"1";
        }
        NSString *user_city = self.infoCompletingView.cityID;
        NSArray *user_sport_id = self.infoCompletingView.selectedSportID;
        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:
                             user_token,
                             @"user_token",
                             user_nickname,
                             @"user_nickname",
                             user_birthday,
                             @"user_birthday",
                             user_sex,
                             @"user_sex",
                             user_city,
                             @"user_city",
                             user_sport_id,
                             @"user_sport_id",
                             self.globalImageURL,
                             @"user_logo_img_path",
                             nil];
        self.requestData = [[NSDictionary alloc] initWithObjectsAndKeys:
                                     [dic JSONString],@"requestData", nil];
        //                                  将key存入数组
        
        NSLog(@"图片上传成功！");
        //如果所有图片上传成功，写入后天，否则不写入
        [self.requestDataCtrl updateUserInfo:self.requestData andRequestCB:^(BOOL code,id responseObject, NSString *error){
            if(code){
                NSLog(@"提交成功");
                ShowHud(@"提交成功", NO);
                
                [hud hide:YES];

                [self dismissViewControllerAnimated:YES completion:nil];
                [[UIApplication sharedApplication] keyWindow].rootViewController = [SingletonForRootViewCtrl sharedInstance];
                
                //更新用户个人头像信息
                // todo:用户个人头像不用更新修改
                [self.userInfoControl updateUserInfoAndSaveHandler:self.requestData];
                
            }
            else{
                NSLog(@"提交失败");
                ShowHud(@"提交失败，请重试", NO);
                NSLog(@"异常,写入数据库");
                [self.view setUserInteractionEnabled:YES];
                [hud hide:YES];

            }
//            self.infoCompletingView.submit.userInteractionEnabled = YES;
            
        }];
    }
}

#pragma  mark 初始化个人信息
- (void) initView{
    
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"enterInfoCompletingVCByPhone"] isEqualToString:@"1"]){
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"enterInfoCompletingVCByPhone"];
    }
    else{
        //是通过微信或者微博进入应用的，那么需要请求个人信息
        //    UIWindow *window = [UIApplication sharedApplication].keyWindow;
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.labelText = @"正在加载个人信息";
        
        //头像填充
        //6.20 by qiang
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        
        if([userDefaults objectForKey:@"user_logo_url"]){
            self.globalImageURL = [userDefaults objectForKey:@"user_logo_url"];
        }
        //判断是否已经有个人信息
        if([userDefaults objectForKey:@"user_logo_img"]){
            self.infoCompletingView.avarlImage.image = [UIImage imageWithData:[userDefaults objectForKey:@"user_logo_img"]];
        }
        else{
            self.infoCompletingView.avarlImage.image=[UIImage imageNamed:@"Home.jpg"];
        }
        //用户nickname
        if(![[userDefaults objectForKey:@"user_nickname"]  isEqual: @""]){
            [self.infoCompletingView.nickname setText:[userDefaults objectForKey:@"user_nickname"]];
        }
        //用户性别
        if([userDefaults objectForKey:@"user_sex"] != nil && ![[userDefaults objectForKey:@"user_sex"] isEqual:@""]){
            switch ([[userDefaults objectForKey:@"user_sex"] intValue]) {
                case 0:
                    //男
                    self.infoCompletingView.male.selected = YES;
                    break;
                case 1:
                    //女
                    self.infoCompletingView.female.selected = YES;
                    break;
                default:
                    self.infoCompletingView.female.selected = YES;
                    break;
            }
        }
        //用户城市也没有
//        NSString *userCity = [userDefaults objectForKey:@"user_city"];
//        if(userCity == nil || userCity.length == 0 || [userCity isEqualToString:@"-10086"])
//        {
//            [self.infoCompletingView.city setText:@""];
//        }
//        else
//        {
//            //将cityID转化成地名描述
//            HSDataFormatHandle *handle = [[HSDataFormatHandle alloc]init];
//            userCity = [handle areaFormatHandleWithStringID:userCity];
//            [self.infoCompletingView.city setText:userCity];
//        }
        //用户生日也没有
//        NSString *userBirthday = [userDefaults objectForKey:@"user_birthday"];
//        if(userBirthday == nil || userBirthday.length == 0 || [userBirthday isEqualToString:@"-10086"])
//        {
//            [self.infoCompletingView.birthday setText:@""];
//        }
//        else
//        {
//            [self.infoCompletingView.birthday setText:userBirthday];
//        }
      //用户个人标签 肯定没有
//        id sportIDs = [userDefaults objectForKey:@"user_sport_id"];
//        if ([sportIDs isKindOfClass:[NSArray class]] && [sportIDs count] > 0) {
//            self.infoCompletingView.selectedSportID = sportIDs;
//            //添加
//            [self.infoCompletingView addSportLabelView:sportIDs];
//        }
        [hud hide:YES];
        
    }

    
}

@end
