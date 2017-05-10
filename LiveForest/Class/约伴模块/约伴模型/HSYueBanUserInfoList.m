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

/// 用于演示
+ (NSMutableArray *)test {
    NSMutableArray *array = [NSMutableArray array];
    
    
    HSYueBanUserInfoList *l = [HSYueBanUserInfoList new];
    l.is_friend = @"0";
    l.user_id = @"0";
    l.user_sex = @"1";
//    l.user_birthday = @"";
    l.user_age = @"18";
    l.user_nickname = @"拉克丝";
    l.user_logo_img_path = @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1494241999521&di=af31c31165364b889b99fcdba15797d2&imgtype=0&src=http%3A%2F%2Fd.hiphotos.baidu.com%2Fzhidao%2Fpic%2Fitem%2F267f9e2f070828383ca71f45b899a9014c08f13d.jpg";
    l.yueban_user_state = @"1";

    HSYueBanUserInfoList *l2 = [HSYueBanUserInfoList new];
    l2.is_friend = @"1";
    l2.user_id = @"1";
    l2.user_sex = @"0";
    l2.user_birthday = @"";
    l2.user_age = @"18";
    l2.user_nickname = @"基拉";
    l2.user_logo_img_path = @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1494241633899&di=40950e895fa02670b82668e26c244806&imgtype=0&src=http%3A%2F%2Fwenwen.soso.com%2Fp%2F20110716%2F20110716201457-789663633.jpg";
    l2.yueban_user_state = @"1";

    HSYueBanUserInfoList *l3 = [HSYueBanUserInfoList new];
    l3.is_friend = @"1";
    l3.user_id = @"1";
    l3.user_sex = @"0";
    l3.user_birthday = @"";
    l3.user_age = @"18";
    l3.user_nickname = @"阿斯兰";
    l3.user_logo_img_path = @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1494241635344&di=703bccbd98f53812b69e237668df98dd&imgtype=0&src=http%3A%2F%2Fwenwen.soso.com%2Fp%2F20110716%2F20110716201513-115129903.jpg";
    l3.yueban_user_state = @"1";

    [array addObject:l];
    [array addObject:l2];
    [array addObject:l3];
    
    return array;
}

@end
