
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

/// 用于演示
+ (NSMutableArray *)test {
    NSMutableArray *array = [NSMutableArray array];
    
    HSGameChartsModel *m = [HSGameChartsModel new];
    m.user_id = @"0";
    m.user_nickname = @"   拉克丝";
    m.score = @"   100000";
    m.user_logo_img_path = @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1494241999521&di=af31c31165364b889b99fcdba15797d2&imgtype=0&src=http%3A%2F%2Fd.hiphotos.baidu.com%2Fzhidao%2Fpic%2Fitem%2F267f9e2f070828383ca71f45b899a9014c08f13d.jpg";

    HSGameChartsModel *m1 = [HSGameChartsModel new];
    m1.user_id = @"1";
    m1.user_nickname = @"   阿斯兰";
    m1.score = @"   99999";
    m1.user_logo_img_path = @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1494241635344&di=703bccbd98f53812b69e237668df98dd&imgtype=0&src=http%3A%2F%2Fwenwen.soso.com%2Fp%2F20110716%2F20110716201513-115129903.jpg";
    
    HSGameChartsModel *m2 = [HSGameChartsModel new];
    m2.user_id = @"2";
    m2.user_nickname = @"   基拉";
    m2.score = @"   99998";
    m2.user_logo_img_path = @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1494241633899&di=40950e895fa02670b82668e26c244806&imgtype=0&src=http%3A%2F%2Fwenwen.soso.com%2Fp%2F20110716%2F20110716201457-789663633.jpg";

    [array addObject: m];
    [array addObject: m1];
    [array addObject: m2];
    
    return array;
}

@end


