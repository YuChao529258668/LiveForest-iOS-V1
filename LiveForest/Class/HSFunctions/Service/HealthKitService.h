//
//  HealthKitService.h
//  LiveForest
//
//  Created by apple on 15/9/22.
//  Copyright (c) 2015年 HOTeam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HealthKitService : NSObject

#pragma mark - 公开静态方法

#pragma mark 获取单例
+ (id)sharedInstance;

#pragma mark 获取计步值
- (void)getStepCountFrom:(NSDate *)startDate To:(NSDate*)endDate andCallBack:(void(^)(double,NSString*))callBack;

#pragma mark 请求用户权限
- (void)requestAuthorization;

@end
