//
//  HSMyYueBanDetailList.h
//  LiveForest
//
//  Created by 傲男 on 15/8/5.
//  Copyright (c) 2015年 HOTeam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HSMyYueBanDetailList : NSObject
/**
 *  约伴纪录id
 */
@property (nonatomic, copy) NSString *yueban_id;
/**
 *  约伴创建者id
 */
@property (nonatomic, copy) NSString *user_id;

@property(nonatomic,copy)NSString *user_sport;
/**
 *  约伴文本信息
 */
@property (nonatomic, copy) NSString *yueban_text_info;
/**
 *  约伴语音地址
 */
@property (nonatomic, copy) NSString *yueban_voice_info;
/**
 *  约伴创建者所在城市
 */
@property (nonatomic, copy) NSString *yueban_user_city;
/**
 *  约伴创建时间
 */
@property (nonatomic, copy) NSString *create_time;
/**
 *  约伴运动类型
 */
@property (nonatomic, copy) NSString *yueban_sport_id;
/**
 *  约伴创建者昵称
 */
@property (nonatomic, copy) NSString *user_nickname;
/**
 *  约伴创建者头像
 */
@property (nonatomic, copy) NSString *user_logo_img_path;
/**
 *  约伴创建者性别
 */
@property (nonatomic, copy) NSString *user_sex;
/**
 *  约伴创建者个人说明
 */
@property (nonatomic, copy) NSString *user_introduction;
/**
 *  约伴创建者生日时间戳
 */
@property (nonatomic, copy) NSString *user_birthday;
/**
 *  约伴创建者设置的约伴预计时间＋创建时间的结果的时间戳。用来算倒计时。
 */
@property (nonatomic, copy) NSString *estimated_time;
/**
 *  约伴的当前状态,'1':广播中,'0':已经停止广播
 */
@property (nonatomic, copy) NSString *yueban_state;
/**
 *  是不是我创建的约伴,'1':是,'0':不是
 */
@property (nonatomic, copy) NSString *is_mine;
/**
 *  本约伴邀请的人数
 */
@property (nonatomic, copy) NSString *yueban_count;
/**
 *  已经参与的本条约伴的人数
 */
@property (nonatomic, copy) NSString *attend_count;
//yueban_voice_second:String本约伴语音的时长，单位秒
@property(nonatomic,copy)NSString *yueban_voice_second;
/**
 *  邀请的好友情况
 */
//@property (nonatomic, strong) NSArray *yuebanFriendsAndState;

/**
 *  邀请的陌生人情况。HSYueBanUserInfoList 的字典信息 
 */
@property (nonatomic, strong) NSArray *yuebanUserAndState;
///**
// *  邀请的用户和参与情况
// */
//@property (nonatomic, strong) NSArray *yuebanUserAndState;

@property(strong,nonatomic)NSMutableArray *friendsArray;
@property(strong,nonatomic)NSMutableArray *strangersArray;

@property(nonatomic)BOOL isDeal;

-(instancetype)initWithDic:(NSDictionary *)dict;
+(instancetype)yueBanDetailWithDic:(NSDictionary *)dict;
+(NSArray *)yueBanDetailArrayWithArray:(NSArray *)array;

/// 用于演示
+ (HSMyYueBanDetailList *)test;

@end
