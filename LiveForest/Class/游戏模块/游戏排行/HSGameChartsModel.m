
//  HSGameChartsModel.m
//  LiveForest
//
//  Created by 余超 on 15/9/10.
//  Copyright (c) 2015年 HOTeam. All rights reserved.
//

#import "HSGameChartsModel.h"
#import "HSDataFormatHandle.h"

@implementation HSGameChartsModel

- (instancetype)initWithDictionary:(NSDictionary *)dic {
    if (self = [super init]) {
//        self.score = [[dic objectForKey:@"score"] intValue];
        self.score = [NSString stringWithFormat:@"%@", [dic objectForKey:@"score"]];
        self.user_id = [dic objectForKey:@"user_id"];
        self.user_nickname = [dic objectForKey:@"user_nickname"];
        self.user_logo_img_path = [dic objectForKey:@"user_logo_img_path"];
        self.user_logo_img_path = [HSDataFormatHandle encodeURL:self.user_logo_img_path];
        
//        NSLog(@"%@",[[dic objectForKey:@"score"] class]);
//        NSLog(@"%@",[[dic objectForKey:@"user_logo_img_path"] class]);
    }
    return self;
}

+ (instancetype)gameChartsModelWithDictionary:(NSDictionary *)dic{
    return [[self alloc]initWithDictionary:dic];
}

+ (NSMutableArray *)gameChartsModelsWithDictionary:(NSDictionary *)dic {
    NSArray *array = [dic objectForKey:@"MyScoreRank"];
    NSMutableArray *gameChartsModels = [NSMutableArray arrayWithCapacity:array.count];
    
    for (NSDictionary *d in array) {
//        NSLog(@"%@",[self gameChartsModelsWithDictionary:d]);
//        NSLog(@"%@",[[self gameChartsModelsWithDictionary:d] class]);
        [gameChartsModels addObject:[self gameChartsModelWithDictionary:d]];
    }
    return gameChartsModels;
}
@end


