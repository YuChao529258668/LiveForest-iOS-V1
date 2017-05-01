//
//  HSFriendInfo.m
//  LiveForest
//
//  Created by wangfei on 7/30/15.
//  Copyright (c) 2015 HOTeam. All rights reserved.
//

#import "HSFriendInfo.h"

@implementation HSFriendInfo
//user_id:String 用户好友id
//user_nickname:String 用户好友昵称
//user_logo_img_path:String 用户好友头像存储地址
//user_sex:String 用户好友性别
//user_introduction:String 用户好友个人简介
-(instancetype)initWithDic:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        //赋值
        self.friend_id = dict[@"user_id"];
        self.user_nickname = dict[@"user_nickname"];
        self.user_logo_img_path = dict[@"user_logo_img_path"];
        self.user_introduction = dict[@"user_introduction"];
        self.user_sex = dict[@"user_sex"];
    }
    return self;
}

+(instancetype)friendInfoWithDic:(NSDictionary *)dict
{
    return [[self alloc]initWithDic:dict];
}

+(NSMutableArray *)friendArrayWithArray:(NSArray *)array
{
    NSMutableArray *arrayM = [NSMutableArray array];
    for (NSDictionary * dict in array) {
        [arrayM addObject:[self friendInfoWithDic:dict]];
    }
    return  arrayM;
}
@end
