//
//  HSDisplayPicActivity.h
//  LiveForest
//
//  Created by wangfei on 7/27/15.
//  Copyright (c) 2015 HOTeam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface HSDisplayPicActivity : NSObject
/**
 *  活动id
 */
@property (nonatomic, copy) NSString *activity_id;
@property (nonatomic, copy) NSString *activity_name;
@property (nonatomic, copy) NSString *activity_summary;
/**
 *  图片路径数组，展示第一张
 */
@property (nonatomic, strong)NSArray *activity_img_path;

@property (nonatomic, copy) NSString *activity_user_num;
@property (nonatomic, copy) NSString *attended_friend_num;

-(instancetype)initWithDic:(NSDictionary *)dict;
+(instancetype)displayPicActivityWithDic:(NSDictionary *)dict;
+(NSMutableArray *)displayPicActivityWithArray:(NSArray *)array;

/// 用于演示
+ (NSMutableArray *)test;

@end
