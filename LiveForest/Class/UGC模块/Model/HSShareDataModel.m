//
//  HSShareDataModel.m
//  LiveForest
//
//  Created by 傲男 on 15/8/27.
//  Copyright (c) 2015年 HOTeam. All rights reserved.
//

#import "HSShareDataModel.h"

@implementation HSShareDataModel

- (instancetype)initWithDic:(NSDictionary *)dict{
    self = [super init];
    if(self){
        //赋值
//    user_id: 用户ID
//    user_nickname:用户昵称
//    user_logo_img_path:用户头像
//    share_id:String 分享ID
//    share_category:String 分享或者承诺(0:分享1:承诺)
//    share_description:String 分享描述
//    share_img_path:Array 分享图片路径
//    share_city:String 城市ID
//    share_county:String 区域ID
//    share_lon:String 经度
//    share_lat:String 纬度
//    share_create_time:String 分享创建时间(提供到秒的精度)
//    share_like_num:String 该分享获得的点赞数量
//    hasLiked:String是否已点赞.0,否;1,是
//    comment_count:String 评论的数量
//    share_location:String 分享位置
//    sport_ids:String运动类型
        self.user_id = [dict objectForKey:@"user_id"];
        self.user_nickname = [dict objectForKey:@"user_nickname"];
        self.user_logo_img_path = [dict objectForKey:@"user_logo_img_path"];
        self.share_id = [dict objectForKey:@"share_id"];
        self.share_category = [dict objectForKey:@"share_category"];
        self.share_description = [dict objectForKey:@"share_description"];
        self.share_img_path = [dict objectForKey:@"share_img_path"];
        self.share_city = [dict objectForKey:@"share_city"];
        self.share_county = [dict objectForKey:@"share_county"];
        self.share_lon = [dict objectForKey:@"share_lon"];
        self.share_lat = [dict objectForKey:@"share_lat"];
        self.share_create_time = [dict objectForKey:@"share_create_time"];
        self.share_like_num = [dict objectForKey:@"share_like_num"];
        self.hasLiked = [dict objectForKey:@"hasLiked"];
        self.comment_count = [dict objectForKey:@"comment_count"];
        self.share_location = [dict objectForKey:@"share_location"];
        self.sport_ids = [dict objectForKey:@"sport_ids"];

    }
    return self;
}

+ (instancetype)shareDetailWithDic:(NSDictionary *)dict{
    return [[self alloc]initWithDic:dict];
}

+(NSArray *)shareListWithArray:(NSArray *)array{
    NSMutableArray *arrayM = [NSMutableArray array];
    for (NSDictionary * dict in array) {
        [arrayM addObject:[self shareDetailWithDic:dict]];
    }
    return  arrayM;
}
@end
