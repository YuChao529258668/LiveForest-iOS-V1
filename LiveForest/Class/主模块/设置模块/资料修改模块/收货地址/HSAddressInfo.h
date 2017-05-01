//
//  HSAddressInfo.h
//  LiveForest
//
//  Created by wangfei on 7/16/15.
//  Copyright (c) 2015 HOTeam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HSAddressInfo : NSObject

@property (nonatomic, copy) NSString *user_name;
@property (nonatomic, copy) NSString *user_phone;
@property (nonatomic, copy) NSString *area_info;
@property (nonatomic, copy) NSString *area_id;
@property (nonatomic, copy) NSString *detail_address;
@property (nonatomic, assign) NSInteger buttonTag;

-(instancetype)initWithDic:(NSDictionary *)dict;
+(instancetype)addressInfoWithDic:(NSDictionary *)dict;
+(NSMutableArray *)addressArray:(NSArray *)userAddress;
@end
