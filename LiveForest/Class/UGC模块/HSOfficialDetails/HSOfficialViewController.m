//
//  HSOfficialViewController.m
//  LiveForest
//
//  Created by 微光 on 15/4/27.
//  Copyright (c) 2015年 HOTeam. All rights reserved.
//

#import "HSOfficialViewController.h"
#import "HSConstantURL.h"

#import <ShareSDK/ShareSDK.h>
#import "Macros.h"

@interface HSOfficialViewController ()

@end

@implementation HSOfficialViewController

@synthesize offView = _offView;
@synthesize dic = _dic;
@synthesize manager = _manager;

//- (void)viewDidLayoutSubviews {
//    self.offView.avataImgBtnLarge.imageView.layer.cornerRadius = self.offView.avataImgBtnLarge.imageView.frame.size.width / 2;
//    self.offView.avataImgBtnLarge.imageView.clipsToBounds = YES;
//}

- (id)init {
    self = [super init];
    if (self) {
        _offView = [[HSOfficialView alloc]init];
        if(_offView){
            //            [self.view addSubview:_offView];
            self.view =  _offView;
            
            UIPanGestureRecognizer* panGestureRecognizer=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePan:)];
            panGestureRecognizer.delegate = self;
            [_offView addGestureRecognizer:panGestureRecognizer];
            
        }
        self.requestDataCtrl = [[HSRequestDataController alloc] init];
       
    }

    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
        // Do any additional setup after rloading the view.
    

//    self.view = _offView;
    
    
}

#pragma mark 对象赋值，直接初始化dic
- (void)getShareInfoWithDic:(NSDictionary*)dic{
    _dic = dic;
    _offView.shareID = [_dic objectForKey:@"share_id"];
    [self initView];
}

#pragma mrak 获取dic用 shareid
- (void)getShareInfoWithShareID:(NSString *)shareID{
    
    _offView.shareID = shareID;
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    //todo，应该给游客固定的token
    if(![userDefaults objectForKey:@"user_token"]){
        NSLog(@"user_token为空，");
    }
    else{
        NSString *user_token = [[NSString alloc]initWithString:[userDefaults objectForKey:@"user_token"]];//如果不存在usertoken,则不能赋值
        NSLog(@"%@",[userDefaults objectForKey:@"user_token"]);
        
        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:
                             user_token,@"user_token",
                             shareID,@"share_id",
                             nil];
        NSDictionary *requestData = [[NSDictionary alloc] initWithObjectsAndKeys:
                                     [dic JSONString],@"requestData", nil];
//        NSLog(@"%@",requestData);
        
        [self.requestDataCtrl getShareInfo:requestData andRequestCB:^(BOOL code,id responseObject, NSString *error){
            if(code){
                
                if(!responseObject)
                {
                    NSLog(@"responseObject是字符串类型，为空");
                    return;
                }
                else {
                    _dic = responseObject;
                    [self initView];
                }
            }
            else{
                
            }
        }];
    }
}


