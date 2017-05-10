//
//  HSYueBanUserInfoList.h
//  LiveForest
//
//  Created by 傲男 on 15/8/5.
//  Copyright (c) 2015年 HOTeam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HSYueBanUserInfoList : NSObject
/**
 *  用户id
 */

@property(nonatomic,copy)NSString *is_friend;

@property (nonatomic, copy) NSString *user_id;
/**
 *  用户性别·(0:男 1:女 -1:未知,-10086:应用外的临时用户，没有性别信息)
 */
@property (nonatomic, copy) NSString *user_sex;
/**
 *  用户年龄·
 */
@property (nonatomic, copy) NSString *user_birthday;
@property (nonatomic, copy) NSString *user_age;

/**
 *  用户昵称·
 */
@property (nonatomic, copy) NSString *user_nickname;
/**
 *  用户头像路径
 */
@property (nonatomic, copy) NSString *user_logo_img_path;
/**
 *  参与状态'0':未查看,'1':已查看,'2':已拒绝,'3':已同意
 */
@property (nonatomic, copy) NSString *yueban_user_state;

-(instancetype)initWithDic:(NSDictionary *)dict;
+(instancetype)userInfoWithDic:(NSDictionary *)dict;
+(NSArray *)userInfoArrayWithArray:(NSArray *)array;

/// 用于演示
+ (NSMutableArray *)test;

@end
