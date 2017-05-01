//
//  HSNotificationDataModel.h
//  LiveForest
//
//  Created by 傲男 on 15/9/2.
//  Copyright (c) 2015年 HOTeam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HSNotificationDataModel : NSObject
/**
 *  通知大类型code
 **/
@property (nonatomic, copy) NSString *notification_code;
/**
 *  通知小类型subcode
 **/
@property (nonatomic, copy) NSString *notification_subcode;
/**
 *  通知内容
 **/
@property (nonatomic, copy) NSDictionary *notification_detail;

-(instancetype)initWithDic:(NSDictionary *)dict;
+(instancetype)notificationDataWithDic:(NSDictionary *)dict;
@end
