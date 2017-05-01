//
//  QRViewController.m
//  QRWeiXinDemo
//
//  Created by lovelydd on 15/4/25.
//  Copyright (c) 2015年 lovelydd. All rights reserved.
//

#import "QRViewController.h"

#import <AVFoundation/AVFoundation.h>
//#import "QRView.h"
@interface QRViewController ()<AVCaptureMetadataOutputObjectsDelegate>{
    CGFloat qrLineY;
}

@property (strong, nonatomic) AVCaptureDevice * device;
@property (strong, nonatomic) AVCaptureDeviceInput * input;
@property (strong, nonatomic) AVCaptureMetadataOutput * output;
@property (strong, nonatomic) AVCaptureSession * session;
@property (strong, nonatomic) AVCaptureVideoPreviewLayer * preview;

@end

@implementation QRViewController

static NSTimeInterval kQrLineanimateDuration = 0.02;

- (instancetype)init{
    self = [super init];
    if(self){
        _requestDataCtrl = [[HSRequestDataController alloc]init];
    }
    return  self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //加载xib
    self.view = [[[NSBundle mainBundle] loadNibNamed:@"qrView" owner:self options:nil] objectAtIndex:0];

    //隐藏导航栏
//    self.navigationController.navigationBar.hidden = YES;
    
    //设置点击标签进入我的二维码
    [_showMyQR setUserInteractionEnabled:YES];
    UITapGestureRecognizer *tapLabel = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showMyQR:)];
    [_showMyQR addGestureRecognizer:tapLabel];
    //加入向左箭头
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"navigationbar_back"] style:UIBarButtonItemStylePlain target:self action:@selector(pop:)];
//    //加入中间相册
//    UIButton *button = [[UIButton alloc]init];
//    [button setTitle: @"相册" forState: UIControlStateNormal];
//    [button sizeToFit];
//    self.navigationItem.titleView = button;
    //加入右边闪光灯
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"闪光灯"] style:UIBarButtonItemStylePlain target:self action:@selector(pop:)];
    
    //背景颜色
    UIButton *_backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 1000, 1000)];
    [_backBtn setBackgroundColor:[UIColor blackColor]];
    _backBtn.alpha = 0.5;
    [self.view insertSubview:_backBtn belowSubview:_qrBlockButton];
    
    
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // Input
    _input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    
    // Output
    _output = [[AVCaptureMetadataOutput alloc]init];
    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    // Session
    _session = [[AVCaptureSession alloc]init];
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    if ([_session canAddInput:self.input])
    {
        [_session addInput:self.input];
    }
    
    if ([_session canAddOutput:self.output])
    {
        [_session addOutput:self.output];
    }
    
    // 条码类型 AVMetadataObjectTypeQRCode
    _output.metadataObjectTypes =@[AVMetadataObjectTypeQRCode];
    
    //增加条形码扫描
//    _output.metadataObjectTypes = @[AVMetadataObjectTypeEAN13Code,
//                                    AVMetadataObjectTypeEAN8Code,
//                                    AVMetadataObjectTypeCode128Code,
//                                    AVMetadataObjectTypeQRCode];
    
    // Preview
    _preview =[AVCaptureVideoPreviewLayer layerWithSession:_session];
    _preview.videoGravity =AVLayerVideoGravityResize;
    _preview.frame =self.view.layer.bounds;
    [self.view.layer insertSublayer:_preview atIndex:0];
////    self.view.backgroundColor = [UIColor grayColor];
//    self.view.layer.backgroundColor = [UIColor grayColor];
    
    [_session startRunning];
    
    
//    CGRect screenRect = [UIScreen mainScreen].bounds;
    [[UIApplication sharedApplication]keyWindow].backgroundColor = [UIColor clearColor];
    
    //修正扫描区域
    CGFloat screenHeight = self.view.frame.size.height;
    CGFloat screenWidth = self.view.frame.size.width;
    CGRect cropRect = _qrBlockButton.frame;

    [_output setRectOfInterest:CGRectMake(cropRect.origin.y / screenHeight,
                                          cropRect.origin.x / screenWidth,
                                          cropRect.size.height / screenHeight,
                                          cropRect.size.width / screenWidth)];

    qrLineY = _qrLineImg.frame.origin.y;
//    扫描线
    stopScan = false;
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:kQrLineanimateDuration target:self selector:@selector(show) userInfo:nil repeats:YES];
    [timer fire];
    
    //屏幕适配
    float factor=[UIScreen mainScreen].bounds.size.width/self.view.frame.size.width;
    
    self.view.transform = CGAffineTransformMakeScale(factor, factor);
    //调整缩放后的位置
    CGRect frame=self.view.frame;
    frame.origin=CGPointZero;
    self.view.frame=frame;
    
    //手势
    UIPanGestureRecognizer* panGestureRecognizer=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePan:)];
    panGestureRecognizer.delegate = self;
    [self.view addGestureRecognizer:panGestureRecognizer];
    

}

#pragma mark 扫描线动画
- (void)show {
    if(stopScan == false){
        [UIView animateWithDuration:kQrLineanimateDuration animations:^{
            
            CGRect rect = _qrLineImg.frame;
            rect.origin.y = qrLineY;
            _qrLineImg.frame = rect;
            
        } completion:^(BOOL finished) {
            
            CGFloat maxBorder = CGRectGetMaxY(_qrBlockButton.frame)-15;
            if (qrLineY > maxBorder) {
                
                qrLineY = _qrBlockButton.frame.origin.y;
            }
            qrLineY++;
        }];
    }
}

