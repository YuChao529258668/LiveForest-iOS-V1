//
//  HSMyYueBanDetailList.m
//  LiveForest
//
//  Created by 傲男 on 15/8/5.
//  Copyright (c) 2015年 HOTeam. All rights reserved.
//

#import "HSMyYueBanDetailList.h"
#import "HSYueBanUserInfoList.h"
@implementation HSMyYueBanDetailList
-(instancetype)initWithDic:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        
//    yueban_id:String约伴纪录id
//    user_id:String约伴创建者id
//    yueban_text_info:String约伴文本信息
//    yueban_voice_info:String约伴语音地址
//    yueban_user_city:String约伴创建者所在城市
//    create_time:String约伴创建时间
//    yueban_sport_id:String约伴运动类型
//    user_nickname:String约伴创建者昵称
//    user_logo_img_path:String约伴创建者头像
//    user_sex:String约伴创建者性别
//    user_introduction:String约伴创建者个人说明
//    user_birthday:String约伴创建者生日时间戳
//    estimated_time:String约伴创建者设置的约伴预计时间＋创建时间的结果的时间戳。用来算倒计时
//    yueban_state:约伴状态,'1':进行中,'0':已停止约伴
        
        self.attend_count = [dict objectForKey:@"attend_count"];
        self.create_time = [dict objectForKey:@"create_time"];
        self.estimated_time = [dict objectForKey:@"estimated_time"];
        self.is_mine = [dict objectForKey:@"is_mine"];
        
        self.user_birthday = [dict objectForKey:@"user_birthday"];
        self.user_id = [dict objectForKey:@"user_id"];
        self.user_logo_img_path = [dict objectForKey:@"user_logo_img_path"];
        self.user_nickname = [dict objectForKey:@"user_nickname"];
        self.user_sex = [dict objectForKey:@"user_sex"];
        self.user_sport = [dict objectForKey:@"user_sport"];
        self.yuebanUserAndState = [dict objectForKey:@"yuebanUserAndState"];
        

        self.yueban_voice_second = [NSString stringWithFormat:@"%@",[dict objectForKeyedSubscript:@"yueban_voice_second"]];
        
        self.friendsArray = [[NSMutableArray alloc]init];
        self.strangersArray = [[NSMutableArray alloc]init]; 
        NSArray *array = self.yuebanUserAndState;
        //                如果是自己的话 friend是好友 strangers是所有人
        //                如果不是自己，friend是自己，strangers是所有人
        
        if ([self.is_mine isEqualToString:@"1"]) {
            for (NSDictionary *userInfo in array) {
                HSYueBanUserInfoList *yuebanUserInfo = [[HSYueBanUserInfoList alloc]initWithDic:userInfo];
                if ([yuebanUserInfo.yueban_user_state isEqualToString:@"3"]) {
                        if ([yuebanUserInfo.is_friend isEqualToString:@"1"]) {
                            [self.friendsArray addObject:yuebanUserInfo];
                        }else{
                            [self.strangersArray addObject:yuebanUserInfo];
                        }
                    }
                }
        }else{
            for (NSDictionary *userInfo in array) {
                HSYueBanUserInfoList *yuebanUserInfo = [[HSYueBanUserInfoList alloc]initWithDic:userInfo];
                    if ([yuebanUserInfo.yueban_user_state isEqualToString:@"3"]) {
                        [self.strangersArray addObject:yuebanUserInfo];
                }
            }
            HSYueBanUserInfoList *yuebanUserInfoSelf = [[HSYueBanUserInfoList alloc]initWithDic:dict];
            [self.friendsArray addObject:yuebanUserInfoSelf];
        }
        self.yueban_id = [dict objectForKey:@"yueban_id"];
        self.yueban_count = [dict objectForKey:@"yueban_count"];
        self.yueban_sport_id = [dict objectForKey:@"yueban_sport_id"];
        self.yueban_state = [dict objectForKey:@"yueban_state"];
        self.yueban_text_info = [dict objectForKey:@"yueban_text_info"];
        self.yueban_user_city = [dict objectForKey:@"yueban_user_city"];
        self.yueban_voice_info = [dict objectForKey:@"yueban_voice_info"];
        
    }
    return self;
}

+(instancetype)yueBanDetailWithDic:(NSDictionary *)dict
{
    return [[self alloc]initWithDic:dict];
}

+(NSArray *)yueBanDetailArrayWithArray:(NSArray *)array
{
    NSMutableArray *arrayM = [NSMutableArray array];
    for (NSDictionary * dict in array) {
        [arrayM addObject:[self yueBanDetailWithDic:dict]];
    }
    return  arrayM;
}

@end
