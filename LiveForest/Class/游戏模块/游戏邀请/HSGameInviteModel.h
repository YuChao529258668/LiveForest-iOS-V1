//
//  HSGameInviteModel.h
//  LiveForest
//
//  Created by 余超 on 15/9/10.
//  Copyright (c) 2015年 HOTeam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HSGameInviteModel : NSObject

//"task_description":"填写给好友的奖励",
//"to_who":"出现",
//"task_create_time":1442206849000,
//"user_id":"143488375573773091",
//"user_nickname":"王下邀月熊",
//"task_leave_words":"给朋友留言吧",
//"task_state":"0",
//"task_id":105,
//"task_time_limit":1,
//"task_goal":5

@property(nonatomic,copy)NSString *task_description;
@property(nonatomic,copy)NSString *to_who;
@property(nonatomic,copy)NSString *task_create_time;
@property(nonatomic,copy)NSString *user_id;//游戏发起人id
@property(nonatomic,copy)NSString *user_nickname;
@property(nonatomic,copy)NSString *task_leave_words;
@property(nonatomic,copy)NSString *task_state;//0表示还没开始 1表示任务结束
@property(nonatomic,copy)NSString *task_id;
@property(nonatomic,copy)NSString *task_time_limit;
@property(nonatomic,copy)NSString *task_goal;
@property(nonatomic,copy)NSString *user_logo_img_path;

+ (NSMutableArray *)gameInviteModelsWitDictionary:(NSDictionary *)dictionary;

@end
