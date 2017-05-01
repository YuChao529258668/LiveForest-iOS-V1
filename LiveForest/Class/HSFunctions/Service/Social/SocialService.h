//
//  SocialService.h
//  LiveForest
//
//  Created by apple on 15/7/28.
//  Copyright (c) 2015年 HOTeam. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <ShareSDK/ShareSDK.h>

#import "UtilsHeader.h"

@interface SocialService : NSObject

#pragma mark 获取静态实例
+ (SocialService*)sharedInstance;

#pragma mark 获取用户微信信息
- (void)getWeChatUserInfo:(void (^)(id userInfo))CallBack;

#pragma mark 获取用户微博信息
- (void)getWeCoUserInfo:(void (^)(id userInfo))CallBack;

#pragma mark 进行第三方分享
- (void)doSocialShareWithContent:(NSString*)content AndHref:(NSString*)href WithCallBack:(void(^)(bool))callBack;
@end
