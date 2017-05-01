//
//  HSInviteFriendsCard.h
//  LiveForest
//
//  Created by 钱梦颖 on 15/8/4.
//  Copyright (c) 2015年 HOTeam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HSInviteFriendsCard : NSObject
//id
@property(nonatomic,copy)NSString *yueban_id;
//时间
@property(nonatomic,copy)NSString *create_time;
//位置
@property(nonatomic,copy)NSString *yueban_user_city;

//发起者id
@property(nonatomic,copy)NSString *user_id;
//发起者姓名
@property(nonatomic,copy)NSString *user_nickname;
//发起者头像url
@property(nonatomic,copy)NSString *user_logo_img_path;
//发起者性别
@property(nonatomic,copy)NSString *user_sex;
//发起者个人说明
@property(nonatomic,copy)NSString *user_introduction;
//约伴创建者生日时间戳
@property(nonatomic,copy)NSString *user_birthday;
//发起活动
@property(nonatomic,copy)NSString *yueban_sport_id;
@property(nonatomic,copy)NSString *yueban_sport;
//发起内容
@property(nonatomic,copy)NSString *yueban_text_info;
//发起语音内容
@property(nonatomic,copy)NSString *yueban_voice_info;
//语音时间
@property(strong,nonatomic)NSString *yueban_voice_second;


//是否同意

//发起标题
@property(nonatomic, copy)NSString *yueban_title;

-(instancetype)initWithDic:(NSDictionary *)dict;
+(instancetype)inviteFriendsModelWithDic:(NSDictionary *)dict;
+(NSMutableArray *)inviteFriendsWithArray:(NSArray *)array;


@end
