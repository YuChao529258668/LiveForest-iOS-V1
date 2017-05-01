//
//  SocialService.m
//  LiveForest
//
//  Created by apple on 15/7/28.
//  Copyright (c) 2015年 HOTeam. All rights reserved.
//

#import "SocialService.h"

@implementation SocialService

#pragma mark - Public Static Methods
#pragma mark 获取实例
+ (SocialService*)sharedInstance
{
    static dispatch_once_t pred = 0;
    __strong static SocialService *_sharedObject = nil;
    dispatch_once(&pred, ^{
        
        _sharedObject = [[self alloc] init]; // or some other init method
        
    });
    return _sharedObject;
}


#pragma mark - 微信相关

#pragma mark 获取微信登录的用户信息
- (void)getWeChatUserInfo:(void (^)(id userInfo))CallBack{

    //跳转到微信登录界面
    [ShareSDK getUserInfoWithType:ShareTypeWeixiTimeline authOptions:nil result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {
        
        //如果用户已经使用本地微信登录过，则会自动获取回调信息
        NSLog(@"getWeChatUserInfo");
        
        if(!result){
            //如果获取失败，则返回控制
            CallBack(nil);
            return;
        }
        
        //解析当前的微信用户信息
        id<ISSPlatformCredential> credential = [ShareSDK getCredentialWithType:ShareTypeWeixiTimeline];
       
        NSMutableDictionary* userInfoDict = [[NSMutableDictionary alloc] init];
        
        //获取用户uid信息
        [userInfoDict setObject:[[[userInfo credential] extInfo] objectForKey:@"unionid"] forKey:@"openId"];
        
        //获取用户昵称
        [userInfoDict setObject:[userInfo nickname] forKey:@"nickname"];
        
        //获取用户头像
        [userInfoDict setObject:[userInfo profileImage] forKey:@"profileImage"];
        
        //获取用户性别
        [userInfoDict setObject:[NSString stringWithFormat:@"%d",[userInfo gender]] forKey:@"sex"];
        
        //获取用户教育
        [userInfoDict setObject:[userInfo educations]?[userInfo educations]:@"" forKey:@"education"];
        
        //获取用户工作
        [userInfoDict setObject:[userInfo works]?[userInfo works]:@"" forKey:@"work"];
        
        //获取用户生日
        [userInfoDict setObject:[userInfo birthday]?[userInfo birthday]:@"" forKey:@"birthday"];
        
        //调用回调函数
        CallBack([[NSDictionary alloc] initWithDictionary:userInfoDict]);
        
    }];
}

#pragma mark - 微博相关

#pragma mark 获取微博登录的用户信息
- (void)getWeCoUserInfo:(void (^)(id userInfo))CallBack{
    
    [ShareSDK getUserInfoWithType:ShareTypeSinaWeibo authOptions:nil result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {
        
        
        //如果用户已经使用本地微信登录过，则会自动获取回调信息
        NSLog(@"getWeCoUserInfo");
        
        if(!result){
            //如果获取失败，则返回控制
            CallBack(nil);
            return;
        }
        
        //解析当前的微信用户信息
        id<ISSPlatformCredential> credential = [ShareSDK getCredentialWithType:ShareTypeWeixiTimeline];
        
        NSMutableDictionary* userInfoDict = [[NSMutableDictionary alloc] init];
        
        //获取用户uid信息
        [userInfoDict setObject:[credential uid] forKey:@"openId"];
        
        //获取用户昵称
        [userInfoDict setObject:[userInfo nickname] forKey:@"nickname"];
        
        //获取用户头像
        [userInfoDict setObject:[userInfo profileImage] forKey:@"profileImage"];
        
        //获取用户性别
        [userInfoDict setObject:[NSString stringWithFormat:@"%d",[userInfo gender]] forKey:@"sex"];
        
        //获取用户教育
        [userInfoDict setObject:[userInfo educations]?[userInfo educations]:@"" forKey:@"education"];
        
        //获取用户工作
        [userInfoDict setObject:[userInfo works]?[userInfo works]:@"" forKey:@"work"];
        
        //获取用户生日
        [userInfoDict setObject:[userInfo birthday]?[userInfo birthday]:@"" forKey:@"birthday"];
        
        //调用回调函数
        CallBack([[NSDictionary alloc] initWithDictionary:userInfoDict]);
    
    }];

}

#pragma mark - 分享相关
#pragma mark 根据内容与外链标签发起分享
- (void)doSocialShareWithContent:(NSString*)content AndHref:(NSString*)href WithCallBack:(void(^)(bool))callBack{
    
    //创建自定义分享列表
    NSArray *shareList = [ShareSDK getShareListWithType:
                          ShareTypeWeixiSession,
                          ShareTypeWeixiTimeline,
                          ShareTypeSinaWeibo,
                          ShareTypeCopy,nil];
    
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"180" ofType:@"png"];
    
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:content
                                       defaultContent:@"欢迎来到LiveForest的世界"
                                                image:[ShareSDK imageWithPath:imagePath]
                                                title:@"LiveForest"
                                                  url:href
                                     
                                          description:NSLocalizedString(@"LiveForest 游戏分享", @"LiveForest 游戏分享")
                                            mediaType:SSPublishContentMediaTypeNews];
    
    
    //弹出分享菜单
    //弹出分享菜单
    [ShareSDK showShareActionSheet:self
                         shareList:shareList
                           content:publishContent
                     statusBarTips:YES
                       authOptions:nil
                      shareOptions:nil
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                
                                if (state == SSResponseStateSuccess)
                                {
                                    NSLog(NSLocalizedString(@"TEXT_ShARE_SUC", @"分享成功"));
                                    //如果分享成功了，则调用回调方法
                                    callBack(true);
                                }
                                else if (state == SSResponseStateFail)
                                {
                                    NSLog(NSLocalizedString(@"TEXT_ShARE_FAI", @"分享失败,错误码:%d,错误描述:%@"), [error errorCode], [error errorDescription]);
                                    callBack(false);
                                    
                                }
                            }];

}

@end
