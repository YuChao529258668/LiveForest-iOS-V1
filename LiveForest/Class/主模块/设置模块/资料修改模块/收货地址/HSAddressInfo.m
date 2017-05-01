//
//  HSAddressInfo.m
//  LiveForest
//
//  Created by wangfei on 7/16/15.
//  Copyright (c) 2015 HOTeam. All rights reserved.
//

#import "HSAddressInfo.h"
#import "HSDataFormatHandle.h"
@implementation HSAddressInfo

-(instancetype)initWithDic:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
//        [self setValuesForKeysWithDictionary:dict];
        self.user_name = [dict objectForKey:@"user_name"];
        self.user_phone = [dict objectForKey:@"user_phone"];
        self.area_id = [dict objectForKey:@"area_id"];
        self.detail_address = [dict objectForKey:@"detail_address"];
        self.area_info = [[[HSDataFormatHandle alloc]init] areaFormatHandleWithStringID:self.area_id];
    }
    return self;
}

+(instancetype)addressInfoWithDic:(NSDictionary *)dict
{
    return [[self alloc]initWithDic:dict];
}

+(NSMutableArray *)addressArray:(NSArray *)userAddress
{
    NSMutableArray *arrayM = [NSMutableArray array];
    for (NSDictionary * dict in userAddress) {
        [arrayM addObject:[self addressInfoWithDic:dict]];
    }
    return  arrayM;
}
@end
