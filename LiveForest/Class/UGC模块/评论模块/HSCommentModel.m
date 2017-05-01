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
@end
