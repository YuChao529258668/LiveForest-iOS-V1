//
//  HSShareInfo.h
//  LiveForest
//
//  Created by wangfei on 7/29/15.
//  Copyright (c) 2015 HOTeam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HSShareInfo : NSObject
/**
 *  分享图片[数组，默认取第一张]
 */
@property (nonatomic, copy) NSArray *share_img_path;
/**
 *  带标签的分享图片
 */
@property (nonatomic, copy) NSString *share_img_path_with_lables;
/**
 *  分享简述
 */
@property (nonatomic, copy) NSString *share_description;
/**
 *  分享id
 */
@property (nonatomic, copy) NSString *share_id;
/**
 *  用户昵称·
 */
@property (nonatomic, copy) NSString *user_nickname;
/**
 *  用户头像路径
 */
@property (nonatomic, copy) NSString *user_logo_img_path;
/**
 *  评论数（>99。表示成99+）
 */
@property (nonatomic, copy) NSString *comment_count;
/**
 *  点赞数（>99。表示成99+）
 */
@property (nonatomic, copy) NSString *share_like_num;
/**
 *  评论创建时间
 */
@property (nonatomic, copy) NSString *share_creat_time;

-(instancetype)initWithDic:(NSDictionary *)dict;
+(instancetype)shareInfoWithDic:(NSDictionary *)dict;
+(NSArray *)shareInfoArrayWithArray:(NSArray *)array;
@end
