//
//  HSShareInfo.m
//  LiveForest
//
//  Created by wangfei on 7/29/15.
//  Copyright (c) 2015 HOTeam. All rights reserved.
//

#import "HSShareInfo.h"
#import "HSDataFormatHandle.h"

@implementation HSShareInfo
///**
// *  分享图片
// */
//@property (nonatomic, copy) NSString *share_img_path;
///**
// *  带标签的分享图片
// */
//@property (nonatomic, copy) NSString *share_img_path_with_lables;
///**
// *  分享简述
// */
//@property (nonatomic, copy) NSString *share_description;
///**
// *  分享id
// */
//@property (nonatomic, copy) NSString *share_id;
///**
// *  用户昵称·
// */
//@property (nonatomic, copy) NSString *user_nickname;
///**
// *  用户头像路径
// */
//@property (nonatomic, copy) NSString *user_logo_img_path;
///**
// *  评论数（>99。表示成99+）
// */
//@property (nonatomic, copy) NSString *comment_count;
///**
// *  点赞数（>99。表示成99+）
// */
//@property (nonatomic, copy) NSString *share_like_num;
///**
// *  评论创建时间
// */
//@property (nonatomic, copy) NSString *share_creat_time;
-(instancetype)initWithDic:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        self.share_img_path = [dict objectForKey:@"share_img_path"];
        self.user_logo_img_path = [dict objectForKey:@"user_logo_img_path"];
        self.user_nickname = [dict objectForKey:@"user_nickname"];
        self.share_id = [dict objectForKey:@"share_id"];
        self.share_creat_time = [HSDataFormatHandle dateFormaterString:dict[@"share_create_time"]];
        self.share_description = [dict objectForKey:@"share_description"];
        
        self.share_like_num = [HSDataFormatHandle handleStringNumber:[dict objectForKey:@"share_like_num"]];
        self.comment_count = [HSDataFormatHandle handleStringNumber:[dict objectForKey:@"comment_count"]];
    }
    return self;
}

+(instancetype)shareInfoWithDic:(NSDictionary *)dict
{
    return [[self alloc]initWithDic:dict];
}

+(NSArray *)shareInfoArrayWithArray:(NSArray *)array
{
    NSMutableArray *arrayM = [NSMutableArray array];
    for (NSDictionary * dict in array) {
        [arrayM addObject:[self shareInfoWithDic:dict]];
    }
    return  arrayM;
}

//- (NSString *)handleStringNumber:(NSString *)stringNumber
//{
//    //空返回0
//    if (stringNumber == nil || stringNumber.length == 0) {
//        return @"0";
//    }
//    
//    //>99 返回99+
//    if (stringNumber.length > 2) {
//        stringNumber = @"99+";
//    }
//    return stringNumber;
//}
@end
