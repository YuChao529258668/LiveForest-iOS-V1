//
//  HSDisplayPicActivity.m
//  LiveForest
//
//  Created by wangfei on 7/27/15.
//  Copyright (c) 2015 HOTeam. All rights reserved.
//

#import "HSDisplayPicActivity.h"

@implementation HSDisplayPicActivity

-(instancetype)initWithDic:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        self.activity_id = dict[@"activity_id"];
        self.activity_name = dict[@"activity_name"];
        self.activity_summary = dict[@"activity_summary"];
        self.activity_img_path = [dict objectForKey:@"activity_img_path"];
        self.activity_user_num = dict[@"activity_user_num"];
    }
    return self;
}
+(instancetype)displayPicActivityWithDic:(NSDictionary *)dict
{
    return [[self alloc]initWithDic:dict];
}
/**
 *  生成模型数组
 *
 *  @param array
 *
 *  @return
 */
+(NSMutableArray *)displayPicActivityWithArray:(NSArray *)array
{
    NSMutableArray *arrayM = [NSMutableArray array];
    for (NSDictionary * dict in array) {
        [arrayM addObject:[self displayPicActivityWithDic:dict]];
    }
    return  arrayM;
}
@end
