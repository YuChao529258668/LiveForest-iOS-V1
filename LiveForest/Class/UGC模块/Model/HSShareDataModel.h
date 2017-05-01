//
//  HSShareDataModel.h
//  LiveForest
//
//  Created by 傲男 on 15/8/27.
//  Copyright (c) 2015年 HOTeam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HSShareDataModel : NSObject

/**
 *  用户ID
**/
@property (nonatomic, copy) NSString *user_id;
/**
 *  用户昵称
 **/
@property (nonatomic, copy) NSString *user_nickname;
/**
 *  用户头像
 **/
@property (nonatomic, copy) NSString *user_logo_img_path;
/**
 *  分享ID
 **/
@property (nonatomic, copy) NSString *share_id;
/**
 *  分享或者承诺(0:分享1:承诺)
 **/
@property (nonatomic, copy) NSString *share_category;
/**
 *  分享描述
 **/
@property (nonatomic, copy) NSString *share_description;
/**
 *  分享图片路径
 **/
@property (nonatomic, strong) NSArray *share_img_path;
/**
 *  城市ID
 **/
@property (nonatomic, copy) NSString *share_city;
/**
 *  区域ID
 **/
@property (nonatomic, copy) NSString *share_county;
/**
 *  经度
 **/
@property (nonatomic, copy) NSString *share_lon;
/**
 *  纬度
 **/
@property (nonatomic, copy) NSString *share_lat;
/**
 * 分享创建时间(提供到秒的精度)
 **/
@property (nonatomic, copy) NSString *share_create_time;
/**
 * 该分享获得的点赞数量
 **/
@property (nonatomic, copy) NSString *share_like_num;
/**
 *  是否已点赞.0,否;1,是
 **/
@property (nonatomic, copy) NSString *hasLiked;
/**
 *  评论的数量
 **/
@property (nonatomic, copy) NSString *comment_count;
/**
 *  分享位置
 **/
@property (nonatomic, copy) NSString *share_location;
/**
 *  运动类型
 **/
@property (nonatomic, copy) NSString *sport_ids;

-(instancetype)initWithDic:(NSDictionary *)dict;
+(instancetype)shareDetailWithDic:(NSDictionary *)dict;
+(NSArray *)shareListWithArray:(NSArray *)array;

@end
