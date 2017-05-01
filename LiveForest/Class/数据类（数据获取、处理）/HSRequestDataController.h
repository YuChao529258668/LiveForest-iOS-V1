//
//  HSRequestDataController.h
//  LiveForest
//
//  Created by 微光 on 15/6/2.
//  Copyright (c) 2015年 HOTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

//请求数据ByQiang
#import <JSONKit.h>
#import <AFNetworking/AFNetworking.h>

#import "HSConstantURL.h"

#import <QiniuSDK.h>

//数据处理函数
#import "HSDataFormatHandle.h"

//会用到登陆，如果token失败
@class HSLoginViewController;

@interface HSRequestDataController : UIViewController

@property (nonatomic, strong) AFHTTPRequestOperationManager *manager;

@property (nonatomic, strong) NSDictionary *dic;

@property(nonatomic,strong) HSDataFormatHandle *dataFormatHandle;  //数据处理函数

//通用请求接口
//-(void)getDataWithURLAndParam:(NSDictionary*)requestData andURL:(NSString*)url andRequestCB:(void(^)(BOOL, id ,NSString *))CallBack;
//#pragma mark 通用请求接口2返回两个结果，只有成功地参数和错误的参数即可
//-(void)getResultWithURLAndParam:(NSDictionary*)requestData andURL:(NSString*)url andRequestCB:(void(^)(bool ,NSString *))CallBack;


#pragma mark 注册相关
//手机号验证
-(void)doPhoneVerify:(NSDictionary*)requestData andRequestCB:(void(^)(BOOL, id ,NSString *))CallBack;
//发送验证码
-(void)doVerificationCodeSend:(NSDictionary*)requestData andRequestCB:(void(^)(BOOL, id ,NSString *))CallBack;
//校验验证码
-(void)doVerificationCodeCheck:(NSDictionary*)requestData andRequestCB:(void(^)(BOOL, id ,NSString *))CallBack;
//注册信息
-(void)doRegister:(NSDictionary*)requestData andRequestCB:(void(^)(BOOL, id ,NSString *))CallBack;


#pragma mark - 运动社
/*
 分享
 */
//请求七牛上传路径
-(void)getQiniuUpTokenWithParam:(NSDictionary*)requestData andRequestCB:(void(^)(BOOL, id ,NSString *))CallBack;
//创建分享
-(void)createShareWithParam:(NSDictionary*)requestData andRequestCB:(void(^)(BOOL, id ,NSString *))CallBack;
//创建分享可以At活动（一个）、群组（一个）、At好友(1-3个)
-(void)doShareCreateWithAt:(NSDictionary*)requestData andRequestCB:(void(^)(BOOL, id ,NSString *))CallBack;
//获取官方分享列表
-(void)getMPShareList:(NSDictionary*)requestData andRequestCB:(void(^)(BOOL, id ,NSString *))CallBack;
//分享点赞
-(void)doShareLike:(NSDictionary*)requestData andRequestCB:(void(^)(BOOL, id ,NSString *))CallBack;
//获取分享点赞状态
-(void)getUserShareLikeState:(NSDictionary*)requestData andRequestCB:(void(^)(BOOL, BOOL ,NSString *))CallBack;
//获取系统推荐分享列表
-(void)getFollowingShareList:(NSDictionary*)requestData andRequestCB:(void(^)(BOOL, id ,NSString *))CallBack;
//获取个人分享列表
-(void)getShareList:(NSDictionary*)requestData andRequestCB:(void(^)(BOOL, id ,NSString *))CallBack;
//分享评论doShareCommentURL
-(void)doShareComment:(NSDictionary*)requestData andRequestCB:(void(^)(BOOL, id ,NSString *))CallBack;
//获取共享评论
-(void)getShareComment:(NSDictionary*)requestData andRequestCB:(void(^)(BOOL, id ,NSString *))CallBack;
//删除分享
-(void)doShareDelete:(NSDictionary*)requestData andRequestCB:(void(^)(BOOL ,NSString *))CallBack;
//获取分享详情
-(void)getShareInfo:(NSDictionary*)requestData andRequestCB:(void(^)(BOOL, id ,NSString *))CallBack;

