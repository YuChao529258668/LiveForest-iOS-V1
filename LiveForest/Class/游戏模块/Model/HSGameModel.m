//
//  HSGameModel.m
//  LiveForest
//
//  Created by 钱梦颖 on 15/9/1.
//  Copyright (c) 2015年 HOTeam. All rights reserved.
//

#import "HSGameModel.h"
#import <ShareSDK/ShareSDK.h>
@implementation HSGameModel


/**
 * @region 用户信息系列接口
 */

/**
 * @function 返回用户信息，包括user_token，user_id，user_nickname等
 * @return
 */
-(void)getUserInfo{
    
}

/**
 * @region 运动数据接口
 */
/**
 * @function 开始今日的单人模式计步
 * @return True：成功开始计步，False：开启失败
 */
-(void)startTodaySingleGameRecord:(int)todayTarget andCallBack:(void(^)(bool))callback{
    if ([HKHealthStore isHealthDataAvailable]) {
        self.healthStore = [[HKHealthStore alloc]init];

        HKQuantityType *stepCountType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
        NSSet *readDataTypes = [NSSet setWithObjects:stepCountType, nil];
        
        [self.healthStore requestAuthorizationToShareTypes:nil readTypes:readDataTypes completion:^(BOOL success, NSError *error) {
            if (!success) {
                callback(false);
            }else{
                callback(true);
            }
        }];
    }

}


/**
 * @function 判断是否正在单人模式计步，存在则返回已经计步值
 * @return 开始计步则返回数值，否则返回-1
 */
-(void)getTodaySingleGameRecordWithCallback:(void (^)(double, NSError *))completionHandler  {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDate *now = [NSDate date];
    
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:now];
    //    应该是当日开始时间
    NSDate *startDate = [calendar dateFromComponents:components];
    //    应该是当前时间
    NSDate *endDate = [calendar dateByAddingUnit:NSCalendarUnitDay value:1 toDate:startDate options:0];
    
    HKQuantityType *sampleType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
    NSPredicate *predicate = [HKQuery predicateForSamplesWithStartDate:startDate endDate:endDate options:HKQueryOptionStrictStartDate];
    
    HKStatisticsQuery *query = [[HKStatisticsQuery alloc] initWithQuantityType:sampleType quantitySamplePredicate:predicate options:HKStatisticsOptionCumulativeSum completionHandler:^(HKStatisticsQuery *query, HKStatistics *result, NSError *error) {
        
        if (completionHandler && error) {
            completionHandler(0.0f, error);
            return;
        }
        
        double totalStepCount= [result.sumQuantity doubleValueForUnit:[HKUnit countUnit]];
        NSLog(@"里程 ===  %f",totalStepCount);
        if (completionHandler) {
            completionHandler(totalStepCount, error);
        }
    }];
    
    [self.healthStore executeQuery:query];
    
//    return -1;
}


/**
 * @function 结束今日的单人模式计步
 * @param TodayTarget
 * @return
 */
-(BOOL)stopTodaySingleGameRecord:(int)todayTarget{
    return YES;
}


/**
 * @function 根据某个任务ID开始某个多人任务计步
 * @param task_id 多人任务的ID
 * @param Target
 * @return 是否成功开始
 */
-(BOOL)startMultipleGameRecord:(NSString *)task_id WithTarget:(int)target{
    return NO;
}


/**
 * @function 判断当前是否有多人任务进行计步
 * @return 如果存在则返回task_id，否则返回null
 */
-(NSString *)isMultipleGameRecording{
    return NULL;
    
}


/**
 * @function 根据多人任务ID获取当前计步值
 * @param task_id 多人任务的id
 * @return
 */
-(int)getMultipleGameRecord:(NSString *)task_id  withCallback:(void (^)(double, NSError *))completionHandler{
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDate *now = [NSDate date];
    
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:now];
    //    应该是当日开始时间
    NSDate *startDate = [calendar dateFromComponents:components];
    //    应该是当前时间
    NSDate *endDate = [calendar dateByAddingUnit:NSCalendarUnitDay value:1 toDate:startDate options:0];
    
    HKQuantityType *sampleType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
    NSPredicate *predicate = [HKQuery predicateForSamplesWithStartDate:startDate endDate:endDate options:HKQueryOptionStrictStartDate];
    
    HKStatisticsQuery *query = [[HKStatisticsQuery alloc] initWithQuantityType:sampleType quantitySamplePredicate:predicate options:HKStatisticsOptionCumulativeSum completionHandler:^(HKStatisticsQuery *query, HKStatistics *result, NSError *error) {
        
        if (completionHandler && error) {
            completionHandler(0.0f, error);
            return;
        }
        
        double totalStepCount= [result.sumQuantity doubleValueForUnit:[HKUnit countUnit]];
        NSLog(@"里程 ===  %f",totalStepCount);
        if (completionHandler) {
            completionHandler(totalStepCount, error);
        }
    }];
    
    [self.healthStore executeQuery:query];
    
    
    return 10086;
}


/**
 * @funcion 结束某个多人任务计步
 * @param task_id 多人任务的id
 * @return 是否成功结束
 */
-(BOOL)stopMultipleGameRecord:(NSString *)task_id{
    return YES;
}


/**
 * @region 分享数据接口
 */


/**
 * @function 调用第三方分享弹窗
 * @param url 待分享出去的url
 * @param title 待分享出去的标题
 * @return 是否分享成功
 */
-(BOOL)doThirdShare:(NSString *)url WithTitle:(NSString *)title{
    
    
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:nil
                                       defaultContent:@"liveforest 分享"
                                                image:[ShareSDK imageWithUrl:url]
                                                title:title
                                                  url:@"http://hoteam.club/pages/share.html"
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
    
    
    
    
    
    
    
    return YES;
}






/**
 * @region 地理位置数据接口
 */
/**
 * @function 获取当前地理位置数据信息
 * @return key为latitude value为longitude
 */
-(NSDictionary *)getCurrentLocation{
    NSDictionary *dict = @{@"latitude":@"longitude"};
    
    
    self.currentLocation = [[CLLocationManager alloc] init];
    self.currentLocation.delegate = self;
    self.currentLocation.desiredAccuracy = kCLLocationAccuracyBest;
    self.currentLocation.distanceFilter  = 1000.0f;
    
    if ([self.currentLocation locationServicesEnabled]) {
        [self.currentLocation startUpdatingLocation];
    }
    
    
    return dict;
}


/**
 * @function 获取当前的城市名称和ID
 * @return key为ID value为城市名
 */
-(NSDictionary *)getCurrentCity{
    NSDictionary *dict = @{@"ID":@"city"};
    
    return dict;
}



- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"locError:%@", error);
    
}


-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    
    
    [manager stopUpdatingLocation];
    
    
}





/**
 * @function 获取当前实例
 * @return
 */
-(void)getInstance{
    
}


@end
