//
//  HSGameModel.h
//  LiveForest
//
//  Created by 钱梦颖 on 15/9/1.
//  Copyright (c) 2015年 HOTeam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <HealthKit/HealthKit.h>
#import <MapKit/MapKit.h>
@interface HSGameModel : NSObject<CLLocationManagerDelegate>

@property(nonatomic,strong)CLLocationManager *currentLocation;


@property (nonatomic, readwrite) HKHealthStore *healthStore;


/**
 * @region 用户信息系列接口
 */

/**
 * @function 返回用户信息，包括user_token，user_id，user_nickname等
 * @return
 */
//返回用户信息的model
-(void)getUserInfo;


/**
 * @region 运动数据接口
 */
/**
 * @function 开始今日的单人模式计步
 * @return True：成功开始计步，False：开启失败
 */
-(BOOL)startTodaySingleGameRecord:(int)todayTarget;


/**
 * @function 判断是否正在单人模式计步，存在则返回已经计步值
 * @return 开始计步则返回数值，否则返回-1
 */
-(int)getTodaySingleGameRecord;


/**
 * @function 结束今日的单人模式计步
 * @param TodayTarget
 * @return
 */
-(BOOL)stopTodaySingleGameRecord:(int)todayTarget;


/**
 * @function 根据某个任务ID开始某个多人任务计步
 * @param task_id 多人任务的ID
 * @param Target
 * @return 是否成功开始
 */
-(BOOL)startMultipleGameRecord:(NSString *)task_id WithTarget:(int)target;


/**
 * @function 判断当前是否有多人任务进行计步
 * @return 如果存在则返回task_id，否则返回null
 */
-(NSString *)isMultipleGameRecording;


/**
 * @function 根据多人任务ID获取当前计步值
 * @param task_id 多人任务的id
 * @return
 */
-(int)getMultipleGameRecord:(NSString *)task_id;


/**
 * @funcion 结束某个多人任务计步
 * @param task_id 多人任务的id
 * @return 是否成功结束
 */
-(BOOL)stopMultipleGameRecord:(NSString *)task_id;


/**
 * @region 分享数据接口
 */


/**
 * @function 调用第三方分享弹窗
 * @param url 待分享出去的url
 * @param title 待分享出去的标题
 * @return 是否分享成功
 */
-(BOOL)doThirdShare:(NSString *)url WithTitle:(NSString *)title;


/**
 * @region 地理位置数据接口
 */
/**
 * @function 获取当前地理位置数据信息
 * @return key为latitude value为longitude
 */
-(NSDictionary *)getCurrentLocation;


/**
 * @function 获取当前的城市名称和ID
 * @return key为ID value为城市名
 */
-(NSDictionary *)getCurrentCity;



/**
 * @function 获取当前实例
 * @return
 */
//返回信息model
-(void)getInstance;



@end