/*
 活动
 */
#pragma mark 创建活动 doActivityCreateByUserURL
-(void)doActivityCreateByUser:(NSDictionary*)requestData andRequestCB:(void(^)(BOOL, id ,NSString *))CallBack;
//获取官方推荐活动
-(void)getMPActivityList:(NSDictionary*)requestData andRequestCB:(void(^)(BOOL, id ,NSString *))CallBack;
//获取推荐活动列表
-(void)getMixActivityList:(NSDictionary*)requestData andRequestCB:(void(^)(BOOL, id ,NSString *))CallBack;
//参加活动
-(void)doActivityAttend:(NSDictionary*)requestData andRequestCB:(void(^)(BOOL, id ,NSString *))CallBack;
//取消参加
-(void)doActivityAttendCancel:(NSDictionary*)requestData andRequestCB:(void(^)(BOOL, id ,NSString *))CallBack;
//获取官方线上晒图活动
-(void)getDisplayPicActivityList:(NSDictionary*)requestData andRequestCB:(void(^)(BOOL, id ,NSString *))CallBack;
//获取官方线上晒图活动详情
-(void)getDisplayPicActivityInfo:(NSDictionary*)requestData andRequestCB:(void(^)(BOOL, id ,NSString *))CallBack;
//#pragma mark 请求个人信息
-(void)getPersonalInfo:(void(^)(BOOL, id ,NSString *))CallBack;
//#pragma mark 修改头像请求接口
-(void)updatePersonLogo:(NSDictionary*)requestData andRequestCB:(void(^)(BOOL, id ,NSString *))CallBack;
//#pragma mark 修改用户城市
-(void)updatePersonCity:(NSDictionary*)requestData andRequestCB:(void(^)(BOOL, id ,NSString *))CallBack;
//修改用户生日
-(void)updatePersonBirthday:(NSDictionary*)requestData andRequestCB:(void(^)(BOOL, id ,NSString *))CallBack;
//修改用户昵称updatePersonNickname
-(void)updatePersonNickname:(NSDictionary*)requestData andRequestCB:(void(^)(BOOL, id ,NSString *))CallBack;
//更新用户运动标签
-(void)updatePersonSports:(NSDictionary*)requestData andRequestCB:(void(^)(BOOL, id ,NSString *))CallBack;
//获取用户收货地址
-(void)getPersonAddress:(NSDictionary*)requestData andRequestCB:(void(^)(BOOL, id ,NSString *))CallBack;
//更新用户收货地址
-(void)updatePersonAddress:(NSDictionary*)requestData andRequestCB:(void(^)(BOOL, id ,NSString *))CallBack;
//#pragma mark 信息补全
-(void)updateUserInfo:(NSDictionary*)requestData andRequestCB:(void(^)(BOOL, id ,NSString *))CallBack;
//#pragma mark 注销个人信息
-(void)doLogout:(NSDictionary*)requestData andRequestCB:(void(^)(BOOL, id ,NSString *))CallBack;
//#pragma mark getUserInfo
-(void)getUserInfo:(NSDictionary*)requestData andRequestCB:(void(^)(BOOL, id ,NSString *))CallBack;
#pragma mark 关注某人
-(void)doFollowingAttention:(NSDictionary*)requestData andRequestCB:(void(^)(BOOL ,NSString *))CallBack;
#pragma mark 取消关注某人
-(void)doFollowingCancel:(NSDictionary*)requestData andRequestCB:(void(^)(BOOL ,NSString *))CallBack;


