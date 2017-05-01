//
//  HSPicActivityInfo.m
//  LiveForest
//
//  Created by wangfei on 7/28/15.
//  Copyright (c) 2015 HOTeam. All rights reserved.
//

#import "HSPicActivityInfo.h"
#import "HSDataFormatHandle.h"
#import "HSShareInfo.h"
@implementation HSPicActivityInfo
//@property (nonatomic, copy) NSString *activity_id;
//@property (nonatomic, copy) NSString *activity_name;
//@property (nonatomic, copy) NSString *activity_summary;
//@property (nonatomic, strong) NSArray *activity_img_path;
///**
// *  活动结束时间
// */
//@property (nonatomic, copy) NSString *activity_time;
///**
// *  活动创建时间
// */
//@property (nonatomic, copy) NSString *create_time;
///**
// *  关联这个活动的分享列表
// */
//@property (nonatomic, strong) NSArray *shareList;
-(instancetype)initWithDic:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        self.activity_name = [dict objectForKey:@"activity_name"];
        NSString *timestamp = [dict objectForKey:@"create_time"];
        self.create_time = [NSString stringWithFormat:@"%@  发布",[HSDataFormatHandle dateformaterWithTimestamp:timestamp andFormater:@"yyyy-MM-dd HH:mm"]];
        self.activity_summary = [dict objectForKey:@"activity_summary"];
        //数组中的字段转化
        NSArray *handelArray = [[[HSDataFormatHandle alloc] init] handleDictArray:[dict objectForKey:@"shareList"]];
        self.shareList = [HSShareInfo shareInfoArrayWithArray:handelArray];
        self.activity_img_path = [dict objectForKey:@"activity_img_path"];
    }
    return self;
}

+(instancetype)picActivityInfoWithDic:(NSDictionary *)dict
{
    return [[self alloc]initWithDic:dict];
}

@end
