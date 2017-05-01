//
//  HSQRDisplayVC.m
//  LiveForest
//
//  Created by 傲男 on 15/7/13.
//  Copyright (c) 2015年 HOTeam. All rights reserved.
//

#import "HSQRDisplayVC.h"

@implementation HSQRDisplayVC

- (instancetype)init{
    
    self = [super init];
    if(self)
    {
        _requestDataCtrl = [[HSRequestDataController alloc]init];
    }
    
    return self;
}

- (void)loadView{
    //加载xib
    self.view = [[[NSBundle mainBundle] loadNibNamed:@"HSQRDisplayView" owner:self options:nil] objectAtIndex:0];
    //头像圆形
    _avatarImg.layer.cornerRadius = _avatarImg.frame.size.width/2;
    _avatarImg.clipsToBounds = YES;
    //二维码图片模式
    _qrImage.contentMode = UIViewContentModeScaleAspectFill;
}

- (void)viewDidLoad{
    
    //加入向左箭头
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"navigationbar_back"] style:UIBarButtonItemStylePlain target:self action:@selector(pop:)];
    
    self.userInfoControl = [[HSUserInfoHandler alloc]init];
    [self.userInfoControl getUserInfoAndSaveHandler:^(BOOL completion){
        if(completion){
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            //判断是否已经有个人信息
            if([userDefaults objectForKey:@"user_logo_img"]){
                _avatarImg.image = [UIImage imageWithData:[userDefaults objectForKey:@"user_logo_img"]];
            }
            else{
                _avatarImg.image=[UIImage imageNamed:@"Home.jpg"];
            }
            _nickNameLabel.text = [userDefaults objectForKey:@"user_nickname"];
            switch ([[userDefaults objectForKey:@"user_sex"] intValue]) {
                case 0:
                    //男
                    [_sexImg setImage:[UIImage imageNamed:@"性别男"]];
                    break;
                case 1:
                    [_sexImg setImage:[UIImage imageNamed:@"性别女"]];
                    
                default:
                    [_sexImg setImage:[UIImage imageNamed:@"性别男"]];
                    break;
            }
        }
    }];
        
//    HSInviteFriendQRController *qr = [[HSInviteFriendQRController alloc]init];
    NSString *user_token = [[NSUserDefaults standardUserDefaults]objectForKey:@"user_token"];
    if(!user_token){
        NSLog(@"用户token为空");
        return ;
    }
    NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:user_token,@"user_token",
                         @"0",@"code_type", nil];
    NSDictionary *requestData = [[NSDictionary alloc] initWithObjectsAndKeys:[dic JSONString],@"requestData", nil];
    
    //        getUserInfo
    [self.requestDataCtrl doQRcodeCreate:requestData andRequestCB:^(BOOL code,id encodeUserInfo, NSString *error){
        if(code){
            
            if(encodeUserInfo){
                [_qrImage setImage:[HSInviteFriendQRController qrImageForString:encodeUserInfo imageSize:_qrImage.frame.size.width]];
            }
            else{
                NSLog(@"出错:%@",error);
            }
            
        }
        else{
            NSLog(@"异常%@",error);
        }
    }];

    
    UIPanGestureRecognizer* panGestureRecognizer=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePan:)];
    panGestureRecognizer.delegate = self;
    [self.view addGestureRecognizer:panGestureRecognizer];
    
    
    
    
    //屏幕适配
    float factor=[UIScreen mainScreen].bounds.size.width/self.view.frame.size.width;
    
    self.view.transform = CGAffineTransformMakeScale(factor, factor);
    //调整缩放后的位置
    CGRect frame=self.view.frame;
    frame.origin=CGPointZero;
    self.view.frame=frame;
   
}


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

@end
