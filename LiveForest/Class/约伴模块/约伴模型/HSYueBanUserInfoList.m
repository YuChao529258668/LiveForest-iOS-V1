//
//  HSYueBanUserInfoList.m
//  LiveForest
//
//  Created by 傲男 on 15/8/5.
//  Copyright (c) 2015年 HOTeam. All rights reserved.
//

#import "HSYueBanUserInfoList.h"
#import "HSDataFormatHandle.h"
@implementation HSYueBanUserInfoList

-(instancetype)initWithDic:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        
        self.user_logo_img_path = [dict objectForKey:@"user_logo_img_path"];
        self.user_nickname = [dict objectForKey:@"user_nickname"];
        self.user_id = [dict objectForKey:@"user_id"];
        self.yueban_user_state = [dict objectForKey:@"yueban_user_state"];
        self.user_sex = [dict objectForKey:@"user_sex"];
        self.user_birthday = [dict objectForKey:@"user_birthday"];
        self.is_friend = [dict objectForKey:@"is_friend"];
        NSString *ageStr = [NSString stringWithFormat:@"%@",self.user_birthday];
        self.user_age = [HSDataFormatHandle getAgeFromBirthday:ageStr];
        
    }
    return self;
}

+(instancetype)userInfoWithDic:(NSDictionary *)dict
{
    return [[self alloc]initWithDic:dict];
}

+(NSArray *)userInfoArrayWithArray:(NSArray *)array
{
    NSMutableArray *arrayM = [NSMutableArray array];
    for (NSDictionary * dict in array) {
        [arrayM addObject:[self userInfoWithDic:dict]];
    }
    return  arrayM;
}
@end
