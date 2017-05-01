//
//  HSCreatActivityViewController.m
//  LiveForest
//
//  Created by Swift on 15/4/17.
//  Copyright (c) 2015年 HOTeam. All rights reserved.
//
#import "HSCreatActivityViewController.h"
#import "HSEditEntryView.h"
#import "HSConstantURL.h"

#import "HSCreateView.h"
#import "mapViewController.h"

@interface HSCreatActivityViewController ()
@property (strong, nonatomic) UIDatePicker *datePicker;
@end

@implementation HSCreatActivityViewController
@synthesize datePicker;

//@synthesize imageView=_shView.firstImageVIew;
//@synthesize manager;
//
//
//@synthesize shView = _shView;
//
- (instancetype)init{
    self = [super init];
    
    // 启动GPS
    [TuSDKTKLocation shared].requireAuthor = YES;
    
    // 异步方式初始化滤镜管理器
    // 需要等待滤镜管理器初始化完成，才能使用所有功能
//    [self showHubWithStatus:LSQString(@"lsq_initing", @"正在初始化")];
    [TuSDK checkManagerWithDelegate:self];

    
    _createView = [[HSCreateView alloc]init];
    if(_createView){
        self.view = _createView;
        //初始化view的按钮
        [_createView.cameraBtn addTarget:self action:@selector(cameraBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_createView.albumBtn addTarget:self action:@selector(albumBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_createView.shareBtn addTarget:self action:@selector(submit:) forControlEvents:UIControlEventTouchUpInside];
        [_createView.backBtn addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        UITapGestureRecognizer *tapImage = [[UITapGestureRecognizer alloc]init];
        [tapImage addTarget:self action:@selector(addImage:)];
        [_createView.firstImageVIew addGestureRecognizer:tapImage];
        
        //时间按钮
        [_createView.timeBtn addTarget:self action:@selector(timeBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
        
        //地图按钮
        [_createView.mapBtn addTarget:self action:@selector(mapBtnClick) forControlEvents:UIControlEventTouchUpInside];

    }
    self.requestCtrl = [[HSRequestDataController alloc]init];

    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
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
- (void)cameraBtnClick {
    NSLog(@"camera click");
    [self cameraComponentHandler];
}
- (void)albumBtnClick:(id)sender {
    [self editAdvancedComponentHandler];
}
- (void)backBtnClick:(id)sender {
//    [self dismissViewControllerAnimated:YES completion:nil];
    [self.view removeFromSuperview];
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
    // opt.filterBarGroupCellClazz = [TuSDKCPGroupFilterGroupCell class];
    
    // 滤镜列表行视图类 (默认:TuSDKCPGroupFilterItem, 需要继承 TuSDKCPGroupFilterItem)
    // opt.filterBarTableCellClazz = [TuSDKCPGroupFilterItem class];
    
    // 需要显示的滤镜名称列表 (如果为空将显示所有自定义滤镜)
    // opt.filterGroup = @[@"SkinNature", @"SkinPink", @"SkinJelly", @"SkinNoir", @"SkinRuddy", @"SkinPowder", @"SkinSugar"];
    
    // 是否保存最后一次使用的滤镜
    opt.saveLastFilter = YES;
    
    // 自动选择分组滤镜指定的默认滤镜
    opt.autoSelectGroupDefaultFilter = YES;
    
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
    [self openEditAdvancedWithController:controller result:result];
    
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
             _createView.firstImageVIew.image = [UIImage imageWithData:fData];
             _createView.firstImageVIew.contentMode = UIViewContentModeScaleAspectFit;
             
//             _shView.firstImageVIew.image =[result loadResultImage];
//             NSLog(@"[self.imageURL];%@",self.imageURL);
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


#pragma mark 提交submit
- (void) submit:(id)sender{
    
    //为空判断
    if (_createView.firstImageVIew.image && self.imageURL &&![_createView.activityTitle.text isEqualToString:@""] &&![_createView.activityDescription.text isEqualToString:@""] && ![_createView.activityKind.text isEqualToString:@""]&& ![_createView.timeLabel.text isEqualToString:@"添加活动时间"]) {
        
        _createView.shareBtn.userInteractionEnabled = NO;
        
        ShowHud(@"正在创建", NO);
        
        
        //把图片转成NSData类型的数据来保存文件
        NSData *dataImag;
        //判断图片是不是png格式的文件
        if (UIImagePNGRepresentation(_createView.firstImageVIew.image)) {
            //返回为png图像。
            dataImag = UIImagePNGRepresentation(_createView.firstImageVIew.image);
        }else {
            //返回为JPEG图像。
            dataImag = UIImageJPEGRepresentation(_createView.firstImageVIew.image, 1.0);
        }
        //        NSLog(@"dataImag:  %@",dataImag);
        NSLog(@"图片上传开始");
        //转化imageURL格式
        NSString *fileName=[NSString stringWithFormat:@"%@", self.imageURL]; //必须
        NSDictionary *dic = @{@"fileName": fileName, @"prefix": @"imageTestByHot"};
        NSString *data = [dic JSONString];
        //        NSLog(@"data:%@",data);
        
        [self.requestCtrl getQiniuUpTokenWithParam:@{@"requestData"  : data} andRequestCB:^(BOOL code,id responseObject, NSString *error){
            if(code){
                
                NSLog(@"获得token成功");
                NSLog(@"%@", responseObject);
                //                 JSONDecoder *decoder=[[JSONDecoder alloc]init];//初始化json解码
                //                 NSData *data = [responseObject JSONData];//获取json数据
                //                 NSDictionary *responseObj = [decoder objectWithData: data];//将json数据给dictionary,获取键值对
                //                 NSLog(@"%@",responseObj);
                NSString *saveKey = [responseObject objectForKey:@"saveKey"];
                NSString *upToken = [responseObject objectForKey:@"upToken"];
                
                NSLog(@"token为：%@",upToken);
                QNUploadManager *upManager = [[QNUploadManager alloc] init];
                //nsdata转位nsstring
                //        NSString *result = [[NSString alloc] initWithData:data  encoding:NSUTF8StringEncoding];
                //        NSData *upData = [result dataUsingEncoding : NSUTF8StringEncoding];
                [upManager putData:dataImag key:saveKey token:upToken
                          complete: ^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                              NSLog(@"图片上传成功！");
                              //                               NSLog(@"%@", info);
                              //                               NSLog(@"%@",key);
                              //                               NSLog(@"路径：%@", resp);
                              
                              //                               createView.activityTitle.text &&_createView.activityDescription.text &&_createView.activityKind.text && _createView.timeLabel.text
                              //                           activity_name:String	M	活动名字
                              //                           activity_summary:String	M	活动简介
                              //                           activity_img_path:Array	M	活动图片	["pic1"]
                              //                               类似于[]、[""]、[" "]均不符合规范
                              //                           activity_location:String	M	活动地址
                              //                           activity_city:String	M	活动所在城市
                              //                           activity_county:String	M	活动所在区域
                              //                           activity_lon:String	M	活动经度
                              //                           activity_lat:String	M	活动纬度
                              //                           activity_time:String	M	活动时间	必须是：yyyy-MM-dd HH:mm:ss
                              //                               如：2011-11-11 13:30:00
                              //                           sport_id:String
                              
                              //4.21写到后台数据库
                              NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                              NSString *user_token = [[NSString alloc]initWithString:[userDefaults objectForKey:@"user_token"]];
                              NSLog(@"%@",[userDefaults objectForKey:@"user_token"]);
                              NSString *sport_id = _createView.activityKind.text;
                              NSString *activity_name = _createView.activityTitle.text;
                              NSString *activity_summary = _createView.activityDescription.text;
                              NSString *activity_location = _createView.addressLabel.text;
                              //todo 城市id，是数字
                              NSString *activity_city = @"1";
                              NSString *activity_county = @"1";
                              NSString *activity_time = _createView.timeLabel.text;
                              NSString *activity_lon = @"1";
                              NSString *activity_lat = @"1";
                              //                               NSString *share_description = _createView.activityDescription.text;
                              
                              NSMutableArray *shere_img_path = [[NSMutableArray alloc]init];
                              //拼接url todo
                              NSString *imgUrl = [[NSString alloc]initWithFormat:@"%s%@",QiNiuImageUrl,[resp objectForKey:@"key"]];
                              [shere_img_path addObject:imgUrl];
                              
                              
                              //                               NSLog(@"[shere_img_path JSONString]:%@",[[shere_img_path JSONString] class]);
                              //构造请求数据
                              NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:user_token,@"user_token",sport_id,@"sport_id",shere_img_path ,@"activity_img_path",activity_name,@"activity_name",activity_summary,@"activity_summary",activity_location,@"activity_location",activity_city,@"activity_city",activity_county,@"activity_county",activity_time,@"activity_time",activity_lon,@"activity_lon",activity_lat,@"activity_lat",nil];
                              NSLog(@"dic:   %@",dic);
                              NSDictionary *requestData = [[NSDictionary alloc] initWithObjectsAndKeys:
                                                           [dic JSONString] ,@"requestData", nil];
                              NSLog(@"%@",requestData);
                              //存放后台
                              [self.requestCtrl doActivityCreateByUser:requestData
                                                           andRequestCB:^(BOOL code, id responseObject, NSString *error){
                                                               if(code){
                                                                   NSLog(@"写入数据库成功");
                                                                   //                                                  [self dismissViewControllerAnimated:YES completion:nil];
                                                                   [self.view removeFromSuperview];
                                                                   NSLog(@"创建成功");
                                                                   ShowHud(@"创建成功", NO);                                                               }
                                                               else{
//                                                                   int subcode =[[responseObject objectForKey:@"subCode"] intValue];
//                                                                   switch (subcode) {
//                                                                       case 0:
//                                                                           ShowHud(@"参数缺失", NO);
//                                                                           break;
//                                                                       case 1:
//                                                                           ShowHud(@"token失效", NO);
//                                                                           break;
//                                                                       case 2:
//                                                                           ShowHud(@"请求参数格式不符", NO);
//                                                                           break;
//                                                                       case 3:
//                                                                           ShowHud(@"时间格式不符", NO);
//                                                                           break;
//                                                                       case 4:
//                                                                           ShowHud(@"创建活动失败", NO);
//                                                                           break;
//                                                                       default:
//                                                                           break;

                                                                   NSLog(@"创建活动失败");
                                                                   ShowHud(@"创建活动失败，请重试", NO);
                                                               }
                                                           }];

                           
                              
                              _createView.shareBtn.userInteractionEnabled = YES;
                              //数据库存放结束
                              
                          } option:nil];
                
                
            }
            else{
                NSLog(@"%@", error);
                //                 NSLog(@"分享失败");
                ShowHud(@"上传失败，请重试", NO);
            }
        }];

        
        //        NSLog(@"图片上传结束");
    }
    else{
        ShowHud(@"请输入完整信息", NO);
        NSLog(@"图片不存在");
    }
    
}



- (void)viewTapped:(UITapGestureRecognizer *)tap{
    if([_createView.activityTitle isFirstResponder]){
        [_createView.activityTitle resignFirstResponder];
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
#pragma mark AFNetworking初始化
-(void)httpInit{
    self.manager = [AFHTTPRequestOperationManager manager];
    self.manager.responseSerializer = [AFJSONResponseSerializer serializer];
    self.manager.responseSerializer.acceptableContentTypes =[[NSSet alloc] initWithObjects:@"text/html",@"text/plain",@"text/json",@"application/json", nil];
//    self.manager.responseSerializer.acceptableContentTypes =[[NSSet alloc] initWithObjects:@"text/html",@"text/plain",@"text/json", nil];
}

#pragma mark addImage
- (void)addImage:(UITapGestureRecognizer *)tap{
    NSLog(@"addimage");
    UIImageView *imageView=(UIImageView *)tap.view;
    [self avatarComponentHandler:imageView];
}
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
             imageView.contentMode = UIViewContentModeScaleAspectFit;
             NSLog(@"[self.imageURL];%@",self.imageURL);
         }
     }];
    // 需要显示的滤镜名称列表 (如果为空将显示所有自定义滤镜)\
    //todo:
    _avatarComponent.options.cameraOptions.filterGroup = nil;
//    @[@"SkinNature", @"SkinPink", @"SkinJelly", @"SkinNoir", @"SkinRuddy", @"SkinPowder", @"SkinSugar"];
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

#pragma mark
#pragma mark 时间按钮点击事件
- (void)timeBtnClick {

    //初始化黑色背景透明按钮
    UIButton *blackBtn=[[UIButton alloc]initWithFrame:self.view.frame];
    blackBtn.backgroundColor=[UIColor blackColor];
    blackBtn.alpha=0.1;
    [blackBtn addTarget:self action:@selector(blackBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:blackBtn];
    
    //初始化时间选择器
    datePicker=[[UIDatePicker alloc]init];
    datePicker.center=self.view.center;//居中
    datePicker.backgroundColor=[UIColor whiteColor];
    datePicker.alpha=0.1;
    datePicker.minimumDate=datePicker.date;//不能选过去的时间
    [self.view insertSubview:datePicker aboveSubview:blackBtn];
    
    //显示的动画
    [UIView animateWithDuration:0.2 animations:^{
        blackBtn.alpha=0.7;
        datePicker.alpha=1;
    }];
    
}

#pragma mark 点击黑色背景按钮，移除时间选择器
- (void)blackBtnClick :(UIButton *)blackBtn {
    //获取时间
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString=[dateFormatter stringFromDate:datePicker.date];
    _createView.timeLabel.text=dateString;
    _createView.timeLabel.textAlignment=NSTextAlignmentCenter;
    
    //消失的动画
    [UIView animateWithDuration:0.3 animations:^{
        blackBtn.alpha=0.1;
        datePicker.alpha=0.1;
    }completion:^(BOOL finished) {
        [datePicker removeFromSuperview];
        datePicker=nil;
        [blackBtn removeFromSuperview];
    }];
}

#pragma mark mapBtnClick
- (void)mapBtnClick{
    mapViewController *mapVC = [[mapViewController alloc] init];
    [self presentViewController:mapVC animated:YES completion:nil];
}
@end