//#pragma mark 原生登陆接口
-(void)doLogin:(NSDictionary*)requestData andRequestCB:(void(^)(BOOL, id ,NSString *))CallBack;
//第三方登陆接口
-(void)doThirdLogin:(NSDictionary*)requestData andRequestCB:(void(^)(BOOL, id ,NSString *))CallBack;
-(void)doThirdBind:(NSDictionary*)requestData andRequestCB:(void(^)(BOOL, id ,NSString *))CallBack;
//#pragma mark 根据用户第三方的openId判断用户是否存在
-(void)doThirdIdCheck:(NSDictionary*)requestData andRequestCB:(void(^)(BOOL, id ,NSString *))CallBack;
//根据微信微博绑定手机号
-(void)doUserPhoneBind:(NSDictionary*)requestData andRequestCB:(void(^)(BOOL ,id ,NSString *))CallBack;
/*
 群组
 */
-(void)getGroupList:(NSDictionary*)requestData andRequestCB:(void(^)(BOOL, id ,NSString *))CallBack;
-(void)getFansOrFollowingList:(NSDictionary*)requestData isFans:(BOOL)isFans andRequestCB:(void(^)(BOOL, id ,NSString *))CallBack;
//后去好友列表
-(void)getFriendsList:(NSDictionary*)requestData andRequestCB:(void(^)(BOOL, id ,NSString *))CallBack;
/*
 二维码
 */
//生成二维码
-(void)doQRcodeCreate:(NSDictionary*)requestData andRequestCB:(void(^)(BOOL ,id ,NSString *))CallBack;
//扫描二维码
-(void)doQRcodeScan:(NSDictionary*)requestData andRequestCB:(void(^)(BOOL ,NSString *))CallBack;

- (NSDictionary*)requestDataWrapper:(NSDictionary*)requestRawData;

#pragma mark - 约伴
//创建约伴
- (void)doYueBanCreateByUser:(NSDictionary *)requestData andRequestCB:(void(^)(BOOL ,id ,NSString *))CallBack;
//获取熟人的推荐列表
-(void)getYueBanListFromFriends:(NSDictionary *)requestData andRequestCB:(void(^)(BOOL ,id ,NSString *))CallBack;
//获取陌生人的推荐列表
-(void)getYueBanListFromStrangers:(NSDictionary *)requestData andRequestCB:(void(^)(BOOL ,id ,NSString *))CallBack;
//用户参与/拒绝约伴
-(void)updataUserYueBanState:(NSDictionary *)requestData andRequestCB:(void(^)(BOOL , NSString*))CallBack;
//获取我的约伴列表
- (void)getMyYueBanDetailList:(NSDictionary *)requestData andRequestCB:(void(^)(BOOL ,id ,NSString *))CallBack;
//获取我参与的约伴的历史记录的列表
-(void)getMyAttendYueBanList:(NSDictionary *)requestData andRequestCB:(void(^)(BOOL ,id ,NSString *))CallBack;

//用户停止广播某个约伴
- (void)doYueBanStopByUser:(NSDictionary *)requestData andRequestCB:(void(^)(BOOL,NSString *))CallBack;
//获取某个约伴详情
-(void)getYueBanDetail:(NSDictionary *)requestData andRequestCB:(void(^)(BOOL,id,NSString *))CallBack;
//获取我参加的和我创建的约伴历史，创建的只返回停止了的
-(void)getMyYueBanRecordList:(NSDictionary *)requestData andRequestCB:(void(^)(BOOL,id,NSString *))CallBack;

#pragma mark - 游戏
//获取我正在进行的游戏任务列表
-(void)getMyCurrentMultiGameInfo:(NSDictionary *)requestData andRequestCB:(void(^)(BOOL,id,NSString *))CallBack;
//获取当日任务目标与互动值
-(void)getTaskTargetAndInteractionValue:(NSDictionary *)requestData andRequestCB:(void(^)(BOOL,id,NSString *))CallBack;
//获取多人游戏邀请列表
//- (void)getMyInvitationList:(NSDictionary *)requestData requestCallBack:(void (^)(BOOL code,id responseObject,NSString *error))callBack;
//获取多人游戏邀请列表
- (void)getMyInvitationListWithCallBack:(void (^)(BOOL code,id responseObject,NSString *error))callBack;
//获取游戏排行榜
- (void)getMyScoreRankWithCallBack:(void (^)(BOOL code,id responseObject,NSString *error))callBack;
@end
