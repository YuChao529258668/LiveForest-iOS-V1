//
//  HSGameInviteModel.m
//  LiveForest
//
//  Created by 余超 on 15/9/10.
//  Copyright (c) 2015年 HOTeam. All rights reserved.
//

#import "HSGameInviteModel.h"
#import "HSDataFormatHandle.h"

@implementation HSGameInviteModel

//"task_create_time" = 1441960543000;
//"task_description" = "\U586b\U5199\U7ed9\U597d\U53cb\U7684\U5956\U52b1";
//"task_goal" = 2;
//"task_id" = 19;
//"task_leave_words" = "\U7ed9\U670b\U53cb\U7559\U8a00\U5427";
//"task_state" = 0;
//"task_time_limit" = 100;
//"to_who" = a;
//"user_id" = 143576626279730219;
//"user_logo_img_path" = "http://tp4.sinaimg.cn/1752350643/50/5730397026/0";
//"user_nickname" = SONIA;

- (instancetype)initWithDictionary:(NSDictionary *)dic {
    if (self = [super init]) {
        self.task_description = [dic objectForKey:@"task_description"];
        self.to_who = [dic objectForKey:@"to_who"];
        NSString *stringDate = [NSString stringWithFormat:@"%@", [dic objectForKey:@"task_create_time"]];
        self.task_create_time = [HSDataFormatHandle dateFormaterString: stringDate];
        self.user_id = [dic objectForKey:@"user_id"];
        self.user_nickname = [dic objectForKey:@"user_nickname"];
        self.task_leave_words = [dic objectForKey:@"task_leave_words"];
        self.task_state = [dic objectForKey:@"task_state"];
        self.task_id = [dic objectForKey:@"task_id"];
        self.task_time_limit = [dic objectForKey:@"task_time_limit"];
        self.task_goal = [dic objectForKey:@"task_goal"];
        self.user_logo_img_path = [dic objectForKey:@"user_logo_img_path"];
    }
    return self;
}

+ (instancetype)gameInviteModelWithDictionary:(NSDictionary *)dic {
    return [[self alloc]initWithDictionary:dic];
}

+ (NSMutableArray *)gameInviteModelsWitDictionary:(NSDictionary *)dictionary {
    NSArray *gameInviteList = [dictionary objectForKey:@"invitationList"];
    NSMutableArray *gameInviteModels = [NSMutableArray arrayWithCapacity:gameInviteList.count];
    
    for (NSDictionary *dic in gameInviteList) {
        [gameInviteModels addObject:[self gameInviteModelWithDictionary:dic]];
    }

    return gameInviteModels;
}

@end
