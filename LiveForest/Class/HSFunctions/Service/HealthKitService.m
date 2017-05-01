//
//  HealthKitService.m
//  LiveForest
//
//  Created by apple on 15/9/22.
//  Copyright (c) 2015年 HOTeam. All rights reserved.
//

#import "HealthKitService.h"
#import "HSDataFormatHandle.h"
#import <HealthKit/HealthKit.h>

@interface HealthKitService()

@property(strong,atomic) HKHealthStore* healthStore;

@property(assign) BOOL isEnabled;

@end

@implementation HealthKitService

#pragma mark 根据输入的开始时间与结束时间获取计步数
- (void)getStepCountFrom:(NSDate *)startDate To:(NSDate*)endDate andCallBack:(void(^)(double,NSString*))callBack{
    
    if(!self.isEnabled){
        //如果环境没有初始化成功，则直接回调报错
        callBack(-1,@"本机不支持HealthKit或者权限获取失败！");
    }
    
    //尝试通过Query查询到用户的步数
    
    // Use the sample type for step count
    HKSampleType *sampleType = [HKSampleType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
    
    //测试数据 将startDate 置为一小时之前
//    startDate = [startDate initWithTimeInterval:-60 * 60 sinceDate:startDate];
    
    //获取两个时间差
    
    startDate = [[NSDate alloc] initWithTimeIntervalSinceNow:- [endDate timeIntervalSinceDate:startDate]];
    
    endDate = [[NSDate alloc] init];
    
    // Create a predicate to set start/end date bounds of the query
    NSPredicate *predicate = [HKQuery predicateForSamplesWithStartDate:startDate endDate:endDate options:HKQueryOptionNone];
    
    // Create a sort descriptor for sorting by start date
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:HKSampleSortIdentifierStartDate ascending:YES];
    
    HKStatisticsQuery *query = [[HKStatisticsQuery alloc] initWithQuantityType:sampleType
                                                       quantitySamplePredicate:predicate
                                                                       options:HKStatisticsOptionCumulativeSum
                                                             completionHandler:^(HKStatisticsQuery *query, HKStatistics *result, NSError *error)
    {
        
        if (error) {
            NSLog(@"%@",error);
            callBack(-1,error);
            return;
        }
        
        double totalStepCount= [result.sumQuantity doubleValueForUnit:[HKUnit countUnit]];
//        NSLog(@"步数 ===  %f",totalStepCount);
        
        //将步数转化为整数
        int totalStepCountInt = [[NSNumber numberWithDouble:totalStepCount] intValue];
        
        callBack(totalStepCountInt,@"Success");
    }];
    
    // Execute the query
    [[[HKHealthStore alloc] init] executeQuery:query];


}


#pragma mark 获取实例
+ (HealthKitService*)sharedInstance
{
    static dispatch_once_t pred = 0;
    __strong static HealthKitService *_sharedObject = nil;
    dispatch_once(&pred, ^{
        
        _sharedObject = [[self alloc] init]; // or some other init method
        
        _sharedObject.healthStore = [[HKHealthStore alloc] init];//初始化HKHealthStore
        
        [_sharedObject requestAuthorization];//请求用户权限
        
    });
    return _sharedObject;
}

#pragma mark - Inner Helper

#pragma mark 请求用户权限
- (void)requestAuthorization{
    //初始测试代码
    if(NSClassFromString(@"HKHealthStore") && [HKHealthStore isHealthDataAvailable])
    {
        // Add your HealthKit code here
        NSLog(@"HealthKit Enabled!");
        
        HKHealthStore *healthStore = [[HKHealthStore alloc] init];
        
        // Share body mass, height and body mass index
        NSSet *shareObjectTypes = [NSSet setWithObjects:
                                   [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMass],
                                   [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeight],
                                   [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMassIndex],
                                   nil];
        
        // Read date of birth, biological sex and step count
        NSSet *readObjectTypes  = [NSSet setWithObjects:
                                   [HKObjectType characteristicTypeForIdentifier:HKCharacteristicTypeIdentifierDateOfBirth],
                                   [HKObjectType characteristicTypeForIdentifier:HKCharacteristicTypeIdentifierBiologicalSex],
                                   [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount],
                                   nil];
        
        // Request access
        [healthStore requestAuthorizationToShareTypes:shareObjectTypes
                                            readTypes:readObjectTypes
                                           completion:^(BOOL success, NSError *error) {
                                               
                                               if(success == YES)
                                               {
                                                   NSLog(@"HealthKit权限请求成功！");
                                                   self.isEnabled = true;
                                                   
                                               }
                                               else
                                               {
                                                   NSLog(@"HealthKit权限请求失败！");
                                                   self.isEnabled = false;
                                               }
                                               
                                           }];
        
    }

}

@end