#pragma 手势是否有效
- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer {
    
    //手势滑动的距离
    CGPoint translation=[gestureRecognizer translationInView:self.view];
    
//    if (translation.x<0)
//        translation.x=-translation.x;
    if (translation.y>0)
        return YES;
    return NO;
    
    //判断左右还是上下滑动多，上下滑动较多就开始缩放手势
//    return translation.x>translation.y?NO:YES;
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

#pragma mark init
- (void) initView{
    
    if(_dic){
        
        //user_nickname 昵称
        NSString *name = [[_dic objectForKey:@"user_nickname"] isEqualToString:@"-10086"]?@"官方推荐":[_dic objectForKey:@"user_nickname"] ;
        [_offView.nameLabelLarge setText:name];
    
        //时间
        [_offView.timeLabelLarge setText:[HSDataFormatHandle dateFormaterString:[_dic objectForKey:@"share_create_time"]]];
        
    
        //描述
        NSString *description = [_dic objectForKey:@"share_description"];
        if ([description isEqualToString:@""]) {
            description = @"爱运动、爱分享——LiveForest";
        }
        [_offView.textLabelLarge setText:description];
    
        
        //内容图片TODO:可能是数组
        NSArray *imgArray = [[NSArray alloc]initWithArray:[_dic objectForKey:@"share_img_path"]];
        NSMutableArray *_srcStringArray = [[NSMutableArray alloc]init];
        for(int i=0;i<imgArray.count;i++){
            NSString *imaUrl = [[NSString alloc] initWithFormat:@"%@%s",[imgArray objectAtIndex:i] ,QiNiuImageYaSuo];
            if(i==0){
                imgUrl = imaUrl;
            }
            imaUrl = [HSDataFormatHandle encodeURL:imaUrl];
            [_srcStringArray addObject:imaUrl];
        }
        SDPhotoGroup *photoGroupSmall = [[SDPhotoGroup alloc] initWithArrayOfUrl:_srcStringArray frame:_offView.contentImgViewLarge.frame];
        [_offView addSubview:photoGroupSmall];
        
        //添加评论视图
        [_offView insertSubview:_offView.commentView aboveSubview:photoGroupSmall];
        
        //头像
    NSString *avarl = [_dic objectForKey:@"user_logo_img_path"];
    //todo:头像的imageview空间方式 有问题
        UIImageView *imgViewTmp = [[UIImageView alloc]init];
//        [imgViewTmp sd_setImageWithURL:urlAvarl
//                             completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//                                 if(image){
//                                     [_offView.avataImgBtnLarge setImage:image forState:UIControlStateNormal];
//                                 }
//                                 else{
//                                     [_offView.avataImgBtnLarge setImage:[UIImage imageNamed:@"评论头像.png"] forState:UIControlStateNormal];
//                                 }
//                             }];
//        
        [HSDataFormatHandle getImageWithUri:avarl isYaSuo:true imageTarget:imgViewTmp defaultImage:[UIImage imageNamed:@"评论头像.png"] andRequestCB:^(UIImage *image) {
            [_offView.avataImgBtnLarge setImage:image forState:UIControlStateNormal];
        }];
        
        //点击头像进入详情
        [_offView.avataImgBtnLarge addTarget:self action:@selector(avataImgPress:) forControlEvents:UIControlEventTouchUpInside];
        
        
        //分享到第三方
        [_offView.shareThird addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
    
        //点赞
        //初始化点赞
        [self setPraiseBtnImage];
        
        NSString *praiseCount = [HSDataFormatHandle handleStringNumber:[_dic objectForKey:@"share_like_num"]];
        [_offView.praiseLabelLarge setText:praiseCount];
        [_offView.praiseBtnLarge addTarget:self action:@selector(praiseBtnLarge:) forControlEvents:UIControlEventTouchUpInside];
        
        
        //cell的地理位置信息
        if([[_dic objectForKey:@"share_location"] isEqualToString:@"-10086"] || ![_dic objectForKey:@"share_location"] ||[[_dic objectForKey:@"share_location"] isEqualToString:@""]){
            [_offView.mapLocationImg removeFromSuperview];
            [_offView.mapLocationLabel removeFromSuperview];    }
        else{
            [_offView.mapLocationLabel setText:[_dic objectForKey:@"share_location"]];
        }
        
        //评论数
        NSString *commentCount = [HSDataFormatHandle handleStringNumber:[_dic objectForKey:@"comment_count"]];
        [_offView.commentCount setText:commentCount];
    }
    
}

#pragma mark share third
- (void) share:(UIButton*)btn{
    //        显示压缩后的图片
    NSCharacterSet *whitespace = [NSCharacterSet  URLQueryAllowedCharacterSet];//编码，将空格编码
    NSString* strAfterDecodeByUTF8AndURI = [imgUrl stringByAddingPercentEncodingWithAllowedCharacters:whitespace];
    [self shareWithcontent:[_dic objectForKey:@"share_description"] withTitle:@"LiveForest分享" withImage:strAfterDecodeByUTF8AndURI withShareID:_offView.shareID];
}
-(void)shareWithcontent:(NSString*)content withTitle:(NSString*)title withImage:(NSString*)imageUrl withShareID:(NSString *)shareID{
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:content
                                       defaultContent:@"liveforest 分享"
                                                image:[ShareSDK imageWithUrl:imageUrl]
                                                title:title
                                                  url:[[NSString alloc]initWithFormat:@"http://m.live-forest.com/static/view/share/weekly_report.html?type=share&id=%@",shareID]
                                          description:@"liveforest 描述"
                                            mediaType:SSPublishContentMediaTypeNews];
    //创建弹出菜单容器
    id<ISSContainer> container = [ShareSDK container];
    //iPad
    //[container setIPadContainerWithView:sender arrowDirect:UIPopoverArrowDirectionUp];
    //定义shareList
    NSArray *shareList = [ShareSDK getShareListWithType:
                          ShareTypeSinaWeibo,
                          ShareTypeWeixiSession,
                          ShareTypeWeixiTimeline,
                          ShareTypeSMS,nil];
    //弹出分享菜单
    [ShareSDK showShareActionSheet:container
                         shareList:shareList
                           content:publishContent
                     statusBarTips:YES
                       authOptions:nil
                      shareOptions:nil
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                
                                if (state == SSResponseStateSuccess)
                                {
                                    NSLog(NSLocalizedString(@"TEXT_ShARE_SUC", @"分享成功"));
                                }
                                else if (state == SSResponseStateFail)
                                {
                                    NSLog(NSLocalizedString(@"TEXT_ShARE_FAI", @"分享失败,错误码:%d,错误描述:%@"), [error errorCode], [error errorDescription]);
                                }
                            }];
}

