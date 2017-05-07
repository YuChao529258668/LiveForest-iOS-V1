//
//  HSCommentModel.m
//  LiveForest
//
//  Created by wangfei on 6/29/15.
//  Copyright (c) 2015 HOTeam. All rights reserved.
//

#import "HSCommentModel.h"

@implementation HSCommentModel
-(instancetype)initWithDic:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+(instancetype)commentModelWithDic:(NSDictionary *)dict
{
    return [[self alloc]initWithDic:dict];
}

+(NSMutableArray *)commentModelsWithArray:(NSArray *)array
{
    NSMutableArray *arrayM = [NSMutableArray array];
    for (NSDictionary * dict in array) {
        [arrayM addObject:[self commentModelWithDic:dict]];
    }
    return  arrayM;
}


/// 用于演示
+ (NSMutableArray *)test {
    NSMutableArray *array = [NSMutableArray array];
    
    HSCommentModel *c = [HSCommentModel new];
    c.user_nickname = @"小红";
    c.comment_id = @"0";
    c.share_comment_content = @"评论内容评论内容评论内容";
    c.user_logo_img_path = @"http://p.store.itangyuan.com/p/chapter/attachment/etMsEgjseS/EgfwEgfSegAuEtjUE_EtETuh4bsOJgetjmilgNmii_EV87ocJn9L5Cb.jpg";
    
    HSCommentModel *c1 = [HSCommentModel new];
    c1.user_nickname = @"小红";
    c1.comment_id = @"1";
    c1.share_comment_content = @"评论内容评论内容评论内容";
    c1.user_logo_img_path = @"http://p.store.itangyuan.com/p/chapter/attachment/etMsEgjseS/EgfwEgfSegAuEtjUE_EtETuh4bsOJgetjmilgNmii_EV87ocJn9L5Cb.jpg";
    
    [array addObject:c];
    [array addObject:c1];
    return array;
}

@end
