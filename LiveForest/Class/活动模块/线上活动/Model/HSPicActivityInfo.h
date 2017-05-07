//
//  HSPicActivityInfo.h
//  LiveForest
//
//  Created by wangfei on 7/28/15.
//  Copyright (c) 2015 HOTeam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HSPicActivityInfo : NSObject
//activityInfo:Object 	{
//    activity_id：活动ID
//activity_name:String 活动名字
//activity_summary:String 活动简介
//activity_img_path:Array 活动图片
//activity_time:String 活动结束时间yyyy-MM-dd HH:mm:ss 如：2011-11-11 13:30:00
//create_time:String 活动创建时间
//shareList:
//    [{
//    share_img_path:String分享图片
//    share_img_path_with_lables:String带标签的分享图片
//    share_description:String分享描述
//    share_id:String 分享id
//    }]
//}
@property (nonatomic, copy) NSString *activity_id;
@property (nonatomic, copy) NSString *activity_name;
@property (nonatomic, copy) NSString *activity_summary;
@property (nonatomic, strong) NSArray *activity_img_path;
/**
 *  活动结束时间
 */
@property (nonatomic, copy) NSString *activity_time;
/**
 *  活动创建时间
 */
@property (nonatomic, copy) NSString *create_time;
/**
 *  关联这个活动的分享列表
 */
@property (nonatomic, strong) NSArray *shareList;

-(instancetype)initWithDic:(NSDictionary *)dict;
+(instancetype)picActivityInfoWithDic:(NSDictionary *)dict;

/// 用于演示
+ (NSMutableArray *)test;

@end