#pragma mark 点赞按钮
- (void) praiseBtnLarge:(UIButton *)btn{
    //获取用户token
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    if(![userDefaults objectForKey:@"user_token"]){
        NSLog(@"user_token为空，");
    }
    else{
        _offView.praiseBtnLarge.userInteractionEnabled = NO;
        
        NSString *user_token = [[NSString alloc]initWithString:[userDefaults objectForKey:@"user_token"]];//如果不存在usertoken,则不能赋值
        
        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:user_token,@"user_token",
                             [_dic objectForKey:@"share_id"],@"share_id",nil];
        NSDictionary *requestData = [[NSDictionary alloc] initWithObjectsAndKeys:[dic JSONString],@"requestData", nil];

        [self.requestDataCtrl doShareLike:requestData andRequestCB:^(BOOL code,id responseObject, NSString *error){
            if(code){
                [self praiseBtnClick:btn andNum:_offView.praiseLabelLarge.text];
            }
            else{
                ShowHud(@"系统异常", NO);
                NSLog(@"异常");
            }
            _offView.praiseBtnLarge.userInteractionEnabled = YES;
        }];


    }
    
}

#pragma mark 点赞 成功效果
-(void)praiseBtnClick:(id)sender andNum:(NSString *)num{
    
    UIImage *image;
    int praiseNum = num.intValue;
    
    if(!_offView.praiseJudge){
        praiseNum++;
        image=[UIImage imageNamed:@"ic_thumb_up_blue_48dp.png"];
        _offView.praiseJudge = YES;
    }
    else{
        praiseNum--;
        image=[UIImage imageNamed:@"ic_thumb_up_black_48dp.png"];
        _offView.praiseJudge = NO;
    }
    
    NSString *type = [[NSString alloc]initWithFormat:@"%i",praiseNum];
    [_offView.praiseLabelLarge setText:type];
    [_offView.praiseBtnLarge setImage:(UIImage *)image forState:UIControlStateNormal];
    
    [UIView animateWithDuration:0.15 animations:^{
        _offView.praiseBtnLarge.transform=CGAffineTransformMakeScale(2, 2);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.05 animations:^{
            _offView.praiseBtnLarge.transform=CGAffineTransformMakeScale(1, 1);
        }];
    }];
}


#pragma mark 点赞状态
-(void) setPraiseBtnImage{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    if(![userDefaults objectForKey:@"user_token"]){
        NSLog(@"user_token为空，");
    }
    else{
        NSString *user_token = [[NSString alloc]initWithString:[userDefaults objectForKey:@"user_token"]];//如果不存在usertoken,则不能赋值

        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:user_token,@"user_token",
                             [_dic objectForKey:@"share_id"],@"share_id",
                             nil];
        NSDictionary *requestData = [[NSDictionary alloc] initWithObjectsAndKeys:[dic JSONString],@"requestData", nil];
        
        [self.requestDataCtrl getUserShareLikeState:requestData andRequestCB:^(BOOL code,BOOL state, NSString *error){
            if(code){
                if(state)  //点过赞了
                {
                    [_offView.praiseBtnLarge setImage:[UIImage imageNamed:@"ic_thumb_up_blue_48dp.png"] forState:UIControlStateNormal];
                    _offView.praiseJudge = true;
                }
                else{
                    _offView.praiseJudge = false;
                    NSLog(@"还没点过赞");
                    [_offView.praiseBtnLarge setImage:[UIImage imageNamed:@"ic_thumb_up_black_48dp.png"] forState:UIControlStateNormal];

                }
            }
            else{
                //                ShowHud(@"获取点赞状态失败",NO);
                NSLog(@"获取点赞状态失败");
            }
        }];
 
    }

}


-(void)viewWillDisappear:(BOOL)animated {
    [self.offView.commentView removeFromSuperview];
}

#pragma mark 点击头像
- (void)avataImgPress:(UIButton *)btn{
    
    _visitMineVC=[[HSVisitMineController alloc]init];
    [_visitMineVC requestPersonalInfoWithUserID:[_dic objectForKey:@"user_id"]];
    //        _visitMineVC.userId = userID;
    [self show:_visitMineVC.view];
//    UIWindow *appWindow = [[UIApplication sharedApplication] keyWindow];
//    [appWindow insertSubview:_visitMineVC.view aboveSubview:self.view];
}

#pragma mark 界面从下向上 弹出
- (void)show:(UIView*)view{
    UIWindow *window = [[UIApplication sharedApplication]keyWindow];
    CGRect frame = window.frame;
    frame.origin.y = kScreenHeight;
    view.frame = frame;
    [window insertSubview:view aboveSubview:self.view];
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = window.frame;
        frame.origin.y = 0;
        view.frame = frame;
    } completion:^(BOOL finished) {
        
    }];
}


- (void)show {
    UIView *ov = self.view;
    CGRect frame=ov.frame;
    frame.origin.y=kScreenHeight;
    ov.frame=frame;
    
    [UIView animateWithDuration:0.3 animations:^{
        UIWindow *appWindow = [[UIApplication sharedApplication] keyWindow];
        [appWindow insertSubview:ov aboveSubview:appWindow.rootViewController.view];
        CGRect frame=ov.frame;
        frame.origin.y=0;
        ov.frame=frame;
    }];
}
@end
