//
//  HSTuSDKRootControllerViewController.m
//  TuSDKDemo
//
//  Created by 微光 on 15/3/23.
//  Copyright (c) 2015年 Lasque. All rights reserved.
//
/*
 如果是系统相册就用setImageSqlInfo，如果是临时文件夹的图片就用setTempFilePath
 */
#import "HSTuSDKRootControllerViewController.h"
#import <QiniuSDK.h>
#import <AFNetworking.h>
#import <JSONKit.h>

@interface HSTuSDKRootControllerViewController ()
@property (nonatomic,strong) UITextField *txtField;
@property (nonatomic,strong) NSString *imageURL;
@end

@implementation HSTuSDKRootControllerViewController

@synthesize imageView=_imageView;

/* 屏幕宽度 */
#define kScreenWidth                             [[UIScreen mainScreen] bounds].size.width
/* 屏幕高度 */
#define kScreenHeight                            [[UIScreen mainScreen] bounds].size.height
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"活动照片滤镜";
    
    // 启动GPS
    [TuSDKTKLocation shared].requireAuthor = YES;
    
    // 异步方式初始化滤镜管理器
    // 需要等待滤镜管理器初始化完成，才能使用所有功能
    [self showHubWithStatus:LSQString(@"lsq_initing", @"正在初始化")];
    [TuSDK checkManagerWithDelegate:self];
    
    //view颜色
    self.view.backgroundColor=[UIColor whiteColor];
    //用户输入文字
    self.txtField = [[UITextField alloc] initWithFrame:CGRectMake(60, 60, kScreenWidth-120,50)];
    //    self.txtField.backgroundColor=[UIColor grayColor];
    //    self.txtField.tintColor = [UIColor blackColor];
    self.txtField.textColor = [UIColor blackColor];
    self.txtField.placeholder = @"写点什么吧...";
    self.txtField.delegate = self;//点击return
    [self.view addSubview:self.txtField];
    //选取图片按钮
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(60, 170, kScreenWidth-120, 30)];
    btn.backgroundColor=[UIColor blueColor];
    [btn setTitle:@"选取图片" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(avatarBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    //图片容器
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(60, 220, kScreenWidth-120, kScreenWidth-120)];
    _imageView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_imageView];
    //提交按钮
    UIButton *submit = [[UIButton alloc] initWithFrame:CGRectMake(60, CGRectGetMaxY(_imageView.frame)+20, kScreenWidth-120, 30)];
    //    submit.tintColor=[UIColor blackColor];
    submit.backgroundColor=[UIColor blueColor];
    
    [submit setTitle:@"提交" forState: UIControlStateNormal];
    //    submit.tintColor = [UIColor blueColor];
    [submit addTarget:self action:@selector(submit:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:submit];
    
    //backIcon
    UIButton *backIcon = [[UIButton alloc] initWithFrame:CGRectMake(10 , 20, 60, 30)];
    [backIcon setImage:[UIImage imageNamed:@"icon_arrows_down"] forState:UIControlStateNormal];
    backIcon.backgroundColor = [UIColor blueColor];
    [backIcon setTitle:@"Back" forState:UIControlStateNormal];
    [backIcon addTarget:self action:@selector(backIconPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backIcon];
    
    //手势操作，实现点击屏幕消失键盘
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    
    //    tapGesture.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGesture];
}


- (void)viewTapped:(UITapGestureRecognizer *)tap{
    if([self.txtField isFirstResponder]){
        [self.txtField resignFirstResponder];
    }
}

/**
 *  清楚所有控件
 */
- (void)clearComponents
{    // 头像设置组件
    _avatarComponent = nil;
}
- (void) avatarBtnPressed:(id)sender{
    NSLog(@"avatarBtnPressed..................................");
    [self avatarComponentHandler];
}

- (void) submit:(id)sender{
    if (_imageView.image != nil) {
        //把图片转成NSData类型的数据来保存文件
        NSData *dataImag;
        //判断图片是不是png格式的文件
        if (UIImagePNGRepresentation(_imageView.image)) {
            //返回为png图像。
            dataImag = UIImagePNGRepresentation(_imageView.image);
        }else {
            //返回为JPEG图像。
            dataImag = UIImageJPEGRepresentation(_imageView.image, 1.0);
        }
        //        NSLog(@"dataImag:  %@",dataImag);
        NSLog(@"图片上传开始");
        //转化imageURL格式
        NSString *fileName=[NSString stringWithFormat:@"%@", self.imageURL]; //必须
        NSDictionary *dic = @{@"fileName": fileName, @"prefix": @"imageTestByHot"};
        NSString *data = [dic JSONString];
        //        NSLog(@"data:%@",data);
        NSString * requestAddress = @"http://121.41.104.156:8888/Infra/Storage/Qiniu/getQiniuUpToken";
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        //manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];//让AFNetWorking支持text/plain
        // 参数的GET请求
        [manager GET:requestAddress parameters:@{@"requestData"  : data}
             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                 NSLog(@"获得token成功");
                 NSLog(@"%@", responseObject);
                 JSONDecoder *decoder=[[JSONDecoder alloc]init];//初始化json解码
                 NSData *data = [responseObject JSONData];//获取json数据
                 NSDictionary *responseObj = [decoder objectWithData: data];//将json数据给dictionary,获取键值对
                 NSLog(@"%@",responseObj);
                 NSString *saveKey = [responseObj objectForKey:@"saveKey"];
                 NSString *upToken = [responseObj objectForKey:@"upToken"];
                 //             NSLog(@"%@",[responseObj objectForKey:@"key"]);
                 //             NSLog(@"%@",[responseObj objectForKey:@"saveKey"]);
                 //             NSLog(@"%@",[responseObj objectForKey:@"upToken"]);
                 //             NSLog(@"savekey:%@======upToken:%@",saveKey,upToken);
                 NSString *token = upToken;
                 NSLog(@"token为：%@",token);
                 QNUploadManager *upManager = [[QNUploadManager alloc] init];
                 //nsdata转位nsstring
                 //        NSString *result = [[NSString alloc] initWithData:data  encoding:NSUTF8StringEncoding];
                 //        NSData *upData = [result dataUsingEncoding : NSUTF8StringEncoding];
                 [upManager putData:dataImag key:saveKey token:token
                           complete: ^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                               NSLog(@"图片上传成功！");
                               NSLog(@"%@", info);
                               NSLog(@"%@", resp);
                           } option:nil];
                 
             }
             failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 NSLog(@"%@", error);
             }];
        
        
        //        NSLog(@"图片上传结束");
    }
    else{
        NSLog(@"图片不存在");
    }
    [self dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"提交成功");
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
    [self showHubSuccessWithStatus:LSQString(@"lsq_inited", @"初始化完成")];
}

#pragma mark - avatarComponentHandler
/**
 *  头像设置组件
 */
- (void) avatarComponentHandler
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
             _imageView.image = [result loadResultImage];
             self.imageURL =(NSString *)[result imageAsset].url;
             NSLog(@"[self.imageURL];%@",self.imageURL);
         }
     }];
    // 需要显示的滤镜名称列表 (如果为空将显示所有自定义滤镜)
    _avatarComponent.options.cameraOptions.filterGroup = @[@"SkinNature", @"SkinPink", @"SkinJelly", @"SkinNoir", @"SkinRuddy", @"SkinPowder", @"SkinSugar"];
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

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backIconPressed:(id)sender {
    NSLog(@"backIconPressed");
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
