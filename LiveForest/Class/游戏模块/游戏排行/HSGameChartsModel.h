//
//  HSGameChartsModel.h
//  LiveForest
//
//  Created by 余超 on 15/9/10.
//  Copyright (c) 2015年 HOTeam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HSGameChartsModel : NSObject

//@property (nonatomic, assign) NSInteger score;
@property (nonatomic, copy) NSString *score;

@property (nonatomic, copy) NSString *user_id;

@property (nonatomic, copy) NSString *user_nickname;

@property (nonatomic, copy) NSString *user_logo_img_path;

+ (NSMutableArray *)gameChartsModelsWithDictionary:(NSDictionary *)dic;

/// 用于演示
+ (NSMutableArray *)test;

@end




