//
//  HSCommentModel.h
//  LiveForest
//
//  Created by wangfei on 6/29/15.
//  Copyright (c) 2015 HOTeam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HSCommentModel : NSObject
/**
 *  评论创建时间
 */
@property (nonatomic, copy) NSString *share_comment_create_time;
/**
 *  用户昵称
 */
@property (nonatomic, copy) NSString *user_nickname;
/**
 *  评论ID
 */
@property (nonatomic, copy) NSString *comment_id;
/**
 *  评论内容
 */
@property (nonatomic, copy) NSString *share_comment_content;
/**
 *  是否是回复
 */
@property (nonatomic, copy) NSString *isReply;
/**
 *  回复的用户昵称
 */
@property (nonatomic, copy) NSString *replyUserNickname;
/**
 *  用户头像路径
 */
@property (nonatomic, copy) NSString *user_logo_img_path;
/**
 *  用户id
 */
@property (nonatomic, copy) NSString *user_id;
/**
 *  评论创建时间
 */
@property (nonatomic, copy) NSString *share_create_time;

-(instancetype)initWithDic:(NSDictionary *)dict;
+(instancetype)commentModelWithDic:(NSDictionary *)dict;
/** 返回commentModel的可变数组*/
+(NSMutableArray *)commentModelsWithArray:(NSArray *)array;
@end
