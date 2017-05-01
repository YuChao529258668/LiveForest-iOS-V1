//
//  HSUserInfoHandler.h
//  LiveForest
//
//  Created by 傲男 on 15/6/20.
//  Copyright (c) 2015年 HOTeam. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HSRequestDataController.h"
//sdwebImageView ByQ on 6.20
#import <SDWebImage/UIImageView+WebCache.h>

@interface HSUserInfoHandler : NSObject{
    bool logoCompleted ,blurLogoCompleted;
}

//头像包括模糊头像，都从七牛获取，应该同时处理，保证两张图片一致
//用户的其它个人信息可以分别处理
@property (strong,nonatomic) HSRequestDataController *requestCtrl;
@property (strong, nonatomic) UIImageView *tmpImgView;
@property (strong, nonatomic) UIImageView *tmpImgView2;
//获取并保存用户个人信息,回调函数，返回是否处理完成
- (void) getUserInfoAndSaveHandler:(void(^)(BOOL))CallBack;
//#pragma mark 更新用户个人模糊头像
- (void) updateUserAvarlAndSaveHandler:(NSString*)url;
//更新用户信息
- (void) updateUserInfoAndSaveHandler:(NSDictionary*)dic;
//更新用户城市ID信息
- (void) updateUserCity:(NSString*)cityID;
//更新用户生日
-(void)updateUserBirthday:(NSString *)dateString;
//更新用户昵称
-(void)updateUserNickname:(NSString *)nickname;
//更新用户运动标签
- (void)updateUserSportsID:(NSArray *)sportsID;
//更新用户微信信息
- (void)updateUserWechatInfo:(NSDictionary*)wechatInfo;
@end