- (void)pop:(UIButton *)button {
    
    [UIView animateWithDuration:0.2 animations:^{
        CGRect viewFram = self.view.frame;
        viewFram.origin.y = kScreenHeight;
        _qrDisplayVC.view.frame = viewFram;
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
    }];

}

#pragma mark QRViewDelegate
//-(void)scanTypeConfig:(QRItem *)item {
//    
//    if (item.type == QRItemTypeQRCode) {
//        _output.metadataObjectTypes =@[AVMetadataObjectTypeQRCode];
//        
//    } else if (item.type == QRItemTypeOther) {
//        
//        _output.metadataObjectTypes = @[AVMetadataObjectTypeEAN13Code,
//                                        AVMetadataObjectTypeEAN8Code,
//                                        AVMetadataObjectTypeCode128Code,
//                                        AVMetadataObjectTypeQRCode];
//    }
//}
#pragma mark AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    NSString *stringValue;
    if ([metadataObjects count] >0)
    {
        //停止扫描
        [_session stopRunning];
        //停止扫描线动画
        stopScan = true;
        
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        stringValue = metadataObject.stringValue;
        
        NSString *user_token = [[NSUserDefaults standardUserDefaults]objectForKey:@"user_token"];
        if(!user_token){
            NSLog(@"用户token为空");
            return ;
        }
        NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:user_token,@"user_token",
                             stringValue,@"QRcode", nil];
        NSDictionary *requestData = [[NSDictionary alloc] initWithObjectsAndKeys:[dic JSONString],@"requestData", nil];
        [self.requestDataCtrl doQRcodeScan:requestData andRequestCB:^(BOOL code, NSString *error){
            if(code){
                NSLog(@"扫描二维码成功");
                ShowHud(@"扫描二维码成功", NO);
                [self pop:nil];
            }
            else{
                NSLog(@"异常%@",error);
            }
        }];

    }else{
        NSLog(@"什么都没扫描到");
    }
    
//    NSLog(@" %@",stringValue);
//
//    if (self.qrUrlBlock) {
//        self.qrUrlBlock(stringValue);
//    }
    
//    [self pop:nil];
    
    
    
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
#pragma mark pangesture
- (void)handlePan:(UIPanGestureRecognizer *)gesture{
    //手势开始
    if ([gesture state]==UIGestureRecognizerStateBegan) {
        
        
    }
    //手势改变
    else if ([gesture state]==UIGestureRecognizerStateChanged) {
        
        
        //获取手势的位移
        CGPoint translation=[gesture translationInView:self.view];
        CGRect frame=self.view.frame;
        
        //上下平移
        frame.origin.y+=translation.y;
        //上部不能上移超出屏幕，比如登录进来就往上滑
        if (frame.origin.y<0) {
            frame.origin.y=0;
        }
        self.view.frame=frame;
        
        //设置透明度
        //        settingView.alpha=self.view.frame.origin.y/self.view.frame.size.height;
        
        //清空手势的位移，因为位移是累加的。
        [gesture setTranslation:CGPointMake(0, 0) inView:self.view];
        
    }
    //手势结束
    else if ([gesture state]==UIGestureRecognizerStateEnded) {
        
        //获取手势的位移
        //        CGPoint translation=[gesture translationInView:self.view];
        
        //速度velocity.y>0是往下平移
        if ([gesture velocityInView:self.view].y>0) {
            [UIView animateWithDuration:0.3 animations:^{
                CGRect frame=self.view.frame;
                frame.origin.y=kScreenHeight;
                self.view.frame=frame;
                
            }completion:^(BOOL finished) {
                [self.view removeFromSuperview];
            }];
        }else{
            [UIView animateWithDuration:0.3 animations:^{
                CGRect frame=self.view.frame;
                frame.origin.y=0;
                self.view.frame=frame;
                
            }completion:^(BOOL finished) {
                //                [self.view removeFromSuperview];
            }];
        }
    }
    else if([gesture state]==UIGestureRecognizerStateCancelled){
        //速度velocity.y>0是往下平移
        if ([gesture velocityInView:self.view].y>0) {
            [UIView animateWithDuration:0.3 animations:^{
                CGRect frame=self.view.frame;
                frame.origin.y=kScreenHeight;
                self.view.frame=frame;
                
            }completion:^(BOOL finished) {
                [self.view removeFromSuperview];
            }];
        }else{
            [UIView animateWithDuration:0.3 animations:^{
                CGRect frame=self.view.frame;
                frame.origin.y=0;
                self.view.frame=frame;
                
            }completion:^(BOOL finished) {
                //                [self.view removeFromSuperview];
            }];
        }
    }
    
    //        if(self.view.frame.origin.y>kScreenHeight/2){
    //
    //        }else{
    //
    //        }
    //
    //            }
    
}

#pragma mark 展示我的二维码
- (void)showMyQR:(UIPanGestureRecognizer *)tap{
    _qrDisplayVC = [[HSQRDisplayVC alloc]init];
    
    CGRect frame=self.view.frame;
    frame.origin.y = kScreenHeight;
    _qrDisplayVC.view.frame = frame;
    [self.view addSubview:_qrDisplayVC.view];

    [UIView animateWithDuration:0.2 animations:^{
        CGRect viewFram = self.view.frame;
        viewFram.origin.y = 0;
        _qrDisplayVC.view.frame = viewFram;
    } completion:^(BOOL finished) {
    }];
    
//    [self.view addSubview:_qrDisplayVC.view];
//    [self presentViewController:_qrDisplayVC animated:YES completion:nil];
}

@end
