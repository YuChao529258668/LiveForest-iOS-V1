//
//  HSNotificationDataModel.m
//  LiveForest
//
//  Created by 傲男 on 15/9/2.
//  Copyright (c) 2015年 HOTeam. All rights reserved.
//

#import "HSNotificationDataModel.h"

@implementation HSNotificationDataModel
- (instancetype)initWithDic:(NSDictionary *)dict{
    self = [super init];
    if(self){
        //赋值
        self.notification_code = [dict objectForKey:@"code"];
        self.notification_subcode = [dict objectForKey:@"subcode"];
        //todo
        self.notification_detail = dict;
    }
    return self;
}

+ (instancetype)notificationDataWithDic:(NSDictionary *)dict{
    return [[self alloc]initWithDic:dict];
}

@end
